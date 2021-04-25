//
//  ApiManager.swift
//  HelloTeko
//
//  Created by thien on 4/24/21.
//  Copyright © 2021 thiennq. All rights reserved.
//

import UIKit
import TrustKit
import Alamofire

final class ApiManager: SessionDelegate{
    
    var sessionManager: Session?
    static let shared = ApiManager()
    
    private init(){
        super.init()
        sessionManager = Session.init(configuration: URLSessionConfiguration.ephemeral, delegate: self)
    }
    
    override func urlSession(_ session: URLSession, task: URLSessionTask,
                             didReceive challenge: URLAuthenticationChallenge,
                             completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        // Call into TrustKit here to do pinning validation
        if TrustKit.sharedInstance().pinningValidator.handle(challenge, completionHandler: completionHandler) == false {
            // TrustKit did not handle this challenge: perhaps it was not for server trust
            // or the domain was not pinned. Fall back to the default behavior
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }
    
    func getProducts(route: URL, method:HTTPMethod, callback: @escaping ([Product]) -> Void){
        sessionManager?.request(route, method: method, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: [Product].self) { (response) in
                guard response.error == nil else {
                    callback([])
                    return
                }
                switch response.result {
                case .success(let products):
                    callback(products)
                case .failure(let error):
                    callback([])
                    debugPrint(error)
                }
        }
    }
}
