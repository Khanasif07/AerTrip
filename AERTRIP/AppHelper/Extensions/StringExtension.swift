//
//  StringExtension.swift
//
//  Created by Pramod Kumar on 5/17/17.
//  Copyright © 2017 Pramod Kumar. All rights reserved.
//

import Foundation
import UIKit
import AVKit

extension UnicodeScalar {
    var isEmoji: Bool {
        switch value {
        case 0x3030, 0x00AE, 0x00A9, // Special Characters
             0x1D000...0x1F77F, // Emoticons
             0x2100...0x27BF, // Misc symbols and Dingbats
             0xFE00...0xFE0F, // Variation Selectors
             0x1F900...0x1F9FF: // Supplemental Symbols and Pictographs
            return true
            
        default: return false
        }
    }
    
    var isZeroWidthJoiner: Bool {
        return value == 8205
    }
    
    
}

// MARK: - glyphCount

extension String {
    
    
    
    var encodeUrl: String {
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) ?? self
    }
    
    var decodeUrl: String {
        return self.removingPercentEncoding ?? self
    }
    
    var utf8Decoded: String {
//        let jsonString = (self as NSString).utf8String
//        if jsonString == nil{
//            return self
//        }
//
//        let jsonData: Data = Data(bytes: UnsafeRawPointer(jsonString!), count: Int(strlen(jsonString)))
//        if let goodMessage = NSString(data: jsonData, encoding: String.Encoding.nonLossyASCII.rawValue){
//            return goodMessage as String
//        }else{
//            return self
//        }
        
        guard let data = self.data(using: String.Encoding.utf8) else {return self}
        let decodedStr = NSString(data: data, encoding: String.Encoding.nonLossyASCII.rawValue)
        if let str = decodedStr {
            return str as String
        }
        return self
    }
    
    var utf8Encoded: String {
//        let uniText: NSString = NSString(utf8String: (self as NSString).utf8String!)!
//        let msgData: Data = uniText.data(using: String.Encoding.nonLossyASCII.rawValue)!
//        let goodMsg: NSString = NSString(data: msgData, encoding: String.Encoding.utf8.rawValue)!
//        return goodMsg as String
        if let str = self.cString(using: .nonLossyASCII), let encodeStr = NSString(cString: str, encoding: String.Encoding.utf8.rawValue) {
            return encodeStr as String
        }
        return self
    }
    
    /// Returns the base64Encoded string
    var base64Encoded: String {
        return Data(self.utf8).base64EncodedString()
    }
    
    /// Returns the string decoded from base64Encoded string
    var base64Decoded: String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    
    var firstCharacter: Character {
        if self.count <= 0 {
            return Character(" ")
        }
        return self[self.index(self.startIndex, offsetBy: 0)]
    }
    
    var lastCharacter: Character {
        if self.count <= 0 {
            return Character(" ")
        }
        return self[self.index(self.endIndex, offsetBy: -1)]
    }
    
    var firstWord: String {
        if self.count <= 0 {
            return ""
        }
        return String(self.split(separator: " ").first ?? Substring(""))
    }
    
    var lastWord: String {
        if self.count <= 0 {
            return ""
        }
        return String(self.split(separator: " ").last ?? Substring(""))
    }
    
    var glyphCount: Int {
        let richText = NSAttributedString(string: self)
        let line = CTLineCreateWithAttributedString(richText)
        return CTLineGetGlyphCount(line)
    }
    
    var isSingleEmoji: Bool {
        return self.glyphCount == 1 && self.containsEmoji
    }
    
    var containsEmoji: Bool {
        return !unicodeScalars.filter { $0.isEmoji }.isEmpty
    }
    
    
    var stringByRemovingEmogies : String {
        return String(self.unicodeScalars.filter { !$0.isEmoji })
    }
    

    var isBackSpace : Bool {
        guard let char = self.cString(using: String.Encoding.utf8) else {return false}
        return strcmp(char, "\\b") == -92
    }
    
    var containsOnlyEmoji: Bool {
        return unicodeScalars.first(where: { !$0.isEmoji && !$0.isZeroWidthJoiner }) == nil
    }
    
    // The next tricks are mostly to demonstrate how tricky it can be to determine emoji's
    // If anyone has suggestions how to improve this, please let me know
    var emojiString: String {
        return self.emojiScalars.map { String($0) }.reduce("", +)
    }
    
    var removeEmojis: String {
        var newString = self
        let emojisArr = newString.emojis
        for emoji in emojisArr {
            newString = newString.replacingOccurrences(of: emoji, with: "")
        }
        return newString
    }
    
    var emojis: [String] {
        var scalars: [[UnicodeScalar]] = []
        var currentScalarSet: [UnicodeScalar] = []
        var previousScalar: UnicodeScalar?
        
        for scalar in self.emojiScalars {
            if let prev = previousScalar, !prev.isZeroWidthJoiner, !scalar.isZeroWidthJoiner {
                scalars.append(currentScalarSet)
                currentScalarSet = []
            }
            currentScalarSet.append(scalar)
            
            previousScalar = scalar
        }
        
        scalars.append(currentScalarSet)
        
        return scalars.map { $0.map { String($0) }.reduce("", +) }
    }
    
    
    
    func hilightAsterisk(withFont font: UIFont, textColor: UIColor = .black, asteriskColor: UIColor = .red) -> NSMutableAttributedString {
        guard self.hasSuffix("*") else {
            return NSMutableAttributedString(string: self)
        }
        
        let subTxt1 = self.substring(to: self.count - 2)
        let subTxt2 = "*"
        
        let attributedStr1 = NSMutableAttributedString(string: subTxt1)
        attributedStr1.addAttributes([NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: textColor], range: NSRange(location: 0, length: subTxt1.count))
        
        let attributedStr2 = NSMutableAttributedString(string: subTxt2)
        attributedStr2.addAttributes([NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: asteriskColor], range: NSRange(location: 0, length: subTxt2.count))
        attributedStr1.append(attributedStr2)
        return attributedStr1
    }
    
    fileprivate var emojiScalars: [UnicodeScalar] {
        var chars: [UnicodeScalar] = []
        var previous: UnicodeScalar?
        for cur in unicodeScalars {
            if let previous = previous, previous.isZeroWidthJoiner, cur.isEmoji {
                chars.append(previous)
                chars.append(cur)
                
            } else if cur.isEmoji {
                chars.append(cur)
            }
            
            previous = cur
        }
        
        return chars
    }
    
    var isEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    var isName:Bool{
        let name = "[A-Z a-z]{1,}"
        let nameTest = NSPredicate(format: "SELF MATCHES %@", name)
        return nameTest.evaluate(with: self)
       
    }
    
    var isPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    var isURL: Bool {
        let types: NSTextCheckingResult.CheckingType = [.link]
        let detector = try? NSDataDetector(types: types.rawValue)
        guard detector != nil, self.count > 0 else { return false }
        if detector!.numberOfMatches(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) > 0 {
            return true
        }
        return false
    }
    
    var isAnyUrl: Bool {
        return (URL(string: self) != nil)
    }
    
    var hasVideoFileExtension: Bool {
        let arr = self.components(separatedBy: ".")
        if arr.count > 1 {
            switch arr.last ?? "" {
            case "mp4", "m4a", "m4v", "mov", "wav", "mp3":
                return true
            default:
                return false
            }
        }
        return false
    }
    var getOnlyIntiger: String{
        let newStr = self.lowercased()
        let okayChars = Set("1234567890")
        return newStr.filter {okayChars.contains($0) }
    }
    // EZSE: remove Multiple Spaces And New Lines
    var removeAllWhiteSpacesAndNewLines: String {
        let components = self.components(separatedBy: NSCharacterSet.whitespacesAndNewlines)
        return components.filter { !$0.isEmpty }.joined(separator: " ")
    }
    
    var removeLeadingTrailingWhitespaces: String {
        let spaceSet = CharacterSet.whitespacesAndNewlines
        return self.trimmingCharacters(in: spaceSet)
    }
    
    // Removing All WhiteSpaces
    var removeAllWhitespaces: String {
        return components(separatedBy: .whitespaces).joined()
    }
    
    // Removing Spacing as Sentence
    
    var removeSpaceAsSentence : String {
        let seprator = " "
        let final = self
            .components(separatedBy: seprator).filter({$0.count > 0}).map{ $0.trimmingCharacters(in: .whitespacesAndNewlines)}.joined(separator: seprator)
        if let last = self.last, "\(last)" == seprator, !final.isEmpty {
            return final + seprator
        }
        else {
            return final
        }
    }
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    /// EZSE: Converts String to URL
    var toUrl: URL? {
        if self.hasPrefix("file://") || self.hasPrefix("https://") || self.hasPrefix("http://") {
            return URL(string: self)
        } else {
            return URL(fileURLWithPath: self)
        }
    }
    
    /// EZSE: Converts String to Int
    var toInt: Int? {
        if let num = NumberFormatter().number(from: self) {
            return num.intValue
        } else {
            return nil
        }
    }
    
    var toInt32: Int32? {
        if let int = self.toInt {
            return Int32(int)
        }
        return nil
    }
    
    var toInt64: Int64? {
        if let int = self.toInt {
            return Int64(int)
        }
        return nil
    }
    
    /// EZSE: Converts String to Bool
    var toBool: Bool {
        switch self.lowercased() {
        case "true", "1", "yes", "ok":
            return true
        default:
            return false
        }
    }
    
    /// EZSE: Converts String to Double
    var toDouble: Double? {
        if let num = NumberFormatter().number(from: self) {
            return num.doubleValue
        } else {
            return nil
        }
    }
    
    /// EZSE: Converts String to Float
    var toFloat: Float? {
        if let num = NumberFormatter().number(from: self) {
            return num.floatValue
        } else {
            return nil
        }
    }
    
    var toFloat32: Float32? {
        if let float = self.toFloat {
            return Float32(float)
        }
        return nil
    }
    
    var toFloat64: Float64? {
        if let float = self.toFloat {
            return Float64(float)
        }
        return nil
    }
    
    var toCGFloat: CGFloat? {
        if let float = self.toFloat {
            return CGFloat(float)
        }
        return nil
    }
    
    var toJSONObject: Any? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: [])
            } catch {
                printDebug(error.localizedDescription)
            }
        }
        return nil
    }
    
    var unitFormattedString: String {
        if let value = self.toInt {
            switch value {
            case 1000..<1000000:
                return "\(value / 1000)K"
            case 1000000..<1000000000:
                return "\(value / 1000000)M"
            default:
                return self
            }
        }
        return ""
    }
    
    var removeNull: String {
        if self == "null" || self == "<null>" || self == "nil" {
            return ""
        }
        return self
    }
    
    var htmlToAttributedString: NSAttributedString {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            let result = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
            return result
        } catch {
            return NSAttributedString()
        }
    }
    
    func htmlCSSCodeString(withFont font: UIFont? = nil, isCustomFont: Bool = false, fontFileName: String? = nil, fontColor: UIColor? = nil) -> String {
        
        /**********************************************************************
            ************* If isCustomFont 'true' ************
         
         Genrate the @font-face by using : https://www.web-font-generator.com/
         Step 1: Open website.
         Step 2: Upload you custom font file.
         Step 3: Check "I'm uploading a font that is legal for web embedding. I checked with the author and/or EULA."
         Step 4: "Generate Web Font"
         Step 5: Download files.
         Step 6: Copy .ttf, .eot,.svg, .woff in to your buldel with the same name.
         
         Note-1: If isCustomFont is true than must pass that name in 'fontFileName' param.
         
         Note-2:
            When loding the string on WKWebView, then must pass the base url as bulel url.
         
         Ex:
         var url = Bundle.main.url(forResource: "SourceSansPro-Regular", withExtension: "ttf")
         url?.deleteLastPathComponent()
         webView.loadHTMLString(<string returned by this method>, baseURL: url)
        
        **********************************************************************/
        
        let tempFont = font ?? UIFont.systemFont(ofSize: 15.0)

        var stringTags = "<!DOCTYPE html>"
        stringTags += "<html>"
        stringTags += "<head>"
        stringTags += "<style>"
        stringTags += "@font-face {"
        stringTags += "font-family: \(tempFont.fontName);"
        if isCustomFont, let fimeName = fontFileName {
            guard let eotPath = Bundle.main.path(forResource: fimeName, ofType: "eot"), let woffPath = Bundle.main.path(forResource: fimeName, ofType: "woff"), let ttfPath = Bundle.main.path(forResource: fimeName, ofType: "ttf"), let svgPath = Bundle.main.path(forResource: fimeName, ofType: "svg") else {
                fatalError("Please check any of (.ttf, .eot,.svg, .woff) file is missing. Read hint above.")
            }
            stringTags += "src: url(\(eotPath)) format(embedded-opentype),"
            stringTags += "url(\(woffPath)) format(woff),"
            stringTags += "url(\(ttfPath))  format(truetype),"
            stringTags += "url(\(svgPath)) format(svg);"
        }
        stringTags += "}"
        
        stringTags += "* {"
        stringTags += "font-family: \(tempFont.fontName) !important;"
        stringTags += "font-size: \(Int(tempFont.pointSize))pt !important;"
        if let color = fontColor {
            stringTags += "color: #\(color.hexString ?? "") !important;"
        }
        stringTags += "}"
        stringTags += "</style>"
        stringTags += "</head>"
        stringTags += "<body>"
        
        stringTags += "\(self)"
        
        stringTags += "</body>"
        stringTags += "</html>"
        
        return stringTags
    }
    
    func htmlToAttributedString(withFontSize fontSize: CGFloat? = nil, fontFamily: String? = nil, fontColor: UIColor? = nil, fontFilePath: String? = nil) -> NSAttributedString {
        var htmlCSSString = "<style>" +
            "html *" +
            "{"
        
        if let size = fontSize {
            htmlCSSString += "font-size: \(size)px !important;"
        }
        
        if let family = fontFamily {
            htmlCSSString += "font-family: \(family) !important;"
        }
        
        if let color = fontColor {
            htmlCSSString += "color: #\(color.hexString ?? "") !important;"
        }
        
        htmlCSSString += "}</style> \(self)"
        
        return htmlCSSString.htmlToAttributedString
    }
    
    func contains(_ find: String) -> Bool {
        return self.range(of: find) != nil
    }
    
    func containsIgnoringCase(_ find: String) -> Bool {
        return self.range(of: find, options: .caseInsensitive) != nil
    }
    
    func substring(from: Int?, to: Int?) -> String {
        if let start = from {
            guard start < self.count else {
                return ""
            }
        }
        
        if let end = to {
            guard end >= 0 else {
                return ""
            }
        }
        
        if let start = from, let end = to {
            guard end - start >= 0 else {
                return ""
            }
        }
        
        let startIndex: String.Index
        if let start = from, start >= 0 {
            startIndex = self.index(self.startIndex, offsetBy: start)
        } else {
            startIndex = self.startIndex
        }
        
        let endIndex: String.Index
        if let end = to, end >= 0, end < self.count {
            endIndex = self.index(self.startIndex, offsetBy: end + 1)
        } else {
            endIndex = self.endIndex
        }
        
        return String(self[startIndex..<endIndex])
    }
    
    func substring(from: Int) -> String {
        return self.substring(from: from, to: nil)
    }
    
    func substring(to: Int) -> String {
        return self.substring(from: nil, to: to)
    }
    
    func substring(from: Int?, length: Int) -> String {
        guard length > 0 else {
            return ""
        }
        
        let end: Int
        if let start = from, start > 0 {
            end = start + length - 1
        } else {
            end = length - 1
        }
        
        return self.substring(from: from, to: end)
    }
    
    func substring(length: Int, to: Int?) -> String {
        guard let end = to, end > 0, length > 0 else {
            return ""
        }
        
        let start: Int
        if let end = to, end - length > 0 {
            start = end - length + 1
        } else {
            start = 0
        }
        
        return self.substring(from: start, to: to)
    }
    
    /// EZSE: Capitalizes first character of String
    public mutating func capitalizeFirst() {
        guard self.count > 0 else { return }
        self.replaceSubrange(startIndex...startIndex, with: String(self[startIndex]).capitalized)
    }
    
    /// EZSE: Capitalizes first character of String, returns a new string
    public func capitalizedFirst() -> String {
        guard self.count > 0 else { return self }
        var result = self
        
        result.replaceSubrange(startIndex...startIndex, with: String(self[startIndex]).capitalized)
        return result
    }
    
    /// EZSE: lowerCased first character of String, returns a new string
    public func lowerCaseFirst() -> String {
        guard self.count > 0 else { return self }
        var result = self
        
        result.replaceSubrange(startIndex...startIndex, with: String(self[startIndex]).lowercased())
        return result
    }
    
    func heighLightHashTags(hashTagsFont: UIFont, hashTagsColor: UIColor) -> NSMutableAttributedString {
        let stringWithTags: NSString = self as NSString
        let regex: NSRegularExpression = try! NSRegularExpression(pattern: "[#](\\w+)", options: NSRegularExpression.Options.caseInsensitive)
        
        let matches: [NSTextCheckingResult] = regex.matches(in: stringWithTags as String, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, stringWithTags.length))
        let attString: NSMutableAttributedString = NSMutableAttributedString(string: self, attributes: [NSAttributedString.Key.font: hashTagsFont])
        for match: NSTextCheckingResult in matches {
            let wordRange: NSRange = match.range(at: 0)
            // Set Font
            attString.addAttribute(NSAttributedString.Key.font, value: hashTagsFont, range: NSMakeRange(0, stringWithTags.length))
            // Set Foreground Color
            attString.addAttribute(NSAttributedString.Key.foregroundColor, value: hashTagsColor, range: wordRange)
        }
        return attString
    }
    
    func allWords(startWith: String) -> [String] {
        var tags = [String]()
        let stringWithTags: NSString = self as NSString
        let regex: NSRegularExpression = try! NSRegularExpression(pattern: "[\(startWith)](\\w+)", options: NSRegularExpression.Options.caseInsensitive)
        
        let matches: [NSTextCheckingResult] = regex.matches(in: stringWithTags as String, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, stringWithTags.length))
        
        let nsString = NSString(string: self)
        
        for match in matches {
            let wordRange: NSRange = match.range(at: 0)
            let wordText = nsString.substring(with: wordRange)
            tags.append(String(wordText))
        }
        return tags
    }
    
    func indexOf(subString: String) -> Int? {
        var pos: Int?
        if let range = self.range(of: subString) {
            if !range.isEmpty {
                pos = self.distance(from: self.startIndex, to: range.lowerBound)
            }
        }
        return pos
    }
    
    func sizeCount(withFont font: UIFont, bundingSize size: CGSize) -> CGSize {
        let mutableParagraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        mutableParagraphStyle.lineBreakMode = NSLineBreakMode.byWordWrapping
//        mutableParagraphStyle.lineSpacing = 10
//        mutableParagraphStyle.maximumLineHeight = 18
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: mutableParagraphStyle]
        let tempStr = NSString(string: self)
        
        let rect: CGRect = tempStr.boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes, context: nil)
        let height = ceilf(Float(rect.size.height))
        let width = ceilf(Float(rect.size.width))
        return CGSize(width: CGFloat(width), height: CGFloat(height))
    }
    
    /// Converts the string into 'Date' if possible, based on the given date format and timezone. otherwise returns nil
    func toDate(dateFormat: String, timeZone: TimeZone = TimeZone.current) -> Date? {
        let frmtr = DateFormatter()
        frmtr.locale = Locale(identifier: "en_US_POSIX")
        frmtr.dateFormat = dateFormat
        frmtr.timeZone = timeZone
        return frmtr.date(from: self)
    }
    
    
    
    func heightOfText(_ width: CGFloat, font: UIFont) -> CGFloat {
         
         let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
         
         let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
         
         return boundingBox.height
     }
    
    func widthOfText(_ height: CGFloat, font: UIFont) -> CGFloat {
        
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
        
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return boundingBox.width
    }
    
    func getTextHeight(width:CGFloat, font:UIFont,  numberOfLines : Int = 0) -> CGFloat{
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
            label.numberOfLines = numberOfLines
           // label.lineBreakMode = NSLineBreakMode.byWordWrapping
            label.font = font
            label.text = self
            label.sizeToFit()
            return label.frame.height
        }
    
    func getTextWidth(height:CGFloat, font:UIFont,  numberOfLines : Int = 0) -> CGFloat{
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: CGFloat.greatestFiniteMagnitude, height: height))
        label.numberOfLines = numberOfLines
       // label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = self
        label.sizeToFit()
        return label.frame.width
    }
    
    
    
}

