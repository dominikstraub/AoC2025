import Algorithms
import Foundation

// Simple rational number to avoid floating point errors
struct Rational: Equatable, Comparable {
  var num: Int
  var den: Int

  init(_ n: Int, _ d: Int = 1) {
    if d == 0 { fatalError("Division by zero") }
    let g = Self.gcd(abs(n), abs(d))
    let sign = d < 0 ? -1 : 1
    num = sign * n / (g == 0 ? 1 : g)
    den = abs(d) / (g == 0 ? 1 : g)
  }

  static func gcd(_ a: Int, _ b: Int) -> Int {
    b == 0 ? a : gcd(b, a % b)
  }

  static func + (a: Rational, b: Rational) -> Rational {
    Rational(a.num * b.den + b.num * a.den, a.den * b.den)
  }

  static func - (a: Rational, b: Rational) -> Rational {
    Rational(a.num * b.den - b.num * a.den, a.den * b.den)
  }

  static func * (a: Rational, b: Rational) -> Rational {
    Rational(a.num * b.num, a.den * b.den)
  }

  static func / (a: Rational, b: Rational) -> Rational {
    Rational(a.num * b.den, a.den * b.num)
  }

  static func < (a: Rational, b: Rational) -> Bool {
    a.num * b.den < b.num * a.den
  }

  var isInteger: Bool { den == 1 }
  var intValue: Int { num / den }

  // Floor: largest integer <= self
  var floor: Int {
    if num >= 0 {
      return num / den
    } else {
      // For negative: -7/3 = -3 in Swift, but floor should be -3
      // Swift's / truncates toward zero, so -7/3 = -2, but floor(-7/3) = -3
      return (num - den + 1) / den
    }
  }

