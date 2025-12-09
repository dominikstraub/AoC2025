import Algorithms
import Foundation

struct Day09: AdventDay {
  nonisolated init(data: String) {
    self.data = data
  }

  var data: String

  func getValues() -> [Point] {
    return
      data.split(separator: "\n").compactMap {
        let parts = $0.split(separator: ",")
        return Point(Int(parts[0])!, Int(parts[1])!)
      }
  }

  func getSize(_ a: Point, _ b: Point) -> Int {
    let xDiff = abs(a.x - b.x) + 1
    let yDiff = abs(a.y - b.y) + 1
    return xDiff * yDiff
  }

  func part1() -> Int {
    let values = getValues()
    // print(values)
    var sizes: [(size: Int, a: Point, b: Point)] = []

    for pair in values.combinations(ofCount: 2) {
      let a = pair[0]
      let b = pair[1]
      let newSize = (size: getSize(a, b), a: a, b: b)
      sizes.append(newSize)
    }
    sizes.sort(by: { $0.size > $1.size })

    // print("")
    // print(sizes)

    let top = sizes[0]
    // print("")
    // print(top3)

    return top.size
  }

  func printGrid(grid: Set<Point>) {
    let maxX = grid.map(\.x).max()!
    let maxY = grid.map(\.y).max()!

    for y in 0...maxY {
      for x in 0...maxX {
        print(grid.contains(Point(x, y)) ? "X" : ".", terminator: "")
      }
      print("")
    }
    print("")
  }

  func buildBorderIndex(border: Set<Point>) -> [Int: [Int]] {
    var borderByRow: [Int: [Int]] = [:]
    for point in border {
      borderByRow[point.y, default: []].append(point.x)
    }
    for key in borderByRow.keys {
      borderByRow[key]?.sort()
    }
    return borderByRow
  }

  func isInside(point: Point, border: Set<Point>, borderByRow: [Int: [Int]]) -> Bool {
    guard let rowPoints = borderByRow[point.y] else {
      return false
    }

    let sorted = rowPoints.filter { $0 < point.x }
    var crossings = 0
    var i = 0

    while i < sorted.count {
      let x = sorted[i]
      let hasAbove = border.contains(Point(x, point.y - 1))
      let hasBelow = border.contains(Point(x, point.y + 1))

      if hasAbove && hasBelow {
        // Vertical segment - counts as crossing
        crossings += 1
        i += 1
      } else if hasAbove || hasBelow {
        // Horizontal segment - find the end
        let startGoesUp = hasAbove
        var j = i + 1
        while j < sorted.count && sorted[j] == sorted[j - 1] + 1 {
          j += 1
        }
        let endX = sorted[j - 1]
        let endGoesUp = border.contains(Point(endX, point.y - 1))
        // Only count if corners go opposite directions
        if startGoesUp != endGoesUp {
          crossings += 1
        }
        i = j
      } else {
        i += 1
      }
    }

    return crossings % 2 == 1
  }

  func isInsideOrBorder(point: Point, border: Set<Point>, borderByRow: [Int: [Int]]) -> Bool {
    if border.contains(point) {
      return true
    }
    return isInside(point: point, border: border, borderByRow: borderByRow)
  }

  func buildBorder(from tiles: [Point]) -> Set<Point> {
    var grid: Set<Point> = []
    var previous: Point? = nil

    for tile in tiles {
      grid.insert(tile)
      if let previous {
        for y in min(previous.y, tile.y)...max(previous.y, tile.y) {
          for x in min(previous.x, tile.x)...max(previous.x, tile.x) {
            grid.insert(Point(x, y))
          }
        }
      }
      previous = tile
    }

    // Close the loop back to first tile
    if let previous {
      let tile = tiles[0]
      for y in min(previous.y, tile.y)...max(previous.y, tile.y) {
        for x in min(previous.x, tile.x)...max(previous.x, tile.x) {
          grid.insert(Point(x, y))
        }
      }
    }

    return grid
  }

  func isRectangleInside(
    minX: Int, maxX: Int, minY: Int, maxY: Int,
    border: Set<Point>, borderByRow: [Int: [Int]]
  ) -> Bool {
    // Check all 4 corners
    let corners = [
      Point(minX, minY), Point(maxX, minY),
      Point(minX, maxY), Point(maxX, maxY),
    ]
    for corner in corners {
      if !isInsideOrBorder(point: corner, border: border, borderByRow: borderByRow) {
        return false
      }
    }

    // Check each row for gaps
    for y in minY...maxY {
      guard let rowPoints = borderByRow[y] else {
        // No border on this row - check if inside
        if !isInside(point: Point(minX, y), border: border, borderByRow: borderByRow) {
          return false
        }
        continue
      }

      let borderInRect = rowPoints.filter { $0 >= minX && $0 <= maxX }

      if borderInRect.isEmpty {
        // No border in rect on this row - check if inside
        if !isInside(point: Point(minX, y), border: border, borderByRow: borderByRow) {
          return false
        }
      } else {
        let sortedBorder = borderInRect.sorted()

        // Check left gap
        if sortedBorder[0] > minX {
          if !isInside(point: Point(minX, y), border: border, borderByRow: borderByRow) {
            return false
          }
        }

        // Check gaps between border segments
        for i in 0..<sortedBorder.count - 1 {
          if sortedBorder[i + 1] > sortedBorder[i] + 1 {
            let gapPoint = Point(sortedBorder[i] + 1, y)
            if !isInside(point: gapPoint, border: border, borderByRow: borderByRow) {
              return false
            }
          }
        }

        // Check right gap
        if sortedBorder.last! < maxX {
          if !isInside(point: Point(maxX, y), border: border, borderByRow: borderByRow) {
            return false
          }
        }
      }
    }

    return true
  }

  func part2() -> Int {
    let redTiles = getValues()
    // print(redTiles)

    let grid = buildBorder(from: redTiles)
    let borderByRow = buildBorderIndex(border: grid)

    // printGrid(grid: grid)

    var sizes: [(size: Int, a: Point, b: Point)] = []

    pairLoop: for pair in redTiles.combinations(ofCount: 2) {
      let a = pair[0]
      let b = pair[1]

      let minX = min(a.x, b.x)
      let maxX = max(a.x, b.x)
      let minY = min(a.y, b.y)
      let maxY = max(a.y, b.y)

      if !isRectangleInside(
        minX: minX, maxX: maxX, minY: minY, maxY: maxY,
        border: grid, borderByRow: borderByRow
      ) {
        continue pairLoop
      }

      let newSize = (size: getSize(a, b), a: a, b: b)
      sizes.append(newSize)
    }
    sizes.sort(by: { $0.size > $1.size })

    // print("")
    // print(sizes)

    let top = sizes[0]
    // print("")
    // print(top)

    return top.size
  }
}