extension String {
    var containsWhitespace: Bool {
        return (self.rangeOfCharacter(from: .whitespacesAndNewlines) != nil)
    }
    
    func checkValidity(_ ValidityExpression: ValidityExpression) -> Bool {
        let regEx = ValidityExpression.rawValue
        
        let test = NSPredicate(format: "SELF MATCHES %@", regEx)
        
        return test.evaluate(with: self)
    }
    
    func checkInvalidity(_ ValidityExpression: ValidityExpression) -> Bool {
        return !self.checkValidity(ValidityExpression)
    }
    
    func stringByAppendingPathComponent(path: String) -> String {
        let nsSt = self as NSString
        return nsSt.appendingPathComponent(path)
    }
    
    func convertUtcToCurrent() -> String {
        let inDateFormatter: DateFormatter = DateFormatter()
        inDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        inDateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let inDate: Date = inDateFormatter.date(from: self) ?? Date()
        let outDateFormatter: DateFormatter = DateFormatter()
        outDateFormatter.timeZone = TimeZone.autoupdatingCurrent
        outDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let outDateStr: Date = outDateFormatter.date(from: outDateFormatter.string(from: inDate)) ?? Date()
        
        outDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return outDateFormatter.string(from: outDateStr)
    }
    
    func containsNumbers() -> Bool {
        let numberRegEx = ".*[0-9]+.*"
        let testCase = NSPredicate(format: "SELF MATCHES %@", numberRegEx)
        return testCase.evaluate(with: self)
    }
    
