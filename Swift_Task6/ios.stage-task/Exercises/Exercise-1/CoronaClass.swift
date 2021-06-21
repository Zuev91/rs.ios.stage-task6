import Foundation

class CoronaClass {

    var seats = [Int]()
    let n: Int
    
    init(n: Int) {
        self.n = n
    }

    func seat() -> Int {
        guard !seats.isEmpty else {
            seats.append(0)
            return 0
        }
        
        guard seats.count != 1 else {
            seats.append(n - 1)
            return n - 1
        }

        var ranges = [ClosedRange<Int>]()

        for seat in seats.enumerated() {
            
            if let nextSeat = seats[safe: seat.offset + 1] {
                if seats[safe: seat.offset - 1] != nil {
                    let range = (seat.element ... nextSeat)
                    ranges.append(range)
                } else {
                    if seat.element == 0 {
                        ranges.append((seat.element ... nextSeat))
                    } else {
                        ranges.append((0 ... seat.element))
                    }
                }
            } else {
                if seat.element == n - 1 {
                    continue
                } else {
                    ranges.append((seat.element ... n - 1))
                }
            }
        }

        let rangeMax = ranges.map(\.minRange).max()
        let rangeIndex = ranges.firstIndex{ $0.minRange == rangeMax }
        let finalRange = ranges[rangeIndex!]
        seats.append(finalRange.middle)
        seats.sort(by: <)
        return finalRange.middle
    }

    func leave(_ p: Int) {
        let index = seats.firstIndex(of: p)!
        seats.remove(at: index)
        seats.sort(by: <)
    }
}

fileprivate extension Collection {

    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

fileprivate extension ClosedRange where Bound == Int {
    var middle: Int {
        (lowerBound + upperBound) / 2
    }
    var minRange: Int {
        Swift.min(middle - lowerBound, upperBound - middle)
    }
}

extension ClosedRange: Comparable where Bound == Int {
    
    public static func < (lhs: ClosedRange<Bound>, rhs: ClosedRange<Bound>) -> Bool {
        lhs.lowerBound < rhs.lowerBound
    }
    
}
