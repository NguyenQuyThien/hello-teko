//
//  AppDelegate.swift
//  HelloTeko
//
//  Created by thien on 3/27/21.
//  Copyright © 2021 thiennq. All rights reserved.
//

import UIKit
import TrustKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        trustKitConfiguration()
        return true
    }
    
    private func trustKitConfiguration() {
        //SSL Pining
        TrustKit.setLoggerBlock { (message) in
            debugPrint("TrustKit log: \(message)")
        }
        
        let trustKitConfig = [
            kTSKSwizzleNetworkDelegates: false,
            kTSKPinnedDomains: [
                "run.mocky.io": [
                    kTSKEnforcePinning: true,
                    kTSKIncludeSubdomains: true,
                    kTSKPublicKeyHashes: [
                        "WgoPGXU0SpJ4q65+D5dMK3VNJY9N3ZE9Hi5nVtcGh6I=",
                        "WoiWRyIOVNa9ihaBciRSC7XHjliYS9VwUGOIud4PB18="
                    ],
                ]
            ]
            ] as [String : Any]
        
        TrustKit.initSharedInstance(withConfiguration: trustKitConfig)
    }
}

