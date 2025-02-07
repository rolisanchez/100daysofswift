import UIKit

// Indexing characters in String
let name = "Taylor"

for letter in name {
    print("Give me a \(letter)!")
}

// print(name[3]) // Can't do this without the extension below!

let letter = name[name.index(name.startIndex, offsetBy: 3)]

print("letter \(letter)")

extension String {
    subscript(i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
}


print("letter sub \(name[2])")

// Working with Prefix and Suffix
let password = "12345"
password.hasPrefix("123")
password.hasSuffix("345")

extension String {
    // remove a prefix if it exists
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
    // remove a suffix if it exists
    func deletingSuffix(_ suffix: String) -> String {
        guard self.hasSuffix(suffix) else { return self }
        return String(self.dropLast(suffix.count))
    }
}

password.deletingPrefix("12")
password.deletingSuffix("45")

// Capitalizing & Capitalizing only first
let weather = "it's going to rain"
print(weather.capitalized)

extension String {
    var capitalizedFirst: String {
        guard let firstLetter = self.first else { return "" }
        return firstLetter.uppercased() + self.dropFirst()
    }
}

weather.capitalizedFirst

// Contains
let input = "Swift is like Objective-C without the C"
input.contains("Swift")

let languages = ["Python", "Ruby", "Swift"]
languages.contains("Swift")

extension String {
    func containsAny(of array: [String]) -> Bool {
        for item in array {
            if self.contains(item) {
                return true
            }
        }
        
        return false
    }
}

input.containsAny(of: languages)

languages.contains(where: input.contains)
// Same as below, but instead of writing the whole closure we just pass input.contains as argument
// Fist class function
//languages.contains { str -> Bool in
//    input.contains(str)
//}

// Formatting strings with NSAttributedString

let string = "This is a test string"
let attributes: [NSAttributedString.Key: Any] = [
    .foregroundColor: UIColor.white,
    .backgroundColor: UIColor.red,
    .font: UIFont.boldSystemFont(ofSize: 36)
]

let attributedString0 = NSAttributedString(string: string, attributes: attributes)

let attributedString = NSMutableAttributedString(string: string)
attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 8), range: NSRange(location: 0, length: 4))
attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 16), range: NSRange(location: 5, length: 2))
attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 24), range: NSRange(location: 8, length: 1))
attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 32), range: NSRange(location: 10, length: 4))
attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 40), range: NSRange(location: 15, length: 6))


extension String {
    func withPrefix(_ prefix: String) -> String {
        if self.hasPrefix(prefix) { return self }
        return prefix+self
    }
}

"pet".withPrefix("car")
"pet".withPrefix("mup")
"carpet".withPrefix("car")

extension String {
    func isNumeric() -> Bool {
        return Double(self) != nil ? true : false
    }
}

"23".isNumeric()
"1a".isNumeric()

extension String {
    func lines() -> [String] {
        return self.components(separatedBy: .newlines)
    }
}

"this\nis\na\ntest".lines()
