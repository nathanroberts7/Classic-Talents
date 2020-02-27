//
//  TalentCell.swift
//  test
//
//  Created by Nathan Roberts on 2/23/20.
//  Copyright © 2020 Nathan Roberts. All rights reserved.
//

import Foundation
import UIKit

protocol TalentCellDelegate: class {
    func talentCell(_: TalentCell, addDownArrowToID: Int)
}

class TalentCell: UICollectionViewCell {
    
    private var maxCount: Int?
    private var currentCount: Int = 0
    private var skillImage: UIImageView?
    var skill: SkillElement?
    weak var delegate: TalentCellDelegate?
    var downArrow: UIImageView?
    var downRightArrow: UIImageView?
    
    private let background: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .green
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    private let blankBackground: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    func configure(withSkill skill: SkillElement? = nil, delegate: TalentCellDelegate? = nil) {
        self.delegate = delegate
        guard let skill = skill else {
            contentView.addSubview(blankBackground)
            blankBackground.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
            blankBackground.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
            blankBackground.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
            blankBackground.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
            return
        }
        self.skill = skill
        skillImage = getSkillImage(skillName: skill.name)
        
        contentView.addSubview(background)
        
        background.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        background.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        background.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        background.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        guard let skillImage = skillImage else { return }
        contentView.addSubview(skillImage)
        skillImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2).isActive = true
        skillImage.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 2).isActive = true
        skillImage.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -2).isActive = true
        skillImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2).isActive = true
        
        guard let dependencyID = skill.requirements?.skill?.id else { return }
        delegate?.talentCell(self, addDownArrowToID: dependencyID)
    }
    
    private func getSkillImage(skillName: String) -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.image = FetchSkillData.getSkillImage(skillName: skillName)
        return imageView
    }
}
