import Algorithms
import Foundation

struct Day00: AdventDay {
  nonisolated init(data: String) {
    self.data = data
  }

  var data: String

  func getValues() -> [Point] {
    return data.split(separator: "\n").compactMap {
      let parts = $0.split(separator: ",")
      return Point(Int(parts[0])!, Int(parts[1])!)
    }
  }

  func part1() -> Int {
    let values = getValues()
    print(values)
    return -1
  }

  func part2() -> Any {
    return -1
  }
}
