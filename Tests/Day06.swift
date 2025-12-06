import Testing

@testable import AdventOfCode

struct Day06Tests {
  let testData = [
    (
      input: """
      123 328  51 64
       45 64  387 23
        6 98  215 314
      *   +   *   +
      """,
      result1: 4_277_556,
      result2: 3_263_827
    )
  ]

  @Test func testPart1() async throws {
    for testDataEl in testData {
      if testDataEl.result1 == -1 { continue }
      let challenge = Day06(data: testDataEl.input)
      #expect(challenge.part1() == testDataEl.result1)
    }
  }

  @Test func testPart2() async throws {
    for testDataEl in testData {
      if testDataEl.result2 == -1 { continue }
      let challenge = Day06(data: testDataEl.input)
      #expect(challenge.part2() == testDataEl.result2)
    }
  }
}
