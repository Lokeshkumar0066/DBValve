//
//  String+Extensions.swift
//  ProFive
//
//  Created by Lokesh Kumar on 08/08/17.
//  Copyright © 2017 Lokesh Kumar. All rights reserved.
//

#if os(macOS)
import Cocoa
#else
import UIKit
#endif


// MARK: - Properties
extension String {
    
    /// String decoded from base64 (if applicable).
    ///
    ///        "SGVsbG8gV29ybGQh".base64Decoded = Optional("Hello World!")
    ///
    public var base64Decoded: String? {
        // https://github.com/Reza-Rg/Base64-Swift-Extension/blob/master/Base64.swift
        guard let decodedData = Data(base64Encoded: self) else {
            return nil
        }
        return String(data: decodedData, encoding: .utf8)
    }
    
    /// String encoded in base64 (if applicable).
    ///
    ///        "Hello World!".base64Encoded -> Optional("SGVsbG8gV29ybGQh")
    ///
    public var base64Encoded: String? {
        // https://github.com/Reza-Rg/Base64-Swift-Extension/blob/master/Base64.swift
        let plainData = data(using: .utf8)
        return plainData?.base64EncodedString()
    }
    
    /// CamelCase of string.
    ///
    ///        "sOme vAriable naMe".camelCased -> "someVariableName"
    ///
    public var camelCased: String {
        let source = lowercased()
        if source.contains(" ") {
            let first = source[..<source.index(after: source.startIndex)]
            let connected = source.capitalized.replacingOccurrences(of: " ", with: "")
            let camel = connected.replacingOccurrences(of: "\n", with: "")
            let rest = String(camel.dropFirst())
            return first + rest
        }
        
        let first = source.lowercased()[..<source.index(after: source.startIndex)]
        let rest = String(source.dropFirst())
        return first + rest
    }
    
    /// Check if string contains one or more emojis.
    ///
    ///        "Hello 😀".containEmoji -> true
    ///
    public var containEmoji: Bool {
        // http://stackoverflow.com/questions/30757193/find-out-if-character-in-string-is-emoji
        for scalar in unicodeScalars {
            switch scalar.value {
            case 0x3030, 0x00AE, 0x00A9, // Special Characters
                 0x1D000...0x1F77F, // Emoticons
                 0x2100...0x27BF, // Misc symbols and Dingbats
                 0xFE00...0xFE0F, // Variation Selectors
                 0x1F900...0x1F9FF: // Supplemental Symbols and Pictographs
                return true
            default:
                continue
            }
        }
        return false
    }
    
    /// First character of string (if applicable).
    ///
    ///        "Hello".firstCharacterAsString -> Optional("H")
    ///        "".firstCharacterAsString -> nil
    ///
    public var firstCharacterAsString: String? {
        guard let first = first else {//characters.first
            return nil
        }
        return String(first)
    }
    
    /// Check if string contains one or more letters.
    ///
    ///        "123abc".hasLetters -> true
    ///        "123".hasLetters -> false
    ///
    public var hasLetters: Bool {
        return rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
    }
    
    /// Check if string contains one or more numbers.
    ///
    ///        "abcd".hasNumbers -> false
    ///        "123abc".hasNumbers -> true
    ///
    public var hasNumbers: Bool {
        return rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
    }
    
    /// Check if string contains only letters.
    ///
    ///        "abc".isAlphabetic -> true
    ///        "123abc".isAlphabetic -> false
    ///
    public var isAlphabetic: Bool {
        let hasLetters = rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
        let hasNumbers = rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
        return hasLetters && !hasNumbers
    }
    
    /// Check if string contains at least one letter and one number.
    ///
    ///        // useful for passwords
    ///        "123abc".isAlphaNumeric -> true
    ///        "abc".isAlphaNumeric -> false
    ///
    public var isAlphaNumeric: Bool {
        let hasLetters = rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
        let hasNumbers = rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
        let comps = components(separatedBy: .alphanumerics)
        return comps.joined(separator: "").count == 0 && hasLetters && hasNumbers
    }
    
