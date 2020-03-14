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
    
    
    var skill: SkillElement?
    
    weak var delegate: TalentCellDelegate?
    
    var isAvailable: Bool = false {
        didSet {
            switch isAvailable {
            case true:
                guard let skill = skill else { return }
                countLabel?.textColor = .green
                skillImageView.image = FetchSkillData.getSkillImage(skillName: skill.name)
                background.backgroundColor = .green
                isGray = false
            case false:
                guard !isGray else { return }
                countLabel?.textColor = .gray
                skillImageView.image = skillImageView.image?.grayscaled
                background.backgroundColor = .gray
                isGray = true
            }
        }
    }
    
    // State:
    private var isGray = false
    
    // Views:
    private var countLabel: UILabel!
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
    
    private let skillImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    func configure(withSkill skill: SkillElement? = nil, delegate: TalentCellDelegate? = nil) {
        self.delegate = delegate
        
        // Invisible Cell Setup (Cell Index does not contain a skill)
        guard let skill = skill else {
            contentView.addSubview(blankBackground)
            blankBackground.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
            blankBackground.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
            blankBackground.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
            blankBackground.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
            return
        }
        
        // Colored Background Setup
        contentView.addSubview(background)
        background.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        background.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        background.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        background.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        // Skill Image Setup
        self.skill = skill
        skillImageView.image = FetchSkillData.getSkillImage(skillName: skill.name)
        contentView.addSubview(skillImageView)
        skillImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2).isActive = true
        skillImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 2).isActive = true
        skillImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -2).isActive = true
        skillImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2).isActive = true
        
        // Count Label Setup
        countLabel = UILabel(frame: CGRect(x: contentView.frame.maxX - 15,
                                           y: contentView.frame.maxY - 10,
                                           width: contentView.frame.width * 0.35,
                                           height: contentView.frame.height * 0.20))
        contentView.addSubview(countLabel)
        countLabel.text = "\(skill.currentRank)/\(skill.maxRank)"
        countLabel.backgroundColor = .black
        countLabel.textColor = .green
        countLabel.clipsToBounds = false
        countLabel.layer.cornerRadius = 6
        
        
        // Programmatically add arrows for dependent talents
        guard let dependencyID = skill.requirements?.skill?.id else { return }
        delegate?.talentCell(self, addDownArrowToID: dependencyID)
    }
    
    func updateCount() {
        guard let skill = skill else { return }
        countLabel.text = "\(skill.currentRank)/\(skill.maxRank)"
    }
}
