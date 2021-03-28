//
//  String+Formatter.swift
//  HelloTeko
//
//  Created by thien on 3/28/21.
//  Copyright © 2021 thiennq. All rights reserved.
//

import UIKit

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        return formatter
    }()
}

extension Numeric {
    var formattedWithSeparatorVND: String { ((Formatter.withSeparator.string(for: self) ?? "0") + " đ") }
}

extension String {
    func setVNDAsSuperscript(_ textToSuperscript: String = "đ") -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        let foundRange = attributedString.mutableString.range(of: textToSuperscript)
        
        let font = UIFont.textStyle9
        
        if foundRange.location != NSNotFound {
            attributedString.addAttribute(.font, value: font, range: foundRange)
            attributedString.addAttribute(.baselineOffset, value: 3, range: foundRange)
            attributedString.addAttribute(.foregroundColor, value: UIColor.tomato, range: foundRange)
        }
        return attributedString
    }
}

extension Double {
    var toVND: Int {
        return Int(self * 23200)
    }
}
