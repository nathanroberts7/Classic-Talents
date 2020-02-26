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
    
    
    let sectionInsets = UIEdgeInsets(top: 50.0, left: 30.0, bottom: 50.0, right: 30.0)
    let numberOfItemsPerRow: CGFloat = 4
    let spacingBetweenCells: CGFloat = 15
    
    var talentDataSource: TalentDataSource = TalentDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = talentDataSource
        collectionView.register(TalentCell.self, forCellWithReuseIdentifier: "talent")
        let grid = [0, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 0, 0, 0, 1, 0, 0, 1, 0, 0]
        
        guard let path = Bundle.main.path(forResource: "talent-data", ofType: "json") else { return }
        let url = URL(fileURLWithPath: path)
        guard let jsonData = try? Data(contentsOf: url) else { return }
        let jsonOjb = try? JSONDecoder().decode(Talents.self, from: jsonData)
        let myClass = jsonOjb?.classes.first() { $0.name == "Mage"}
        let myTree = myClass?.talentTrees.first() { $0.name == "Fire"}
        let mySkills = myTree?.skills
        
        guard let skills = mySkills else { return }
        
        talentDataSource.configure(withTalents: skills, grid: grid, delegate: self)
        //collectionView.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacing = (2 * sectionInsets.left) + ((numberOfItemsPerRow - 1) * spacingBetweenCells)

        if let collection = self.collectionView{
            let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
            return CGSize(width: width, height: width)
        } else {
            return CGSize(width: 0, height: 0)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacingBetweenCells
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TalentCell else { return }
    }
}

extension TalentViewController: TalentCellDelegate {
    func talentCell(_ talentCell: TalentCell, addDownArrowToID: Int) {
        let cell = collectionView.visibleCells.first() {
            guard let cell = $0 as? TalentCell else { return false }
            if cell.skill?.id == addDownArrowToID {
                return true
            }
            return false
        } as? TalentCell
        guard let myCell = cell else { return }
        let arrowView = UIImageView()
        arrowView.image = UIImage(imageLiteralResourceName: "down-arrow")
        collectionView.addSubview(arrowView)
        arrowView.frame = CGRect(x: myCell.frame.origin.x + myCell.frame.width/2 - 10,
                                 y: myCell.frame.origin.y + myCell.frame.height - 2, width: 20, height: myCell.frame.height + 34)
        myCell.downArrow = arrowView
    }
}

