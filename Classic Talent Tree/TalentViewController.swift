//
//  ViewController.swift
//  test
//
//  Created by Nathan Roberts on 2/23/20.
//  Copyright © 2020 Nathan Roberts. All rights reserved.
//

import UIKit

class TalentViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet var collectionView: UICollectionView!
    private var tabViewReference: TabViewController!
    private var pointCount: Int = 0
    private var rowRequirement = [0, 5, 10, 15, 20, 25, 30]
    private var rowPointCount = [0, 0, 0, 0, 0, 0, 0]
    
    
    @IBOutlet private var remainingPointsLabel: UILabel!
    @IBOutlet private var requiredLevelLabel: UILabel!
    @IBOutlet private var backgroundImageView: UIImageView!
    private var backgroundImage: UIImage!
    
    
    
    enum Constants {
        static let itemsPerRow: CGFloat = 4
        static let cellSpacing: CGFloat = 15
        static let sectionInsets: UIEdgeInsets = UIEdgeInsets(top: 50.0, left: 30.0, bottom: 50.0, right: 30.0)
        static let cellIdentifier: String = "talent"
    }
    
    private var talentDataSource: TalentDataSource = TalentDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = talentDataSource
        collectionView.register(TalentCell.self, forCellWithReuseIdentifier: Constants.cellIdentifier)
        backgroundImageView.image = backgroundImage
    }
    
    func configure(skills: [SkillElement], grid: [Int], image: UIImage, reference: TabViewController) {
        talentDataSource.configure(withSkills: skills, grid: grid, delegate: self)
        collectionView?.reloadData()
        tabViewReference = reference
        backgroundImage = image
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacing = (2 * Constants.sectionInsets.left) + ((Constants.itemsPerRow - 1) * Constants.cellSpacing)

        if let collection = self.collectionView{
            let width = (collection.bounds.width - totalSpacing)/Constants.itemsPerRow
            return CGSize(width: width, height: width)
        } else {
            return CGSize(width: 0, height: 0)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return Constants.sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TalentCell, let skill = cell.skill, cell.isAvailable else { return }
        let row = skill.position[0] - 1
        guard tabViewReference.pointsRemaining > 0 else {
            cell.skill?.currentRank = 0
            rowPointCount[row] -= skill.currentRank
            pointCount -= skill.currentRank
            tabViewReference.pointsRemaining += skill.currentRank
            cell.updateCount()
            updateCellAvailability(forRow: row)
            return
        }
        if skill.currentRank < skill.maxRank {
            cell.skill?.currentRank += 1
            rowPointCount[row] += 1
            pointCount += 1
            tabViewReference.pointsRemaining -= 1
        } else {
            cell.skill?.currentRank = 0
            rowPointCount[row] -= skill.maxRank
            pointCount -= skill.maxRank
            tabViewReference.pointsRemaining += skill.maxRank
        }
        cell.updateCount()
        updateCellAvailability(forRow: row)
    }
    
    private func updateCellAvailability(forRow row: Int) {
        guard let collectionView = collectionView else { return }
        for index in 0...27 {
            guard let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? TalentCell,
                let pointRequirement = cell.skill?.requirements?.specPoints else { continue }
            guard pointCount >= pointRequirement else { cell.isAvailable = false; continue }
            if let dependentID = cell.dependentID {
                guard let dependentCell = collectionView.visibleCells.first(where: { ($0 as? TalentCell)?.skill?.id == dependentID }) as? TalentCell,
                    dependentCell.skill?.currentRank == dependentCell.skill?.maxRank else { cell.isAvailable = false; continue }
            }
            cell.isAvailable = true
        }
        
        // If a row does not meet the requirements, delete all rows above it.
        if row != 6 && currentRowPointCount(toRow: row) < rowRequirement[row + 1] {
            for index in ((row + 1) * 4)...27 {
                guard let cell = collectionView.cellForItem(at: IndexPath(item: index , section: 0)) as? TalentCell, let skill = cell.skill else { continue }
                let upperRow = index/4
                guard upperRow >= 1 else {continue}
                cell.isAvailable = false
                pointCount -= skill.currentRank
                tabViewReference.pointsRemaining += skill.currentRank
                cell.skill?.currentRank = 0
                cell.updateCount()
                rowPointCount[upperRow] = 0
                
            }
        }
    }
    
    private func currentRowPointCount(toRow row: Int) -> Int {
        var count = 0
        for index in 0...row {
            count += rowPointCount[index]
        }
        return count
    }
    
    @IBAction func resetPoints(_ sender: UIButton) {
    }
}

extension TalentViewController: TalentCellDelegate {
    func talentCell(_ talentCell: TalentCell, addDownArrowToID: Int) {
        guard let cell = collectionView.visibleCells.first(where: { ($0 as? TalentCell)?.skill?.id == addDownArrowToID }) as? TalentCell else { return }
        let arrowView = UIImageView()
        arrowView.image = UIImage(imageLiteralResourceName: "down-arrow")
        collectionView.addSubview(arrowView)
        arrowView.frame = CGRect(x: cell.frame.origin.x + cell.frame.width/2 - 10,
                                 y: cell.frame.origin.y + cell.frame.height - 2, width: 20, height: (talentCell.frame.minY - cell.frame.maxY) + 5)
        talentCell.downArrow = arrowView
    }
}

