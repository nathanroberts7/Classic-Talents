//
//  SettingsMenu.swift
//  Classic Talent Tree
//
//  Created by Nathan Roberts on 3/28/20.
//  Copyright © 2020 Nathan Roberts. All rights reserved.
//

import Foundation
import RHSideButtons

class SettingsMenuDataSource: RHSideButtonsDataSource {
    
    private enum Constants {
        static let saveIcon = "save-icon"
        static let folderIcon = "folder-icon"
        static let infoIcon = "info-icon"
    }
    
    var settingsChoices = [RHButtonView]()
    
    init() {
        configureButtons()
    }
    
    private func configureButtons() {
        let saveButton = RHButtonView {
            $0.image = UIImage(named: Constants.saveIcon)
            $0.hasShadow = false
        }
        
        let folderButton = RHButtonView {
            $0.image = UIImage(named: Constants.folderIcon)
            $0.hasShadow = false
        }
        
        let infoButton = RHButtonView {
            $0.image = UIImage(named: Constants.infoIcon)
            $0.hasShadow = false
        }
        settingsChoices.append(contentsOf: [saveButton, folderButton, infoButton])
    }
    
    func sideButtonsNumberOfButtons(_ sideButtons: RHSideButtons) -> Int {
        return settingsChoices.count
    }
    
    func sideButtons(_ sideButtons: RHSideButtons, buttonAtIndex index: Int) -> RHButtonView {
        return settingsChoices[index]
    }
}