    func containsUpperCase() -> Bool {
        let capitalLetterRegEx = ".*[A-Z]+.*"
        let texttest = NSPredicate(format: "SELF MATCHES %@", capitalLetterRegEx)
        return texttest.evaluate(with: self)
    }
    
    func containsLowerCase() -> Bool {
        let capitalLetterRegEx = ".*[a-z]+.*"
        let texttest = NSPredicate(format: "SELF MATCHES %@", capitalLetterRegEx)
        return texttest.evaluate(with: self)
    }
    
    func containsSpecialCharacters() -> Bool {
        let capitalLetterRegEx = ".*[!&^%$#@()/*]+.*"
        let texttest = NSPredicate(format: "SELF MATCHES %@", capitalLetterRegEx)
        return texttest.evaluate(with: self)
    }
    
    func slice(from: String, to: String) -> String? {
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
    
    static var quotes: (String, String) {
        guard
            let bQuote = Locale.current.quotationBeginDelimiter,
            let eQuote = Locale.current.quotationEndDelimiter
        else { return ("\"", "\"") }
        
        return (bQuote, eQuote)
    }
    
    var quoted: String {
        let (bQuote, eQuote) = String.quotes
        return bQuote + self + eQuote
    }
}

enum ValidityExpression: String {
    case Username = "^[a-zA-z]{1,}+[a-zA-z0-9!@#$%&*]{2,15}"
    case Email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    case MobileNumber = "^[+0-9]{0,16}$"
    case Password = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[!&^%$#@()/*])[A-Za-z\\dd$@$!%*?&#]{8,}"
    case Name = "^[a-zA-Z ]{2,50}"
    case Url = "((?:http|https)://)?(?:www\\.)?[\\w\\d\\-_]+\\.\\w{2,25}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?"
    case Price = "^([0-9]{0,0}((.)[0-9]{0,0}))$"
    case PanCard = "[A-Z]{3}P[A-Z]{1}[0-9]{4}[A-Z]{1}"
    case gst = "^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$"

}

// Stylish

extension String {
    
