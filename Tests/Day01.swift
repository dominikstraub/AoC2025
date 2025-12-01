import Testing

@testable import AdventOfCode

struct Day01Tests {
    let testData = [
        (
            input: """
            L68
            L30
            R48
            L5
            R60
            L55
            L1
            L99
            R14
            L82
            """,
            result1: 3,
            result2: 6
        ),
    ]

    @Test func testPart1() async throws {
        for testDataEl in testData {
            if testDataEl.result1 == -1 { continue }
            let challenge = Day01(data: testDataEl.input)
            #expect(challenge.part1() == testDataEl.result1)
        }
    }

    @Test func testPart2() async throws {
        for testDataEl in testData {
            if testDataEl.result2 == -1 { continue }
            let challenge = Day01(data: testDataEl.input)
            #expect(challenge.part2() == testDataEl.result2)
        }
    }
}
