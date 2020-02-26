//
//  TalentDataSource.swift
//  test
//
//  Created by Nathan Roberts on 2/24/20.
//  Copyright © 2020 Nathan Roberts. All rights reserved.
//

import Foundation
import UIKit

class TalentDataSource: NSObject, UICollectionViewDataSource {
    
    private var talents: [SkillElement] = []
    private var grid: [Int] = []
    weak var delegate: TalentCellDelegate?
    
    func configure(withTalents talents: [SkillElement], grid: [Int], delegate: TalentCellDelegate) {
        self.talents = talents
        self.grid = grid
        self.delegate = delegate
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return grid.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "talent", for: indexPath) as! TalentCell
        let isNotEmpty = grid[indexPath.item]
        let talent: SkillElement? = isNotEmpty != 0 ? talents.removeFirst() : nil
        cell.configure(withTalent: talent, delegate: delegate)
        return cell
    }
}
