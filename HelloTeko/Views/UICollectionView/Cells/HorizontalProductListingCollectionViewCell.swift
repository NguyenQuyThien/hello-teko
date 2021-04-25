//
//  HorizontalProductListingCollectionViewCell.swift
//  HelloTeko
//
//  Created by thien on 3/28/21.
//  Copyright © 2021 thiennq. All rights reserved.
//

import UIKit

final class HorizontalProductListingCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblProductPrice: UILabel!
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        lblProductName.font = .textStyle
        lblProductName.textColor = .darkGrey
        
        lblProductPrice.font = .textStyle2
        lblProductPrice.textColor = .tomato
    }
    
    override func prepareForReuse() {
        imgProduct.cancelDownload()
        imgProduct.image = nil
    }
    
    // MARK: - Bind data to UI
    func bindUI(model: Product){
        imgProduct.setImage(url: URL(string: model.imageURL), getThumbnailImage: true, completion: nil)
        lblProductName.text = model.name
        lblProductPrice.attributedText = String(model.price.toVND.formattedWithSeparatorVND).setVNDAsSuperscript()
    }
}
