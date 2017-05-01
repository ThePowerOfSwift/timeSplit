//
//  UIImageView+Kingfisher.swift
//  timeSplit
//
//  Created by Cory Billeaud on 4/14/17.
//  Copyright © 2017 Cory. All rights reserved.
//

import Foundation
import Kingfisher

extension UIImageView {
    func download(image url: String) {
        guard let imageURL = URL(string:url) else {
            return
        }
        self.kf.setImage(with: ImageResource(downloadURL: imageURL))
    }
}
