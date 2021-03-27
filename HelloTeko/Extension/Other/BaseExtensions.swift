//
//  BaseExtensions.swift
//  HelloTeko
//
//  Created by thien on 3/27/21.
//  Copyright © 2021 thiennq. All rights reserved.
//

import Foundation
import UIKit

struct Debug {
    static func log(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        // to use this, you must sure that: "-D DEBUG added to "Other Swift Flags" in your target's Build Settings at Debug mode
        logInfo(items, fileInfo: false)
    }
    
    static func logInfo(_ items: Any..., fileInfo: Bool = true, separator: String = " ", terminator: String = "\n", _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        #if DEBUG
        if fileInfo { print("\((file as NSString).lastPathComponent)->\(function)[\(line)]:") }
        print(items, separator: separator, terminator: terminator)
        #endif
    }
    
    let LocalizedString: CGFloat = 0
}

public func LocalizedString(_ key: String, inTable table: String? = nil) -> String {
    return NSLocalizedString(key, tableName: table, comment: "")
}

public extension UIView {
    class var nibNameClass: String { return String(describing: self.self) }

    class var nibClass: UINib? {
        if Bundle.main.path(forResource: nibNameClass, ofType: "nib") != nil {
            return UINib(nibName: nibNameClass, bundle: nil)
        } else {
            return nil
        }
    }

    class func loadFromNib(nibName: String? = nil) -> Self? {
        return loadFromNib(nibName: nibName, type: self)
    }

    class func loadFromNib<T: UIView>(nibName: String? = nil, type: T.Type) -> T? {
        guard let nibViews = Bundle.main.loadNibNamed(nibName ?? self.nibNameClass, owner: nil, options: nil)
            else { return nil }

        return nibViews.filter({ (nibItem) -> Bool in
            return (nibItem as? T) != nil
        }).first as? T
    }

    func setCornerRadius(cornerRadius: CGFloat, borderWidth: CGFloat = 0, borderColor: UIColor? = nil) {
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor?.cgColor
        layer.masksToBounds = true
        clipsToBounds = true
    }

    var xFrame: CGFloat {
        get { return self.frame.origin.x }
        set { self.frame.origin.x = newValue }
    }
    var yFrame: CGFloat {
        get { return self.frame.origin.y }
        set { self.frame.origin.y = newValue }
    }
    var wFrame: CGFloat {
        get { return self.bounds.size.width }
        set { self.bounds.size.width = newValue }
    }
    var hFrame: CGFloat {
        get { return self.bounds.size.height }
        set { self.bounds.size.height = newValue }
    }

    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }

    func removeAllSubviews() {
        let allSubs = self.subviews
        for aSub in allSubs {
            aSub.removeFromSuperview()
        }
    }

    /// IBInspectable border UIView
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
            setNeedsLayout()
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set {
            layer.borderWidth = newValue
            setNeedsLayout()
        }
    }

    @IBInspectable var borderColor: UIColor? {
        get { return UIColor(cgColor: layer.borderColor ?? UIColor.clear.cgColor) }
        set {
            layer.borderColor = newValue?.cgColor
            setNeedsLayout()
        }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        get { return layer.shadowOffset }
        set {
            layer.shadowOffset = newValue
            setNeedsLayout()
        }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        get { return UIColor(cgColor: layer.shadowColor ?? UIColor.clear.cgColor) }
        set {
            layer.shadowColor = newValue?.cgColor
            setNeedsLayout()
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get { return layer.shadowRadius }
        set {
            layer.shadowRadius = newValue
            clipsToBounds = false
            setNeedsLayout()
        }
    }
    
    @IBInspectable var viewShadowOpacity: Float {
        get { return layer.shadowOpacity }
        set {
            layer.shadowOpacity = newValue
            setNeedsLayout()
        }
    }

    func captured(withScale: CGFloat = 0.0) -> UIImage? {
        var capturedImage: UIImage?
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, withScale)
        if let currentContext = UIGraphicsGetCurrentContext() {
            self.layer.render(in: currentContext)
            capturedImage = UIGraphicsGetImageFromCurrentImageContext()
        }

        UIGraphicsEndImageContext()
        return capturedImage
    }
    
    // Add motion effects
    func applyMotionEffects() {
        let motionEffectExtent: Int = 10
        
        let horizontalEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: UIInterpolatingMotionEffect.EffectType.tiltAlongHorizontalAxis)
        horizontalEffect.minimumRelativeValue = -motionEffectExtent
        horizontalEffect.maximumRelativeValue = +motionEffectExtent
        
        let verticalEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: UIInterpolatingMotionEffect.EffectType.tiltAlongVerticalAxis)
        verticalEffect.minimumRelativeValue = -motionEffectExtent
        verticalEffect.maximumRelativeValue = +motionEffectExtent
        
        let motionEffectGroup = UIMotionEffectGroup()
        motionEffectGroup.motionEffects = [horizontalEffect, verticalEffect]
        
        self.addMotionEffect(motionEffectGroup)
    }
    
    func rotate(degree: CGFloat = 0, duration: TimeInterval = 0) {
        DispatchQueue.mainAsync { [weak self] in
            UIView.animate(withDuration: duration) {
                self?.transform = CGAffineTransform(rotationAngle: CGFloat.pi * degree / 180.0)
            }
        }
    }
}

