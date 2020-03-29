//
//  SideMenuDataSource.swift
//  Classic Talent Tree
//
//  Created by Nathan Roberts on 3/28/20.
//  Copyright © 2020 Nathan Roberts. All rights reserved.
//

import Foundation
import RHSideButtons

class ClassMenuDataSource: RHSideButtonsDataSource {
    
    var classChoices = [RHButtonView]()
    
    init() {
        configureButtons()
    }
    
    private func configureButtons() {
        FetchData.getClassNames().forEach() { className in
            let button = RHButtonView {
                $0.image = UIImage(named: "icon-\(className)")
                $0.hasShadow = false
                $0.className = className
            }
            classChoices.append(button)
        }
    }
    
    func sideButtonsNumberOfButtons(_ sideButtons: RHSideButtons) -> Int {
        return classChoices.count
    }
    
    func sideButtons(_ sideButtons: RHSideButtons, buttonAtIndex index: Int) -> RHButtonView {
        return classChoices[index]
    }
}
