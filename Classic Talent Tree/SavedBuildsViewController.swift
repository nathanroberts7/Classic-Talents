//
//  SavedBuildsViewController.swift
//  Classic Talent Tree
//
//  Created by Nathan Roberts on 3/29/20.
//  Copyright © 2020 Nathan Roberts. All rights reserved.
//

import UIKit

protocol SavedBuildsViewControllerDelegate: class {
    func savedBuildsViewController(_: SavedBuildsViewController, loadBuild build: Build)
}

class SavedBuildsViewController: UIViewController {
    
    private enum Constants {
           static let buildViewHeight: CGFloat = 100
       }
    
    @IBOutlet var savedBuildsStackView: UIStackView!
    
    private let buildManager: BuildManager = BuildManager()
    
    weak var delegate: SavedBuildsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func configure(delegate: SavedBuildsViewControllerDelegate) {
        self.delegate = delegate
    }
    
    private func setup() {
        let builds = buildManager.retrieveAllSavedBuilds().sorted() { $0.name < $1.name }
        builds.forEach() { build in
            let buildView = SavedBuild(build: build, delegate: self)
            buildView.heightAnchor.constraint(equalToConstant: Constants.buildViewHeight).isActive = true
            savedBuildsStackView.addArrangedSubview(buildView)
        }
    }
    
    private func getFormattedTalentPoints(points: [[Int]]) -> String {
        guard points.count == 3 else { return "0/0/0"}
        let firstTree = points[0].reduce(0, +)
        let secondTree = points[1].reduce(0, +)
        let thirdTree = points[2].reduce(0, +)
        return "\(firstTree)/\(secondTree)/\(thirdTree)"
    }
}

extension SavedBuildsViewController: SavedBuildDelegate {
    
    func savedBuild(_: SavedBuild, deleteBuild build: Build) {
        buildManager.deleteBuild(build: build)
    }
    
    func savedBuild(_: SavedBuild, loadBuild build: Build) {
        delegate?.savedBuildsViewController(self, loadBuild: build)
        dismiss(animated: true)
    }
}
