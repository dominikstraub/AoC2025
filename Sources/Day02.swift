import Algorithms
import Foundation

struct Day02: AdventDay {
    nonisolated init(data: String) {
        self.data = data
    }

    var data: String

    func getValues() -> [ClosedRange<Int>] {
        return data.split(separator: "\n").flatMap { line in
            line.split(separator: ",").compactMap { part -> ClosedRange<Int>? in
                let parts = part.split(separator: "-")
                guard parts.count == 2,
                      let start = Int(String(parts[0])),
                      let end = Int(String(parts[1]))
                else {
                    return nil
                }
                return start ... end
            }
        }
    }

    func isIdValid(id: Int) -> Bool {
        let digits = String(id)
        let count = digits.count

        guard count % 2 == 0 && count >= 2 else { return false }

        let midIndex = digits.index(digits.startIndex, offsetBy: count / 2)
        let firstHalf = digits[..<midIndex]
        let secondHalf = digits[midIndex...]

        return firstHalf == secondHalf
    }

    func getInvalidIds(range: ClosedRange<Int>) -> [Int] {
        return range.filter(isIdValid)
    }

    func getInvalidIds(ranges: [ClosedRange<Int>]) -> [Int] {
        return ranges.flatMap(getInvalidIds)
    }

    func part1() -> Int {
        return getValues().flatMap(getInvalidIds).reduce(0, +)
    }

    func isIdValid2(id: Int) -> Bool {
        let digits = String(id)
        let count = digits.count

        guard count >= 2 else { return false }

        for length in 1 ... (count / 2) {
            guard count % length == 0 else { continue }

            let repetitions = count / length
            if repetitions < 2 { continue }

            let pattern = String(digits.prefix(length))
            let repeated = String(repeating: pattern, count: repetitions)

            if repeated == digits {
                return true
            }
        }

        return false
    }

    func getInvalidIds2(range: ClosedRange<Int>) -> [Int] {
        return range.filter(isIdValid2)
    }

    func getInvalidIds2(ranges: [ClosedRange<Int>]) -> [Int] {
        return ranges.flatMap(getInvalidIds2)
    }

    func part2() -> Int {
        return getValues().flatMap(getInvalidIds2).reduce(0, +)
    }
}
