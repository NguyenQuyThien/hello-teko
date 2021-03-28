//
//  HelloTekoApi.swift
//  HelloTeko
//
//  Created by thien on 3/27/21.
//  Copyright © 2021 thiennq. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

struct HelloTekoApi {
    
    // MARK: - API errors
    enum Errors: Error {
      case requestFailed
    }
    
    // MARK: - API Endpoint Requests
    static func fetchProduct(query: String) -> Observable<[Product]> {
     
        let response: Observable<[Product]> = request(url: "https://run.mocky.io/v3/7af6f34b-b206-4bed-b447-559fda148ca5")

        return response
          .map { result in
            return result
//            guard let users = result["users"] as? [Product] else {return []}
//            return users
      }
    }
    
    // MARK: - generic request to send an SLRequest
    static private func request<T: Any>(url: String, parameters: [String: String] = [:]) -> Observable<T> {
        return Observable.create { observer in
            let request = AF.request(url)
            
            request.responseJSON { response in
                guard response.error == nil, let data = response.data,
                    let json = try? JSONSerialization.jsonObject(with: data, options: []) as? T else {
                        observer.onError(Errors.requestFailed)
                        return
                }
                let result = json
                observer.onNext(result)
                observer.onCompleted()
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
