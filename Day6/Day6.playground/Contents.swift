import UIKit

//Creating basic closures

let driving1 = {
    print("I'm driving in my car")
}

driving1()

//Accepting parameters in a closure

let driving = { (place: String) in
    print("I'm going to \(place) in my car")
}

driving("London")

//Returning values from a closure

let drivingWithReturn = { (place: String) -> String in
    return "I'm going to \(place) in my car"
}

let message = drivingWithReturn("London")
print(message)

//Closures as parameters

func travel(action: () -> Void) {
    print("I'm getting ready to go.")
    action()
    print("I arrived!")
}

travel(action: driving1)

//Trailing closure syntax

travel() {
    print("I'm driving in my plane")
}

travel {
    print("I'm driving in my boat")
}

//Using closures as parameters when they accept parameters

func travel(action: (String) -> Void) {
    print("I'm getting ready to go.")
    action("London")
    print("I arrived!")
}

travel { (place: String) in
    print("I'm going to \(place) in my car")
}

//Using closures as parameters when they return values

func travel(action: (String) -> String) {
    print("I'm getting ready to go.")
    let description = action("London")
    print(description)
    print("I arrived!")
}

travel { (place: String) -> String in
    return "I'm going to \(place) in my spaceship"
}


//Shorthand parameter names

travel { place -> String in
    return "I'm going to \(place) in my horse"
}

travel { place in
    return "I'm going to \(place) in my camel"
}

travel { place in
    "I'm going to \(place) in my dog"
}

travel {
    "I'm going to \($0) in my whale"
}

//Closures with multiple parameters

func travel(action: (String, Int) -> String) {
    print("I'm getting ready to go.")
    let description = action("London", 60)
    print(description)
    print("I arrived!")
}


travel {
    "I'm going to \($0) at \($1) miles per hour."
}

travel { place, speed -> String in
    "I'm going to \(place) at \(speed) kmh per hour."
}

//Returning closures from functions

func travelc() -> (String) -> Void {
    return {
        print("I'm going to \($0)")
    }
}

let result = travelc()
result("London")

let result2 = travelc()("Russia")

//Capturing values

func travel() -> (String) -> Void {
    var counter = 1
    
    return {
        print("\(counter). I'm going to \($0)")
        counter += 1
    }
}

let result1 = travel()

result1("London")
result1("London")
result1("London")

//Closures summary

