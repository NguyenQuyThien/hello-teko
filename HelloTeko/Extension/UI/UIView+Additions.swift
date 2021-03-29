//
//  UIView+Additions.swift
//  HelloTeko
//
//  Created by thien on 3/28/21.
//  Copyright © 2021 thiennq. All rights reserved.
//

import UIKit

extension UIView {
    
    @discardableResult
    func applyGradient(colours: [UIColor], locations: [NSNumber]?, isVertical: Bool = false) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        if !isVertical {
            gradient.startPoint = CGPoint(x: 0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1, y: 0.5)
        }
        
        self.layer.insertSublayer(gradient, at: 0)
        return gradient
    }
    
}
