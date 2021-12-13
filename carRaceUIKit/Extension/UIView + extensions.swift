//
//  UIView + extensions.swift
//  carRaceUIKit
//
//  Created by Vadim Zhuravlenko on 29.07.21.
//

import Foundation
import UIKit

extension UIView {
    
    func addShadow(radius: CGFloat, color: UIColor = .black) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = .zero
    }
    
    func addCornerRadius(_ radius: CGFloat) {
        self.layer.cornerRadius = radius
    }
    
    func addGradient(colors: [CGColor], locations: [NSNumber]) {
        
        let gradient = CAGradientLayer()
        gradient.colors = colors
        gradient.locations = locations
        
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        
        gradient.frame = bounds
        
        self.layer.insertSublayer(gradient, at: 0)
        
    }
    
}
