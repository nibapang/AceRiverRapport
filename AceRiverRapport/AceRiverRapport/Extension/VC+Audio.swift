//
//  VC+Audio.swift
//  AceRiverRapport
//
//  Created by Ace River Rapport on 2025/3/13.
//


import UIKit
import AVFoundation

extension UIViewController {
    
    static var audioPlayer: AVAudioPlayer?
    
    func playSound(name: String, type: String = "mp3", repeatCount: Int = 0) {
        
        if let path = Bundle.main.path(forResource: name, ofType: type) {
            let url = URL(fileURLWithPath: path)
            
            do {
                UIViewController.audioPlayer = try AVAudioPlayer(contentsOf: url)
                UIViewController.audioPlayer?.numberOfLoops = repeatCount == 0 ? -1 : repeatCount - 1
                UIViewController.audioPlayer?.play()
            } catch {
                print("Couldn't load the audio file")
            }
        }
    }
    
    func setVolume(_ v: Float) {
        UIViewController.audioPlayer?.volume = v
    }
    
    func pauseSound() {
        UIViewController.audioPlayer?.pause()
    }
    
    func resumeSound() {
        UIViewController.audioPlayer?.play()
    }
    
}
