//
//  Build.swift
//  Classic Talent Tree
//
//  Created by Nathan Roberts on 3/28/20.
//  Copyright © 2020 Nathan Roberts. All rights reserved.
//

import Foundation

struct Build: Codable {
    let name: String
    let specPoints: [[Int]]
    let buildClass: Class
    
    init(name: String, specPoints: [[Int]], buildClass: Class) {
        self.name = name
        self.specPoints = specPoints
        self.buildClass = buildClass
    }
}
