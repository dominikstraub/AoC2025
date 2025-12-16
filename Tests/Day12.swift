import Testing

@testable import AdventOfCode

struct Day12Tests {
  let testData = [
    (
      input: """
      0:
      ###
      ##.
      ##.

      1:
      ###
      ##.
      .##

      2:
      .##
      ###
      ##.

      3:
      ##.
      ###
      ##.

      4:
      ###
      #..
      ###

      5:
      ###
      .#.
      ###

      4x4: 0 0 0 0 2 0
      12x5: 1 0 1 0 2 2
      12x5: 1 0 1 0 3 2
      """,
      result1: 2,
      result2: -1
    )
  ]

  @Test func testPart1() async throws {
    for testDataEl in testData {
      if testDataEl.result1 == -1 { continue }
      let challenge = Day12(data: testDataEl.input)
      #expect(challenge.part1() == testDataEl.result1)
    }
  }

  //    @Test func testPart2() async throws {
  //        for testDataEl in testData {
  //            if testDataEl.result2 == -1 { continue }
  //            let challenge = Day12(data: testDataEl.input)
  //             #expect(challenge.part2() == testDataEl.result2)
  //        }
  //    }
}
