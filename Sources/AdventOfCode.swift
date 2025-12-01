import ArgumentParser
import Foundation

// Add each new day implementation to this array:
let allChallenges: [any AdventDay] = [
  Day00(),
  Day01(),
]

@main
struct AdventOfCode: AsyncParsableCommand {
  @Argument(help: "The day of the challenge. For December 1st, use '1'.")
  var day: Int?

  @Flag(help: "Benchmark the time taken by the solution")
  var benchmark: Bool = false

  @Flag(help: "Run all the days available")
  var all: Bool = false

  /// The selected day, or the latest day if no selection is provided.
  var selectedChallenge: any AdventDay {
    get throws {
      if let day {
        if let challenge = allChallenges.first(where: { $0.day == day }) {
          return challenge
        } else {
          throw ValidationError("No solution found for day \(day)")
        }
      } else {
        return latestChallenge
      }
    }
  }

  /// The latest challenge in `allChallenges`.
  var latestChallenge: any AdventDay {
    allChallenges.max(by: { $0.day < $1.day })!
  }

  func run<T>(part: () async throws -> T, named: String) async -> Duration {
    var result: Result<T, Error>?
    let timing = await ContinuousClock().measure {
      do {
        result = try .success(await part())
      } catch {
        result = .failure(error)
      }
    }
    switch result! {
    case .success(let success):
      print("\(named): \(success)")
    case .failure(let failure as PartUnimplemented):
      print("Day \(failure.day) part \(failure.part) unimplemented")
    case .failure(let failure):
      print("\(named): Failed with error: \(failure)")
    }
    return timing
  }

  func run() async throws {
    let challenges =
      if all {
        allChallenges
      } else {
        try [selectedChallenge]
      }

    for challenge in challenges {
      print("Executing Advent of Code challenge \(challenge.day)...")

      let timing1 = await run(part: challenge.part1, named: "Part 1")
      let timing2 = await run(part: challenge.part2, named: "Part 2")

      if benchmark {
        print("Part 1 took \(timing1), part 2 took \(timing2).")
        #if DEBUG
          print("Looks like you're benchmarking debug code. Try swift run -c release")
        #endif
      }
    }
  }
}

extension StringProtocol {
  public subscript(_ offset: Int) -> Element { self[index(startIndex, offsetBy: offset)] }
  public subscript(_ range: Range<Int>) -> SubSequence {
    prefix(range.lowerBound + range.count).suffix(range.count)
  }
  public subscript(_ range: ClosedRange<Int>) -> SubSequence {
    prefix(range.lowerBound + range.count).suffix(range.count)
  }
  public subscript(_ range: PartialRangeThrough<Int>) -> SubSequence {
    prefix(range.upperBound.advanced(by: 1))
  }
  public subscript(_ range: PartialRangeUpTo<Int>) -> SubSequence { prefix(range.upperBound) }
  public subscript(_ range: PartialRangeFrom<Int>) -> SubSequence {
    suffix(Swift.max(0, count - range.lowerBound))
  }

  public func contains(_ elements: Set<Character>) -> Bool {
    for element in elements where !contains(element) {
      return false
    }
    return true
  }

  public func hexToBin() -> String {
    return compactMap { $0.hexToBin() }.joined(separator: "")
  }

  public func binToDec() -> Int? {
    return Int(self, radix: 2)
  }

  public var isNumber: Bool {
    return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
  }
}

extension Character {
  public func hexToDec() -> Int? {
    return Int(string, radix: 16)
  }

  public func hexToBin() -> String? {
    guard let dec = hexToDec() else { return nil }
    return String(String(dec, radix: 2).paddingToLeft(upTo: 4, using: "0"))
  }
}

extension LosslessStringConvertible {
  public var string: String { .init(self) }
}

extension BidirectionalCollection {
  public subscript(safe offset: Int) -> Element? {
    guard !isEmpty,
      offset >= 0,
      let index = index(startIndex, offsetBy: offset, limitedBy: index(before: endIndex))
    else { return nil }
    return self[index]
  }
}

// modulo in swift can return negative numbers, so we make our own modulo operator
infix operator %%
extension Int {
  public static func %% (_ lhs: Int, _ rhs: Int) -> Int {
    if lhs >= 0 { return lhs % rhs }
    if lhs >= -rhs { return lhs + rhs }
    return ((lhs % rhs) + rhs) % rhs
  }
}