public extension UILabel {
    @IBInspectable var autoResizeToFitWidth: Bool {
        get { return self.adjustsFontSizeToFitWidth }
        set {
            self.adjustsFontSizeToFitWidth = newValue
            setNeedsLayout()
        }
    }
    
    func strikeThroughText() {
        let attributeStr = NSMutableAttributedString(string: text ?? "")
        attributeStr.addAttributes([.strikethroughStyle: 1, .font: self.font!], range: NSMakeRange(0, attributeStr.length))
        
        self.attributedText = attributeStr
    }
}

@IBDesignable
extension UITextField {

    @IBInspectable var paddingLeft: CGFloat {
        get {
            return leftView!.frame.size.width
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            leftView = paddingView
            leftViewMode = .always
        }
    }

    @IBInspectable var paddingRight: CGFloat {
        get {
            return rightView!.frame.size.width
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            rightView = paddingView
            rightViewMode = .always
        }
    }
}

public extension CALayer {
    var borderUIColor: UIColor? {
        get {
            if let cgColor = self.borderColor {
                return UIColor(cgColor: cgColor)
            } else { return nil }
        }
        set { borderColor = newValue?.cgColor }
    }
}

extension UIDevice {
    static var isIphoneX: Bool {
        if #available(iOS 11.0, *) {
            return (UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0) > 0
        } else {
            return false
        }
    }
}

public extension UIScreen {
    static var height: CGFloat { return self.main.bounds.size.height }
    static var width: CGFloat { return self.main.bounds.size.width }
    static var bottomPaddingSafeArea: CGFloat {
        if #available(iOS 11.0, *) { return UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0 }
        return 0
    }
    static var topPaddingSafeArea: CGFloat {
        if #available(iOS 11.0, *) { return UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0 }
        return 0
    }
}

public extension UIColor {
    convenience init(hexCss: UInt, alpha: CGFloat = 1.0) {
        self.init(red: CGFloat((hexCss >> 16) & 0xFF) / 255.0, green: CGFloat((hexCss >> 8) & 0xFF) / 255.0, blue: CGFloat(hexCss & 0xFF) / 255.0, alpha: alpha)
    }
    
    func convert(to color: UIColor, multiplier _multiplier: CGFloat) -> UIColor? {
        let multiplier = min(max(_multiplier, 0), 1)
        
        let components = cgColor.components ?? []
        let toComponents = color.cgColor.components ?? []
        
        if components.isEmpty || components.count < 3 || toComponents.isEmpty || toComponents.count < 3 {
            return nil
        }
        
        var results: [CGFloat] = []
        
        for index in 0...3 {
            let result = (toComponents[index] - components[index]) * abs(multiplier) + components[index]
            results.append(result)
        }
        
        return UIColor(red: results[0], green: results[1], blue: results[2], alpha: results[3])
    }
}

extension UIImage {
    func maskWithColor(_ color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return self
        }
        
        let rect = CGRect(origin: CGPoint.zero, size: size)
        
        color.setFill()
        self.draw(in: rect)
        
        context.setBlendMode(.sourceIn)
        context.fill(rect)
        
