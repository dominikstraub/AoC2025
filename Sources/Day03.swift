import Algorithms
import Foundation

struct Day03: AdventDay {
  nonisolated init(data: String) {
    self.data = data
  }

  var data: String

  func getValues() -> [[Int]] {
    return data.split(separator: "\n").compactMap {
      $0.compactMap {
        Int($0)
      }
    }
  }

  func getJoltage(bank: [Int]) -> Int {
    // print(bank)
    guard let firstDigit = bank[safe: 0..<bank.count - 1]?.max() else { return 0 }
    guard let firstIndex = bank.firstIndex(of: firstDigit) else { return 0 }
    guard let secondDigit = bank[safe: firstIndex + 1..<bank.count]?.max() else { return 0 }
    return Int("\(firstDigit)\(secondDigit)") ?? 0
  }

  func getJoltage(banks: [[Int]]) -> Int {
    return banks.compactMap(getJoltage).reduce(0, +)
  }

  func part1() -> Int {
    let banks = getValues()
    // print(banks)
    return getJoltage(banks: banks)
  }

  func getJoltage2(bank: [Int]) -> Int {
    // print(bank)
    var currentIndex = -1
    var digits: [Int] = []
    for index in (1...12).reversed() {
      guard let currentBank = bank[safe: currentIndex + 1..<bank.count - index + 1] else {
        return 0
      }
      guard let currentDigit = currentBank.max() else { return 0 }
      digits.append(currentDigit)
      currentIndex = currentBank.firstIndex(of: currentDigit) ?? -1
    }
    return Int(digits.map { String($0) }.joined()) ?? 0
  }

  func getJoltage2(banks: [[Int]]) -> Int {
    return banks.compactMap(getJoltage2).reduce(0, +)
  }

  func part2() -> Int {
    let banks = getValues()
    // print(banks)
    return getJoltage2(banks: banks)
  }
}
