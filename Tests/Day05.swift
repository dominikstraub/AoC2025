import Testing

@testable import AdventOfCode

struct Day05Tests {
  let testData = [
    (
      input: """
      3-5
      10-14
      16-20
      12-18

      1
      5
      8
      11
      17
      32
      """,
      result1: 3,
      result2: 14
    )
  ]

  @Test func testPart1() async throws {
    for testDataEl in testData {
      if testDataEl.result1 == -1 { continue }
      let challenge = Day05(data: testDataEl.input)
      #expect(challenge.part1() == testDataEl.result1)
    }
  }

  @Test func testPart2() async throws {
    for testDataEl in testData {
      if testDataEl.result2 == -1 { continue }
      let challenge = Day05(data: testDataEl.input)
      #expect(challenge.part2() == testDataEl.result2)
    }
  }
}
