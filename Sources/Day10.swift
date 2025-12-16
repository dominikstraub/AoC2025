import Algorithms
import Foundation

struct Day10: AdventDay {
    nonisolated init(data: String) {
        self.data = data
    }

    var data: String

    func getValues() -> [(lights: Int, buttonsNr: [Int], buttons: [[Int]], joltage: [Int])] {
        let mainRegex = /\[(?<lights>[.#]+)\](?<buttons>(?: \([^)]+\))+) \{(?<joltage>[^}]+)\}/
        let buttonRegex = /\((?<buttons>[0-9,]+)\)/
        return data.split(separator: "\n").compactMap {
            line -> (lights: Int, buttonsNr: [Int], buttons: [[Int]], joltage: [Int])? in
            guard let match = line.firstMatch(of: mainRegex) else { return nil }
            let lights = match.output.lights.map { $0 == "#" }
            let lightsNr = lights.reduce(0) { ($0 << 1) | ($1 ? 1 : 0) }

            let buttons: [[Int]] = match.output.buttons
                .matches(of: buttonRegex).map { button in
                    button.output.buttons.split(separator: ",")
                        .compactMap { digit in
                            Int(digit)
                        }
                }

            let buttonsNr: [Int] =
                buttons
                    .map { button in
                        button
                            .map { digit in
                                Int(pow(2, Double(lights.count - 1 - digit)))
                            }.reduce(0, +)
                    }

            let joltage = match.output.joltage
                .split(separator: ",")
                .compactMap { Int($0) }

            return (lights: lightsNr, buttonsNr: buttonsNr, buttons: buttons, joltage: joltage)
        }
    }

    func solve(target: Int, values: [Int]) -> [Int]? {
        let n = values.count
        var bestSolution: [Int]? = nil
        var bestSum = Int.max

        var stack: [(index: Int, current: Int, coefficients: [Int], sum: Int)] = [(0, 0, [], 0)]

        while !stack.isEmpty {
            let (index, current, coefficients, sum) = stack.removeLast()

            if current == target {
                if sum < bestSum {
                    bestSum = sum
                    bestSolution = coefficients
                }
                continue
            }
            if index >= n || sum >= bestSum { continue }

            var skipCoeffs = coefficients
            skipCoeffs.append(0)
            stack.append((index + 1, current, skipCoeffs, sum))

            var pressCoeffs = coefficients
            pressCoeffs.append(1)
            stack.append((index + 1, current ^ values[index], pressCoeffs, sum + 1))
        }

        return bestSolution
    }

    func part1() -> Int {
        let machines = getValues()
        // print(machines)

        let solutions = machines.map { solve(target: $0.lights, values: $0.buttonsNr) }

        return solutions.compactMap { solution in
            // print("")
            // print(solution)
            guard let solution else { return nil }
            // print(solution.reduce(0, +))
            return solution.reduce(0, +)
        }.sum()
    }

    func solve2(targets: [Int], equations: [[Int]]) -> Int? {
        print("targets: \(targets)")
        print("equations: \(equations)")
        let numCoefficients = equations.count
        let maxCoeffValue = targets.max() ?? 0

        var bestSum = Int.max
        var currentValues = [Int](repeating: 0, count: targets.count) // running totals for each target

        func backtrack(coeffIndex: Int, currentSum: Int) {
            // Pruning: if we've already exceeded best, stop
            if currentSum >= bestSum { return }

            // Base case: assigned all coefficients
            if coeffIndex == numCoefficients {
                if currentValues == targets {
                    bestSum = currentSum
                }
                return
            }

            // Pruning: if any target is already exceeded, stop
            for i in 0 ..< targets.count {
                if currentValues[i] > targets[i] { return }
            }

            let connectedTargets = equations[coeffIndex]

            // Try each possible value for this coefficient
            for value in 0 ... maxCoeffValue {
                // Apply this coefficient
                for targetIdx in connectedTargets {
                    currentValues[targetIdx] += value
                }

                backtrack(coeffIndex: coeffIndex + 1, currentSum: currentSum + value)

                // Undo (backtrack)
                for targetIdx in connectedTargets {
                    currentValues[targetIdx] -= value
                }
            }
        }

        backtrack(coeffIndex: 0, currentSum: 0)

        return bestSum == Int.max ? nil : bestSum
    }

    func part2() -> Int {
        let machines = getValues()
        // print(machines)

        return machines.compactMap { solve2(targets: $0.joltage, equations: $0.buttons) }.sum()
    }
}
