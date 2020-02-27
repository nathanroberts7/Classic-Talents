//
//  TalentData.swift
//  Classic Talent Tree
//
//  Created by Nathan Roberts on 2/26/20.
//  Copyright © 2020 Nathan Roberts. All rights reserved.
//

import Foundation

class TalentData {
    
    static var isLoaded = false
    static var data: Talents?
    
    enum LoadedData {
        case talents
        
        var path: String {
            switch self {
            case .talents:
                return "talent-data"
            }
        }
        
        var type: String {
            switch self {
            case .talents:
                return "json"
            }
        }
    }
    
    static let shared = TalentData()
    
    static func getDataFromJson() {
        // This should only be called once.
        guard !isLoaded else { preconditionFailure() }
        guard let path = Bundle.main.path(forResource: LoadedData.talents.path, ofType: LoadedData.talents.type) else { return }
        let url = URL(fileURLWithPath: path)
        guard let jsonData = try? Data(contentsOf: url) else { return }
        data = try? JSONDecoder().decode(Talents.self, from: jsonData)
        guard data != nil else { return }
        isLoaded = true
    }
}
