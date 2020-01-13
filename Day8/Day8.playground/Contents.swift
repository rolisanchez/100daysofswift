import UIKit

//Classes
//Creating your own classes

class Dog1 {
    var name: String
    var breed: String
    
    init(name: String, breed: String) {
        self.name = name
        self.breed = breed
    }
}

let poppy1 = Dog1(name: "Poppy", breed: "Poodle")

//Class inheritance

class Poodle1: Dog1 {
    init(name: String) {
        super.init(name: name, breed: "Poodle")
    }
}

let poppy2 = Poodle1(name: "Poppy1")

//Overriding methods

class Dog2 {
    func makeNoise() {
        print("Woof!")
    }
}

class Poodle2: Dog2 {
    override func makeNoise() {
        print("Yip!")
    }
}

let poppy3 = Poodle2()
poppy3.makeNoise()

//Final classes

final class Dog {
    var name: String
    var breed: String
    
    init(name: String, breed: String) {
        self.name = name
        self.breed = breed
    }
}

//Copying objects

class Singer1 {
    var name = "Taylor Swift"
}

var singer1 = Singer1()
print(singer1.name)

var singerCopy = singer1
singerCopy.name = "Justin Bieber"
print(singerCopy.name)
print(singer1.name)

//Deinitializers

class Person1 {
    var name = "John Doe"
    
    init() {
        print("\(name) is alive!")
    }
    
    func printGreeting() {
        print("Hello, I'm \(name)")
    }
}

for _ in 1...3 {
    let person = Person1()
    person.printGreeting()
}

class Person {
    var name = "John Doe"
    
    init() {
        print("\(name) is alive!")
    }
    
    deinit {
        print("\(name) is no more!")
    }
    
    func printGreeting() {
        print("Hello, I'm \(name)")
    }
}

for _ in 1...3 {
    let person = Person()
    person.printGreeting()
}

//Mutability

class Singer {
    var name = "Taylor Swift"
}

let taylor = Singer()
taylor.name = "Ed Sheeran"
print(taylor.name)

//Classes summary
