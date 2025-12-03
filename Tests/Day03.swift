import Testing

@testable import AdventOfCode

struct Day03Tests {
    let testData = [
        (
            input: """
            987654321111111
            811111111111119
            234234234234278
            818181911112111
            """,
            result1: 357,
            result2: -1
        ),
    ]

    @Test func testPart1() async throws {
        for testDataEl in testData {
            if testDataEl.result1 == -1 { continue }
            let challenge = Day03(data: testDataEl.input)
            #expect(challenge.part1() == testDataEl.result1)
        }
    }

    @Test func testPart2() async throws {
        for testDataEl in testData {
            if testDataEl.result2 == -1 { continue }
            let challenge = Day03(data: testDataEl.input)
            #expect(challenge.part2() == testDataEl.result2)
        }
    }
}