    /// Check if string is valid email format.
    ///
    ///        "john@doe.com".isEmail -> true
    ///
    public var isEmail: Bool {
        // http://stackoverflow.com/questions/25471114/how-to-validate-an-e-mail-address-in-swift
        return matches(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
    }
    
    /// Check if string is a valid URL.
    ///
    ///        "https://google.com".isValidUrl -> true
    ///
    public var isValidUrl: Bool {
        return URL(string: self) != nil
    }
    
    /// Check if string is a valid schemed URL.
    ///
    ///        "https://google.com".isValidSchemedUrl -> true
    ///        "google.com".isValidSchemedUrl -> false
    ///
    public var isValidSchemedUrl: Bool {
        guard let url = URL(string: self) else {
            return false
        }
        return url.scheme != nil
    }
    
    /// Check if string is a valid https URL.
    ///
    ///        "https://google.com".isValidHttpsUrl -> true
    ///
    public var isValidHttpsUrl: Bool {
        guard let url = URL(string: self) else {
            return false
        }
        return url.scheme == "https"
    }
    
    /// Check if string is a valid http URL.
    ///
    ///        "http://google.com".isValidHttpUrl -> true
    ///
    public var isValidHttpUrl: Bool {
        guard let url = URL(string: self) else {
            return false
        }
        return url.scheme == "http"
    }
    
    /// Check if string is a valid file URL.
    ///
    ///        "file://Documents/file.txt".isValidFileUrl -> true
    ///
    public var isValidFileUrl: Bool {
        return URL(string: self)?.isFileURL ?? false
    }
    
    /// Check if string contains only numbers.
    ///
    ///        "123".isNumeric -> true
    ///        "abc".isNumeric -> false
    ///
    public var isNumeric: Bool {
        let hasLetters = rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
        let hasNumbers = rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
        return  !hasLetters && hasNumbers
    }
    
    /// Last character of string (if applicable).
    ///
    ///        "Hello".lastCharacterAsString -> Optional("o")
    ///        "".lastCharacterAsString -> nil
    ///
    public var lastCharacterAsString: String? {
        guard let last = last else { //characters.last
            return nil
        }
        return String(last)
    }
    
    /// Latinized string.
    ///
    ///        "Hèllö Wórld!".latinized -> "Hello World!"
    ///
    public var latinized: String {
        return folding(options: .diacriticInsensitive, locale: Locale.current)
    }
    
    /// Array of strings separated by new lines.
    ///
    ///        "Hello\ntest".lines -> ["Hello", "test"]
    ///
    public var lines: [String] {
        var result = [String]()
        enumerateLines { line, _ in
            result.append(line)
        }
        return result
    }
    
    /// The most common character in string.
    ///
    ///        "This is a test, since e is appearing everywhere e should be the common character".mostCommonCharacter -> "e"
    ///
    public var mostCommonCharacter: String {
        let mostCommon = withoutSpacesAndNewLines.reduce([Character: Int]()) {
            var counts = $0
            counts[$1] = ($0[$1] ?? 0) + 1
            return counts
        }.max { $0.1 < $1.1 }?.0
        guard let common = mostCommon else { return "" }
        return "\(common)"
    }
    
    /// Reversed string.
    ///
    ///        "foo".reversed -> "oof"
    ///
    public var reversed: String {
        return String(reversed())
    }
    
    /// Bool value from string (if applicable).
    ///
    ///        "1".bool -> true
    ///        "False".bool -> false
    ///        "Hello".bool = nil
    ///
    public var bool: Bool? {
        let selfLowercased = trimmed.lowercased()
        if selfLowercased == "true" || selfLowercased == "1" {
            return true
        } else if selfLowercased == "false" || selfLowercased == "0" {
            return false
        }
        return nil
    }
    
    /// Date object from "yyyy-MM-dd" formatted string.
    ///
    ///        "2007-06-29".date -> Optional(Date)
    ///
    public var date: Date? {
        let selfLowercased = trimmed.lowercased()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: selfLowercased)
    }
    
