//
//  UIImageView+PercentageArc.swift
//  Mentalist
//
//  Created by Michael Kühweg on 05.04.17.
//  Copyright © 2017 Michael Kühweg. All rights reserved.
//

import UIKit

extension UITableViewCell {
    
    func percentageArc(percent: Int, drawnInColor color: UIColor) {
        let maxExtent = self.frame.size.height
        let imageSize = CGSize(width: maxExtent, height: maxExtent)
        let scale: CGFloat = 0
        UIGraphicsBeginImageContextWithOptions(imageSize, false, scale)
        let context = UIGraphicsGetCurrentContext()!
        
        drawMissingPercentageArc(percent: percent, drawnInColor: color, withMaxExtent: maxExtent, inContext: context)
        drawRatingPercentageArc(percent: percent, drawnInColor: color, withMaxExtent: maxExtent, inContext: context)
        drawRatingPercentageText(percent: percent, drawnInColor: color, withMaxExtent: maxExtent)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return (self.imageView?.image = newImage!)!
    }
    
    func drawMissingPercentageArc(percent: Int, drawnInColor color: UIColor, withMaxExtent maxExtent: CGFloat, inContext context: CGContext) {
        
        let center = maxExtent / 2
        let radius = maxExtent * 3 / 8
        let lineWidth = 1
        
        var startAngle = CGFloat(0)
        var ratingAngle = CGFloat(M_PI * 2)
        if percent > 0 {
            startAngle = CGFloat(-M_PI / 2)
            ratingAngle = CGFloat(M_PI * 2) * CGFloat(Double(percent) / 100)
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
    
    func drawRatingPercentageArc(percent: Int, drawnInColor color: UIColor, withMaxExtent maxExtent: CGFloat, inContext context: CGContext) {
        
        guard percent > 0 else { return }
        
        let center = maxExtent / 2
        let radius = maxExtent * 3 / 8
        let lineWidth = 1
        
        let startAngle = CGFloat(-M_PI / 2)
        let ratingAngle = CGFloat(M_PI * 2) * CGFloat(Double(percent) / 100)
        
        let ratingArc =
            UIBezierPath(arcCenter: CGPoint(x: center, y: center),
                         radius: radius,
                         startAngle: startAngle, endAngle: startAngle + ratingAngle,
                         clockwise: true)
        context.saveGState()
        context.setFillColor(UIColor.clear.cgColor)
        context.setStrokeColor(color.cgColor)
        ratingArc.lineWidth = CGFloat(lineWidth)
        ratingArc.stroke()
        context.restoreGState()
    }
    
    func drawRatingPercentageText(percent: Int, drawnInColor color: UIColor, withMaxExtent maxExtent: CGFloat) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attrs = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 13),
            NSParagraphStyleAttributeName: paragraphStyle,
            NSForegroundColorAttributeName: color]
        let string = String("\(percent)")!
        let stringSize = string.size(attributes: attrs)
        string.draw(with: CGRect(x: 0, y: (maxExtent / 2) - (stringSize.height / 2), width: maxExtent, height: maxExtent), options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
    }
    
}
