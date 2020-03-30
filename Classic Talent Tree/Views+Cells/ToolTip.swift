//
//  ToolTip.swift
//  Classic Talent Tree
//
//  Created by Nathan Roberts on 3/23/20.
//  Copyright © 2020 Nathan Roberts. All rights reserved.
//

import UIKit

class ToolTip: UIView {
    
    @IBOutlet private var contentView: UIStackView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var rankLabel: UILabel!
    @IBOutlet private var currentRankStackView: UIStackView!
    @IBOutlet private var nextRankStackView: UIStackView!
    @IBOutlet private var currentRankDescription: UILabel!
    @IBOutlet private var nextRankDescription: UILabel!
    @IBOutlet private var requirementsLabel: UILabel!
    @IBOutlet private var contentStackView: UIStackView!
    
    private enum Constants {
        static let width: CGFloat = UIScreen.main.bounds.width - 50
        static let xValue: CGFloat = 25
        static let cornerRadius: CGFloat = 8
        static let spacer: CGFloat = 10
    }
        
    convenience init(cell: TalentCell, specName: String) {
        self.init()
        setupNib(cellFrame: cell.frame)
        configure(cell: cell, specName: specName)
    }

    private func setupNib(cellFrame: CGRect) {
        // Load Nib:
        Bundle.main.loadNibNamed("ToolTip", owner: self, options: nil)
        addSubview(contentView)
        
        // Setup contentView Layout/Constraints
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        contentStackView.addBackground(color: .spookyMineshaft, cornerRadius: Constants.cornerRadius)
        initializeFrame(cellFrame: cellFrame)
    }
    
    private func configure(cell: TalentCell, specName: String) {
        guard let skill = cell.skill else { return }
        
        defer {
            contentStackView.addBackground(color: .spookyMineshaft, cornerRadius: Constants.cornerRadius)
        }
        
        titleLabel.text = skill.name
        rankLabel.text = "Rank \(skill.currentRank)/\(skill.maxRank)"
        
        guard cell.isAvailable else {
            currentRankStackView.isHidden = true
            nextRankDescription.text = skill.rankDescription.first
            if let requiredPoints = skill.requirements?.specPoints {
                requirementsLabel.isHidden = false
                requirementsLabel.text = "Needs \(requiredPoints) points in the \(specName) tree."
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

    private func initializeFrame(cellFrame: CGRect) {
        // Determine if the tool tip needs to be below/above the cell
        let distanceToBottom = UIScreen.main.bounds.height - cellFrame.maxY
        let yValue: CGFloat
        if distanceToBottom > contentView.frame.height + cellFrame.height + Constants.spacer * 10 {
           yValue = cellFrame.maxY + Constants.spacer * 5
        } else {
           yValue = cellFrame.minY - Constants.spacer * 6 - cellFrame.height
        }
        frame = CGRect(x: Constants.xValue, y: yValue, width: Constants.width, height: contentView.frame.height)
    }
}
