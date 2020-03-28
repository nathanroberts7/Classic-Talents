//
//  ViewController.swift
//  Classic Talent Tree
//
//  Created by Nathan Roberts on 2/23/20.
//  Copyright © 2020 Nathan Roberts. All rights reserved.
//

import UIKit

class TalentViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet var collectionView: UICollectionView?
    private var tabViewReference: TabViewController?
    private var specName: String!
    private var pointCount: Int = 0
    private var rowRequirement = [0, 5, 10, 15, 20, 25, 30]
    private var rowPointCount = [0, 0, 0, 0, 0, 0, 0]
    
    @IBOutlet private var remainingPointsLabel: UILabel!
    @IBOutlet private var requiredLevelLabel: UILabel!
    @IBOutlet private var backgroundImageView: UIImageView!
    private var backgroundImage: UIImage!
    private var toolTip: ToolTip?
    
    private var talentDataSource: TalentDataSource = TalentDataSource()
    
    private enum Constants {
        static let itemsPerRow: CGFloat = 4
        static let cellSpacing: CGFloat = 10
        static let sectionInsets: UIEdgeInsets = UIEdgeInsets(top: 50.0, left: 30.0, bottom: 50.0, right: 30.0)
        static let cellIdentifier: String = "talent"
        static let maxCellIndex: Int = 27
        static let maxRowIndex: Int = 6
        static let downArrowIdentifier: String = "down-arrow"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.delegate = self
        collectionView?.dataSource = talentDataSource
        collectionView?.register(TalentCell.self, forCellWithReuseIdentifier: Constants.cellIdentifier)
        backgroundImageView.image = backgroundImage
        collectionView?.reloadData()
        
        // Tap Gesture for Tool Tip Removal
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.removeToolTip))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateRequiredLevelLabel()
        updateRemainingPointsLabel()
        updateCellAvailability(forRow: 0)
    }
    
    func configure(skills: [SkillElement], grid: [Int], image: UIImage, name: String, reference: TabViewController) {
        talentDataSource.configure(withSkills: skills, grid: grid, delegate: self)
        collectionView?.reloadData()
        tabViewReference = reference
        backgroundImage = image
        specName = name
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacing = (2 * Constants.sectionInsets.left) + (Constants.itemsPerRow * Constants.cellSpacing)
        guard let collection = self.collectionView else {  return CGSize(width: 0, height: 0) }
        let width = (collection.bounds.width - totalSpacing)/Constants.itemsPerRow
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return Constants.sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.cellSpacing
    }
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TalentCell, let skill = cell.skill else { return }
        
        guard cell.isAvailable else { toggleToolTip(cell: cell, specName: specName); return }
        
        defer {
            cell.updateColor()
            updateRequiredLevelLabel()
            updateRemainingPointsLabel()
        }
        
        let row = skill.position[0] - 1
        
        // If all possible points were used, reset the cell the user taps next.
        guard let tabView = tabViewReference, tabView.pointsRemaining > 0,
            skill.currentRank < skill.maxRank else { resetCell(cell: cell, withSkill: skill, atRow: row); toggleToolTip(cell: cell, specName: specName); return }
        
        // Tap to increase the rank. If already max, then reset.
        increaseCellRank(cell: cell, atRow: row)
        
        cell.updateText()
        updateCellAvailability(forRow: row)
        toggleToolTip(cell: cell, specName: specName)
    }
    
    private func updateCellAvailability(forRow row: Int) {
        guard let collectionView = collectionView else { return }
        for index in 0...Constants.maxCellIndex {
            guard let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? TalentCell else { continue }
            let pointRequirement = cell.skill?.requirements?.specPoints ?? 0
            
            // If total pointCount does not equal skill requirement, make it unavailable.
            guard pointCount >= pointRequirement else { cell.isAvailable = false; continue }
            
            // If a skill has a dependency and the dependency is not max rank, make the skill unavailable.
            if let dependentID = cell.dependentID, let dependentCell = collectionView.visibleCells.first(where: { ($0 as? TalentCell)?.skill?.id == dependentID }) as? TalentCell,
                let skill = cell.skill, dependentCell.skill?.currentRank != dependentCell.skill?.maxRank {
                cell.isAvailable = false
                // Reset the skills rank if it had points in it.
                guard cell.skill?.currentRank ?? 0 > 0 else { continue }
                let dependentRow = index/Int(Constants.itemsPerRow)
                resetCell(cell: cell, withSkill: skill, atRow: dependentRow)
                continue
            }
            cell.isAvailable = true
        }
        
        // If a row does not meet the requirements, delete all rows above it. This does not apply to the last row.
        guard row < Constants.maxRowIndex && currentRowPointCount(toRow: row) < rowRequirement[row + 1] else { return }
        for index in ((row + 1) * Int(Constants.itemsPerRow))...Constants.maxCellIndex {
            // upperRow defines the current row given the index. This will always be above the initial row.
            let upperRow = index/Int(Constants.itemsPerRow)
            guard let cell = collectionView.cellForItem(at: IndexPath(item: index , section: 0)) as? TalentCell,
                let skill = cell.skill,  upperRow >= 1 else { continue }
            
            cell.isAvailable = false
            resetCell(cell: cell, withSkill: skill, atRow: upperRow)
        }
    }
    
    private func currentRowPointCount(toRow row: Int) -> Int {
        return rowPointCount[0...row].reduce(0, +)
    }

    private func resetCell(cell: TalentCell, withSkill skill: SkillElement, atRow row: Int) {
        cell.skill?.currentRank = 0
        rowPointCount[row] -= skill.currentRank
        pointCount -= skill.currentRank
        tabViewReference?.pointsRemaining += skill.currentRank
        cell.updateText()
        updateCellAvailability(forRow: row)
    }
    
    private func increaseCellRank(cell: TalentCell, atRow row: Int) {
        cell.skill?.currentRank += 1
        rowPointCount[row] += 1
        pointCount += 1
        tabViewReference?.pointsRemaining -= 1
    }
    
    private func updateRemainingPointsLabel() {
        guard let points = tabViewReference?.pointsRemaining else { return }
        remainingPointsLabel.text = "Remaining Points: \(points)"
    }
    
    private func updateRequiredLevelLabel() {
        guard let points = tabViewReference?.pointsRemaining, points < 51 else { requiredLevelLabel.text = "Required Level: -"; return }
        requiredLevelLabel.text = "Required Level: \((51 - points) + 9)"
    }
    
    private func toggleToolTip(cell: TalentCell, specName: String) {
        if toolTip != nil { toolTip?.removeFromSuperview() }
        toolTip = ToolTip(cell: cell, specName: specName)
        guard let toolTip = toolTip else { return }
        view.addSubview(toolTip)
    }
    
    @objc private func removeToolTip() {
        toolTip?.removeFromSuperview()
    }
    
    // IBActions:
    @IBAction func resetPoints(_ sender: UIButton) {
        guard let collectionView = collectionView else { return }
        for index in 0...Constants.maxCellIndex {
            guard let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? TalentCell,
                let skill = cell.skill else { continue }
            let row = index/Int(Constants.itemsPerRow)
            resetCell(cell: cell, withSkill: skill, atRow: row)
            cell.updateColor()
        }
        updateRequiredLevelLabel()
        updateRemainingPointsLabel()
        if toolTip != nil { toolTip?.removeFromSuperview() }
    }
}