  // Ceiling: smallest integer >= self
  var ceiling: Int {
    if num <= 0 {
      return num / den
    } else {
      // For positive: 7/3 = 2 in Swift, but ceiling should be 3
      return (num + den - 1) / den
    }
  }
}

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

  // Solve Ax = b where we minimize sum(x), x >= 0, x integers
  // Uses Gaussian elimination to get RREF, then searches free variable space
  func solve2(targets: [Int], equations: [[Int]]) -> Int? {
    let numButtons = equations.count
    let numCounters = targets.count

    // Build augmented matrix [A | b] using Rationals to avoid floating point issues
    // A[counter][button] = 1 if button affects counter
    var aug = [[Rational]](
      repeating: [Rational](repeating: Rational(0), count: numButtons + 1), count: numCounters
    )
    for counterIdx in 0..<numCounters {
      for (buttonIdx, connectedCounters) in equations.enumerated() {
        if connectedCounters.contains(counterIdx) {
          aug[counterIdx][buttonIdx] = Rational(1)
        }
      }
      aug[counterIdx][numButtons] = Rational(targets[counterIdx])
    }

    // Gaussian elimination to RREF
    var pivotCols = [Int]()
    var pivotRow = 0

    for col in 0..<numButtons {
      // Find non-zero pivot in this column
      var foundRow: Int? = nil
      for row in pivotRow..<numCounters {
        if aug[row][col] != Rational(0) {
          foundRow = row
          break
        }
      }

      guard let pr = foundRow else { continue }

      // Swap rows
      (aug[pivotRow], aug[pr]) = (aug[pr], aug[pivotRow])

      // Scale pivot row so pivot = 1
      let scale = aug[pivotRow][col]
      for j in 0...numButtons {
        aug[pivotRow][j] = aug[pivotRow][j] / scale
      }

      // Eliminate this column in all other rows
      for row in 0..<numCounters {
        if row != pivotRow, aug[row][col] != Rational(0) {
          let factor = aug[row][col]
          for j in 0...numButtons {
            aug[row][j] = aug[row][j] - factor * aug[pivotRow][j]
          }
        }
      }

      pivotCols.append(col)
      pivotRow += 1
    }

    // Check for inconsistency (0 = nonzero)
    for row in pivotRow..<numCounters {
      if aug[row][numButtons] != Rational(0) {
        return nil
      }
    }

    // Free variables are non-pivot columns
    let freeVars = (0..<numButtons).filter { !pivotCols.contains($0) }

    // Map pivot column -> row
    var pivotColToRow = [Int: Int]()
    for (row, col) in pivotCols.enumerated() {
      pivotColToRow[col] = row
    }

    // Compute solution given free variable values
    func computeSolution(freeValues: [Int]) -> [Int]? {
      var solution = [Rational](repeating: Rational(0), count: numButtons)

      // Set free variables
      for (i, fv) in freeVars.enumerated() {
        solution[fv] = Rational(freeValues[i])
      }

      // Compute pivot variables: x_pivot = b - sum(coeff_j * x_j) for all non-pivot j
      for col in pivotCols {
        let row = pivotColToRow[col]!
        var val = aug[row][numButtons]
        // Subtract contribution from ALL free variables
        for fv in freeVars {
          val = val - aug[row][fv] * solution[fv]
        }
        solution[col] = val
      }

      // Check all are non-negative integers
      var intSolution = [Int]()
      for s in solution {
        guard s.isInteger, s >= Rational(0) else { return nil }
        intSolution.append(s.intValue)
      }

      return intSolution
    }

    // If no free variables, just compute the unique solution
    if freeVars.isEmpty {
      guard let sol = computeSolution(freeValues: []) else { return nil }
      return sol.reduce(0, +)
    }

    // Search over free variables
    var bestSum = Int.max
    let maxFreeVal = targets.max() ?? 100

    // Compute a safe upper bound for a free variable (only considering positive coefficients)
    func safeUpperBound(freeIdx: Int, freeValues: [Int]) -> Int {
      let fv = freeVars[freeIdx]
      var maxVal = maxFreeVal

      for col in pivotCols {
        let row = pivotColToRow[col]!
        let coeff = aug[row][fv]

        // Only use positive coefficients for upper bound (conservative)
        if coeff > Rational(0) {
          var partialSum = aug[row][numButtons]
          for (i, fvPrev) in freeVars.prefix(freeIdx).enumerated() {
            partialSum = partialSum - aug[row][fvPrev] * Rational(freeValues[i])
          }
          // For negative coefficients on later free vars, they could increase partialSum
          // So we add their maximum possible contribution
          for fvLater in freeVars.suffix(from: freeIdx + 1) {
            let laterCoeff = aug[row][fvLater]
            if laterCoeff < Rational(0) {
              // This free var could add up to -laterCoeff * maxFreeVal to the pivot
              partialSum = partialSum - laterCoeff * Rational(maxFreeVal)
            }
          }
          let bound = partialSum / coeff
          if bound >= Rational(0) {
            maxVal = min(maxVal, bound.floor)
          }
        }
      }

      return max(0, maxVal)
    }

    func search(freeIdx: Int, freeValues: [Int], currentFreeSum: Int) {
      // Prune if current free sum already exceeds best
      if currentFreeSum >= bestSum { return }

      if freeIdx == freeVars.count {
        if let sol = computeSolution(freeValues: freeValues) {
          let total = sol.reduce(0, +)
          if total < bestSum {
            bestSum = total
          }
        }
        return
      }

      let upperBound = safeUpperBound(freeIdx: freeIdx, freeValues: freeValues)

      // Try all values from 0 to upperBound
      for v in 0...upperBound {
        var newFreeValues = freeValues
        newFreeValues.append(v)
        search(freeIdx: freeIdx + 1, freeValues: newFreeValues, currentFreeSum: currentFreeSum + v)
      }
    }

    search(freeIdx: 0, freeValues: [], currentFreeSum: 0)

    return bestSum == Int.max ? nil : bestSum
  }

  func part2() -> Int {
    let machines = getValues()
    // print(machines)

    return machines.compactMap { solve2(targets: $0.joltage, equations: $0.buttons) }.sum()
  }
}
