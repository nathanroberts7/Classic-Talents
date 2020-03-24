//
//  ToolTip.swift
//  Classic Talent Tree
//
//  Created by Nathan Roberts on 3/23/20.
//  Copyright © 2020 Nathan Roberts. All rights reserved.
//

import UIKit

class ToolTip: UIView {
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var rankLabel: UILabel!
    @IBOutlet var currentRankStackView: UIStackView!
    @IBOutlet var nextRankStackView: UIStackView!
    @IBOutlet var currentRankDescription: UILabel!
    @IBOutlet var nextRankDescription: UILabel!
    @IBOutlet var requirementsLabel: UILabel!
    
    
    private enum Constants {
        static let width: CGFloat = UIScreen.main.bounds.width - 58
        static let xValue: CGFloat = 29
        static let cornerRadius: CGFloat = 8
        static let spacer: CGFloat = 20
    }
        
    convenience init(cell: TalentCell) {
        self.init()
        setupNib(cellFrame: cell.frame)
        configure(cell: cell)
    }

    private func setupNib(cellFrame: CGRect) {
        // Load Nib:
        Bundle.main.loadNibNamed("ToolTip", owner: self, options: nil)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        
        // Setup contentView Layout/Constraints
        contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = Constants.cornerRadius
        
        // Setup view frame - determine if the tool tip needs to be below/above the cell
        let distanceToBottom = UIScreen.main.bounds.height - cellFrame.maxY
        let yValue: CGFloat
        if distanceToBottom > contentView.frame.height + Constants.spacer * 10 {
            yValue = cellFrame.maxY + Constants.spacer + cellFrame.height/2
        } else {
            yValue = cellFrame.minY - Constants.spacer * 2 - cellFrame.height
        }
        frame = CGRect(x: Constants.xValue, y: yValue, width: Constants.width, height: contentView.frame.height)
    }
    
    private func configure(cell: TalentCell) {
        guard let skill = cell.skill else { return }
        
        titleLabel.text = skill.name
        rankLabel.text = "Rank \(skill.currentRank)/\(skill.maxRank)"
        
        guard cell.isAvailable else {
            currentRankStackView.isHidden = true
            nextRankDescription.text = skill.rankDescription.first
            if let requiredPoints = skill.requirements?.specPoints {
                requirementsLabel.isHidden = false
                requirementsLabel.text = "Needs \(requiredPoints) points in the TEST tree."
            }
            return
        }
        
        guard skill.currentRank > 0 else {
            currentRankStackView.isHidden = true
            nextRankDescription.text = skill.rankDescription.first
            return
        }
        
        guard skill.currentRank != skill.maxRank else {
            nextRankStackView.isHidden = true
            currentRankDescription.text = skill.rankDescription.last
            return
        }
        
        currentRankDescription.text = skill.rankDescription[skill.currentRank - 1]
        nextRankDescription.text = skill.rankDescription[skill.currentRank]
    }
}
