//
//  CelebrityJson.swift
//  Mentalist
//
//  Created by Michael Kühweg on 05.03.17.
//  Copyright © 2017 Michael Kühweg. All rights reserved.
//

import Foundation

class CelebrityJson {
    
    var celebrity = Celebrity(withName: "", andDescription: "")
    
    init(fromJson: Any) {
        let dictionary = fromJson as! [String : Any]
        celebrity = extractCelebrity(fromJsonDictionary: dictionary)
    }
    
    func extractCelebrity(fromJsonDictionary dictionary: [String: Any]) -> Celebrity {
        let name = dictionary["name"] as! String
        let description = dictionary["description"] as! String
        return Celebrity(withName: name, andDescription: description)
    }
    
}