    func asStylizedPrice(using font: UIFont) -> NSMutableAttributedString {
        let stylizedPrice = NSMutableAttributedString(string: self, attributes: [.font: font])
        
        guard var changeRange = self.range(of: ".")?.asNSRange(inString: self) else {
            return stylizedPrice
        }
        let result = self.components(separatedBy: ".").last?.components(separatedBy: " ").first?.count
        changeRange.length = self.count - changeRange.location
        
        guard let font = UIFont(name: font.fontName, size: (font.pointSize * 0.75)) else {
            printDebug("font not found")
            return stylizedPrice
        }
        let changeFont = font
        let offset = 6.2
        stylizedPrice.addAttribute(.font, value: changeFont, range: changeRange)
        stylizedPrice.addAttribute(.baselineOffset, value: offset, range: changeRange)
        return stylizedPrice
    }
    
    func addPriceSymbolToLeft(using font: UIFont) -> NSMutableAttributedString {
        let stylizedPrice = NSMutableAttributedString(string: self, attributes: [.font: font])
        
        guard let font = UIFont(name: font.fontName, size: (font.pointSize / 1.6)) else {
            printDebug("font not found")
            return stylizedPrice
        }
        let changeFont = font
        let offset = 0
        stylizedPrice.addAttribute(.font, value: changeFont, range: NSRange(location: 0, length: 2))
        stylizedPrice.addAttribute(.baselineOffset, value: offset, range: NSRange(location: 0, length: 2))
        return stylizedPrice
    }
    
