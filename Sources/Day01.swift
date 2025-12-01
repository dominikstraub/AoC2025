import Algorithms
import Foundation

struct Day01: AdventDay {
    nonisolated init(data: String) {
        self.data = data
    }

    var data: String

    func getValues() -> [String] {
        return data.split(separator: "\n").compactMap {
            String($0)
        }
    }

    func part1() -> Int {
        let values = getValues()
        // print(values)
        var dial = 50
        var count = 0
        for val in values {
            let rotate = Int(val.dropFirst())
            guard let rotate else {
                return -3
            }
            switch val[0] {
            case "L":
                dial -= rotate
            case "R":
                dial += rotate
            default:
                return -2
            }
            dial %= 100
            if dial == 0 {
                count += 1
            }
        }

        return count
    }

    func part2() -> Int {
        let values = getValues()
        // print(values)
        var dial = 50
        var count = 0
        for val in values {
            let oldDial = dial
            let rotate = Int(val.dropFirst())
            guard let rotate else {
                return -3
            }
            switch val[0] {
            case "L":
                dial -= rotate
            case "R":
                dial += rotate
            default:
                return -2
            }

            let crossings: Int
            if dial >= 100 {
                crossings = dial / 100
            } else if dial <= 0 {
                if oldDial == 0 {
                    crossings = ((-dial + 100) / 100) - 1
                } else {
                    crossings = (-dial + 100) / 100
                }
            } else {
                crossings = 0
            }
            count += crossings

            dial %= 100
            if dial < 0 {
                dial += 100
            }
        }

        return count
    }
}
