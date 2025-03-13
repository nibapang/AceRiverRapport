//
//  GetStartedVC.swift
//  AceRiverRapport
//
//  Created by jin fu on 2025/3/13.
//


import UIKit

class RapportGetStartedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now()+2){
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC")as! RapportHomeViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
}