        let resultImage = UIGraphicsGetImageFromCurrentImageContext() ?? self
        UIGraphicsEndImageContext()
        return resultImage
    }
    
    func cropAutoSizeImageView(imageView: UIImageView) -> UIImage? {
        let imsize = self.size
        let ivsize = imageView.bounds.size
        
        var scale : CGFloat = ivsize.width / imsize.width
        if imsize.height * scale < ivsize.height {
            scale = ivsize.height / imsize.height
        }
        
        let croppedImsize = CGSize(width:ivsize.width/scale, height:ivsize.height/scale)
        let croppedImrect =
            CGRect(origin: CGPoint(x: (imsize.width-croppedImsize.width)/2.0,
                                   y: (imsize.height-croppedImsize.height)/2.0),
                   size: croppedImsize)
        
        let r = UIGraphicsImageRenderer(size:croppedImsize)
        let croppedImg = r.image { _ in
            self.draw(at: CGPoint(x:-croppedImrect.origin.x, y:-croppedImrect.origin.y))
        }
        return croppedImg
    }
    
    func resizeImage(with image: UIImage?, scaledToFill size: CGSize) -> UIImage? {
        let scale: CGFloat = max(size.width / (image?.size.width ?? 0.0), size.height / (image?.size.height ?? 0.0))
        let width: CGFloat = (image?.size.width ?? 0.0) * scale
        let height: CGFloat = (image?.size.height ?? 0.0) * scale
        let imageRect = CGRect(x: (size.width - width) / 2.0, y: (size.height - height) / 2.0, width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        image?.draw(in: imageRect)
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}

public extension String {
    func convertHtml(withFontSize size: Int = 15) -> NSAttributedString? {
        let modifiedFont = String(format:"<span style=\"font-family: '-apple-system', 'HelveticaNeue'; font-size: %d\">%@</span>", size, self)
        
        guard let data = modifiedFont.data(using: .unicode, allowLossyConversion: true) else { return nil }
        //process collection values
        return try? NSAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html,
                      .characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil)
    }
    //Validate
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}"
        let emailCheck = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailCheck.evaluate(with: self.trimmingCharacters(in: .whitespacesAndNewlines))
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
    
    var checkMinimumPhoneLength: Bool {
        let passwordRegex = "^[0]\\d{9}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
    // Ít nhất 6 kí tự bao gồm cả số, chữ cái
    var isValidPassword: Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[\\s\\S]{6,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
    
    // Bao gồm cả số, chữ cái
    var isValidLicensePlate: Bool {
        let licenseRegex = "^(?=.*[A-Za-z])(?=.*\\d)[\\s\\S]{1,}$"
        return NSPredicate(format: "SELF MATCHES %@", licenseRegex).evaluate(with: self)
    }
    
    var isValidKana: Bool {
        let kanaRegex = "[30A0-30FF]"
        return NSPredicate(format: "SELF MATCHES %@", kanaRegex).evaluate(with: self)
    }
    
    
    // subcript string
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, count) ..< count]
    }
    
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(count, r.lowerBound)),
                                            upper: min(count, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    //
    var nsString: NSString { return self as NSString }
    var length: Int { return (self as NSString).length }
    var trimWhiteSpace: String { return self.trimmingCharacters(in: .whitespaces) }
    var trimWhiteSpaceAndNewLine: String { return self.trimmingCharacters(in: .whitespacesAndNewlines) }
    static func isEmpty(_ string: String?, characterSet: CharacterSet = CharacterSet(charactersIn: "")) -> Bool {
        return (string?.trimmingCharacters(in: characterSet) ?? "") == ""
    }

    func toDate(withFormat formatDate: String, timezone: TimeZone? = nil) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatDate
        dateFormatter.calendar = Calendar.greCalendar
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        if let timezone = timezone {
            dateFormatter.timeZone = timezone
        }
        return dateFormatter.date(from: self)
    }

    func toDateFormat8601() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.calendar = Calendar.greCalendar
        return dateFormatter.date(from: self)
    }
    
    func base64DecodedToJson() -> [String: Any]? {
        var stringBase64 = self
        if (self.count % 4 <= 2) {
            stringBase64 += String(repeating: "=", count: (self.count % 4))
        }
        guard let data = Data(base64Encoded: stringBase64) else { return nil }
        
        return (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any]
    }

    func getDynamicHeight(withFont: UIFont) -> CGFloat {
        return self.nsString.size(withAttributes: [NSAttributedString.Key.font: withFont]).height
    }

    mutating func stringByDeleteCharactersInRange(range: NSRange) {
        let startIndex = self.index(self.startIndex, offsetBy: range.location)
        let endIndex = self.index(startIndex, offsetBy: range.length)
        self.removeSubrange(startIndex ..< endIndex)
    }

    func stringByDeletePrefix(_ prefix: String?) -> String {
        if let prefixString = prefix, self.hasPrefix(prefixString) {
            return self.nsString.substring(from: prefixString.length)
        }
        return self
    }

    func stringByDeleteSuffix(_ suffix: String?) -> String {
        if let suffixString = suffix, self.hasSuffix(suffixString) {
            return self.nsString.substring(to: self.length - suffixString.length)
        }
        return self
    }
    
    func deleteSuffix(_ suffix: Int) -> String {
        if suffix >= self.length {
            return ""
        } else {
            return self.nsString.substring(to: self.length - suffix)
        }
    }
    
    func removeAll(substring: String) -> String {
        return self.replacingOccurrences(of: substring, with: "")
    }

    func getRanges(of: String?) -> [NSRange]? {
        guard let ofString = of, String.isEmpty(ofString) == false else {
            return nil
        }

        do {
            let regex = try NSRegularExpression(pattern: ofString)
            return regex.matches(in: self, range: NSRange(location: 0, length: self.length)).map({ (textCheckingResult) -> NSRange in
                return textCheckingResult.range
            })
        } catch {
            let range = self.nsString.range(of: ofString)
            if range.location != NSNotFound {
                var ranges = [NSRange]()
                ranges.append(range)
                let remainString = self.nsString.substring(from: range.location + range.length)
                if let rangesNext = remainString.getRanges(of: ofString) {
                    ranges.append(contentsOf: rangesNext)
                }
                return ranges
            } else {
                return nil
            }
        }
    }

    func rangesOfString(_ ofString: String, options: NSString.CompareOptions = [], searchRange: Range<Index>? = nil ) -> [Range<Index>] {
        if let range = self.range(of: ofString, options: options, range: searchRange, locale: nil) {
            let nextRange: Range = range.upperBound..<self.endIndex
            return [range] + rangesOfString(ofString, searchRange: nextRange)
        } else {
            return []
        }
    }
    
    func appendPath(_ pathComponent: String) -> String {
        return self.nsString.appendingPathComponent(pathComponent)
    }
    
    func appendPathExtension(_ pathExtension: String) -> String {
        return self.nsString.appendingPathExtension(pathExtension) ?? self
    }
    
    func addSpaces(_ forMaxLenght: Int) -> String {
        if self.length >= forMaxLenght { return self }
        var result = self
        for _ in 0..<(forMaxLenght - self.length) {
            result.append(" ")
        }
        return result
    }
    
    var int: Int? { return Int(self) }
    var intValue: Int { return Int(self) ?? 0 }
    var int32: Int32? { return Int32(self) }
    var int32Value: Int32 { return Int32(self) ?? 0 }
    var int64: Int64? { return Int64(self) }
    var int64Value: Int64 { return Int64(self) ?? 0 }
    var doubleValue: Double {return Double(self) ?? 0}
    var floatValue: Float {return Float(self) ?? 0}
    
    @discardableResult
    func writeToDocument(_ fileName: String) -> Bool {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(fileName)
            //writing
            do {
                try self.write(to: fileURL, atomically: false, encoding: .utf8)
                return true
            } catch { /* error handling here */ }
        }
        return false
    }
    
    func widthWithConstrainedHeight(_ height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
        
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    func heightWithConstrainedWidth(_ width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    var encodeURI: String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? self
    }
    
    var decodeURI: String {
        return self.removingPercentEncoding ?? self
    }
    
    static func randomState(_ length: Int = 32) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let lettersCount = UInt32(letters.count)
        
        var randomString = ""
        for _ in 0..<length {
            let rand = arc4random_uniform(lettersCount)
            let idx = letters.index(letters.startIndex, offsetBy: Int(rand))
            let letter = letters[idx]
            randomString += String(letter)
        }
        return randomString
    }
}

