import Testing

@testable import AdventOfCode

struct Day04Tests {
    let testData = [
        (
            input: """
            ..@@.@@@@.
            @@@.@.@.@@
            @@@@@.@.@@
            @.@@@@..@.
            @@.@@@@.@@
            .@@@@@@@.@
            .@.@.@.@@@
            @.@@@.@@@@
            .@@@@@@@@.
            @.@.@@@.@.
            """,
            result1: 13,
            result2: 43
        ),
    ]

    @Test func testPart1() async throws {
        for testDataEl in testData {
            if testDataEl.result1 == -1 { continue }
            let challenge = Day04(data: testDataEl.input)
            #expect(challenge.part1() == testDataEl.result1)
        }
    }

    @Test func testPart2() async throws {
        for testDataEl in testData {
            if testDataEl.result2 == -1 { continue }
            let challenge = Day04(data: testDataEl.input)
            #expect(challenge.part2() == testDataEl.result2)
        }
    }
}
