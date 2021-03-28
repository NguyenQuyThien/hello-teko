//
//  UIImageView+Additions.swift
//  HelloTeko
//
//  Created by thien on 3/27/21.
//  Copyright © 2021 thiennq. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImage(url: URL?, getThumbnailImage: Bool = false, completion: ((UIImage?)->Void)? = nil) {
        let options: KingfisherOptionsInfo? = getThumbnailImage ?
            [.processor(DownsamplingImageProcessor(size: self.frame.size)),
             .scaleFactor(UIScreen.main.scale),
             .cacheOriginalImage] : nil
        kf.setImage(with: url, placeholder: R.image.imagePlaceholder(),
                    options: options, completionHandler:  { result in
            switch result {
            case .success(let value):
                completion?(value.image)
            case .failure(_):
                completion?(nil)
            }
        })
    }
    
    func cancelDownload() {
        kf.cancelDownloadTask()
    }
}
