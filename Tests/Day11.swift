import Testing

@testable import AdventOfCode

struct Day11Tests {
  let testData = [
    (
      input: """
      svr: aaa bbb
      aaa: fft
      fft: ccc
      bbb: tty
      tty: ccc
      ccc: ddd eee
      ddd: hub
      hub: fff
      eee: dac
      dac: fff
      fff: ggg hhh
      ggg: out
      hhh: out
      """,
      result1: 5,
      result2: 2
    )
  ]

  @Test func testPart1() async throws {
    for testDataEl in testData {
      if testDataEl.result1 == -1 { continue }
      let challenge = Day11(data: testDataEl.input)
      #expect(challenge.part1() == testDataEl.result1)
    }
  }

  @Test func testPart2() async throws {
    for testDataEl in testData {
      if testDataEl.result2 == -1 { continue }
      let challenge = Day11(data: testDataEl.input)
      #expect(challenge.part2() == testDataEl.result2)
    }
  }
}
