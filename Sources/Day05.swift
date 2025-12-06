import Algorithms
import Foundation

struct Day05: AdventDay {
  nonisolated init(data: String) {
    self.data = data
  }

  var data: String

  func getValues() -> (fresh: Set<ClosedRange<Int>>, ingredients: Set<Int>) {
    let parts = data.split(separator: "\n\n")
    let fresh = Set(
      parts[0].split(separator: "\n").compactMap { line in
        let rangeParts = line.split(separator: "-")
        return Int(rangeParts[0])!...Int(rangeParts[1])!
      })
    let ingredients = Set(
      parts[1].split(separator: "\n").compactMap { line in
        Int(line)
      })
    return (fresh: fresh, ingredients: ingredients)
  }

  func isFresh(ingredient: Int, fresh: Set<ClosedRange<Int>>) -> Bool {
    for range in fresh where range.contains(ingredient) {
      return true
    }
    return false
  }

  func part1() -> Int {
    let values = getValues()
    // print(values)
    return values.ingredients.filter { isFresh(ingredient: $0, fresh: values.fresh) }.count
  }

  func getFreshRanges(fresh: Set<ClosedRange<Int>>) -> Set<ClosedRange<Int>> {
    var ranges = Set<ClosedRange<Int>>()
    for workingRange in fresh {
      var mergedRange = workingRange

      while let overlapping = ranges.first(where: { mergedRange.overlaps($0) }) {
        ranges.remove(overlapping)
        let newLower = min(mergedRange.lowerBound, overlapping.lowerBound)
        let newUpper = max(mergedRange.upperBound, overlapping.upperBound)
        mergedRange = newLower...newUpper
      }

      ranges.insert(mergedRange)
    }
    return ranges
  }

  func part2() -> Int {
    let fresh = getValues().fresh
    // print("fresh: \(fresh)")
    return getFreshRanges(fresh: fresh).map { $0.count }.sum()
  }
}
