//
//  SavedBuild.swift
//  Classic Talent Tree
//
//  Created by Nathan Roberts on 3/29/20.
//  Copyright © 2020 Nathan Roberts. All rights reserved.
//

import UIKit

protocol SavedBuildDelegate: class {
    func savedBuild(_: SavedBuild, deleteBuild build: Build)
    func savedBuild(_: SavedBuild, loadBuild build: Build)
}

class SavedBuild: UIView {
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private var stackView: UIStackView!
    @IBOutlet private var buildNameLabel: UILabel!
    @IBOutlet private var classNameLabel: UILabel!
    @IBOutlet private var talentPointsLabel: UILabel!
    private var buildReference: Build?
    
    weak var delegate: SavedBuildDelegate?
    
    convenience init(build: Build, delegate: SavedBuildDelegate) {
        self.init()

        // Load Nib:
        Bundle.main.loadNibNamed("SavedBuild", owner: self, options: nil)
        addSubview(contentView)

        // Setup contentView Layout/Constraints
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        // Setup Labels
        buildNameLabel.text = build.name
        classNameLabel.text = "Class: \(build.buildClass.name)"
        talentPointsLabel.text = getFormattedTalentPoints(points: build.specPoints)
        
        // Delegate Setup
        self.delegate = delegate
        
        // Save Build Reference
        self.buildReference = build
        
        // Tap Gesture Setup
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.loadBuild))
        tapGesture.cancelsTouchesInView = false
        stackView.addGestureRecognizer(tapGesture)
       }
    
    @IBAction func deleteBuild(_ sender: UIButton) {
        self.isHidden = true
        guard let build = buildReference else { return }
        delegate?.savedBuild(self, deleteBuild: build)
    }
    
    @objc private func loadBuild() {
        guard let build = buildReference else { return }
        delegate?.savedBuild(self, loadBuild: build)
    }
    
    private func getFormattedTalentPoints(points: [[Int]]) -> String {
        guard points.count == 3 else { return "0/0/0"}
        let firstTree = points[0].reduce(0, +)
        let secondTree = points[1].reduce(0, +)
        let thirdTree = points[2].reduce(0, +)
        return "\(firstTree)/\(secondTree)/\(thirdTree)"
    }
}