extension TalentViewController: TalentCellDelegate {
    func talentCell(_ talentCell: TalentCell, addDownArrowToID: Int) {
        guard let cell = collectionView?.visibleCells.first(where: { ($0 as? TalentCell)?.skill?.id == addDownArrowToID }) as? TalentCell else { return }
        let arrowView = UIImageView()
        collectionView?.addSubview(arrowView)
        
        if cell.frame.midX < talentCell.frame.midX && cell.frame.midY < talentCell.frame.midY {
            // Right + Down Arrow
            let rightArrow = UIImage(imageLiteralResourceName: Constants.downArrowIdentifier).rotate(radians: CGFloat((3 * Double.pi)/2))
            let downArrow = UIImage(imageLiteralResourceName: Constants.downArrowIdentifier)
            let size = CGSize(width:(talentCell.frame.midX - cell.frame.maxX) + 10, height: (talentCell.frame.minY - cell.frame.midY))
            UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
            rightArrow.draw(in: CGRect(x: 0, y: 0, width: size.width, height: 15))
            downArrow.draw(in: CGRect(x: size.width - 15, y: 4, width: 20, height: size.height - 5))
            guard let rightDownArrow: UIImage = UIGraphicsGetImageFromCurrentImageContext() else { return }
            UIGraphicsEndImageContext()
            arrowView.image = rightDownArrow
            arrowView.frame = CGRect(x: cell.frame.origin.x + cell.frame.width - 2.5,
                                     y: cell.frame.origin.y + cell.frame.height/2 - 10,
                                     width: (talentCell.frame.midX - cell.frame.maxX) + 5,
                                     height: (talentCell.frame.minY - cell.frame.midY) + 15)
            
        } else if cell.frame.midX < talentCell.frame.midX && cell.frame.midY == talentCell.frame.midY {
            // Right Arrow (Rotate Down Arrow)
            arrowView.image = UIImage(imageLiteralResourceName: Constants.downArrowIdentifier).rotate(radians: CGFloat((3 * Double.pi)/2))
            arrowView.frame = CGRect(x: cell.frame.origin.x + cell.frame.width - 2,
                                     y: cell.frame.origin.y + cell.frame.height/2 - 5,
                                     width: (talentCell.frame.minX - cell.frame.maxX) + 5,
                                     height: 20)
        } else {
            // Down Arrow
            arrowView.image = UIImage(imageLiteralResourceName: Constants.downArrowIdentifier)
            arrowView.frame = CGRect(x: cell.frame.origin.x + cell.frame.width/2 - 10,
                                     y: cell.frame.origin.y + cell.frame.height - 2,
                                     width: 20,
                                     height: (talentCell.frame.minY - cell.frame.maxY) + 5)
        }
        talentCell.downArrow = arrowView
    }
}

