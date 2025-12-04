import Algorithms
import Foundation

struct Day04: AdventDay {
    nonisolated init(data: String) {
        self.data = data
    }

    var data: String

    func getValues() -> Set<Point> {
        Set(
            data.split(separator: "\n")
                .enumerated()
                .flatMap { lineIndex, row in
                    row.enumerated()
                        .filter { $0.element == "@" }
                        .map { rowIndex, _ in Point(rowIndex, lineIndex) }
                })
    }

    let neibours: Set<Point> = [
        Point(-1, -1), Point(0, -1), Point(1, -1),
        Point(-1, 0), Point(1, 0),
        Point(-1, 1), Point(0, 1), Point(1, 1),
    ]

    func nrOfRolls(diagram: Set<Point>, position: Point) -> Int {
        return neibours.map { diagram.contains(position + $0) ? 1 : 0 }.sum()
    }

    func canAccessRoll(diagram: Set<Point>, position: Point) -> Bool {
        return nrOfRolls(diagram: diagram, position: position) < 4
    }

    func nrOfAccessibleRolls(diagram: Set<Point>) -> Int {
        return diagram.map {
            canAccessRoll(diagram: diagram, position: $0) ? 1 : 0
        }.sum()
    }

    func part1() -> Int {
        let rolls = getValues()
        print(rolls)
        return nrOfAccessibleRolls(diagram: rolls)
    }

    func part2() -> Int {
        return -1
    }
}
