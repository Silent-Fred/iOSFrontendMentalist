//
//  TableViewController.swift
//  Mentalist
//
//  Created by Michael Kühweg on 04.03.17.
//  Copyright © 2017 Michael Kühweg. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UITableViewController {
    
    var nextMove = NextMove()
    
    override func viewDidLoad() {
        self.navigationItem.title = "Rating"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nextMove.currentEvaluation.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "jumpToCelebritiesWithRating" {
            let celebritiesWithRatingController = segue.destination as! CelebritiesWithRatingTableViewController
            celebritiesWithRatingController.rating = nextMove.currentEvaluation[(self.tableView.indexPathForSelectedRow?.row)!]
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ratingCell", for: indexPath)
        
        let rating = nextMove.currentEvaluation[indexPath.row]
        
        cell.textLabel?.text = String("\(rating.points) Punkte")
        let celebrityText = rating.numberOfEntitiesThatHaveThisEvaluationStatus == 1 ? "Persönlichkeit" : "Persönlichkeiten"
        cell.detailTextLabel?.text = String("\(rating.numberOfEntitiesThatHaveThisEvaluationStatus) \(celebrityText) mit diesem Rating")
        
        cell.percentageArc(percent: rating.percentOfMax, drawnInColor: self.view.tintColor)
        
        return cell
    }
    
}
