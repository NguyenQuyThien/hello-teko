//
//  ProductDetailViewModel.swift
//  HelloTeko
//
//  Created by thien on 3/28/21.
//  Copyright © 2021 thiennq. All rights reserved.
//

import Foundation
import RxSwift

class ProductDetailViewModel {
    
    var itemsInCart = BehaviorSubject<Int>(value: 0)
    let itemPrice = 0
    var totalItems = BehaviorSubject<Int>(value: 0)
    
}
