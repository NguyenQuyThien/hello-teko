//
//  HTLoading.swift
//  HelloTeko
//
//  Created by thien on 4/25/21.
//  Copyright © 2021 thiennq. All rights reserved.
//

import SVProgressHUD

struct HTLoading {
    
    init() {
        SVProgressHUD.setBackgroundColor(.gray)
    }
    
    static func showLoading() {
        DispatchQueue.main.async {
            if !SVProgressHUD.isVisible() {
                SVProgressHUD.setDefaultMaskType(.black)
                SVProgressHUD.show()
            }
        }
    }
    
    static func dismissLoading(_ completion: (() -> Void)? = nil) {
        DispatchQueue.mainAsyncAfter(second: 0.2) {
            if SVProgressHUD.isVisible() {
                SVProgressHUD.dismiss(completion: completion)
            } else {
                completion?()
            }
        }
    }
}


