import UIKit

let defaults = UserDefaults.standard

// Numbers and Booleans
defaults.set(25, forKey: "Age")
defaults.set(true, forKey: "UseTouchID")
defaults.set(CGFloat.pi, forKey: "Pi")

// Strings and Dates
defaults.set("Paul Hudson", forKey: "Name")
defaults.set(Date(), forKey: "LastRun")

// Arrays and Dictionaries
let array = ["Hello", "World"]
defaults.set(array, forKey: "SavedArray")

let dict = ["Name": "Paul", "Country": "UK"]
defaults.set(dict, forKey: "SavedDict")

// Reading from User Defaults
let readArray = defaults.object(forKey:"SavedArray") as? [String] ?? [String]()
print("readArray \(readArray)")

let falseReadArray = defaults.object(forKey:"falseReadArray") as? [String] ?? [String]()
print("falseReadArray \(falseReadArray)")

let readDict = defaults.object(forKey: "SavedDict") as? [String: String] ?? [String: String]()
