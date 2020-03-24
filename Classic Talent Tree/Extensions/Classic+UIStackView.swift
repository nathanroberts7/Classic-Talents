//
//  Classic+UIStackView.swift
//  Classic Talent Tree
//
//  Created by Nathan Roberts on 3/24/20.
//  Copyright © 2020 Nathan Roberts. All rights reserved.
//

import UIKit

extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}
