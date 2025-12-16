import Algorithms
import Foundation

struct Day12: AdventDay {
  nonisolated init(data: String) {
    self.data = data
  }

  var data: String

  func getValues() -> (shapes: Int, regions: [(size: Point, count: Int)]) {
    let tmp = data.split(separator: "\n\n")
    // tmp[0 ..< tmp.count - 1].compactMap {
    //     let parts = $0.split(separator: ",")
    //     return Point(Int(parts[0])!, Int(parts[1])!)
    // }
    let tmp5 = String(tmp[tmp.count - 1])
    let regions = tmp5.split(separator: "\n").compactMap { regionLine in
      let tmp2 = regionLine.split(separator: ": ")
      let tmp3 = tmp2[0].split(separator: "x")
      let tmp4 = tmp2[1].split(separator: " ").compactMap { countChar in
        Int(String(countChar))
      }.sum()
      return (size: Point(Int(tmp3[0])!, Int(tmp3[1])!), count: tmp4)
    }
    return (shapes: -1, regions: regions)
  }

  func part1() -> Int {
    return getValues().regions.filter { $0.size.x / 3 * $0.size.y / 3 >= $0.count }.count
  }

  func part2() -> Any {
    return -1
  }
}
