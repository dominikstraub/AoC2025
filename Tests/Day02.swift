import Testing

@testable import AdventOfCode

struct Day02Tests {
    let testData = [
        (
            input: """
            11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124
            """,
            result1: 1_227_775_554,
            result2: 4_174_379_265
        ),
    ]

    @Test func testPart1() async throws {
        for testDataEl in testData {
            if testDataEl.result1 == -1 { continue }
            let challenge = Day02(data: testDataEl.input)
            #expect(challenge.part1() == testDataEl.result1)
        }
    }

    @Test func testPart2() async throws {
        for testDataEl in testData {
            if testDataEl.result2 == -1 { continue }
            let challenge = Day02(data: testDataEl.input)
            #expect(challenge.part2() == testDataEl.result2)
        }
    }
}
