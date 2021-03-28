//
//  HardwareDetailTableViewCell.swift
//  HelloTeko
//
//  Created by thien on 3/28/21.
//  Copyright © 2021 thiennq. All rights reserved.
//

import UIKit

class HardwareDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblTitle.textColor = .coolGrey
        lblDetail.textColor = .darkGrey
        lblDetail.font = .textStyle
    }

    func bind(model: HardwareDetail) {
        lblDetail.text = model.detail
        lblTitle.text = model.title
    }
    
}
