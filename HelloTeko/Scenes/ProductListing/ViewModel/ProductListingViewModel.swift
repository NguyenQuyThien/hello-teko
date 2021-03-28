//
//  ProductListingViewModel.swift
//  HelloTeko
//
//  Created by thien on 3/27/21.
//  Copyright © 2021 thiennq. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

class ProductListingViewModel {
    
    var allProducts = [Product]()
    var products = PublishSubject<[Product]>()
    
    func fetchData() {
        AF.request("https://run.mocky.io/v3/7af6f34b-b206-4bed-b447-559fda148ca5")
            .validate()
            .responseDecodable(of: [Product].self) { [weak self] (response) in
                guard let models = response.value else { return }
                self?.allProducts = models
                self?.products.onNext(self?.allProducts ?? [])
        }
    }
}
