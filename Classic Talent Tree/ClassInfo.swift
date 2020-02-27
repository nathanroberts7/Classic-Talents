//
//  ClassGrid.swift
//  Classic Talent Tree
//
//  Created by Nathan Roberts on 2/27/20.
//  Copyright © 2020 Nathan Roberts. All rights reserved.
//

import Foundation
import UIKit

enum ClassInfo {
    case Warrior
    case Mage
    case Rogue
    case Warlock
    case Hunter
    case Priest
    case Druid
    case Paladin
    case Shaman
    
    var specializations: [Specialization] {
        switch self {
        default:
            return [.frost, .fire, .arcane]
        }
    }
}

enum Specialization {
    // Mage
    case frost
    case fire
    case arcane
    
    var grid: [Int] {
        switch self {
        default:
            return [0, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 0, 0, 0, 1, 0, 0, 1, 0, 0]
        }
    }
    
    var background: UIImage {
        switch self {
        default:
            return UIImage(imageLiteralResourceName: "background-mage-fire")
        }
    }
    
}
