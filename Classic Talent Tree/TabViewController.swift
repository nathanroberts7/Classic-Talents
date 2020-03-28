//
//  TabViewController.swift
//  Classic Talent Tree
//
//  Created by Nathan Roberts on 2/27/20.
//  Copyright © 2020 Nathan Roberts. All rights reserved.
//

import Foundation
import UIKit
import RHSideButtons

class TabViewController: UITabBarController {
    
    private var sideButtonsView: RHSideButtons?
    private var classChoices = [RHButtonView]()
    fileprivate let triggerButtonMargin = CGFloat(70)


    var pointsRemaining: Int = 51
    
    var currentClass: Class? {
        didSet {
            guard let currentClass = self.currentClass else { return }
            currentClass.talentTrees.forEach() { specialization in
                let skills = specialization.skills
                let name = specialization.name
                let storyboard = UIStoryboard(name: "Talent", bundle: nil)
                guard let viewController = storyboard.instantiateViewController(withIdentifier: "Talent") as? TalentViewController else { return }
                let tabImage = FetchData.getSpecImage(className: currentClass.name,specName: name).resizeMyImage(newWidth: 27).roundMyImage.withRenderingMode(.alwaysOriginal)
                let tab = UITabBarItem(title: name, image: tabImage, selectedImage: nil)
                viewController.tabBarItem = tab
                viewController.configure(skills: skills,
                                         grid: FetchData.getSpecGrid(specialization: name, class: currentClass.name),
                                         image: FetchData.getSpecBackgroundImage(className: currentClass.name, specName: name),
                                         name: name,
                                         reference: self)
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
        tabBar.tintColor = .white
        currentClass = talentData.classes.first(where: { $0.name.lowercased() == "mage" })
        //configureMenu()
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        configureMenu()
    }
    
    private func configureMenu() {
        let triggerButton = RHTriggerButtonView(pressedImage: UIImage(imageLiteralResourceName: "menu-icon")) {
            $0.image = UIImage(named: "menu-icon")
            $0.hasShadow = false
        }
         
        FetchData.getClassNames().forEach() { className in
            let button = RHButtonView {
                $0.image = UIImage(named: "icon-\(className)")
                $0.hasShadow = false
            }
            classChoices.append(button)
        }
        sideButtonsView?.reloadButtons()
        sideButtonsView = RHSideButtons(parentView: self.view, triggerButton: triggerButton)
        
        sideButtonsView?.delegate = self
        sideButtonsView?.dataSource = self

        let safeAreaHeight = (UIScreen.main.bounds.height - view.safeAreaLayoutGuide.layoutFrame.size.height)/2
        sideButtonsView?.setTriggerButtonPosition(CGPoint(x: UIScreen.main.bounds.width - UIScreen.main.bounds.height/16 - 10, y: tabBar.frame.minY - safeAreaHeight - 35 - UIScreen.main.bounds.height/16))
    }

}

extension TabViewController: RHSideButtonsDataSource {
    
    func sideButtonsNumberOfButtons(_ sideButtons: RHSideButtons) -> Int {
        return classChoices.count
    }
    
    func sideButtons(_ sideButtons: RHSideButtons, buttonAtIndex index: Int) -> RHButtonView {
        return classChoices[index]
    }
}

extension TabViewController: RHSideButtonsDelegate {
    
    func sideButtons(_ sideButtons: RHSideButtons, didSelectButtonAtIndex index: Int) {
        print("🍭 button index tapped: \(index)")
    }
    
    func sideButtons(_ sideButtons: RHSideButtons, didTriggerButtonChangeStateTo state: RHButtonState) {
        print("🍭 Trigger button")
    }
}