extension BinaryInteger {
    var isEven: Bool {
        return self % 2 == 0
    }
}

extension Int {
    var string: String {
        return String(self)
    }
}

extension Int32 {
    var string: String {
        return String(self)
    }
}

extension Int64 {
    var string: String {
        return String(self)
    }
}

extension Double {
    var string: String {
        return String(format: self.isInt ? "%.0f" : "%.1f",self)
    }
    
    var isInt: Bool {
        return floor(self) == self
    }
    
    var fullString: String {
        return String(self)
    }
}

extension Bool {
    var stringValue: String {
        return self ? "true" : "false"
    }
}

extension Float {
    var string: String {
        return String(format: "%.0f",self)
    }
}

public extension NSMutableAttributedString {
    func addFont(font: UIFont, for subString: String?) {
        guard let forSubString = subString, String.isEmpty(forSubString) == false else { return }
        let rangeOfSub = self.string.nsString.range(of: forSubString)
        if rangeOfSub.location != NSNotFound {
            self.addAttributes([NSAttributedString.Key.font: font], range: rangeOfSub)
        } else {
            // not proccess
        }
    }

    func addTextColor(color: UIColor, for subString: String?) {
        guard let forSubString = subString, String.isEmpty(forSubString) == false else { return }
        let rangeOfSub = self.string.nsString.range(of: forSubString)
        if rangeOfSub.location != NSNotFound {
            self.addAttributes([NSAttributedString.Key.foregroundColor: color], range: rangeOfSub)
        } else {
            // not proccess
        }
    }

    func addFont(font: UIFont, forSubs subString: String?) {
        self.string.getRanges(of: subString)?.forEach({ (range) in
            if range.location != NSNotFound {
                self.addAttributes([NSAttributedString.Key.font: font], range: range)
            } else {
                // not proccess
            }
        })
    }

    func addTextColor(color: UIColor, forSubs subString: String?) {
        self.string.getRanges(of: subString)?.forEach({ (range) in
            if range.location != NSNotFound {
                self.addAttributes([NSAttributedString.Key.foregroundColor: color], range: range)
            } else {
                // not proccess
            }
        })
    }
}

public extension UITextView {
    func shouldChangeTextInRange(withMaxLenght: Int, inRange range: NSRange, replacementString text: String) -> (Bool, String?) {
        var result: Bool = true
        let commentInput = text as NSString
        let maximumCommentLenght = withMaxLenght
        var resultString: String? = (self.text as NSString?)?.replacingCharacters(in: range, with: text)
        if withMaxLenght <= 0 { return (result, resultString) }
        if (commentInput.length > 1) {
            // paste event
            var textControl: NSString = (self.text as NSString).replacingCharacters(in: range, with: text) as NSString
            if (textControl.length > maximumCommentLenght) {
                var rangeEnum: NSRange = NSRange(location: maximumCommentLenght - 2, length: 4)
                if(rangeEnum.location + rangeEnum.length > textControl.length) {
                    rangeEnum.length = textControl.length - rangeEnum.location
                }
                var maxTextInputAvaiable: NSInteger = maximumCommentLenght
                textControl.enumerateSubstrings(in: rangeEnum, options: NSString.EnumerationOptions.byComposedCharacterSequences) { (_, substringRange, _, _) -> Void in
                    if(substringRange.location + substringRange.length <= maximumCommentLenght) {
                        maxTextInputAvaiable = substringRange.location + substringRange.length
                    }
                }
                textControl = textControl.substring(to: maxTextInputAvaiable) as NSString
                resultString = textControl as String
                result = false
            }
        } else {
            // press keyboard / typing
            if (range.length <= 0) {
                let textControl: NSString = (self.text as NSString).replacingCharacters(in: range, with: text) as NSString
                result = textControl.length <= maximumCommentLenght
                resultString = result ? resultString : self.text
            }
        }
        return (result, resultString)
    }
}

