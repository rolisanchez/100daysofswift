import UIKit

// Extend Int with a times() method that runs a closure as many times as the number is high. For example, 5.times { print("Hello!") } will print “Hello” five times.

extension Int {
    func times(){
        for _ in 0..<abs(self) {
            print("Hello!")
        }
    }
}

5.times()

0.times()

(-5).times()


// Extend Array so that it has a mutating remove(item:) method. If the item exists more than once, it should remove only the first instance it finds. Tip: you will need to add the Comparable constraint to make this work!

extension Array where Element: Comparable {
    mutating func remove(item: Element) {
        if let index = self.firstIndex(of: item){
            self.remove(at: index)
        }
    }
}

var array = ["Jon", "Arya"]

array.remove(item: "Jon")
