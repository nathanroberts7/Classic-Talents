//
//  FetchTalentData.swift
//  Classic Talent Tree
//
//  Created by Nathan Roberts on 2/25/20.
//  Copyright © 2020 Nathan Roberts. All rights reserved.
//

import Foundation
import UIKit

class FetchData {

    static func getClassImage(className: String) -> UIImage {
        return UIImage(imageLiteralResourceName: "icon-\(className.lowercased())")
    }
    
    static func getSpecImage(className: String, specName: String) -> UIImage {
        let specName = specName.replacingOccurrences(of: " ", with: "-").lowercased()
        return UIImage(imageLiteralResourceName: "\(className.lowercased())-\(specName)")
    }
    
    static func getSpecBackgroundImage(className: String, specName: String) -> UIImage {
        let specName = specName.replacingOccurrences(of: " ", with: "-").lowercased()
        return UIImage(imageLiteralResourceName: "background-\(className.lowercased())-\(specName)")
    }
    
    static func getSkillImage(skillName: String) -> UIImage {
        let skillPath = skillName.replacingOccurrences(of: "'", with: "")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: ":", with: "")
            .replacingOccurrences(of: " ", with: "-")
            .lowercased()
        return UIImage(imageLiteralResourceName: skillPath)
    }
    
    static func getClassNames() -> [String] {
        // Returns all class names in order of popularity
        return ["warrior", "mage", "rogue", "priest", "warlock", "hunter", "druid", "shaman", "paladin"]
    }
    
    static func getSpecGrid(specialization: String, class: String) -> [Int] {
        // Make sure to handle class specific cases via currentClass!
        switch specialization {
        case "Arcane":
            return [1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0]
        case "Fire":
            return [0, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 0, 0, 0, 1, 0, 0, 1, 0, 0]
        case "Frost":
            return [1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 1, 0, 0]
        default:
            return [0]
        }
    }
}
