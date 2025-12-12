import Algorithms
import Foundation

struct Day11: AdventDay {
  nonisolated init(data: String) {
    self.data = data
  }

  var data: String

  func getValues() -> [String: Set<String>] {
    var result: [String: Set<String>] = [:]
    for line in data.split(separator: "\n") {
      let parts = line.split(separator: ":")
      let device = String(parts[0])
      let out = Set(
        parts[1].trimmingCharacters(in: .whitespacesAndNewlines)
          .split(separator: " ").map(String.init))

      result[device] = out
    }

    return result
  }

  func check(next current: String, graph: [String: Set<String>]) -> Int {
    // print(current)
    // print(graph)
    if current == "out" {
      return 1
    }
    var count = 0
    for next in graph[current]! {
      count += check(next: next, graph: graph)
    }
    return count
  }

  func part1() -> Int {
    let values = getValues()
    // print(values)

    return check(next: "you", graph: values)
  }

  func check2(
    next current: String, target: String, graph: [String: Set<String>], devices: Set<String>,
    pathCounts: inout [String: Int]
  ) -> Int {
    if current == target {
      return 1
    }
    if devices.contains(current) {
      print("loop detected")
      return 0
    }

    var newDevices = devices
    newDevices.insert(current)

    var count = 0
    for next in graph[current, default: []] {
      if let newCount = pathCounts[next] {
        count += newCount
      } else {
        let result = check2(
          next: next, target: target, graph: graph, devices: newDevices, pathCounts: &pathCounts
        )
        count += result
      }
    }

    pathCounts[current] = count

    return count
  }

  func part2() -> Int {
    let values = getValues()
    // print(values)

    var pathCounts: [String: Int] = [:]
    let svrDac = check2(
      next: "svr", target: "dac", graph: values, devices: [], pathCounts: &pathCounts
    )
    pathCounts = [:]
    let dacFft = check2(
      next: "dac", target: "fft", graph: values, devices: [], pathCounts: &pathCounts
    )
    pathCounts = [:]
    let fftOut = check2(
      next: "fft", target: "out", graph: values, devices: [], pathCounts: &pathCounts
    )

    pathCounts = [:]
    let svrFft = check2(
      next: "svr", target: "fft", graph: values, devices: [], pathCounts: &pathCounts
    )
    pathCounts = [:]
    let fftDac = check2(
      next: "fft", target: "dac", graph: values, devices: [], pathCounts: &pathCounts
    )
    pathCounts = [:]
    let dacOut = check2(
      next: "dac", target: "out", graph: values, devices: [], pathCounts: &pathCounts
    )
    return svrDac * dacFft * fftOut + svrFft * fftDac * dacOut
  }
}
