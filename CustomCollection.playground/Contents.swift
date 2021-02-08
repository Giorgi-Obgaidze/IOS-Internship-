import UIKit


class StructElement<T: Hashable, Y> {
    var key: T
    var value: Y?
    
    init(_ key: T, _ value: Y?) {
        self.key = key
        self.value = value
    }
}

struct CustomCollection<Key: Hashable, Value> {
    
    typealias Bag = [StructElement<Key, Value>]
    
    var bagArray: [Bag]
    
    init(capacity: Int) {
        assert(capacity > 0)
        bagArray = Array<Bag>(repeatElement([], count: capacity))
    }
    
    func getIndex(for key: Key) -> Int {
        var divisor: Int = 0
        for key in String(describing: key).unicodeScalars {
            divisor += abs(Int(key.value.hashValue))
        }
        let index = abs(divisor) % bagArray.count
        return index
    }
    
    mutating func removeValue(for key: Key){
        let index = self.getIndex(for: key)
        for (i, elem) in bagArray[index].enumerated() {
            if elem.key == key {
                bagArray[index].remove(at: i)
            }
        }
    }

    
    func value(for key: Key) -> Value? {
        let index = self.getIndex(for: key)
        for e in bagArray[index] {
            if e.key == key {
                return e.value
            }
        }
        return nil
    }
    
    
    mutating func addValue(data value: Value, forKey key: Key) {
        bagArray[self.getIndex(for: key)].append(StructElement(key, value))
    }
    
}

