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
       let context = CIContext(options: nil)
        guard let currentFilter = CIFilter(name: "CIPhotoEffectTonal") else { return nil }
        currentFilter.setValue(CIImage(image: self), forKey: kCIInputImageKey)
        if let output = currentFilter.outputImage,
            let cgImage = context.createCGImage(output, from: output.extent) {
            return UIImage(cgImage: cgImage, scale: scale, orientation: imageOrientation)
        }
        return nil
    }
}
