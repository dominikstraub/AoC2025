import Algorithms
import Foundation

struct Day08: AdventDay {
  nonisolated init(data: String) {
    self.data = data
  }

  var data: String

  func getValues() -> Set<Point3D> {
    return Set(
      data.split(separator: "\n").compactMap {
        let parts = $0.split(separator: ",")
        return Point3D(Int(parts[0])!, Int(parts[1])!, Int(parts[2])!)
      })
  }

  func getDistance(_ a: Point3D, _ b: Point3D) -> Double {
    let xDiff = abs(a.x - b.x)
    let yDiff = abs(a.y - b.y)
    let zDiff = abs(a.z - b.z)
    return sqrt(Double(xDiff * xDiff + yDiff * yDiff + zDiff * zDiff))
  }

  func part1() -> Int {
    let values = getValues()
    // print(values)
    let pairs = 1000
    var distances: [(distance: Double, a: Point3D, b: Point3D)] = []

    for pair in values.combinations(ofCount: 2) {
      let a = pair[0]
      let b = pair[1]
      let newDistance = (distance: getDistance(a, b), a: a, b: b)
      if distances.count < pairs {
        distances.append(newDistance)
      } else {
        if distances.count == pairs {
          distances.sort(by: { $0.distance < $1.distance })
        }
        for (index, distance) in distances.enumerated()
        where newDistance.distance < distance.distance {
          distances.insert(newDistance, at: index)
          distances.removeLast()
          break
        }
      }
    }
    // print("")
    // print(distances)

    var circuits: Set<Set<Point3D>> = []
    for distance in distances {
      var found: Set<Point3D>? = nil
      for var circuit in circuits {
        if circuit.contains(distance.a) || circuit.contains(distance.b) {
          if var found {
            circuits.remove(found)
            found.formUnion(circuit)
            circuits.remove(circuit)
            circuits.insert(found)
          } else {
            circuits.remove(circuit)
            circuit.insert(distance.a)
            circuit.insert(distance.b)
            found = circuit
            circuits.insert(circuit)
          }
        }
      }
      if found == nil {
        circuits.insert([distance.a, distance.b])
      }
    }
    // print("")
    // print(circuits)

    let top3 = circuits.sorted { $0.count > $1.count }[0..<3]
    // print("")
    // print(top3)

    return top3.map { $0.count }.product()
  }

  func part2() -> Int {
    let values = getValues()
    // print(values)
    var distances: [(distance: Double, a: Point3D, b: Point3D)] = []

    for pair in values.combinations(ofCount: 2) {
      let a = pair[0]
      let b = pair[1]
      let newDistance = (distance: getDistance(a, b), a: a, b: b)
      distances.append(newDistance)
    }
    distances.sort(by: { $0.distance < $1.distance })
    // print("")
    // print(distances)

    var circuits: Set<Set<Point3D>> = []
    var lastOnes: Set<Point3D> = []
    disLoop: for distance in distances {
      var found: Set<Point3D>? = nil
      for var circuit in circuits {
        if circuit.contains(distance.a) || circuit.contains(distance.b) {
          if var found {
            circuits.remove(found)
            found.formUnion(circuit)
            circuits.remove(circuit)
            circuits.insert(found)
            if found.count == values.count {
              lastOnes.insert(distance.a)
              lastOnes.insert(distance.b)
              break disLoop
            }
          } else {
            circuits.remove(circuit)
            circuit.insert(distance.a)
            circuit.insert(distance.b)
            found = circuit
            circuits.insert(circuit)
            if circuit.count == values.count {
              lastOnes.insert(distance.a)
              lastOnes.insert(distance.b)
              break disLoop
            }
          }
        }
      }
      if found == nil {
        circuits.insert([distance.a, distance.b])
      }
    }
    // print("")
    // print(circuits)

    return lastOnes.map { $0.x }.product()
  }
}
