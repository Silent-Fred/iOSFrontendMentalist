//
//  Celebrity.swift
//  Mentalist
//
//  Created by Michael Kühweg on 05.03.17.
//  Copyright © 2017 Michael Kühweg. All rights reserved.
//

import Foundation

struct Celebrity {
    var name: String
    var description: String
    
    init(withName: String, andDescription: String) {
        name = withName
        description = andDescription
    }
}
