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
    
    private enum Constants {
        static let sideMenuButtonMargin: CGFloat = 10
        static let sideMenuButtonSizeRatio: CGFloat = 16
        static let talentInfoHeight: CGFloat = 35
        static let menuIcon: String = "menu-icon"
        static let maxPoints: Int = 51
    }
    
    private var sideMenuView: RHSideButtons?
    private var sideMenuDataSource: SideMenuDataSource = SideMenuDataSource()
    
    var pointsRemaining: Int = Constants.maxPoints
    
    var currentClass: Class? {
        didSet {
            guard let currentClass = self.currentClass else { return }
            currentClass.talentTrees.forEach() { specialization in
                let skills = specialization.skills
                let name = specialization.name
                let storyboard = UIStoryboard(name: "Talent", bundle: nil)
                guard let viewController = storyboard.instantiateViewController(withIdentifier: "Talent") as? TalentViewController else { return }
                let tabImage = FetchData.getSpecImage(className: currentClass.name, specName: name).resizeMyImage(newWidth: 27).roundMyImage.withRenderingMode(.alwaysOriginal)
                let tab = UITabBarItem(title: name, image: tabImage, selectedImage: nil)
                viewController.tabBarItem = tab
                viewController.configure(skills: skills,
                                         grid: FetchData.getSpecGrid(specialization: name, className: currentClass.name),
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
        currentClass = talentData.classes.first(where: { $0.name.lowercased() == "druid" })
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        configureMenu()
    }
    
    private func configureMenu() {
        let triggerButton = RHTriggerButtonView(pressedImage: UIImage(imageLiteralResourceName: Constants.menuIcon)) {
            $0.image = UIImage(named: Constants.menuIcon)
            $0.hasShadow = false
        }
    
        sideMenuView?.reloadButtons()
        sideMenuView = RHSideButtons(parentView: self.view, triggerButton: triggerButton)
        sideMenuView?.delegate = self
        sideMenuView?.dataSource = sideMenuDataSource

        let safeAreaHeight = (UIScreen.main.bounds.height - view.safeAreaLayoutGuide.layoutFrame.size.height)/2
        let buttonPosition = CGPoint(x: UIScreen.main.bounds.width - UIScreen.main.bounds.height/Constants.sideMenuButtonSizeRatio - Constants.sideMenuButtonMargin,
                                     y: tabBar.frame.minY - safeAreaHeight - Constants.talentInfoHeight - UIScreen.main.bounds.height/Constants.sideMenuButtonSizeRatio)
        sideMenuView?.setTriggerButtonPosition(buttonPosition)
    }
    
    private func reset() {
        self.viewControllers = nil
        pointsRemaining = Constants.maxPoints
    }
}

extension TabViewController: RHSideButtonsDelegate {
    
    func sideButtons(_ sideButtons: RHSideButtons, didSelectButtonAtIndex index: Int) {
        guard let className = sideMenuDataSource.classChoices[index].className else { return }
        guard let talentData = TalentData.data else { return }
        reset()
        currentClass = talentData.classes.first(where: { $0.name.lowercased() == className })
    }
    
    func sideButtons(_ sideButtons: RHSideButtons, didTriggerButtonChangeStateTo state: RHButtonState) {
        // Do nothing.
    }
}
