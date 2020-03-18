//
//  ViewController.swift
//  Project21
//
//  Created by Victor Rolando Sanchez Jara on 3/17/20.
//  Copyright © 2020 Victor Rolando Sanchez Jara. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
    }
    
    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound, .criticalAlert]) { (granted, error) in
//        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Yay!")
            } else {
                print("D'oh")
            }
        }
    }
    
    @objc func scheduleLocal() {
        let center = UNUserNotificationCenter.current()
        
        
        // Cancel all previously scheduled
        center.removeAllPendingNotificationRequests()
        // Cancel all previously scheduled
        
        registerCategories()
        
//        let content = UNMutableNotificationContent()
//        content.title = "Title goes here"
//        content.body = "Main text goes here"
//        content.categoryIdentifier = "customIdentifier"
//        content.userInfo = ["customData": "fizzbuzz"]
//        content.sound = UNNotificationSound.default
        
        let content = UNMutableNotificationContent()
        content.title = "Late wake up call"
        content.body = "The early bird catches the worm, but the second mouse gets the cheese."
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound.defaultCritical
        
        // Set at a specific date / time
//        var dateComponents = DateComponents()
//        dateComponents.hour = 10
//        dateComponents.minute = 30
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
//
//        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//        center.add(request)
        
        // Set after a specific interval
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)

    }

    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "show", title: "Tell me more…", options: .foreground)
        let remind = UNNotificationAction(identifier: "remind", title: "Remind me later!", options: .foreground)
        
        let category = UNNotificationCategory(identifier: "alarm", actions: [show, remind], intentIdentifiers: [])
        
        center.setNotificationCategories([category])
    }
    
    // MARK: UNUserNotificationCenterDelegate
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Update the app interface directly.
        print("willPresent")
        // Play a sound.
        completionHandler(UNNotificationPresentationOptions.sound)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("userNotificationCenter")
        // pull out the buried userInfo dictionary
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String {
            print("Custom data received: \(customData)")
            
            switch response.actionIdentifier {
                case UNNotificationDefaultActionIdentifier:
                    // the user swiped to unlock
                    print("Default identifier")
                
                    let ac = UIAlertController(title: "Default", message: "Default identifier", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "Ok", style: .default)
                    
                    ac.addAction(okAction)
                    
                    present(ac, animated: true)
                
                case "show":
                    // the user tapped our "show more info…" button
                    print("Show more information…")
                    
                    let ac = UIAlertController(title: "More", message: "More information...", preferredStyle: .alert)
                
                    let okAction = UIAlertAction(title: "Ok", style: .default)
                
                    ac.addAction(okAction)
                
                    present(ac, animated: true)
                case "remind":
                    print("Remind me later")
                
                    let content = UNMutableNotificationContent()
                    content.title = "Reminder"
                    content.body = "You asked us to remind you about this"
                    content.categoryIdentifier = "reminder"
                    content.userInfo = ["customData": "fizzbuzz"]
                    content.sound = UNNotificationSound.defaultCritical
                
                    
                    // Set after a specific interval
                    // 86400 seconds = After a day
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                    center.add(request)

                default:
                    break
            }
        }
        
        // you must call the completion handler when you're done
        completionHandler()
    }
}

