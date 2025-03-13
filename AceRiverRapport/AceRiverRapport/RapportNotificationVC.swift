//
//  NotificationVC.swift
//  AceRiverRapport
//
//  Created by Ace River Rapport on 2025/3/13.
//


import UIKit
import UserNotifications

class RapportNotificationVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnAddNotification: UIButton!
    
    var notifications: [UNNotificationRequest] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        requestNotificationPermission()
        loadNotifications()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "NotificationCell")
        
        btnAddNotification.layer.cornerRadius = 10
        btnAddNotification.addTarget(self, action: #selector(addNotification), for: .touchUpInside)
    }
    
    // MARK: - Request Notification Permission
    private func requestNotificationPermission() {
        NotificationManager.shared.requestPermission { granted in
            if granted {
                print("Notifications enabled ✅")
            } else {
                print("Notifications denied ❌")
            }
        }
    }
    
    // MARK: - Load Scheduled Notifications
    private func loadNotifications() {
        NotificationManager.shared.getPendingNotifications { requests in
            self.notifications = requests
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Add Notification Button Action
    @objc private func addNotification() {
        let identifier = UUID().uuidString
        NotificationManager.shared.scheduleNotification(
            title: "Reminder!",
            body: "Come back and check your game progress.",
            identifier: identifier,
            timeInterval: 10
        )
        showAlert(title: "Notification Added", message: "A new notification has been scheduled in 10 seconds.")
        loadNotifications()
    }
    
    // MARK: - Show Alert
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
}

// MARK: - UITableView Delegate & DataSource
extension RapportNotificationVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath)
        let notification = notifications[indexPath.row]
        cell.textLabel?.text = notification.content.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, completion in
            let identifier = self.notifications[indexPath.row].identifier
            NotificationManager.shared.removeNotification(identifier: identifier)
            self.notifications.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            completion(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
}


class NotificationManager {
    
    static let shared = NotificationManager()
    
    private init() {}
    
    /// Request notification permission
    func requestPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
    
    /// Schedule a local notification
    func scheduleNotification(title: String, body: String, identifier: String, timeInterval: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
    
    /// Get all pending notifications
    func getPendingNotifications(completion: @escaping ([UNNotificationRequest]) -> Void) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            DispatchQueue.main.async {
                completion(requests)
            }
        }
    }
    
    /// Remove a specific notification
    func removeNotification(identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
}
