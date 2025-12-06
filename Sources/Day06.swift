import Algorithms
import Foundation

struct Day06: AdventDay {
  nonisolated init(data: String) {
    self.data = data
  }

  var data: String

  func getValues() -> (operands: [[Int]], operators: [(Int, Int) -> Int]) {
    var lines = data.split(separator: "\n")

    let ops = String(lines.popLast()!).components(separatedBy: .whitespaces).compactMap {
      switch $0 {
      case "+": return (+) as (Int, Int) -> Int
      case "*": return (*)
      default: return nil
      }
    }

    let operands = lines.map {
      String($0).components(separatedBy: .whitespaces).compactMap { Int($0) }
    }

    return (operands: operands, operators: ops)
  }

  func part1() -> Int {
    let values = getValues()
    // print(values)

    let columns = (0..<values.operators.count)
    return columns.map { column in
      (1..<values.operands.count).reduce(values.operands[0][column]) { current, row in
        values.operators[column](current, values.operands[row][column])
      }
    }.sum()
  }

  func getValues2() -> (operands: [[Int]], operators: [(Int, Int) -> Int]) {
    var lines = data.split(separator: "\n")

    let ops = String(lines.popLast()!).components(separatedBy: .whitespaces).compactMap {
      switch $0 {
      case "+": return (+) as (Int, Int) -> Int
      case "*": return (*)
      default: return nil
      }
    }

    let longestLine = lines.max(by: { $0.count < $1.count })!
    let columnValues: [Int?] = longestLine.indices.map { columnIndex in
      let offset = longestLine.distance(from: longestLine.startIndex, to: columnIndex)
      let digitsInColumn = lines.compactMap { line -> Int? in
        guard
          let targetIndex = line.index(line.startIndex, offsetBy: offset, limitedBy: line.endIndex),
          targetIndex < line.endIndex
        else {
          return nil
        }
        return Int(String(line[targetIndex]))
      }

      return digitsInColumn.isEmpty ? nil : Int(digitsInColumn.map(String.init).joined())
    }

    var operands: [[Int]] = []
    var numbers: [Int] = []
    for number in columnValues {
      if let number {
        numbers.append(number)
      } else if !numbers.isEmpty {
        operands.append(numbers)
        numbers = []
      }
    }
    if !numbers.isEmpty {
      operands.append(numbers)
    }

    return (operands: operands, operators: ops)
  }

  func part2() -> Int {
    let values = getValues2()
    // print(values)

    let columns = (0..<values.operators.count)
    return columns.map { column in
      (1..<values.operands[column].count).reduce(values.operands[column][0]) { current, row in
        values.operators[column](current, values.operands[column][row])
      }
    }.sum()
  }
}