precedencegroup PowerPrecedence {
  higherThan: MultiplicationPrecedence
}
infix operator ^^ : PowerPrecedence
public func ^^ (radix: Int, power: Int) -> Int {
  return Int(pow(Double(radix), Double(power)))
}

public func ^^ (radix: Int, power: Int) -> Double {
  return pow(Double(radix), Double(power))
}

public func ^^ (radix: Double, power: Double) -> Double {
  return pow(radix, power)
}

public enum DefaultError: Error {
  case message(String)
}

public func print(string: String) {
  Swift.print(string)
}

extension Sequence where Element: AdditiveArithmetic {
  public func sum() -> Element { reduce(.zero, +) }
}

extension Sequence where Element: Numeric {
  public func product() -> Element { reduce(1, *) }
}

extension RangeReplaceableCollection where Self: StringProtocol {
  public func paddingToLeft(upTo length: Int, using element: Element = " ") -> SubSequence {
    return repeatElement(element, count: Swift.max(0, length - count))
      + suffix(Swift.max(count, count - length))
  }
}

extension Array {
  public subscript(safe range: Range<Index>) -> ArraySlice<Element>? {
    if range.endIndex > endIndex {
      if range.startIndex >= endIndex {
        return nil
      } else {
        return self[range.startIndex..<endIndex]
      }
    } else {
      return self[range]
    }
  }
}

public class Ref<T> {
  public var val: T

  public init(_ val: T) {
    self.val = val
  }
}

extension Ref where T: CustomStringConvertible {
  public var description: String {
    return "\(val.description)"
  }
}

public struct Point {
  public var x: Int
  public var y: Int
}

extension Point {
  // init(x: Int, y: Int) {
  //     self.x = x
  //     self.y = y
  // }

  public init(y: Int, x: Int) {
    self.x = x
    self.y = y
  }

  public init(coord0: Int, coord1: Int) {
    x = coord0
    y = coord1
  }

  public init(_ x: Int, _ y: Int) {
    self.x = x
    self.y = y
  }

  public init(array: [Int]) {
    x = array[0]
    y = array[1]
  }

  public init(_ array: [Int]) {
    x = array[0]
    y = array[1]
  }
}

extension Point {
  public var array: [Int] {
    get {
      [x, y]
    }
    set(newValue) {
      x = newValue[0]
      y = newValue[1]
    }
  }

  public subscript(_ dimension: Int) -> Int {
    get {
      array[dimension]
    }
    set(newValue) {
      array[dimension] = newValue
    }
  }

  public var coord0: Int {
    return x
  }

  public var coord1: Int {
    return y
  }
}

extension Point: CustomStringConvertible {
  public var description: String {
    return "(\(x), \(y))"
  }
}

extension Point: Sendable {}

extension Point: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(x.hashValue)
    hasher.combine(y.hashValue)
  }
}

extension Point: Equatable {
  public static func == (lhs: Point, rhs: Point) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
  }
}

extension Point: Comparable {
  public static func < (lhs: Point, rhs: Point) -> Bool {
    return lhs.x < rhs.x || lhs.y < rhs.y
  }
}

