//
//  CurrencyFormatter.swift
//  HelloTeko
//
//  Created by Thien on 3/30/21.
//  Copyright © 2021 thiennq. All rights reserved.
//

import Foundation

enum CurrencyFormatter {
//    CurrencyFormatter.vietNamMoneyFormatter.string(from: Float(1000000.22))
//    >>> "1.000.000 ₫"
    static let vietNamMoneyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "vi_VN")
        return formatter
    }()
}

extension NumberFormatter {
    func string(from float: Float) -> String? {
        return self.string(from: NSNumber(value: float))
    }
    
    func string(from int: Int) -> String? {
        return self.string(from: NSNumber(value: int))
    }
}
