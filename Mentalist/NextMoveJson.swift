//
//  NextMoveJson.swift
//  Mentalist
//
//  Created by Michael Kühweg on 26.02.17.
//  Copyright © 2017 Michael Kühweg. All rights reserved.
//

import Foundation

class NextMoveJson {
    
    var nextMove = NextMove()
    
    public init(fromJson: Any) {
        if let dictionary = fromJson as? [String: Any] {
            let myQuestion = dictionary["myQuestion"] as? [String: Any]
            nextMove.questionNumber = (myQuestion?["id"] as? Int)
            nextMove.questionText = (myQuestion?["text"] as? String)
            
            extractGuess(fromJsonDictionary: dictionary)
            
            extractEndpointsForAnswers(fromJsonDictionary: dictionary)
            
            extractCurrentRatings(fromJsonDictionary: dictionary)
        }
    }
    
    func extractCurrentRatings(fromJsonDictionary dictionary: [String: Any]) {
        guard let ratings = dictionary["currentRatings"] as? [Any]
            else {
                return
        }
        for rating in ratings {
            guard let currentRating = rating as? [String: Any]
                else {
                    continue
            }
            var status = EvaluationStatus()
            status.points = currentRating["ratingPoints"] as! Int
            status.percentOfMax = currentRating["percentageOfMaximallyPossibleRating"] as! Int
            status.numberOfEntitiesThatHaveThisEvaluationStatus = currentRating["numberOfCelebritiesSharingThisRating"] as! Int
            let endpoints = currentRating["_links"] as? [String: Any]
            let endpoint = endpoints?["celebs"] as? [String: String]
            status.endpoint = (endpoint?["href"])!
            nextMove.currentEvaluation.append(status)
        }
    }
    
    func extractGuess(fromJsonDictionary dictionary: [String: Any]) {
        guard let blockForMyGuess = dictionary["myGuess"] as? [String: Any]
            else {
                return
        }
        guard let celebrityInMyGuess = blockForMyGuess["myGuess"] as? [String: Any]
            else {
                return
        }
        nextMove.myGuessesName = celebrityInMyGuess["name"] as! String?
        extractEndpointsForGuess(fromJsonDictionary: dictionary)
    }
    
    func extractEndpointsForGuess(fromJsonDictionary dictionary: [String: Any]) {
        guard let blockForMyGuess = dictionary["myGuess"] as? [String: Any]
            else {
                return
        }
        guard let endpoints = blockForMyGuess["_links"] as? [String: Any]
            else {
                return
        }
        extractEndpoint(fromJsonDictionary: endpoints, withKey: NextMove().keyForEndpointConfirm)
        extractEndpoint(fromJsonDictionary: endpoints, withKey: NextMove().keyForEndpointRectify)
    }
    
    func extractEndpointsForAnswers(fromJsonDictionary dictionary: [String: Any]) {
        guard let endpoints = dictionary["_links"] as? [String: Any]
            else {
                return
        }
        extractEndpoint(fromJsonDictionary: endpoints, withKey: NextMove().keyForEndpointAnswerYes)
        extractEndpoint(fromJsonDictionary: endpoints, withKey: NextMove().keyForEndpointAnswerNo)
        extractEndpoint(fromJsonDictionary: endpoints, withKey: NextMove().keyForEndpointAnswerDunno)
        extractEndpoint(fromJsonDictionary: endpoints, withKey: NextMove().keyForEndpointAnswerProbablyYes)
        extractEndpoint(fromJsonDictionary: endpoints, withKey: NextMove().keyForEndpointAnswerProbablyNo)
    }
    
    func extractEndpoint(fromJsonDictionary: [String: Any], withKey: String) {
        guard let endpoint = fromJsonDictionary[withKey] as? [String: String]
            else { return }
        nextMove.endpoints[withKey] = endpoint["href"]
    }
    
}
