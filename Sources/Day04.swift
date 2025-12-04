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
        let diagram = getValues()
        // print(diagram)
        return nrOfAccessibleRolls(diagram: diagram)
    }

    func nrOfRolls2(diagram: Set<Point>, position: Point) -> Int {
        return neibours.map { diagram.contains(position + $0) ? 1 : 0 }.sum()
    }

    func canAccessRoll2(diagram: Set<Point>, position: Point) -> Bool {
        return nrOfRolls2(diagram: diagram, position: position) < 4
    }

    func removeRolls2(diagram: inout Set<Point>) {
        while !diagram.isEmpty {
            var change = false
            for position in diagram where canAccessRoll2(diagram: diagram, position: position) {
                change = true
                diagram.remove(position)
            }
            if !change {
                break
            }
        }
    }

    func part2() -> Int {
        var diagram = getValues()
        // print(diagram)
        let countBefore = diagram.count
        removeRolls2(diagram: &diagram)
        return countBefore - diagram.count
    }
}