    /// Date object from "yyyy-MM-dd HH:mm:ss" formatted string.
    ///
    ///        "2007-06-29 14:23:09".dateTime -> Optional(Date)
    ///
    public var dateTime: Date? {
        let selfLowercased = trimmed.lowercased()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: selfLowercased)
    }
    
    /// Float value from string (if applicable).
    ///
    /// - Parameter locale: Locale (default is Locale.current)
    /// - Returns: Optional Float value from given string.
    public func float(locale: Locale = .current) -> Float? {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.allowsFloats = true
        return formatter.number(from: self) as? Float
    }
    
    /// Double value from string (if applicable).
    ///
    /// - Parameter locale: Locale (default is Locale.current)
    /// - Returns: Optional Double value from given string.
    public func double(locale: Locale = .current) -> Double? {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.allowsFloats = true
        return formatter.number(from: self) as? Double
    }
    
    /// CGFloat value from string (if applicable).
    ///
    /// - Parameter locale: Locale (default is Locale.current)
    /// - Returns: Optional CGFloat value from given string.
    public func cgFloat(locale: Locale = .current) -> CGFloat? {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.allowsFloats = true
        return formatter.number(from: self) as? CGFloat
    }
    
    /// Integer value from string (if applicable).
    ///
    ///        "101".int -> 101
    ///
    public var int: Int? {
        return Int(self)
    }
    
    /// URL from string (if applicable).
    ///
    ///        "https://google.com".url -> URL(string: "https://google.com")
    ///        "not url".url -> nil
    ///
    public var url: URL? {
        return URL(string: self)
    }
    
    /// String with no spaces or new lines in beginning and end.
    ///
    ///        "   hello  \n".trimmed -> "hello"
    ///
    public var trimmed: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// Array with unicodes for all characters in a string.
    ///
    ///        "string".unicodeArray -> [83, 119, 105, 102, 116, 101, 114, 83, 119, 105, 102, 116]
    ///
    public var unicodeArray: [Int] {
        return unicodeScalars.map({$0.hashValue})
    }
    
    /// Readable string from a URL string.
    ///
    ///        "it's%20easy%20to%20decode%20strings".urlDecoded -> "it's easy to decode strings"
    ///
    public var urlDecoded: String {
        return removingPercentEncoding ?? self
    }
    
    /// URL escaped string.
    ///
    ///        "it's easy to encode strings".urlEncoded -> "it's%20easy%20to%20encode%20strings"
    ///
    public var urlEncoded: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    /// String without spaces and new lines.
    ///
    ///        "   \n Swifter   \n  Swift  ".withoutSpacesAndNewLines -> "string"
    ///
    public var withoutSpacesAndNewLines: String {
        return replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "")
    }
    
    /// an array of all words in a string
    ///
    ///        "Swift is amazing".words -> ["Swift", "is", "amazing"]
    ///
    public var words: [String] {
        // https://stackoverflow.com/questions/42822838
        let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        let comps = components(separatedBy: chararacterSet)
        return comps.filter { !$0.isEmpty }
    }
    
    /// Count of words in a string.
    ///
    ///        "Swift is amazing".wordsCount -> 3
    ///
    public var wordCount: Int {
        // https://stackoverflow.com/questions/42822838
        let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        let comps = components(separatedBy: chararacterSet)
        let words = comps.filter { !$0.isEmpty }
        return words.count
    }
    
}


// MARK: - Methods
extension String {
    
    /// Safely subscript string with index.
    ///
    ///        "Hello World!"[3] -> "l"
    ///        "Hello World!"[20] -> nil
    ///
    /// - Parameter i: index.
    public subscript(safe i: Int) -> String? {
        guard i >= 0 && i < count else {
            return nil
        }
        return String(self[index(startIndex, offsetBy: i)])
    }
    