public extension UITextField {
    func shouldChangeCharactersInRange(withMaxLenght: Int, inRange: NSRange, replacementString string: String) -> (Bool, String) {
        var result: Bool = true
        let maximumCommentLenght = withMaxLenght
        var resultString: String = ((self.text ?? "") as NSString).replacingCharacters(in: inRange, with: string)
        if (string.length > 1) {
            // paste event
            var textControl: NSString = resultString as NSString
            if (textControl.length > maximumCommentLenght) {
                var rangeEnum: NSRange = NSRange(location: maximumCommentLenght - 2, length: 4)
                if(rangeEnum.location + rangeEnum.length > textControl.length) {
                    rangeEnum.length = textControl.length - rangeEnum.location
                }
                var maxTextInputAvaiable: NSInteger = maximumCommentLenght
                textControl.enumerateSubstrings(in: rangeEnum, options: NSString.EnumerationOptions.byComposedCharacterSequences) { (_, substringRange, _, _) -> Void in
                    if(substringRange.location + substringRange.length <= maximumCommentLenght) {
                        maxTextInputAvaiable = substringRange.location + substringRange.length
                    }
                }
                textControl = textControl.substring(to: maxTextInputAvaiable) as NSString
                resultString = textControl as String
                result = false
            }
        } else {
            // press keyboard / typing
            if (inRange.length <= 0) {
                result = resultString.length <= maximumCommentLenght
                resultString = result ? resultString : (self.text ?? "")
            }
        }
        return (result, resultString)
    }
}

extension UICollectionView {
    func setBackgroundText(_ text: String) {
        let label = UILabel(frame: bounds)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.text = text
        label.numberOfLines = 0
        self.backgroundView = label
    }
    
    func clearBackgroundView() {
        self.backgroundView = nil
    }

    func isValid(indexPath: IndexPath) -> Bool {
        guard indexPath.section < numberOfSections,
              indexPath.row < numberOfItems(inSection: indexPath.section)
            else { return false }
        return true
    }
}

public extension UITableView {
    
    func layoutSizeFittingHeaderView(_ width: CGFloat? = nil) {
        guard let viewFitting = self.tableHeaderView else { return }
        
        let fitWidth = width ?? self.frame.width
        
        viewFitting.translatesAutoresizingMaskIntoConstraints = false
        // [add subviews and their constraints to view]
        let widthConstraint = NSLayoutConstraint(item: viewFitting, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: fitWidth)
        widthConstraint.isActive = true
        
        viewFitting.addConstraint(widthConstraint)
        viewFitting.setNeedsLayout()
        viewFitting.layoutIfNeeded()
        let fittingHeight = viewFitting.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        viewFitting.removeConstraint(widthConstraint)
        widthConstraint.isActive = false
        
        viewFitting.frame = CGRect(x: 0, y: 0, width: fitWidth, height: fittingHeight)
        viewFitting.translatesAutoresizingMaskIntoConstraints = true
        
        self.tableHeaderView = viewFitting
    }
    
    func layoutSizeFittingFooterView(_ width: CGFloat? = nil) {
        guard let viewFitting = self.tableFooterView else { return }

        let fitWidth = width ?? self.frame.width
        
        viewFitting.translatesAutoresizingMaskIntoConstraints = false
        // [add subviews and their constraints to view]
        let widthConstraint = NSLayoutConstraint(item: viewFitting, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: fitWidth)
        widthConstraint.isActive = true
        
        viewFitting.addConstraint(widthConstraint)
        viewFitting.setNeedsLayout()
        viewFitting.layoutIfNeeded()
        let fittingHeight = viewFitting.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        viewFitting.removeConstraint(widthConstraint)
        widthConstraint.isActive = false
        
        viewFitting.frame = CGRect(x: 0, y: 0, width: fitWidth, height: fittingHeight)
        viewFitting.translatesAutoresizingMaskIntoConstraints = true
        
        self.tableFooterView = viewFitting
    }
    
    func setTableHeaderViewLayoutSizeFitting(_ headerView: UIView) {
        self.tableHeaderView = headerView
        self.layoutSizeFittingHeaderView()
    }
    
    func setTableFooterViewLayoutSizeFitting(_ footerView: UIView) {
        self.tableFooterView = footerView
        self.layoutSizeFittingFooterView()
    }
    
