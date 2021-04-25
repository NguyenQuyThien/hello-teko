//
//  MenuCell.swift
//  HelloTeko
//
//  Created by thien on 3/28/21.
//  Copyright © 2021 thiennq. All rights reserved.
//

import UIKit
import PagingKit

final class MenuCell: PagingMenuViewCell {
    @IBOutlet weak var lblTitleLabel: UILabel!
    
    override public var isSelected: Bool {
        didSet {
            lblTitleLabel.textColor = isSelected ? .darkGrey : .coolGrey
        }
    }
}
