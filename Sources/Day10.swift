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

  func solve2(target: [Int], values: [[Int]]) -> [Int]? {
    let targetSize = target.count
    let numButtons = values.count

    let buttonEffects: [Set<Int>] = values.map { Set($0.filter { $0 < targetSize }) }

    var indexToButtons: [[Int]] = Array(repeating: [], count: targetSize)
    for (btnIdx, effects) in buttonEffects.enumerated() {
      for idx in effects {
        indexToButtons[idx].append(btnIdx)
      }
    }

    for idx in 0..<targetSize {
      if target[idx] > 0, indexToButtons[idx].isEmpty {
        return nil
      }
    }

    var remaining = target
    var solution = [Int](repeating: 0, count: numButtons)

    var changed = true
    while changed {
      changed = false

      let sortedIndices = (0..<targetSize)
        .filter { remaining[$0] > 0 }
        .sorted { indexToButtons[$0].count < indexToButtons[$1].count }

      for idx in sortedIndices {
        if remaining[idx] <= 0 { continue }

        let validButtons = indexToButtons[idx].filter { btnIdx in
          buttonEffects[btnIdx].allSatisfy { remaining[$0] >= remaining[idx] }
        }

        if validButtons.isEmpty {
          var bestBtn = -1
          var bestContrib = 0
          for btnIdx in indexToButtons[idx] {
            var maxContrib = Int.max
            for affectedIdx in buttonEffects[btnIdx] {
              maxContrib = min(maxContrib, remaining[affectedIdx])
            }
            if maxContrib > bestContrib {
              bestContrib = maxContrib
              bestBtn = btnIdx
            }
          }

          if bestBtn >= 0, bestContrib > 0 {
            solution[bestBtn] += bestContrib
            for affectedIdx in buttonEffects[bestBtn] {
              remaining[affectedIdx] -= bestContrib
            }
            changed = true
          }
        } else {
          var bestBtn = validButtons[0]
          var bestScore = 0
          for btnIdx in validButtons {
            var score = 0
            for affectedIdx in buttonEffects[btnIdx] {
              if remaining[affectedIdx] >= remaining[idx] {
                score += 1
              }
            }
            if score > bestScore {
              bestScore = score
              bestBtn = btnIdx
            }
          }

          let presses = remaining[idx]
          solution[bestBtn] += presses
          for affectedIdx in buttonEffects[bestBtn] {
            remaining[affectedIdx] -= presses
          }
          changed = true
        }
      }
    }

    if remaining.allSatisfy({ $0 == 0 }) {
      return [solution.reduce(0, +)]
    }

    return nil
  }

  func part2() -> Int {
    let machines = getValues()
    // print(machines)

    let solutions = machines.map { solve2(target: $0.joltage, values: $0.buttons) }

    return solutions.compactMap { solution in
      // print("")
      // print(solution)
      guard let solution else { return nil }
      // print(solution.reduce(0, +))
      return solution.reduce(0, +)
    }.sum()
  }
}