    func makeHeaderLeastNonzeroHeight() {
        let tempHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.width, height: CGFloat.leastNonzeroMagnitude))
        self.tableHeaderView = tempHeaderView
    }
    
    func makeFooterLeastNonzeroHeight() {
        let tempHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.width, height: CGFloat.leastNonzeroMagnitude))
        self.tableFooterView = tempHeaderView
    }
    
    func isValidIndexPath(_ indexPath: IndexPath) -> Bool {
        return indexPath.row >= 0 && indexPath.section >= 0 && indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }

    func scrollToLastRow(animated: Bool = true, atScrollPosition: UITableView.ScrollPosition = .bottom) {
        let sections = self.numberOfSections
        if sections > 0 {
            let rows = self.numberOfRows(inSection: sections - 1)
            if self.isValidIndexPath(IndexPath(row: rows - 1, section: sections - 1)) {
                self.scrollToRow(at: IndexPath(row: rows - 1, section: sections - 1), at: atScrollPosition, animated: animated)
            }
        }
    }
    
    func scrollToCurrentResponderCell(animated: Bool = true, atScrollPosition: UITableView.ScrollPosition = .bottom) {
        guard let currentResponder = UIApplication.currentFirstResponder() else { return }
        guard let cell = currentResponder.parrentCell else { return }
        guard let indexPath = self.indexPath(for: cell) else { return }
        self.scrollToRow(at: indexPath, at: atScrollPosition, animated: animated)
    }

    func setEmptyRowClear() {
        self.tableFooterView = UIView()
    }
    
    func setBackgroundText(_ text: String) {
        let label = UILabel(frame: bounds)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.text = text
        label.numberOfLines = 0
        self.backgroundView = label
    }
    
    func clearBackgroundView() {
        self.backgroundView = nil
    }
    
    func isLastIndexPath(_ indexPath: IndexPath) -> Bool {
        return (indexPath.section == self.numberOfSections - 1) && (indexPath.row == self.numberOfRows(inSection: indexPath.section) - 1)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(cellIdentifier: String) -> T {
        return (self.dequeueReusableCell(withIdentifier: cellIdentifier) as? T) ?? T()
    }
}

public extension UITableViewCell {
    static var defaultIdentifier: String { return String(describing: self.self) }
    var parentTableView: UITableView? {
        var parentView: UIView? = self.superview
        while (parentView != nil && (parentView as? UITableView) == nil) {
            parentView = parentView?.superview
        }

        return parentView  as? UITableView
    }
    
    func setSeparatorFullWidth() {
        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = UIEdgeInsets.zero
        self.layoutMargins = UIEdgeInsets.zero
    }
    
    func setSeparatorInsets(edgeInsets: UIEdgeInsets) {
        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = edgeInsets
        self.layoutMargins = UIEdgeInsets.zero
    }
}

extension UIView {
    func convert(_ frame: CGRect, toDest destination: UIView) -> CGRect {
        var parentView: UIView? = self.superview
        var converted = frame
        var currentView = self
        while (parentView != nil && parentView != destination) {
            converted = currentView.convert(converted, to: parentView)
            currentView = parentView!
            parentView = parentView?.superview
        }
        return currentView.convert(converted, to: parentView)
    }
}

public extension UITableViewHeaderFooterView {
    static var defaultIdentifier: String { return "UITableViewHeaderFooterView" }
}

public extension UIScrollView {
    var isAtBottom: Bool {
        return contentOffset.y >= verticalOffsetForBottom
    }

    var verticalOffsetForBottom: CGFloat {
        let scrollViewHeight = bounds.height
        let scrollContentSizeHeight = contentSize.height
        let bottomInset = contentInset.bottom
        let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
        return scrollViewBottomOffset
    }
    
    func scrollToBottom(animated: Bool = false) {
        let bottomRect = CGRect(x: contentSize.width - 1, y: contentSize.height - 1, width: 1, height: 1)
        self.scrollRectToVisible(bottomRect, animated: animated)
    }
    
    func scrollToTop(animated: Bool) {
        setContentOffset(.zero, animated: animated)
    }
}

public extension Date {
    enum WeekDay: Int {
        case sunday = 1
        case monday
        case tuesday
        case wednesday
        case thursday
        case friday
        case saturday
    }
    
