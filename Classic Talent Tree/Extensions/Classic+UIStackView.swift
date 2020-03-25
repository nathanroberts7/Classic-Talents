//
//  Classic+UIStackView.swift
//  Classic Talent Tree
//
//  Created by Nathan Roberts on 3/24/20.
//  Copyright © 2020 Nathan Roberts. All rights reserved.
//

import UIKit

extension UIStackView {
    func addBackground(color: UIColor, cornerRadius: CGFloat) {
        let subView = UIView(frame: CGRect(x: bounds.minX - 10, y: bounds.minY - 10, width: bounds.width + 20, height: bounds.height + 20))
        subView.backgroundColor = color
        subView.clipsToBounds = true
        subView.layer.cornerRadius = cornerRadius
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
}
