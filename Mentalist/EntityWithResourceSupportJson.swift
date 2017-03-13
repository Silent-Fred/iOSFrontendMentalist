//
//  EntityFromJsonWithResourceSupport.swift
//  Mentalist
//
//  Created by Michael Kühweg on 12.03.17.
//  Copyright © 2017 Michael Kühweg. All rights reserved.
//

import Foundation

class EntityWithResourceSupportJson: CompoundJson {
    
    func extractURL(withKey: String) -> String? {
        guard let hrefElement = element(withPath: ["_links", withKey])
            else {
                return nil
        }
        return hrefElement["href"] as? String
    }
}
