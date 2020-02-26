//
//  TalentCell.swift
//  test
//
//  Created by Nathan Roberts on 2/23/20.
//  Copyright © 2020 Nathan Roberts. All rights reserved.
//

import Foundation
import UIKit

class TalentCell: UICollectionViewCell {
    
    private var maxCount: Int?
    private var currentCount: Int = 0
    private var talentImage: UIImageView?
    
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
    
    func configureUI(withTalent talent: SkillElement? = nil) {
        guard let talent = talent else {
            contentView.addSubview(blankBackground)
            blankBackground.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
            blankBackground.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
            blankBackground.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
            blankBackground.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
            return
        }
        
        talentImage = getTalentImage(skillName: talent.name)
        
        contentView.addSubview(background)
        
        background.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        background.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        background.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        background.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        guard let talentImage = talentImage else { return }
        contentView.addSubview(talentImage)
        talentImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2).isActive = true
        talentImage.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 2).isActive = true
        talentImage.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -2).isActive = true
        talentImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2).isActive = true
    }
    
    private func getTalentImage(skillName: String) -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.image = FetchTalentData.getTalentImage(skillName: skillName)
        return imageView
    }
}
