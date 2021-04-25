//
//  ProductListingViewModel.swift
//  HelloTeko
//
//  Created by thien on 3/27/21.
//  Copyright © 2021 thiennq. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

final class ProductListingViewModel {
    
    var allProducts = [Product]()
    var products = BehaviorRelay<[Product]>(value: [])
    
    func fetchData() {
        HTLoading.showLoading()
        ApiManager.shared.getProducts(route: AppConstants.productsPath,
                                      method: .get) { [weak self] (products: [Product]) in
                HTLoading.dismissLoading()
                self?.allProducts = products
                self?.products.accept(self?.allProducts ?? [])
        }
    }
}
