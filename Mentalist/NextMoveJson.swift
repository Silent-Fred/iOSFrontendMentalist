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
    
    init(fromJson: Any) {
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
            status.endpoint = EntityWithResourceSupportJson(json: currentRating).extractURL(withKey: "celebs")!
            nextMove.currentEvaluation.append(status)
        }
    }
    
    func extractGuess(fromJsonDictionary dictionary: [String: Any]) {
        let complexEntity = CompoundJson(json: dictionary)
        guard let guess = complexEntity.element(withPath: ["myGuess", "myGuess"])
            else {
                return
        }
        nextMove.myGuess = CelebrityJson(fromJson: guess).celebrity
        let resources = EntityWithResourceSupportJson(json: (complexEntity.element(withPath: ["myGuess"]))!)
        nextMove.endpoints[NextMove().keyForEndpointConfirm] = resources.extractURL(withKey: NextMove().keyForEndpointConfirm)
        nextMove.endpoints[NextMove().keyForEndpointRectify] = resources.extractURL(withKey: NextMove().keyForEndpointRectify)
    }
    
    func extractEndpointsForAnswers(fromJsonDictionary dictionary: [String: Any]) {
        let answerResources = EntityWithResourceSupportJson(json: dictionary)
        nextMove.endpoints[NextMove().keyForEndpointAnswerYes] = answerResources.extractURL(withKey: NextMove().keyForEndpointAnswerYes)
        nextMove.endpoints[NextMove().keyForEndpointAnswerNo] = answerResources.extractURL(withKey: NextMove().keyForEndpointAnswerNo)
        nextMove.endpoints[NextMove().keyForEndpointAnswerDunno] = answerResources.extractURL(withKey: NextMove().keyForEndpointAnswerDunno)
        nextMove.endpoints[NextMove().keyForEndpointAnswerProbablyYes] = answerResources.extractURL(withKey: NextMove().keyForEndpointAnswerProbablyYes)
        nextMove.endpoints[NextMove().keyForEndpointAnswerProbablyNo] = answerResources.extractURL(withKey: NextMove().keyForEndpointAnswerProbablyNo)
    }
}
