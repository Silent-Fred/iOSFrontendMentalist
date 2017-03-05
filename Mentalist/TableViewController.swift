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
        cell.imageView?.image = ratingDisplayedAsArc(basedOnRating: rating, toReplaceImageInCell: cell)
        
        return cell
    }
    
    func ratingDisplayedAsArc(basedOnRating rating: EvaluationStatus, toReplaceImageInCell cell: UITableViewCell) -> UIImage {
        
        let maxExtent = cell.frame.size.height
        let imageSize = CGSize(width: maxExtent, height: maxExtent)
        let scale: CGFloat = 0
        UIGraphicsBeginImageContextWithOptions(imageSize, false, scale)
        let context = UIGraphicsGetCurrentContext()!
        
        drawMissingPercentageArc(basedOnRating: rating, withMaxExtent: maxExtent, inContext: context)
        drawRatingPercentageArc(basedOnRating: rating, withMaxExtent: maxExtent, inContext: context)
        drawRatingPercentageText(basedOnRating: rating, withMaxExtent: maxExtent)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    func drawMissingPercentageArc(basedOnRating rating: EvaluationStatus, withMaxExtent maxExtent: CGFloat, inContext context: CGContext) {
        
        let center = maxExtent / 2
        let radius = maxExtent * 3 / 8
        let lineWidth = 1
        
        var startAngle = CGFloat(0)
        var ratingAngle = CGFloat(M_PI * 2)
        if rating.percentOfMax > 0 {
            startAngle = CGFloat(-M_PI / 2)
            ratingAngle = CGFloat(M_PI * 2) * CGFloat(Double(rating.percentOfMax) / 100)
        }
        
        let missingArc =
            UIBezierPath(arcCenter: CGPoint(x: center, y: center),
                         radius: radius,
                         startAngle: startAngle, endAngle: startAngle + ratingAngle,
                         clockwise: false)
        context.saveGState()
        context.setFillColor(UIColor.clear.cgColor)
        context.setStrokeColor(UIColor(white: CGFloat(0.9), alpha: (1.0)).cgColor)
        missingArc.lineWidth = CGFloat(lineWidth)
        missingArc.stroke()
        context.restoreGState()
    }
    
    func drawRatingPercentageArc(basedOnRating rating: EvaluationStatus, withMaxExtent maxExtent: CGFloat, inContext context: CGContext) {
        
        guard rating.percentOfMax > 0 else { return }
        
        let center = maxExtent / 2
        let radius = maxExtent * 3 / 8
        let lineWidth = 1
        
        let startAngle = CGFloat(-M_PI / 2)
        let ratingAngle = CGFloat(M_PI * 2) * CGFloat(Double(rating.percentOfMax) / 100)
        
        let ratingArc =
            UIBezierPath(arcCenter: CGPoint(x: center, y: center),
                         radius: radius,
                         startAngle: startAngle, endAngle: startAngle + ratingAngle,
                         clockwise: true)
        context.saveGState()
        context.setFillColor(UIColor.clear.cgColor)
        context.setStrokeColor(self.view.tintColor.cgColor)
        ratingArc.lineWidth = CGFloat(lineWidth)
        ratingArc.stroke()
        context.restoreGState()
    }
    
    func drawRatingPercentageText(basedOnRating rating: EvaluationStatus, withMaxExtent maxExtent: CGFloat) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attrs = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 13),
            NSParagraphStyleAttributeName: paragraphStyle,
            NSForegroundColorAttributeName: self.view.tintColor]
        let string = String("\(rating.percentOfMax)")!
        let stringSize = string.size(attributes: attrs)
        string.draw(with: CGRect(x: 0, y: (maxExtent / 2) - (stringSize.height / 2), width: maxExtent, height: maxExtent), options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
    }
}
