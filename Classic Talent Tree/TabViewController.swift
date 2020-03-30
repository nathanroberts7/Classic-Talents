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
        static let menuButtonMargin: CGFloat = 10
        static let menuButtonSizeRatio: CGFloat = 16
        static let talentInfoHeight: CGFloat = 35
        static let classMenuIcon: String = "menu-icon"
        static let settingsMenuIcon: String = "settings-icon"
        static let maxPoints: Int = 51
        static let lastVistedClassDefault: String = "lastVistedClassDefault"
        static let defaultClass: String = "mage"
    }
    
    private var classMenuView: RHSideButtons?
    private var classMenuDataSource: ClassMenuDataSource = ClassMenuDataSource()
    
    private var settingsMenuView: RHSideButtons?
    private var settingsMenuDataSource: SettingsMenuDataSource = SettingsMenuDataSource()
    
    private var buildManager: BuildManager = BuildManager()
    
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
        currentClass = talentData.classes.first(where: { $0.name.lowercased() == getLastVistedClass() })
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        configureClassMenu()
        configureSettingsMenu()
    }
    
    private func configureClassMenu() {
        let triggerButton = RHTriggerButtonView(pressedImage: UIImage(imageLiteralResourceName: Constants.classMenuIcon)) {
            $0.image = UIImage(named: Constants.classMenuIcon)
            $0.hasShadow = false
        }
    
        classMenuView?.reloadButtons()
        classMenuView = RHSideButtons(parentView: self.view, triggerButton: triggerButton)
        classMenuView?.delegate = self
        classMenuView?.dataSource = classMenuDataSource
        classMenuView?.menuType = 1

        let safeAreaHeight = (UIScreen.main.bounds.height - view.safeAreaLayoutGuide.layoutFrame.size.height)/2
        let buttonPosition = CGPoint(x: UIScreen.main.bounds.width - UIScreen.main.bounds.height/Constants.menuButtonSizeRatio - Constants.menuButtonMargin,
                                     y: tabBar.frame.minY - safeAreaHeight - Constants.talentInfoHeight - UIScreen.main.bounds.height/Constants.menuButtonSizeRatio)
        classMenuView?.setTriggerButtonPosition(buttonPosition)
    }
    
    private func configureSettingsMenu() {
        let triggerButton = RHTriggerButtonView(pressedImage: UIImage(imageLiteralResourceName: Constants.settingsMenuIcon)) {
                $0.image = UIImage(named: Constants.settingsMenuIcon)
                $0.hasShadow = false
            }
        
        settingsMenuView?.reloadButtons()
        settingsMenuView = RHSideButtons(parentView: self.view, triggerButton: triggerButton)
        settingsMenuView?.delegate = self
        settingsMenuView?.dataSource = settingsMenuDataSource
        settingsMenuView?.menuType = 0

        let safeAreaHeight = (UIScreen.main.bounds.height - view.safeAreaLayoutGuide.layoutFrame.size.height)/2
        let buttonPosition = CGPoint(x: Constants.menuButtonMargin,
                                     y: tabBar.frame.minY - safeAreaHeight - Constants.talentInfoHeight - UIScreen.main.bounds.height/Constants.menuButtonSizeRatio)
        settingsMenuView?.setTriggerButtonPosition(buttonPosition)
    }
    
    private func reset() {
        self.viewControllers = nil
        pointsRemaining = Constants.maxPoints
    }
    
    private func loadBuild(specPoints: [[Int]]) {
        guard specPoints.count == 3, let viewControllers = viewControllers else { return }
        for (index, viewController) in viewControllers.enumerated() {
            guard let viewController = viewController as? TalentViewController else { continue }
            viewController.loadSpec = true
            viewController.loadSpecPoints = specPoints[index]
        }
    }
    
    private func saveLastVisitedClass(className: String) {
        UserDefaults.standard.set(className, forKey: Constants.lastVistedClassDefault)
    }
    
    private func getLastVistedClass() -> String {
        let className = UserDefaults.standard.string(forKey: Constants.lastVistedClassDefault) ?? Constants.defaultClass
        return className.lowercased()
    }
}

extension TabViewController: RHSideButtonsDelegate {
    
    func sideButtons(_ sideButtons: RHSideButtons, didSelectButtonAtIndex index: Int, menuType: Int?) {
        guard let menuType = menuType else { return }
        switch menuType {
        case 0:
            accessSettings(index: index)
        case 1:
            changeClass(index: index)
        default:
            return
        }
    }
    
    private func changeClass(index: Int) {
        guard let className = classMenuDataSource.classChoices[index].className else { return }
        guard let talentData = TalentData.data else { return }
        reset()
        currentClass = talentData.classes.first(where: { $0.name.lowercased() == className })
        saveLastVisitedClass(className: className)
    }
    
    private func accessSettings(index: Int) {
        switch index {
        case 0:
            // Save
            saveBuild()
        case 1:
            // Access Save Folder
            let storyboard = UIStoryboard(name: "SavedBuilds", bundle: nil)
            guard let controller = storyboard.instantiateViewController(withIdentifier: "SavedBuildsViewController") as? SavedBuildsViewController else { return }
            controller.configure(delegate: self)
            self.present(controller, animated: true, completion: nil)
        case 2:
            // Info
            let storyboard = UIStoryboard(name: "Info", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "InfoViewController")
            self.present(controller, animated: true, completion: nil)
        default:
            return
        }
    }
    
    private func saveBuild() {
        guard let currentClass = currentClass else { return }
        showInputDialog(title: "Save This \(currentClass.name) Build?",
            subtitle: "Enter a name below.",
            actionTitle: "Save",
            cancelTitle: "Cancel",
            inputPlaceholder: "Build Name",
            inputKeyboardType: UIKeyboardType.default,
            cancelHandler: nil) { name in
                guard let name = name else { return }
                self.handleSaveBuild(name: name, buildClass: currentClass)
        }
    }
    
    private func handleSaveBuild(name: String, buildClass: Class) {
        var specPoints: [[Int]] = []
        viewControllers?.forEach() { viewController in
            guard let viewController = viewController as? TalentViewController else { return }
            specPoints.append(viewController.getPointAllocationData())
        }
        guard specPoints.count == 3 else { return }
        let build = Build(name: name, specPoints: specPoints, buildClass: buildClass)
        buildManager.saveBuild(build: build) { result in
            if !result {
                self.showDuplicateEntryError()
            }
        }
    }
    
    private func showDuplicateEntryError() {
        let alert = UIAlertController(title: "Save Error", message: "A build with that name exists.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
    
    func sideButtons(_ sideButtons: RHSideButtons, didTriggerButtonChangeStateTo state: RHButtonState) {
        // Do nothing.
    }
}

extension TabViewController: SavedBuildsViewControllerDelegate {
    
    func savedBuildsViewController(_: SavedBuildsViewController, loadBuild build: Build) {
        guard let talentData = TalentData.data else { return }
        reset()
        currentClass = talentData.classes.first(where: { $0.name.lowercased() == build.buildClass.name.lowercased() })
        loadBuild(specPoints: build.specPoints)
    }
}
