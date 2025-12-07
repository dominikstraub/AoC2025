import Algorithms
import Foundation

struct Day07: AdventDay {
  enum GridValue: CustomStringConvertible, Equatable {
    case source
    case splitter
    case beam
    case empty
    case number(Int)

    var description: String {
      switch self {
      case .source: return "S"
      case .splitter: return "^"
      case .beam: return "|"
      case .empty: return "."
      case .number(let n): return String(n)
      }
    }
  }

  typealias GridField = [Point: GridValue]

  nonisolated init(data: String) {
    self.data = data
  }

  var data: String

  func getValues() -> (source: Point, grid: GridField, max: Point) {
    var map: GridField = [:]
    var source = Point(-1, -1)
    var max = Point(-1, -1)
    data.split(separator: "\n")
      .enumerated()
      .forEach { lineIndex, row in
        if lineIndex > max.x {
          max = Point(max.y, lineIndex)
        }
        for (rowIndex, value) in row.enumerated() {
          let gridValue: GridValue
          let point = Point(rowIndex, lineIndex)
          switch value {
          case "S":
            gridValue = .source
            source = point
          case "^":
            gridValue = .splitter
          case "|":
            gridValue = .beam
          case ".":
            gridValue = .empty
          default:
            gridValue = .empty
          }
          if gridValue != .empty {
            map[point] = gridValue
          }
          if rowIndex > max.y {
            max = Point(max.x, rowIndex)
          }
        }
      }
    return (source: source, grid: map, max: max)
  }

  func printGrid(grid: GridField, max: Point) {
    for y in 0...max.y {
      for x in 0...max.x {
        if case .number = grid[Point(x, y)] {
          print(GridValue.beam, terminator: "")
        } else {
          print(grid[Point(x, y)] ?? .empty, terminator: "")
        }
      }
      print("")
    }
  }

  func beamNextTick(position: Point, grid: inout GridField, max: Point) -> Int {
    if grid[position] == .empty || grid[position] == nil {
      grid[position] = .beam
    } else if grid[position] == .beam {
      return 0
    }
    if position.y >= max.y {
      return 0
    }
    if grid[position] == .splitter {
      return beamNextTick(position: position + Point(-1, 1), grid: &grid, max: max)
        + beamNextTick(position: position + Point(1, 1), grid: &grid, max: max) + 1
    } else {
      return beamNextTick(position: position + Point(0, 1), grid: &grid, max: max)
    }
  }

  func part1() -> Int {
    var values = getValues()
    let result = beamNextTick(
      position: values.source + Point(0, 1), grid: &values.grid, max: values.max
    )
    printGrid(grid: values.grid, max: values.max)
    return result
  }

  func beamNextTick2(position: Point, grid: inout GridField, max: Point) -> Int {
    if position.y >= max.y {
      return 1
    }
    if case .number(let n) = grid[position] {
      return n
    }
    if grid[position] == .splitter {
      let result =
        beamNextTick2(position: position + Point(-1, 1), grid: &grid, max: max)
        + beamNextTick2(position: position + Point(1, 1), grid: &grid, max: max)
      grid[position] = .number(result)
      return result
    } else {
      let result = beamNextTick2(position: position + Point(0, 1), grid: &grid, max: max)
      grid[position] = .number(result)
      return result
    }
  }

  func part2() -> Int {
    var values = getValues()
    let result = beamNextTick2(
      position: values.source + Point(0, 1), grid: &values.grid, max: values.max
    )
    printGrid(grid: values.grid, max: values.max)
    return result
  }
}
