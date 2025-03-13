//
//  VC+cus.swift
//  AceRiverRapport
//
//  Created by jin fu on 2025/3/13.
//


import UIKit

extension UIAlertController {
    
    func applyCustomStyles() {
        // Set background color and corner radius
        if let bgView = self.view.subviews.first?.subviews.first?.subviews.first {
            bgView.backgroundColor = UIColor.white.withAlphaComponent(0.85)
            bgView.layer.cornerRadius = 20
            bgView.layer.masksToBounds = true
        }
        
        self.view.subviews.first?.subviews.first?.subviews.first?.subviews.first?.backgroundColor = .white
        let bg = UIImageView(image: UIImage(named: "BG"))
        bg.alpha = 0.3
        self.view.subviews.first?.subviews.first?.subviews.first?.subviews.first?.insertSubview(bg,at: 0)
        self.view.subviews.first?.subviews.first?.subviews.first?.subviews.last?.subviews.first?.backgroundColor = .white

        // Increase alert width and height
        let widthConstraint = NSLayoutConstraint(item: self.view!, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 500)
        let heightConstraint = NSLayoutConstraint(item: self.view!, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200)
        self.view.addConstraints([widthConstraint, heightConstraint])
    }
    
}
