//
//  TabViewController.swift
//  Classic Talent Tree
//
//  Created by Nathan Roberts on 2/27/20.
//  Copyright © 2020 Nathan Roberts. All rights reserved.
//

import Foundation
import UIKit

class TabViewController: UITabBarController {

    
    var currentClass: Class? {
        didSet {
            guard let currentClass = self.currentClass else { return }
            currentClass.talentTrees.forEach() { specialization in
                let skills = specialization.skills
                let name = specialization.name
                let storyboard = UIStoryboard(name: "Talent", bundle: nil)
                guard let viewController = storyboard.instantiateViewController(withIdentifier: "Talent") as? TalentViewController else { return }
                let tab = UITabBarItem(title: name, image: nil, selectedImage: nil)
                viewController.tabBarItem = tab
                viewController.configure(skills: skills, grid: self.getGrid(withSpecialization: name))
                if self.viewControllers == nil {
                    self.viewControllers = [viewController]
                } else {
                    self.viewControllers?.append(viewController)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let talentData = TalentData.data else { preconditionFailure() }
        currentClass = talentData.classes.first(where: { $0.name == "Mage" })
    }
    
    private func getGrid(withSpecialization specialization: String) -> [Int] {
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