    func attributeStringWithColors(subString : String,
                                   strClr: UIColor,
                                   substrClr: UIColor,
                                   strFont: UIFont = AppFonts.Regular.withSize(12),
                                   subStrFont: UIFont = AppFonts.SemiBold.withSize(12), backgroundColor : UIColor = UIColor.clear) -> NSAttributedString{

        let attributedString = NSMutableAttributedString(string:self)

        let range1 = (self as NSString).range(of: self)
        // attributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 14), range: range1)
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor : strClr, NSAttributedString.Key.font: strFont], range: range1)

        //if main_string.contains("(should be 18 years or above from curent date)"){
        let range2 = (self as NSString).range(of: subString)

        attributedString.addAttributes([NSAttributedString.Key.font: subStrFont ,NSAttributedString.Key.foregroundColor : substrClr], range: range2)
        
        attributedString.addAttributes([NSAttributedString.Key.backgroundColor : backgroundColor], range: range2)
        
        return attributedString
    }
    
    func attributeStringWithColors(subString : [String],
                                     strClr: UIColor,
                                     substrClr: UIColor,
                                     strFont: UIFont = AppFonts.Regular.withSize(12),
                                     subStrFont: UIFont = AppFonts.SemiBold.withSize(12)) -> NSAttributedString{

          let attributedString = NSMutableAttributedString(string:self)

          let range1 = (self as NSString).range(of: self)
          // attributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 14), range: range1)
          attributedString.addAttributes([NSAttributedString.Key.foregroundColor : strClr, NSAttributedString.Key.font: strFont], range: range1)

        subString.forEach { (str) in
            let range2 = (self as NSString).range(of: str)
             attributedString.addAttributes([NSAttributedString.Key.font: subStrFont ,NSAttributedString.Key.foregroundColor : substrClr], range: range2)
        }
        
          return attributedString
      }
    
}