extension Point {
  static func + (lhs: Point, rhs: Point) -> Point {
    return Point(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
  }

  static func - (lhs: Point, rhs: Point) -> Point {
    return Point(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
  }

  static func * (lhs: Point, rhs: Point) -> Point {
    return Point(x: lhs.x * rhs.x, y: lhs.y * rhs.y)
  }

  static func / (lhs: Point, rhs: Point) -> Point {
    return Point(x: lhs.x / rhs.x, y: lhs.y / rhs.y)
  }

  static prefix func - (point: Point) -> Point {
    return Point(x: -point.x, y: -point.y)
  }

  static func + (lhs: Point, rhs: Int) -> Point {
    return Point(x: lhs.x + rhs, y: lhs.y + rhs)
  }

  static func - (lhs: Point, rhs: Int) -> Point {
    return Point(x: lhs.x - rhs, y: lhs.y - rhs)
  }

  static func * (lhs: Point, rhs: Int) -> Point {
    return Point(x: lhs.x * rhs, y: lhs.y * rhs)
  }

  static func / (lhs: Point, rhs: Int) -> Point {
    return Point(x: lhs.x / rhs, y: lhs.y / rhs)
  }

  static func + (lhs: Int, rhs: Point) -> Point {
    return rhs + lhs
  }

  static func * (lhs: Int, rhs: Point) -> Point {
    return rhs * lhs
  }
}

extension Point {
  var rotatedClock90: Point {
    return Point(-y, x)
  }

  var rotatedCounterClock90: Point {
    return Point(y, -x)
  }
}

public struct Point3D {
  public var x: Int
  public var y: Int
  public var z: Int
}

extension Point3D {
  //    init(x: Int, y: Int, z: Int) {
  //        self.x = x
  //        self.y = y
  //        self.z = z
  //    }

  public init(_ x: Int, _ y: Int, _ z: Int) {
    self.x = x
    self.y = y
    self.z = z
  }

  public init(array: [Int]) {
    x = array[0]
    y = array[1]
    z = array[2]
  }

  public init(_ array: [Int]) {
    x = array[0]
    y = array[1]
    z = array[2]
  }
}

extension Point3D {
  public var array: [Int] {
    get {
      [x, y, z]
    }
    set(newValue) {
      x = newValue[0]
      y = newValue[1]
      z = newValue[2]
    }
  }

  public subscript(_ dimension: Int) -> Int {
    get {
      array[dimension]
    }
    set(newValue) {
      array[dimension] = newValue
    }
  }

  public var coord0: Int {
    return x
  }

  public var coord1: Int {
    return y
  }

  public var coord2: Int {
    return z
  }
}

extension Point3D: CustomStringConvertible {
  public var description: String {
    return "(\(x), \(y), \(z))"
  }
}

extension Point3D: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(x)
    hasher.combine(y)
    hasher.combine(z)
  }
}

extension Point3D: Equatable {
  public static func == (lhs: Point3D, rhs: Point3D) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
  }
}

extension Point3D: Comparable {
  public static func < (lhs: Point3D, rhs: Point3D) -> Bool {
    return lhs.x < rhs.x || lhs.y < rhs.y || lhs.z < rhs.z
  }
}

extension Int {
  public init?(_ description: Character) {
    if let val = Int(String(description)) {
      self = val
    } else {
      return nil
    }
  }
}

func printArray2D<T>(_ map: [[T]]) {
  for row in map {
    for field in row {
      print(field, terminator: "")
    }
    print("", terminator: "\n")
  }
}

func printMap<T>(_ map: [Point: T], emptyValue: T) {
  var orderd: [[T]] = []
  var offsetY = 0
  var offsetX = 0
  for (point, value) in map {
    if point.y < 0, offsetY < abs(point.y) {
      let newOffsetY = abs(point.y)
      for _ in 0..<newOffsetY - offsetY {
        orderd.insert([], at: 0)
      }
      offsetY = newOffsetY
    }
    let y = point.y + offsetY
    while orderd.count <= y {
      orderd.append([])
    }
    if point.x < 0, offsetX < abs(point.x) {
      let newOffsetX = abs(point.x)
      for _ in 0..<newOffsetX - offsetX {
        for currentY in 0..<orderd.count {
          orderd[currentY].insert(emptyValue, at: 0)
        }
      }
      offsetX = newOffsetX
    }
    let x = point.x + offsetX
    while orderd[y].count <= x {
      orderd[y].append(emptyValue)
    }
    orderd[y][x] = value
  }
  printArray2D(orderd)
}

func printSet(_ map: Set<Point>, value: String, emptyValue: String = " ") {
  var orderd: [[String]] = []
  var offsetY = 0
  var offsetX = 0
  for point in map {
    if point.y < 0, offsetY < abs(point.y) {
      let newOffsetY = abs(point.y)
      for _ in 0..<newOffsetY - offsetY {
        orderd.insert([], at: 0)
      }
      offsetY = newOffsetY
    }
    let y = point.y + offsetY
    while orderd.count <= y {
      orderd.append([])
    }
    if point.x < 0, offsetX < abs(point.x) {
      let newOffsetX = abs(point.x)
      for _ in 0..<newOffsetX - offsetX {
        for currentY in 0..<orderd.count {
          orderd[currentY].insert(emptyValue, at: 0)
        }
      }
      offsetX = newOffsetX
    }
    let x = point.x + offsetX
    while orderd[y].count <= x {
      orderd[y].append(emptyValue)
    }
    orderd[y][x] = value
  }
  printArray2D(orderd)
}