    /// Safely subscript string within a half-open range.
    ///
    ///        "Hello World!"[6..<11] -> "World"
    ///        "Hello World!"[21..<110] -> nil
    ///
    /// - Parameter range: Half-open range.
    public subscript(safe range: CountableRange<Int>) -> String? {
        guard let lowerIndex = index(startIndex, offsetBy: max(0,range.lowerBound), limitedBy: endIndex) else {
            return nil
        }
        guard let upperIndex = index(lowerIndex, offsetBy: range.upperBound - range.lowerBound, limitedBy: endIndex) else {
            return nil
        }
        return String(self[lowerIndex..<upperIndex])
    }
    
    /// Safely subscript string within a closed range.
    ///
    ///        "Hello World!"[6...11] -> "World!"
    ///        "Hello World!"[21...110] -> nil
    ///
    /// - Parameter range: Closed range.
    public subscript(safe range: ClosedRange<Int>) -> String? {
        guard let lowerIndex = index(startIndex, offsetBy: max(0,range.lowerBound), limitedBy: endIndex) else {
            return nil
        }
        guard let upperIndex = index(lowerIndex, offsetBy: range.upperBound - range.lowerBound + 1, limitedBy: endIndex) else {
            return nil
        }
        return String(self[lowerIndex..<upperIndex])
    }
    
    #if os(iOS) || os(macOS)
    /// Copy string to global pasteboard.
    ///
    ///        "SomeText".copyToPasteboard() // copies "SomeText" to pasteboard
    ///
    public func copyToPasteboard() {
        #if os(iOS)
        UIPasteboard.general.string = self
        #elseif os(macOS)
        NSPasteboard.general().clearContents()
        NSPasteboard.general().setString(self, forType: NSPasteboardTypeString)
        #endif
    }
    #endif
    
    /// Converts string format to CamelCase.
    ///
    ///        var str = "sOme vaRiabLe Name"
    ///        str.camelize()
    ///        print(str) // prints "someVariableName"
    ///
    public mutating func camelize() {
        self = camelCased
    }
    
