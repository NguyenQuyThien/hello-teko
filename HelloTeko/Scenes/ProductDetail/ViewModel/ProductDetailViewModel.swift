//
//  ProductDetailViewModel.swift
//  HelloTeko
//
//  Created by thien on 3/28/21.
//  Copyright © 2021 thiennq. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

final class ProductDetailViewModel {
    
    var itemsInCart = BehaviorRelay<Int>(value: 0)
    let itemPrice = 0
    var totalItems = BehaviorRelay<Int>(value: 0)
    var sameProducts = BehaviorRelay<[Product]>(value: [])
    
    func getSameProducts(id: Int) {
        ApiManager.shared.getProducts(route: AppConstants.productsPath,
                                      method: .get) { [weak self] (products: [Product]) in
            self?.sameProducts.accept(products.filter({
                return ($0.id < id) && ($0.id % 5 == 0)
            }))
        }
    }
}