extension String {
    func deletingPrefix(prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    func deletingSuffix(suffix: String) -> String {
        guard self.hasSuffix(suffix) else { return self }
        return String(self.dropLast(suffix.count))
    }
}

extension NSAttributedString {
    
    /** Will Trim space and new line from start and end of the text */
    public func trimWhiteSpace() -> NSAttributedString {
        let invertedSet = CharacterSet.whitespacesAndNewlines.inverted
        let startRange = string.utf16.description.rangeOfCharacter(from: invertedSet)
        let endRange = string.utf16.description.rangeOfCharacter(from: invertedSet, options: .backwards)
        guard let startLocation = startRange?.upperBound, let endLocation = endRange?.lowerBound else {
            return NSAttributedString(string: string)
        }
        
        let location = string.utf16.distance(from: string.startIndex, to: startLocation) - 1
        let length = string.utf16.distance(from: startLocation, to: endLocation) + 2
        let range = NSRange(location: location, length: length)
        return attributedSubstring(from: range)
    }
    
}


extension String {
    
    
    var fileSizeInBytes: Int {
        
        guard let url = self.toUrl else {
            return 0
        }
        
        do {
            let resources = try url.resourceValues(forKeys:[.fileSizeKey])
            return resources.fileSize ?? 0
        } catch {
            return 0
        }
    }
    
