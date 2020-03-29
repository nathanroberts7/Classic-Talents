//
//  BuildManager.swift
//  Classic Talent Tree
//
//  Created by Nathan Roberts on 3/28/20.
//  Copyright © 2020 Nathan Roberts. All rights reserved.
//

import Foundation

class BuildManager {
    
    func saveBuild(build: Build, completionHandler: @escaping (Bool) -> Void) {
        guard !isKeyPresent(key: "build-\(build.name)") else { completionHandler(false); return }
        let encoder = JSONEncoder()
        if let encodedBuild = try? encoder.encode(build) {
            UserDefaults.standard.set(encodedBuild, forKey: "build-\(build.name)")
            completionHandler(true)
        }
    }
    
    private func isKeyPresent(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
}
