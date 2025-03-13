//
//  HomeVC.swift
//  AceRiverRapport
//
//  Created by Ace River Rapport on 2025/3/13.
//


import UIKit
import StoreKit

class RapportHomeViewController: UIViewController {
    
    @IBOutlet weak var imgSnake: UIImageView!
    @IBOutlet weak var lblCard: UILabel!
    
    @IBOutlet weak var viewAdd: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgSnake.image = UIImage.gifImageWithName("snake")
        lblCard.transform = CGAffineTransform(rotationAngle: CGFloat.pi/10)
        
        playSound(name: "bg")
        setVolume(0.5)
    }
    
    
    @IBAction func btnRate(_ sender: Any) {
        
        SKStoreReviewController.requestReview()
        viewAdd.removeFromSuperview()
        
    }
    
    
    @IBAction func btnAdd(_ sender: UIButton) {
        
        if sender.tag == 1{
            
            viewAdd.removeFromSuperview()
            
        }else{
            
            let size = UIScreen.main.bounds.size
            
            viewAdd.frame.size = size
            
            viewAdd.center = CGPoint(x: size.width/2, y: size.height/2)
            
            view.addSubview(viewAdd)
            
        }
        
    }
    
    @IBAction func btnMusic(_ sender: UIButton) {
        sender.isSelected.toggle()
        sender.isSelected ? pauseSound() : resumeSound()
    }
    
    @IBAction func sldrVolume(_ sender: UISlider) {
        setVolume(sender.value)
    }
    
}
