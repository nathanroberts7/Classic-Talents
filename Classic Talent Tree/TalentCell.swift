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
                guard isGray else { return }
                countLabel?.textColor = .green
                skillImageView.image = skillImage
                background.backgroundColor = .green
                downArrow?.image = downArrowImage
                downRightArrow?.image = downRightArrowImage
                isGray = false
            case false:
                guard !isGray else { return }
                countLabel?.textColor = .gray
                skillImageView.image = skillBWImage
                background.backgroundColor = .gray
                downArrow?.image = downArrowBWImage
                downRightArrow?.image = downRightArrowBWImage
                isGray = true
            }
        }
    }
    
    // State:
    private var isGray = true
    var dependentID: Int?
    
    // Views:
    private var countLabel: UILabel!
    
    var downArrow: UIImageView? {
        didSet {
            downArrowImage = downArrow?.image
            downArrowBWImage = downArrow?.image?.grayscaled
            if !isAvailable {
                downArrow?.image = downArrowBWImage
            }
        }
    }
    private var downArrowImage: UIImage?
    private var downArrowBWImage: UIImage?
    
    var downRightArrow: UIImageView? {
        didSet {
            downRightArrowImage = downRightArrow?.image
            downRightArrowBWImage = downRightArrow?.image?.grayscaled
            if !isAvailable {
                downRightArrow?.image = downRightArrowBWImage
            }
        }
    }
    private var downRightArrowImage: UIImage?
    private var downRightArrowBWImage: UIImage?
    private var skillImage: UIImage?
    private var skillBWImage: UIImage?
    
    
    private let background: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .gray
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
        skillImage = FetchSkillData.getSkillImage(skillName: skill.name)
        skillBWImage = skillImage?.grayscaled
        skillImageView.image = skillBWImage
        contentView.addSubview(skillImageView)
        skillImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2).isActive = true
        skillImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 2).isActive = true
        skillImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -2).isActive = true
        skillImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2).isActive = true
        
        // Count Label Setup
        countLabel = UILabel(frame: CGRect(x: contentView.frame.maxX - 15,
                                           y: contentView.frame.maxY - 10,
                                           width: contentView.frame.width * 0.45,
                                           height: contentView.frame.height * 0.20))
        countLabel.font = UIFont(name: "Roboto", size: 12)
        contentView.addSubview(countLabel)
        countLabel.text = "\(skill.currentRank)/\(skill.maxRank)"
        countLabel.backgroundColor = .black
        countLabel.textColor = .gray
        countLabel.clipsToBounds = false
        countLabel.layer.cornerRadius = 6
        
        
        // Programmatically add arrows for dependent talents
        guard let dependencyID = skill.requirements?.skill?.id else { return }
        delegate?.talentCell(self, addDownArrowToID: dependencyID)
        dependentID = dependencyID
    }
    
    func updateCount() {
        guard let skill = skill else { return }
        countLabel.text = "\(skill.currentRank)/\(skill.maxRank)"
    }
}
