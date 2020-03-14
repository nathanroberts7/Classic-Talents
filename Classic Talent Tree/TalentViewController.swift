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
    private var pointCount = 0
    
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
    }
    
    func configure(skills: [SkillElement], grid: [Int]) {
        talentDataSource.configure(withSkills: skills, grid: grid, delegate: self)
        collectionView?.reloadData()
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
        if skill.currentRank < skill.maxRank {
            cell.skill?.currentRank += 1
            pointCount += 1
        } else {
            cell.skill?.currentRank = 0
            pointCount -= skill.maxRank
        }
        cell.updateCount()
        updateCellAvailability()
    }
    
    private func updateCellAvailability() {
        guard let collectionView = collectionView else { return }
        for index in 0...27 {
            guard let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? TalentCell else { return }
            if index < (pointCount/5)*4+4 {
                cell.isAvailable = true
            } else {
                cell.isAvailable = false
            }
        }
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

