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
    next current: String, graph: [String: Set<String>], devices: Set<String>,
    pathCounts: inout [String: (good: Int, all: Int)]
  ) -> (good: Int, all: Int) {
    // print(current)
    // print(devices.count)
    // print(graph)

    if current == "out" {
      if devices.contains("dac"), devices.contains("fft") {
        print(devices)
        return (good: 1, all: 1)
      } else {
        return (good: 0, all: 1)
      }
    }
    if devices.contains(current) {
      print("loop detected")
      return (good: 0, all: 0)
    }

    var newDevices = devices
    newDevices.insert(current)

    var count = (good: 0, all: 0)
    for next in graph[current]! {
      if let newCount = pathCounts[next] {
        count.good += newCount.good
        count.all += newCount.all
      } else {
        let result = check2(next: next, graph: graph, devices: newDevices, pathCounts: &pathCounts)
        count.good += result.good
        count.all += result.all
      }
    }

    pathCounts[current] = count

    if newDevices.contains("dac"), newDevices.contains("fft") {
      count.good = count.all
    }
    return count
  }

  func part2() -> Int {
    let values = getValues()
    // print(values)

    var pathCounts: [String: (good: Int, all: Int)] = [:]
    let result = check2(next: "svr", graph: values, devices: [], pathCounts: &pathCounts)
    return result.good
  }
}
