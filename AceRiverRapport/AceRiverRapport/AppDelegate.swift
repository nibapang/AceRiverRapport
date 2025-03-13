//
//  AppDelegate.swift
//  AceRiverRapport
//
//  Created by Ace River Rapport on 2025/3/13.
//

import UIKit
import FBSDKCoreKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if let d = UserDefaults.standard.value(forKey: "hist")as? Data{
            do{
                let arr = try JSONDecoder().decode([RapportHistoryModel].self, from: d)
                arrHistory = arr
            }catch{
                print(error.localizedDescription)
            }
        }
        
        ApplicationDelegate.shared.application(
                    application,
                    didFinishLaunchingWithOptions: launchOptions
                )
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

// Add this extension to handle notification scheduling
extension AppDelegate {
    static func scheduleGameReminder() {
        // Clear any pending notifications first
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        // Create notification content
        let content = UNMutableNotificationContent()
        content.title = "Time to Play!"
        content.body = "Ready for another round of Snake Game?"
        content.sound = .default
        content.userInfo = ["NOTIFICATION_TYPE": "GAME_REMINDER"]
        
        // Create trigger for 6 hours from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 6 * 3600, repeats: false)
        
        // Create request
        let request = UNNotificationRequest(
            identifier: "GAME_REMINDER",
            content: content,
            trigger: trigger
        )
        
        // Schedule notification
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Game reminder scheduled for 6 hours from now")
            }
        }
    }
}
