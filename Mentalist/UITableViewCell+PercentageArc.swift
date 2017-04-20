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
        return (self.imageView?.image = PercentageVisualizer().drawPercentageArc(percent: percent, inFrame: self.frame, inColor: color))!
    }
}