    /// Check if string contains one or more instance of substring.
    ///
    ///        "Hello World!".contain("O") -> false
    ///        "Hello World!".contain("o", caseSensitive: false) -> true
    ///
    /// - Parameters:
    ///   - string: substring to search for.
    ///   - caseSensitive: set true for case sensitive search (default is true).
    /// - Returns: true if string contains one or more instance of substring.
    public func contains(_ string: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return range(of: string, options: .caseInsensitive) != nil
        }
        return range(of: string) != nil
    }
    
    /// Count of substring in string.
    ///
    ///        "Hello World!".count(of: "o") -> 2
    ///        "Hello World!".count(of: "L", caseSensitive: false) -> 3
    ///
    /// - Parameters:
    ///   - string: substring to search for.
    ///   - caseSensitive: set true for case sensitive search (default is true).
    /// - Returns: count of appearance of substring in string.
    public func count(of string: String, caseSensitive: Bool = true) -> Int {
        if !caseSensitive {
            return lowercased().components(separatedBy: string.lowercased()).count - 1
        }
        return components(separatedBy: string).count - 1
    }
    
    /// Check if string ends with substring.
    ///
    ///        "Hello World!".ends(with: "!") -> true
    ///        "Hello World!".ends(with: "WoRld!", caseSensitive: false) -> true
    ///
    /// - Parameters:
    ///   - suffix: substring to search if string ends with.
    ///   - caseSensitive: set true for case sensitive search (default is true).
    /// - Returns: true if string ends with substring.
    public func ends(with suffix: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return lowercased().hasSuffix(suffix.lowercased())
        }
        return hasSuffix(suffix)
    }
    
    /// First index of substring in string.
    ///
    ///        "Hello World!".firstIndex(of: "l") -> 2
    ///        "Hello World!".firstIndex(of: "s") -> nil
    ///
    /// - Parameter string: substring to search for.
    /// - Returns: first index of substring in string (if applicable).
    public func firstIndex(of string: String) -> Int? {
        return map({String($0)}).firstIndex(of: string)
    }
    
    /// Latinize string.
    ///
    ///        var str = "Hèllö Wórld!"
    ///        str.latinize()
    ///        print(str) // prints "Hello World!"
    ///
    public mutating func latinize() {
        self = latinized
    }
    
    /// Random string of given length.
    ///
    ///        String.random(ofLength: 18) -> "u7MMZYvGo9obcOcPj8"
    ///
    /// - Parameter length: number of characters in string.
    /// - Returns: random string of given length.
    public static func random(ofLength length: Int) -> String {
        guard length > 0 else { return "" }
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        return (0..<length).reduce("") { arg1, _ in
            let randomIndex = arc4random_uniform(UInt32(base.count))
            let randomCharacter = "\(base[base.index(base.startIndex, offsetBy: IndexDistance(randomIndex))])"
            return arg1 + randomCharacter
        }
        
        
        //        return (0..<length).reduce("") {
        //            let randomIndex = arc4random_uniform(UInt32(base.characters.count))
        //            let randomCharacter = "\(base[base.index(base.startIndex, offsetBy: IndexDistance(randomIndex))])"
        //            return $0.0 + randomCharacter
        //        }
    }
    
    /// Reverse string.
    public mutating func reverse() {
        self = String(reversed())
    }
    
    /// Sliced string from a start index with length.
    ///
    ///        "Hello World".slicing(from: 6, length: 5) -> "World"
    ///
    /// - Parameters:
    ///   - i: string index the slicing should start from.
    ///   - length: amount of characters to be sliced after given index.
    /// - Returns: sliced substring of length number of characters (if applicable) (example: "Hello World".slicing(from: 6, length: 5) -> "World")
    public func slicing(from i: Int, length: Int) -> String? {
        guard length >= 0, i >= 0, i < count  else {
            return nil
        }
        guard i.advanced(by: length) <= count else {
            return slicing(at: i)
        }
        guard length > 0 else {
            return ""
        }
        return self[safe: i..<i.advanced(by: length)]
    }
    
    /// Slice given string from a start index with length (if applicable).
    ///
    ///        var str = "Hello World"
    ///        str.slice(from: 6, length: 5)
    ///        print(str) // prints "World"
    ///
    /// - Parameters:
    ///   - i: string index the slicing should start from.
    ///   - length: amount of characters to be sliced after given index.
    public mutating func slice(from i: Int, length: Int) {
        if let str = slicing(from: i, length: length) {
            self = str
        }
    }
    
    /// Sliced string from a start index to an end index.
    ///
    ///        "Hello World".slicing(from: 6, to: 11) -> "World"
    ///
    /// - Parameters:
    ///   - start: string index the slicing should start from.
    ///   - end: string index the slicing should end at.
    /// - Returns: sliced substring starting from start index, and ends at end index (if applicable) (example: "Hello World".slicing(from: 6, to: 11) -> "World")
    public func slicing(from start: Int, to end: Int) -> String? {
        guard end >= start else {
            return nil
        }
        return self[safe: start..<end]
    }
    
    /// Slice given string from a start index to an end index (if applicable).
    ///
    ///        var str = "Hello World"
    ///        str.slice(from: 6, to: 11)
    ///        print(str) // prints "World"
    ///
    /// - Parameters:
    ///   - start: string index the slicing should start from.
    ///   - end: string index the slicing should end at.
    public mutating func slice(from start: Int, to end: Int) {
        if let str = slicing(from: start, to: end) {
            self = str
        }
    }
    
    /// Sliced string from a start index.
    ///
    ///        "Hello World".slicing(at: 6) -> "World"
    ///
    /// - Parameter i: string index the slicing should start from.
    /// - Returns: sliced substring starting from start index (if applicable) (example: "Hello world".slicing(at: 6) -> "world")
    public func slicing(at i: Int) -> String? {
        guard i < count else {
            return nil
        }
        return self[safe: i..<count]
    }
    
    /// Slice given string from a start index (if applicable).
    ///
    ///        var str = "Hello World"
    ///        str.slice(at: 6)
    ///        print(str) // prints "World"
    ///
    /// - Parameter i: string index the slicing should start from.
    public mutating func slice(at i: Int) {
        if let str = slicing(at: i) {
            self = str
        }
    }
    
    /// Array of strings separated by given string.
    ///
    ///        "hello World".splited(by: " ") -> ["hello", "World"]
    ///
    /// - Parameter separator: separator to split string by.
    /// - Returns: array of strings separated by given string.
    public func splitted(by separator: Character) -> [String] {
        return split{$0 == separator}.map(String.init)
    }//characters.split{$0 == separator}.map(String.init)
    
    /// Check if string starts with substring.
    ///
    ///        "hello World".starts(with: "h") -> true
    ///        "hello World".starts(with: "H", caseSensitive: false) -> true
    ///
    /// - Parameters:
    ///   - suffix: substring to search if string starts with.
    ///   - caseSensitive: set true for case sensitive search (default is true).
    /// - Returns: true if string starts with substring.
    public func starts(with prefix: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return lowercased().hasPrefix(prefix.lowercased())
        }
        return hasPrefix(prefix)
    }
    
    /// Date object from string of date format.
    ///
    ///        "2017-01-15".date(withFormat: "yyyy-MM-dd") -> Date set to Jan 15, 2017
    ///        "not date string".date(withFormat: "yyyy-MM-dd") -> nil
    ///
    /// - Parameter format: date format.
    /// - Returns: Date object from string (if applicable).
    public func date(withFormat format: String, zone: TimeZone? = nil) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        if let tz = zone {
            dateFormatter.timeZone = tz
        }
        return dateFormatter.date(from: self)
    }
    
    /// Removes spaces and new lines in beginning and end of string.
    ///
    ///        var str = "  \n Hello World \n\n\n"
    ///        str.trim()
    ///        print(str) // prints "Hello World"
    ///
    public mutating func trim() {
        self = trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    /// Truncate string (cut it to a given number of characters).
    ///
    ///        var str = "This is a very long sentence"
    ///        str.truncate(toLength: 14)
    ///        print(str) // prints "This is a very..."
    ///
    /// - Parameters:
    ///   - toLength: maximum number of characters before cutting.
    ///   - trailing: string to add at the end of truncated string (default is "...").
    public mutating func truncate(toLength: Int, trailing: String? = "...") {
        guard toLength > 0 else {
            return
        }
        if count > toLength {
            self = self[..<index(startIndex, offsetBy: toLength)] + (trailing ?? "")
        }
    }
    
    /// Truncated string (limited to a given number of characters).
    ///
    ///        "This is a very long sentence".truncated(toLength: 14) -> "This is a very..."
    ///        "Short sentence".truncated(toLength: 14) -> "Short sentence"
    ///
    /// - Parameters:
    ///   - toLength: maximum number of characters before cutting.
    ///   - trailing: string to add at the end of truncated string.
    /// - Returns: truncated string (this is an extr...).
    public func truncated(toLength: Int, trailing: String? = "...") -> String {
        guard 1..<count ~= toLength else { return self }
        return self[..<index(startIndex, offsetBy: toLength)] + (trailing ?? "")
    }
    
    /// Convert URL string to readable string.
    ///
    ///        var str = "it's%20easy%20to%20decode%20strings"
    ///        str.urlDecode()
    ///        print(str) // prints "it's easy to decode strings"
    ///
    public mutating func urlDecode() {
        if let decoded = removingPercentEncoding {
            self = decoded
        }
    }
    
    /// Escape string.
    ///
    ///        var str = "it's easy to encode strings"
    ///        str.urlEncode()
    ///        print(str) // prints "it's%20easy%20to%20encode%20strings"
    ///
    public mutating func urlEncode() {
        if let encoded = addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            self = encoded
        }
    }
    
    /// Verify if string matches the regex pattern.
    ///
    /// - Parameter pattern: Pattern to verify.
    /// - Returns: true if string matches the pattern.
    func matches(pattern: String) -> Bool {
        return range(of: pattern,
                     options: String.CompareOptions.regularExpression,
                     range: nil, locale: nil) != nil
    }
    
}


