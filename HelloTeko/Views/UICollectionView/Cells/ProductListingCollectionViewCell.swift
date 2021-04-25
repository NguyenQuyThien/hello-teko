//
//  ProductListingCollectionViewCell.swift
//  HelloTeko
//
//  Created by thien on 3/27/21.
//  Copyright © 2021 thiennq. All rights reserved.
//

import UIKit

final class ProductListingCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblOriginalPrice: UILabel!
    @IBOutlet weak var lblSave: UILabel!
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        lblProductName.font = .textStyle
        lblProductName.textColor = .darkGrey
        
        lblPrice.font = .textStyle2
        lblPrice.textColor = .tomato
        
        lblOriginalPrice.font = .textStyle6
        lblOriginalPrice.textColor = .coolGrey
    }
    
    override func prepareForReuse() {
        imgProduct.cancelDownload()
        imgProduct.image = nil
    }
    
    // MARK: - Bind data to UI
    func bindUI(model: Product){
        imgProduct.setImage(url: URL(string: model.imageURL), getThumbnailImage: true, completion: nil)
        lblProductName.text = model.name
        lblPrice.attributedText = String(model.price.toVND.formattedWithSeparatorVND).setVNDAsSuperscript()
    }
}
