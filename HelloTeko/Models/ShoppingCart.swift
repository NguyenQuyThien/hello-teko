//
//  ShoppingCart.swift
//  HelloTeko
//
//  Created by Thien on 3/30/21.
//  Copyright © 2021 thiennq. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class ShoppingCart {
    
    static let shared = ShoppingCart()
    
    var products: BehaviorRelay<[Product: Int]> = .init(value: [:])
    
    private init() {}
    
    func addProduct(_ product: Product, withCount count: Int) {
        var tempProducts = products.value
        
        if let currentCount = tempProducts[product] {
            tempProducts[product] = currentCount + count
        } else {
            tempProducts[product] = count
        }
        
        products.accept(tempProducts)
    }
    
    func removeCoffee(_ product: Product) {
        var tempProducts = products.value
        tempProducts[product] = nil
        
        products.accept(tempProducts)
    }
    
    func getTotalCost() -> Observable<Float> {
        return products.map { $0.reduce(Float(0)) { $0 + ($1.key.price * Float($1.value)) }}
    }
    
    func getTotalCount() -> Observable<Int> {
        return products.map { $0.reduce(0) { $0 + $1.value }}
    }
    
    func getCartItems() -> Observable<[CartItem]> {
        return products.map { $0.map { CartItem(product: $0.key, count: $0.value) }}
    }
}
