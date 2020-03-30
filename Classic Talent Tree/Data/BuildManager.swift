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
    
    func deleteBuild(build: Build) {
        UserDefaults.standard.removeObject(forKey: "build-\(build.name)")
    }
    
    func retrieveAllSavedBuilds() -> [Build] {
        var builds: [Build] = []
        let decoder = JSONDecoder()
        for (_, encodedBuild) in UserDefaults.standard.dictionaryRepresentation() {
            guard let encodedBuild = encodedBuild as? Data else { continue }
            if let decodedBuild = try? decoder.decode(Build.self, from: encodedBuild) {
                builds.append(decodedBuild)
            }
        }
        return builds
    }
    
    private func isKeyPresent(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
}
