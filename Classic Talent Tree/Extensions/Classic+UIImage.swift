//
//  Classic+UIImage.swift
//  Classic Talent Tree
//
//  Created by Nathan Roberts on 3/13/20.
//  Copyright © 2020 Nathan Roberts. All rights reserved.
//

import UIKit

extension UIImage {
    var grayscaled: UIImage? {
        let ciImage = CIImage(image: self)
        guard let grayscale = ciImage?.applyingFilter("CIColorControls", parameters: [ kCIInputSaturationKey: 0.0 ]) else { return nil }
        return UIImage(ciImage: grayscale)
    }
}
