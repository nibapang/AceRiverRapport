//
//  GameVC.swift
//  AceRiverRapport
//
//  Created by Ace River Rapport on 2025/3/13.
//


import UIKit
import SpriteKit
import UserNotifications

class RapportGameViewController: UIViewController, UNUserNotificationCenterDelegate {

    @IBOutlet weak var viewGame: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    
    private var gameScene: RapportGameScene?
    private var gameTimer: Timer?
    private var timeRemaining: Int = 60
    private var score = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Schedule next reminder when game opens
        AppDelegate.scheduleGameReminder()
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.4){
            self.setupGame()
        }
        
        // Set notification delegate
        UNUserNotificationCenter.current().delegate = self
        
        // Request notification permission
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                print("Notification permission granted")
            }
        }
    }
    
    // Handle notification when app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
                              withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound])
    }
    
    // Handle notification tap
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    private func setupGame() {
        // Setup SpriteKit scene
        let scene = RapportGameScene(size: viewGame.bounds.size)
        scene.scaleMode = .aspectFill
        scene.backgroundColor = .clear
        
        // Setup SKView
        let skView = SKView(frame: viewGame.bounds)
        skView.presentScene(scene)
        skView.backgroundColor = .clear
        viewGame.addSubview(skView)
        
        gameScene = scene
        gameScene?.gameDelegate = self
        
        // Initialize labels
        scoreLabel.text = "Score: 0"
        levelLabel.text = "Level: 1"
        timeLabel.text = "Time: 60"
        
        startGameTimer()
        
        scene.setGameOver = { i in
            if !i{
                self.gameOver()
            }
            guard let image = skView.takeSnapshot() else { return }
            if let imageData = image.pngData() {
                let historyEntry = RapportHistoryModel(time: Date(), img: imageData, score: self.score)
                arrHistory.append(historyEntry)
            }
            
        }
        
    }
    
    private func startGameTimer() {
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] tmr in
            guard let self = self else { return }
            self.timeRemaining -= 1
            self.timeLabel.text = "Time: \(self.timeRemaining)"
            
            if self.timeRemaining <= 0 {
                self.gameOver()
                tmr.invalidate()
            }
        }
    }
    
    func gameOver() {
        // Ensure we're on the main thread
        if !Thread.isMainThread {
            DispatchQueue.main.async { [weak self] in
                self?.gameOver()
            }
            return
        }
        
        // Stop the timer
        gameTimer?.invalidate()
        gameTimer = nil
        
        // Ensure game scene is paused
        gameScene?.isPaused = true
        
        // Show game over alert
        let alert = UIAlertController(title: score > 500 ? "GAME WIN" : "GAME OVER",
                                    message: "Your final score: \(gameScene?.score ?? 0)",
                                    preferredStyle: .alert)
        
        let restartAction = UIAlertAction(title: "RESTART", style: .default) { [weak self] _ in
            self?.restartGame()
        }
        
        let quitAction = UIAlertAction(title: "QUIT", style: .destructive) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        
        alert.addAction(restartAction)
        alert.addAction(quitAction).self
        alert.applyCustomStyles()
        present(alert, animated: true)
    }
    
    private func restartGame() {
        // Reset timer
        timeRemaining = 60
        timeLabel.text = "Time: 60"
        
        // Reset game scene
        gameScene?.resetGame()
        
        // Start new timer
        startGameTimer()
    }
    
}

extension RapportGameViewController: RapportGameSceneDelegate {
    
    func didUpdateScore(_ score: Int) {
        scoreLabel.text = "Score: \(score)"
        self.score = score
    }
    
    func didUpdateLevel(_ level: Int) {
        levelLabel.text = "Level: \(level)"
    }
    
}
