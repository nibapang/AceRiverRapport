//
//  VC+Back.swift
//  AceRiverRapport
//
//  Created by Ace River Rapport on 2025/3/13.
//


import UIKit

extension UIViewController{
    
    @IBAction func btnBack(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
        
    }
    
}
