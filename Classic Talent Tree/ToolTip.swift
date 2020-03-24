//
//  ToolTip.swift
//  Classic Talent Tree
//
//  Created by Nathan Roberts on 3/23/20.
//  Copyright © 2020 Nathan Roberts. All rights reserved.
//

import UIKit

class ToolTip: UIView {
    
    private enum Constants {
        static let height: CGFloat = UIScreen.main.bounds.height/6
        static let width: CGFloat = UIScreen.main.bounds.width - 65
        static let xValue: CGFloat = 32.5
        static let cornerRadius: CGFloat = 8
        static let spacer: CGFloat = 20
    }
        
    convenience init(skill: SkillElement, cellFrame: CGRect) {
        self.init()
        setup(skill: skill, cellFrame: cellFrame)
    }
    
    private func setup(skill: SkillElement, cellFrame: CGRect) {
        // Frame:
        let distanceToBottom = UIScreen.main.bounds.height - cellFrame.maxY
        let yValue: CGFloat
        distanceToBottom > Constants.height + Constants.spacer * 10 ? yValue = cellFrame.maxY + Constants.spacer + cellFrame.height/2 : (yValue = cellFrame.minY - Constants.spacer * 2 - cellFrame.height)
        frame = CGRect(x: Constants.xValue, y: yValue, width: Constants.width, height: Constants.height)
        backgroundColor = .darkGray
        clipsToBounds = true
        layer.cornerRadius = Constants.cornerRadius
        
        // Title:
        let title = UILabel()
        title.font = UIFont(name: "Arial", size: 16)
        title.textColor = .white
        title.text = skill.name
        
        // Description:
        let description = UILabel()
        description.font = UIFont(name: "Arial", size: 14)
        description.textColor = .white
        description.text = skill.rankDescription[0]
        description.numberOfLines = 0
        
        // StackView:
        let stackView = UIStackView(arrangedSubviews: [title, description])
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 6).isActive = true
        stackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        stackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
    }
}