    func toStringFormat8601() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.calendar = Calendar.greCalendar
        return dateFormatter.string(from: self)
    }

    func toString(format dateFormat: String, timeZone: TimeZone? = nil) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.calendar = Calendar.greCalendar
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        if timeZone != nil { dateFormatter.timeZone = timeZone }
        return dateFormatter.string(from: self)
    }
    
    func toStringJP(format dateFormat: String, timeZone: TimeZone? = nil) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.calendar = Calendar.greCalendar
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        dateFormatter.locale = Locale(identifier: "ja_JP")
        if timeZone != nil { dateFormatter.timeZone = timeZone }
        return dateFormatter.string(from: self)
    }

    func toStringJpTimeZone(format dateFormat: String) -> String {
        return self.toString(format: dateFormat, timeZone: TimeZone.jp)
    }
    
    func startOfMonth() -> Date {
        return Calendar.vnCalendar.date(from: Calendar.vnCalendar.dateComponents([.year, .month], from: Calendar.vnCalendar.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.vnCalendar.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }

    var isFirstDayOfMonth: Bool {
        return Calendar.vnCalendar.dateComponents(Set<Calendar.Component>([.day]), from: self).day == 1
    }

    var isLastDayOfMonth: Bool {
        return self.addingTimeInterval(24 * 60 * 60).isFirstDayOfMonth
    }

    var isFirstMonthOfYear: Bool {
        return Calendar.vnCalendar.dateComponents(Set<Calendar.Component>([.month]), from: self).month == 1
    }

    var day: Int {
        return Calendar.vnCalendar.dateComponents(Set<Calendar.Component>([.day]), from: self).day ?? 0
    }

    var month: Int {
        return Calendar.vnCalendar.dateComponents(Set<Calendar.Component>([.month]), from: self).month ?? 0
    }

    var year: Int {
        return Calendar.vnCalendar.dateComponents(Set<Calendar.Component>([.year]), from: self).year ?? 0
    }

    var second: Int {
        return Calendar.vnCalendar.dateComponents(Set<Calendar.Component>([.second]), from: self).second ?? 0
    }

    var minute: Int {
        return Calendar.vnCalendar.dateComponents(Set<Calendar.Component>([.minute]), from: self).minute ?? 0
    }

    var hour: Int {
        return Calendar.vnCalendar.dateComponents(Set<Calendar.Component>([.hour]), from: self).hour ?? 0
    }
    
    var weekday: WeekDay? {
        return WeekDay(rawValue: Calendar.vnCalendar.dateComponents(Set<Calendar.Component>([.weekday]), from: self).weekday ?? 0)
    }

    func isEqualDateIgnoreTime(toDate: Date?) -> Bool {
        if let dateCompare = toDate {
            return self.day == dateCompare.day && self.month == dateCompare.month && self.year == dateCompare.year
        } else {
            return false
        }
    }

    var isToday: Bool {
        return self.isEqualDateIgnoreTime(toDate: Date())
    }
    
    func addingDays(_ days: Int) -> Date {
        return self.addingTimeInterval(TimeInterval(days * 24 * 60 * 60))
    }
    
    func timeAgo() -> String {
        
        let interval = Calendar.current.dateComponents([.year, .day, .hour, .minute, .second], from: self, to: Date())
        
        if let year = interval.year, year > 0 {
            return DateFormatter.localizedString(from: self, dateStyle: .long, timeStyle: .none)
        }
        if let day = interval.day, day > 6 {
            let format = DateFormatter.dateFormat(fromTemplate: "MMMMd", options: 0, locale: NSLocale.current)
            let formatter = DateFormatter()
            formatter.dateFormat = format
            return formatter.string(from: self)
        }
        if let day = interval.day, day > 0 {
            return day == 1 ? "\(day)" + " " + "day ago" :
                "\(day)" + " " + "days ago"
        }
        if let hour = interval.hour, hour > 0 {
            return hour == 1 ? "\(hour)" + " " + "hour ago" :
                "\(hour)" + " " + "hours ago"
        }
        if let minute = interval.minute, minute > 0 {
            return minute == 1 ? "\(minute)" + " " + "minute ago" :
                "\(minute)" + " " + "minutes ago"
        }
        if let second = interval.second, second > 0 {
            return second == 1 ? "\(second)" + " " + "second ago" :
                "\(second)" + " " + "seconds ago"
        }
        return "just now"
    }
    
    static func getToday(for dateFormat: String) -> String {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = dateFormat
        let formattedDate = format.string(from: date)
        return formattedDate
    }
    
    static func createDate(adding hour: Int, minute: Int, from date: Date) -> Date? {
        let calendar = Calendar.greCalendar

        var components = DateComponents()
        components.day = date.day
        components.month = date.month
        components.year = date.year
        components.hour = hour
        components.minute = minute
        
        return calendar.date(from: components)
    }
    
    static func createDateFilter(adding hour: Int, minute: Int, day: Int, month: Int, year: Int) -> Date? {
        let calendar = Calendar.greCalendar

        var components = DateComponents()
        components.day = day
        components.month = month
        components.year = year
        components.hour = hour
        components.minute = minute
        
        return calendar.date(from: components)
    }
    
    func compareWithoutTime(_ date: Date) -> ComparisonResult {
        return Calendar.vnCalendar.compare(self, to: date, toGranularity: .day)
    }
}

public extension TimeZone {
    init?(hoursFromGMT: Int) {
        self.init(secondsFromGMT: hoursFromGMT * 3600)
    }

    static var jp: TimeZone = TimeZone(hoursFromGMT: 9) ?? TimeZone.current
    static var vn: TimeZone = TimeZone(hoursFromGMT: 7) ?? TimeZone.current
}

public extension Calendar {
    static var jpCalendar: Calendar { return Calendar(identifier: Identifier.japanese) }
    static var greCalendar: Calendar { return Calendar(identifier: .gregorian) }
    static var vnCalendar: Calendar {
        var calendar = Calendar.greCalendar
        calendar.timeZone = TimeZone.vn
        return calendar
    }
}

public extension Array where Element: Equatable {
    // Remove first collection element that is equal to the given `object`:
    mutating func remove(object: Element) {
        if let index = firstIndex(of: object) {
            remove(at: index)
        }
    }
    
    func indexOf(object: Element) -> Int? {
        return (self as NSArray).contains(object) ? (self as NSArray).index(of: object) : nil
    }
}

public extension Array where Element: Comparable {
    func containsElements(as other: [Element]) -> Bool {
        for element in other {
            if !self.contains(element) { return false }
        }
        return true
    }
}

public extension UIResponder {
    private weak static var currentFirstResponder__: UIResponder?

    class func currentFirstResponder() -> UIResponder? {
        UIResponder.currentFirstResponder__ = nil
        UIApplication.shared.sendAction(#selector(UIResponder.findFirstResponder(sender:)), to: nil, from: nil, for: nil)
        return UIResponder.currentFirstResponder__
    }

    @objc internal func findFirstResponder(sender: AnyObject) {
        UIResponder.currentFirstResponder__ = self
    }

    static func sharedAppDelegate<T: UIResponder>() -> T? {
        return UIApplication.shared.delegate as? T
    }
    
    var parrentCell: UITableViewCell? {
        guard let parrent = (self as? UIView)?.superview else { return nil }
        if let cell = parrent as? UITableViewCell { return cell }
        return parrent.parrentCell
    }
}

extension UIApplication {
    static var applicationVersion: String {
        return (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String) ?? "1.0.0"
    }
    
    static var applicationBuild: String {
        return (Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String) ?? "1"
    }
    
    static var appVersionBuild: String {
        let version = self.applicationVersion
        let build = self.applicationBuild
        
        return "v\(version)(\(build))"
    }
    
    class func openUrlString(_ urlString: String?) {
        if let stringUrl = urlString, let url = URL(string: stringUrl) {
            if #available(iOS 10.0, *) {
                self.shared.open(url, options: [:], completionHandler: nil)
            } else {
                self.shared.openURL(url)
            }
        }
    }
    
    var statusBarUIView: UIView? {

      if #available(iOS 13.0, *) {
          let tag = 3848245

          let keyWindow = UIApplication.shared.connectedScenes
              .map({$0 as? UIWindowScene})
              .compactMap({$0})
              .first?.windows.first

          if let statusBar = keyWindow?.viewWithTag(tag) {
              return statusBar
          } else {
              let height = keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? .zero
              let statusBarView = UIView(frame: height)
              statusBarView.tag = tag
              statusBarView.layer.zPosition = 999999

              keyWindow?.addSubview(statusBarView)
              return statusBarView
          }

      } else {

          if responds(to: Selector(("statusBar"))) {
              return value(forKey: "statusBar") as? UIView
          }
      }
      return nil
    }
    
    static var statusBarView: UIView? {
        return UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
    }
    
    static func switchRootViewController(to rootViewController: UIViewController, animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        guard let window = UIApplication.shared.keyWindow ?? UIApplication.shared.windows.first else {
            completion?(false)
            return
        }
        
        if animated {
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                let oldState: Bool = UIView.areAnimationsEnabled
                UIView.setAnimationsEnabled(false)
                window.rootViewController = rootViewController
                UIView.setAnimationsEnabled(oldState)
            }, completion: { (finished: Bool) -> () in
                completion?(true)
            })
        } else {
            window.rootViewController = rootViewController
            completion?(true)
        }
    }
}

