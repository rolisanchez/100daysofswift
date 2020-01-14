import UIKit

//Protocols and extensions
//Protocols

protocol Identifiable1 {
    var id: String { get set }
}

struct User1: Identifiable1 {
    var id: String
}

func displayID(thing: Identifiable1) {
    print("My ID is \(thing.id)")
}
//Protocol inheritance

protocol Payable {
    func calculateWages() -> Int
}

protocol NeedsTraining {
    func study()
}

protocol HasVacation {
    func takeVacation(days: Int)
}

protocol Employee: Payable, NeedsTraining, HasVacation { }

struct AppleEmployee: Employee {
    func calculateWages() -> Int {
        return 999
    }
    
    func study() {
        print("Studying Swift...")
    }
    
    func takeVacation(days: Int) {
        print("Takind \(days) vactation..")
    }
    
    
}

//Extensions

extension Int {
    func squared() -> Int {
        return self * self
    }
}

let number = 8
number.squared()

extension Int {
    var isEven: Bool {
        return self % 2 == 0
    }
}

number.isEven

//Protocol extensions

let pythons = ["Eric", "Graham", "John", "Michael", "Terry", "Terry"]
let beatles = Set(["John", "Paul", "George", "Ringo"])

extension Collection {
    func summarize() {
        print("There are \(count) of us:")
        
        for name in self {
            print(name)
        }
    }
}

pythons.summarize()
beatles.summarize()

//Protocol-oriented programming

protocol Identifiable {
    var id: String { get set }
    func identify()
}

extension Identifiable {
    func identify() {
        print("My ID is \(id).")
    }
}

struct User: Identifiable {
    var id: String
}

let twostraws = User(id: "twostraws")
twostraws.identify()

//Protocols and extensions summary