// MARK: - Operators
extension String {
    
    /// Repeat string multiple times.
    ///
    ///        'bar' * 3 -> "barbarbar"
    ///
    /// - Parameters:
    ///   - lhs: string to repeat.
    ///   - rhs: number of times to repeat character.
    /// - Returns: new string with given string repeated n times.
    public static func * (lhs: String, rhs: Int) -> String {
        guard rhs > 0 else {
            return ""
        }
        return String(repeating: lhs, count: rhs)
    }
    
    /// Repeat string multiple times.
    ///
    ///        3 * 'bar' -> "barbarbar"
    ///
    /// - Parameters:
    ///   - lhs: number of times to repeat character.
    ///   - rhs: string to repeat.
    /// - Returns: new string with given string repeated n times.
    public static func * (lhs: Int, rhs: String) -> String {
        guard lhs > 0 else {
            return ""
        }
        return String(repeating: rhs, count: lhs)
    }
    
}


// MARK: - Initializers
extension String {
    
    /// Create a new string from a base64 string (if applicable).
    ///
    ///        String(base64: "SGVsbG8gV29ybGQh") = "Hello World!"
    ///        String(base64: "hello") = nil
    ///
    /// - Parameter base64: base64 string.
    public init?(base64: String) {
        guard let str = base64.base64Decoded else {
            return nil
        }
        self.init(str)
    }
    
