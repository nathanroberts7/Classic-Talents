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

        let talentData = TalentData.data
        let myClass = talentData?.classes.first() { $0.name == "Mage"}
        let myTree = myClass?.talentTrees.first() { $0.name == "Fire"}
        let spec = ClassInfo.Mage.specializations.first(where: { $0 == .fire })
        guard let skills = myTree?.skills, let grid = spec?.grid else { return }
        talentDataSource.configure(withSkills: skills, grid: grid, delegate: self)
        //collectionView.reloadData()
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
        guard let cell = collectionView.cellForItem(at: indexPath) as? TalentCell else { return }
    }
}

extension TalentViewController: TalentCellDelegate {
    func talentCell(_ talentCell: TalentCell, addDownArrowToID: Int) {
        guard let cell = collectionView.visibleCells.first(where: { ($0 as? TalentCell)?.skill?.id == addDownArrowToID }) as? TalentCell else { return }
        let arrowView = UIImageView()
        arrowView.image = UIImage(imageLiteralResourceName: "down-arrow")
        collectionView.addSubview(arrowView)
        arrowView.frame = CGRect(x: cell.frame.origin.x + cell.frame.width/2 - 10,
                                 y: cell.frame.origin.y + cell.frame.height - 2, width: 20, height: cell.frame.height + 34)
        cell.downArrow = arrowView
    }
}

