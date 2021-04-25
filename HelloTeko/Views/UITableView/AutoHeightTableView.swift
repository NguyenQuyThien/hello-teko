//
//  AutoHeightTableView.swift
//  HelloTeko
//
//  Created by thien on 4/24/21.
//  Copyright © 2021 thiennq. All rights reserved.
//

import UIKit

final class AutoHeightTableView: UITableView {
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return self.contentSize
        
    }
    override var contentSize: CGSize {
        didSet{
            self.invalidateIntrinsicContentSize()
        }
    }
}