    var fileSizeWithUnit: String {
        let bytes = Double(self.fileSizeInBytes)
        guard bytes > 0 else {
            return "0 bytes"
        }
        
        let suffixes = ["bytes", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"]
        let k: Double = 1000
        let i = floor(log(bytes) / log(k))
        
        // Format number with thousands separator and everything below 1 GB with no decimal places.
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = i < 3 ? 0 : 1
        numberFormatter.numberStyle = .decimal
        
        let numberString = numberFormatter.string(from: NSNumber(value: bytes / pow(k, i))) ?? "Unknown"
        let suffix = suffixes[Int(i)]
        return "\(numberString) \(suffix)"
    }
    
    mutating func insert(string:String,ind:Int) {
        self.insert(contentsOf: string, at:self.index(self.startIndex, offsetBy: ind) )
    }
  
    var alphanumeric: String {
        return self.components(separatedBy: CharacterSet.alphanumerics.inverted).joined().lowercased()
    }
}

// FLIGHTS

extension String {
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}

extension String {
    
    func dateUsing(format : String ,isRoundedUP : Bool , interval : Double)  -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        guard let date = dateFormatter.date(from: self) else {
            return nil
        }
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        
        let startTime = date.timeIntervalSince(startOfDay)
        
        let timeInterval : TimeInterval
        
