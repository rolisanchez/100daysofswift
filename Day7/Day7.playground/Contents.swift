import UIKit

//Structs

//Creating your own structs

struct Sport1 {
    var name: String
}

var tennis = Sport1(name: "Tennis")
print(tennis.name)

tennis.name = "Lawn tennis"
print(tennis.name)

//Computed properties.

struct Sport {
    var name: String
    var isOlympicSport: Bool
    
    var olympicStatus: String {
        if isOlympicSport {
            return "\(name) is an Olympic sport"
        } else {
            return "\(name) is not an Olympic sport"
        }
    }
}

let chessBoxing = Sport(name: "Chessboxing", isOlympicSport: false)
print(chessBoxing.olympicStatus)

//Property observers

struct Progress1 {
    var task: String
    var amount: Int
}

var progress1 = Progress1(task: "Loading data", amount: 0)
progress1.amount = 30
progress1.amount = 80
progress1.amount = 100

struct Progress {
    var task: String
    var amount: Int {
        didSet {
            print("\(task) is now \(amount)% complete")
        }
    }
}

var progress = Progress(task: "Loading data", amount: 0)
progress.amount = 30
progress.amount = 80
progress.amount = 100

//Methods

struct City {
    var population: Int
    
    func collectTaxes() -> Int {
        return population * 1000
    }
}

let london = City(population: 9_000_000)
london.collectTaxes()

//Mutating methods

struct Person1 {
    var name: String
    
    mutating func makeAnonymous() {
        name = "Anonymous"
    }
}

var person1 = Person1(name: "Ed")
person1.makeAnonymous()

//Properties and methods of strings

let string = "Do or do not, there is no try."

print(string.count)

print(string.hasPrefix("Do"))

print(string.uppercased())

print(string.sorted())

//Properties and methods of arrays

var toys = ["Woody"]

print(toys.count)
toys.append("Buzz")
toys.firstIndex(of: "Buzz")
print(toys.sorted())
toys.remove(at: 0)
toys.firstIndex(of: "Buzz")

//Initializers

struct User1 {
    var username: String
}

var user1 = User1(username: "twostraws")

struct User {
    var username: String
    
    init() {
        username = "Anonymous"
        print("Creating a new user!")
    }
}

var user = User()
user.username = "twostraws"

//Referring to the current instance

struct Person2 {
    var name: String
    
    init(name: String) {
        print("\(name) was born!")
        self.name = name
    }
}

//Lazy properties

struct FamilyTree {
    init() {
        print("Creating family tree!")
    }
}

struct Person3 {
    var name: String
    var familyTree = FamilyTree()
    
    init(name: String) {
        self.name = name
    }
}

var ed3 = Person3(name: "Ed")

struct Person4 {
    var name: String
    lazy var familyTree = FamilyTree()
    
    init(name: String) {
        self.name = name
    }
}

var ed4 = Person4(name: "Ed")

ed4.familyTree

//Static properties and methods

struct Student1 {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}

let ed1 = Student1(name: "Ed")
let taylor1 = Student1(name: "Taylor")

struct Student {
    static var classSize = 0
    var name: String
    
    init(name: String) {
        self.name = name
        Student.classSize += 1
    }
}

let ed2 = Student(name: "Ed")
let taylor2 = Student(name: "Taylor")

print(Student.classSize)

struct Pokemon {
    static var numberCaught = 0
    var name: String
    static func catchPokemon() {
        print("Caught!")
        Pokemon.numberCaught += 1
    }
}

//Access control

struct Person5 {
    var id: String
    
    init(id: String) {
        self.id = id
    }
}

var ed5 = Person5(id: "12345")
ed5.id = "XX"
print(ed5)

struct Person6 {
    private var id: String
    
    init(id: String) {
        self.id = id
    }
}

let ed6 = Person6(id: "12345")

struct Person {
    private var id: String
    
    init(id: String) {
        self.id = id
    }
    
    func identify() -> String {
        return "My social security number is \(id)"
    }
}

let ed = Person(id: "12345")
ed.identify()

//Structs summary
