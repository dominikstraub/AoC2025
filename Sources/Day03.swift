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
        guard let firstDigit = bank[safe: 0 ..< bank.count - 1]?.max() else { return 0 }
        guard let firstIndex = bank.firstIndex(of: firstDigit) else { return 0 }
        guard let secondDigit = bank[safe: firstIndex + 1 ..< bank.count]?.max() else { return 0 }
        // guard let secondIndex = bank[safe: firstIndex ..< bank.count]?.firstIndex(of: secondDigit) else { return 0 }
        // guard let tmp = (bank[safe: firstIndex ... secondIndex]?.compactMap { String($0) })?.joined() else { return 0 }
        let tmp = "\(firstDigit)\(secondDigit)"
        // print(tmp)
        return Int(tmp) ?? 0
    }

    func getJoltage(banks: [[Int]]) -> Int {
        return banks.compactMap(getJoltage).reduce(0, +)
    }

    func part1() -> Int {
        let banks = getValues()
        // print(banks)
        return getJoltage(banks: banks)
    }

    func part2() -> Int {
        return -1
    }
}
