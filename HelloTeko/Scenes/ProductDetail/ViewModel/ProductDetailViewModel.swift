//
//  ProductDetailViewModel.swift
//  HelloTeko
//
//  Created by thien on 3/28/21.
//  Copyright © 2021 thiennq. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

class ProductDetailViewModel {
    
    var itemsInCart = BehaviorSubject<Int>(value: 0)
    let itemPrice = 0
    var totalItems = BehaviorSubject<Int>(value: 0)
    var sameProducts = PublishSubject<[Product]>()
    
    func getSameProducts(id: Int) {
        AF.request("https://run.mocky.io/v3/7af6f34b-b206-4bed-b447-559fda148ca5")
            .validate()
            .responseDecodable(of: [Product].self) { [weak self] (response) in
                guard let models = response.value else { return }
                self?.sameProducts.onNext(models.filter({
                    return ($0.id < id) && ($0.id % 5 == 0)
                }))
        }
    }
}
