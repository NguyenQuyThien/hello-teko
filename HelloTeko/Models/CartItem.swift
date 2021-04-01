//
//  CartItem.swift
//  HelloTeko
//
//  Created by Thien on 3/30/21.
//  Copyright © 2021 thiennq. All rights reserved.
//

import Foundation

struct CartItem {
    let product: Product
    let count: Int
    let totalPrice: Float
    
    init(product: Product, count: Int) {
        self.product = product
        self.count = count
        self.totalPrice = Float(count) * product.price
    }
}
