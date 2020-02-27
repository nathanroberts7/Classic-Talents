//
//  FetchTalentData.swift
//  Classic Talent Tree
//
//  Created by Nathan Roberts on 2/25/20.
//  Copyright © 2020 Nathan Roberts. All rights reserved.
//

import Foundation
import UIKit

class FetchSkillData {
    
//    enum Directory {
//        case skillIcons
//        
//        var path: String {
//            switch self {
//            case .skillIcons:
//                return "skill-icons/"
//            }
//        }
//    }
    
    static func getSkillImage(skillName: String) -> UIImage {
//        let path = "\(Directory.skillIcons.path)\(className.lowercased())/\(treeName.replacingOccurrences(of: " ", with: "-").lowercased())/"
        let skillPath = skillName.replacingOccurrences(of: "'", with: "")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: ":", with: "")
            .replacingOccurrences(of: " ", with: "-")
            .lowercased()
        return UIImage(imageLiteralResourceName: skillPath)
    }
}