public extension NotificationCenter {
    class func post(name aName: NSNotification.Name, object anObject: Any? = nil, userInfo aUserInfo: [AnyHashable: Any]? = nil, withCenter: NotificationCenter = NotificationCenter.default) {
        withCenter.post(name: aName, object: anObject, userInfo: aUserInfo)
    }

    @discardableResult
    class func addObserver(forName name: NSNotification.Name?, object obj: Any? = nil,
                                  queue: OperationQueue? = OperationQueue.main,
                                  withCenter: NotificationCenter = NotificationCenter.default,
                                  using block: @escaping (Notification) -> Void) -> NSObjectProtocol {
        let notifProtocol = withCenter.addObserver(forName: name, object: obj, queue: queue, using: block)
        return notifProtocol
    }

    @discardableResult
    class func addObserver(forNames names: [NSNotification.Name], object obj: Any? = nil,
                                  queue: OperationQueue? = OperationQueue.main,
                                  withCenter: NotificationCenter = NotificationCenter.default,
                                  using block: @escaping (Notification) -> Void) -> [NSObjectProtocol] {
        return names.map({ (notificationName) -> NSObjectProtocol in
            let notifProtocol = withCenter.addObserver(forName: notificationName, object: obj, queue: queue, using: block)
            return notifProtocol
        })
    }

    class func addObserver(_ observer: Any, selector aSelector: Selector, name aName: NSNotification.Name?, objects forObjects: [Any]? = nil) {
        if (forObjects?.count ?? 0) > 0 {
            NotificationCenter.default.addObserver(observer, selector: aSelector, name: aName, object: nil)
        } else {
            forObjects?.forEach({ (anObject) in
                NotificationCenter.default.addObserver(observer, selector: aSelector, name: aName, object: anObject)
            })
        }
    }

    class func removeObserver(_ observer: Any, name aName: NSNotification.Name? = nil, object anObject: Any? = nil) {
        NotificationCenter.default.removeObserver(observer, name: aName, object: anObject)
    }
}

extension DispatchTime {
    static func forSecondFromNow(_ second: Double) -> DispatchTime {
        return DispatchTime.now() + second
    }
}

extension DispatchQueue {
    class func mainAsyncAfter(second: Double, execute work: @escaping @convention(block) () -> Swift.Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + second, execute: work)
    }
    
    class func mainAsync(execute work: @escaping @convention(block) () -> Swift.Void) {
        DispatchQueue.main.async(execute: work)
    }
    
    class func globalAsync(execute work: @escaping @convention(block) () -> Swift.Void) {
        DispatchQueue.global().async(execute: work)
    }
}

extension NSError {
    static func error(with localizedDescription: String = "") -> NSError {
        return NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: localizedDescription])
    }
}

extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
}

extension NSLayoutConstraint {
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem!, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}