    /// Create a new random string of given length.
    ///
    ///        String(randomOfLength: 10) -> "gY8r3MHvlQ"
    ///
    /// - Parameter length: number of characters in string.
    public init(randomOfLength length: Int) {
        self = String.random(ofLength: length)
    }
    
}



//MARK: - NSString extensions
extension String {
    
    /// NSString from a string.
    ///
    public var nsString: NSString {
        return NSString(string: self)
    }
    
    /// NSString lastPathComponent.
    ///
    public var lastPathComponent: String {
        return (self as NSString).lastPathComponent
    }
    
    /// NSString pathExtension.
    ///
    public var pathExtension: String {
        return (self as NSString).pathExtension
    }
    
    /// NSString deletingLastPathComponent.
    ///
    public var deletingLastPathComponent: String {
        return (self as NSString).deletingLastPathComponent
    }
    
    /// NSString deletingPathExtension.
    ///
    public var deletingPathExtension: String {
        return (self as NSString).deletingPathExtension
    }
    
    /// NSString pathComponents.
    ///
    public var pathComponents: [String] {
        return (self as NSString).pathComponents
    }
    
    /// NSString appendingPathComponent(str: String)
    ///
    /// - Parameter str: the path component to append to the receiver.
    /// - Returns: a new string made by appending aString to the receiver, preceded if necessary by a path separator.
    public func appendingPathComponent(_ str: String) -> String {
        return (self as NSString).appendingPathComponent(str)
    }
    
    /// NSString appendingPathExtension(str: String)
    ///
    /// - Parameter str: The extension to append to the receiver.
    /// - Returns: a new string made by appending to the receiver an extension separator followed by ext (if applicable).
    public func appendingPathExtension(_ str: String) -> String? {
        return (self as NSString).appendingPathExtension(str)
    }
    
}

extension String {
    
    func size(using font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size
    }
}

extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}

extension Substring {
    var string: String {
        return String(self)
    }
}


extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

extension String {
    var html2AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}
