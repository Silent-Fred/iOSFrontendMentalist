//
//  NextMove.swift
//  Mentalist
//
//  Created by Michael Kühweg on 19.02.17.
//  Copyright © 2017 Michael Kühweg. All rights reserved.
//

import Foundation

struct NextMove {
    
    let keyForEndpointAnswerYes = "YES"
    let keyForEndpointAnswerNo = "NO"
    let keyForEndpointAnswerDunno = "DUNNO"
    let keyForEndpointAnswerProbablyYes = "PROBABLY_YES"
    let keyForEndpointAnswerProbablyNo = "PROBABLY_NO"

    let keyForEndpointConfirm = "confirm"
    let keyForEndpointRectify = "rectify"
    
    var myGuess: Celebrity?
    var questionNumber: Int?
    var questionText: String?
    
    var endpoints = [String:String]()
    
    var currentEvaluation = [EvaluationStatus]()
    
    func endpoint(withKey keyForAnswer: String) -> String? {
        guard let endpoint = endpoints[keyForAnswer] else {
            return nil
        }
        return endpoint
    }

    func endpointAnswerYes() -> String? {
        return endpoint(withKey: keyForEndpointAnswerYes)
    }
    
    func endpointAnswerNo() -> String? {
        return endpoint(withKey: keyForEndpointAnswerNo)
    }
    
    func endpointAnswerDunno() -> String? {
        return endpoint(withKey: keyForEndpointAnswerDunno)
    }
    
    func endpointAnswerProbablyYes() -> String? {
        return endpoint(withKey: keyForEndpointAnswerProbablyYes)
    }
    
    func endpointAnswerProbablyNo() -> String? {
        return endpoint(withKey: keyForEndpointAnswerProbablyNo)
    }
    
    func endpointConfirm() -> String? {
        return endpoint(withKey: keyForEndpointConfirm)
    }
    
    func endpointRectify() -> String? {
        return endpoint(withKey: keyForEndpointRectify)
    }
}
