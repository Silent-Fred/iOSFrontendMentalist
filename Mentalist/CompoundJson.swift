//
//  EntityFromJson.swift
//  Mentalist
//
//  Created by Michael Kühweg on 12.03.17.
//  Copyright © 2017 Michael Kühweg. All rights reserved.
//

import Foundation

class CompoundJson {
    
    let json: [String : Any]
    
    init(json: [String : Any]) {
        self.json = json
    }
    
    func element(withPath: [String]) -> [String : Any]? {
        var interimJson: [String : Any]?
        interimJson = json
        for pathElement in withPath {
            interimJson = interimJson?[pathElement] as? [String : Any]
            guard interimJson != nil else {
                return nil
            }
        }
        return interimJson
    }
}
