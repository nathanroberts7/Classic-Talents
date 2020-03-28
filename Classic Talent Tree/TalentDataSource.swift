//
//  TalentDataSource.swift
//  Classic Talent Tree
//
//  Created by Nathan Roberts on 2/24/20.
//  Copyright © 2020 Nathan Roberts. All rights reserved.
//

import Foundation
import UIKit

class TalentDataSource: NSObject, UICollectionViewDataSource {
    
    private var skills: [SkillElement] = []
    private var grid: [Int] = []
    weak var delegate: TalentCellDelegate?
    
    func configure(withSkills skills: [SkillElement], grid: [Int], delegate: TalentCellDelegate) {
        self.skills = skills
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
        let skill: SkillElement? = isNotEmpty != 0 ? skills.removeFirst() : nil
        cell.configure(withSkill: skill, delegate: delegate)
        return cell
    }
}