        if isRoundedUP {
            timeInterval = interval * ceil(startTime / interval)
        }
        else {
            timeInterval = interval * floor(startTime / interval)
        }
        
        let formatedDate = startOfDay.addingTimeInterval(timeInterval)

        return formatedDate
    }
    
    func getTimeIntervalFromDateString(df : String) -> Date {
        let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = df
         guard let arrivalDate = dateFormatter.date(from: self) else { return Date() }
         return arrivalDate
     }
    
}

extension String {
    
    var removingLeadingZeros : String {
        return self.replacingOccurrences(of: "^0+", with: "", options: .regularExpression)
    }
    
    func replacingLastOccurrenceOfString(_ searchString: String,
            with replacementString: String,
            caseInsensitive: Bool = true) -> String {
        let options: String.CompareOptions
        if caseInsensitive {
            options = [.backwards, .caseInsensitive]
        } else {
            options = [.backwards]
        }

        if let range = self.range(of: searchString,
                options: options,
                range: nil,
                locale: nil) {

            return self.replacingCharacters(in: range, with: replacementString)
        }
        return self
    }
    
    
    
}

extension String {
    var stringIn_ddMMyyyy: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "dd-mm-yyyy"
            return dateFormatter.string(from: date)
        } else {
            return self
        }
    }
    
    var stringIn_yyyyMMdd: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-mm-yyyy"
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "yyyy-mm-dd"
            return dateFormatter.string(from: date)
        } else {
            return self
        }
    }
}

// Currency changes function

extension String{
    
    
    func asStylizedPriceWithSymbol(using font: UIFont) -> NSMutableAttributedString {
        let stylizedPrice = NSMutableAttributedString(string: self, attributes: [.font: font])
        
        guard var changeRange = self.range(of: ".")?.asNSRange(inString: self) else {
            return stylizedPrice.addCurrencySymbol(using: font)
        }
        changeRange.length = self.count - changeRange.location
        
        guard let newFont = UIFont(name: font.fontName, size: (font.pointSize * 0.75)) else {
            printDebug("font not found")
            return stylizedPrice.addCurrencySymbol(using: font)
        }
        let changeFont = newFont
        let offset = 6.2
        stylizedPrice.addAttribute(.font, value: changeFont, range: changeRange)
        stylizedPrice.addAttribute(.baselineOffset, value: offset, range: changeRange)
        return stylizedPrice.addCurrencySymbol(using: font)
    }
    
}

extension NSMutableAttributedString{
    
    func addCurrencySymbol(using font: UIFont)->NSMutableAttributedString{
        if let currency =  UserInfo.preferredCurrencyDetails{
            var  currencyText = NSMutableAttributedString(string: currency.currencySymbol, attributes: [.font: font])
            if currency.textSuffix{
                currencyText = NSMutableAttributedString(string: " \(currency.currencySymbol)", attributes: [.font: font])
                self.append(currencyText)
                return self
            }else{
                currencyText.append(self)
                return currencyText
            }
        }else{
            let currency = NSMutableAttributedString(string: "₹", attributes: [.font: font])
            currency.append(self)
            return currency
        }
        
    }
    
    
}
