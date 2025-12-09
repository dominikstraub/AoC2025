import Testing

@testable import AdventOfCode

struct Day09Tests {
  let testData = [
    (
      input: """
      7,1
      11,1
      11,7
      9,7
      9,5
      2,5
      2,3
      7,3
      """,
      result1: 50,
      result2: 24
    )
  ]

  @Test func testPart1() async throws {
    for testDataEl in testData {
      if testDataEl.result1 == -1 { continue }
      let challenge = Day09(data: testDataEl.input)
      #expect(challenge.part1() == testDataEl.result1)
    }
  }

  @Test func testPart2() async throws {
    for testDataEl in testData {
      if testDataEl.result2 == -1 { continue }
      let challenge = Day09(data: testDataEl.input)
      #expect(challenge.part2() == testDataEl.result2)
    }
  }
}
