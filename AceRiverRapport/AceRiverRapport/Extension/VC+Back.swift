//
//  VC+Back.swift
//  AceRiverRapport
//
//  Created by jin fu on 2025/3/13.
//


import UIKit

extension UIViewController{
    
    @IBAction func btnBack(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
        
    }
    
}