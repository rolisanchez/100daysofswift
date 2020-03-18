//
//  ViewController.swift
//  Project2
//
//  Created by Victor Rolando Sanchez Jara on 1/23/20.
//  Copyright © 2020 Victor Rolando Sanchez Jara. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    
    var countries = [String]()
    var correctAnswer = 0
    var score = 0
    var questionsAsked = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(showScore))

        setupCountries()
        askQuestion()
        // askQuestion(action: nil)= nil
        registerLocal()
        
        
    }
    

    
    func setupCountries(){
//        countries.append("estonia")
//        countries.append("france")
//        countries.append("germany")
//        countries.append("ireland")
//        countries.append("italy")
//        countries.append("monaco")
//        countries.append("nigeria")
//        countries.append("poland")
//        countries.append("russia")
//        countries.append("spain")
//        countries.append("uk")
//        countries.append("us")
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        correctAnswer = Int.random(in: 0...2)
        let defaults = UserDefaults.standard

        let maxScore = defaults.integer(forKey: "maxScore")
        title = "Guess: " + countries[correctAnswer].uppercased() + " ~ Current: \(score) ~ Max: \(maxScore)"
        
        questionsAsked += 1

    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        let defaults = UserDefaults.standard
        var maxScore = defaults.integer(forKey: "maxScore")
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
            sender.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            sender.transform = .identity
        })

        if sender.tag == correctAnswer {
            score += 1
            if score > maxScore {
                maxScore = score
                defaults.set(maxScore, forKey: "maxScore")
            }
            title = "Correct! ~ Max: \(maxScore)"
            
        } else {
            title = "Wrong! That's the flag of \(countries[sender.tag].uppercased()) ~ Max: \(maxScore)"
            score -= 1
        }
        
        if questionsAsked == 10 {
            let ac = UIAlertController(title: title, message: "Final score is \(score).", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Restart", style: .default, handler: restart))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: title, message: "Your score is \(score).", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
            present(ac, animated: true)
        }
        
    }
    
    func restart(action: UIAlertAction! = nil) {
        score = 0
        questionsAsked = 0
        
        askQuestion()
        
    }
    
    @objc func showScore() {
        let ac = UIAlertController(title: "Score", message: "Your score is \(score).", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
        present(ac, animated: true)
    }
    
    
    func registerLocal() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Yay!")
                self.scheduleLocal()
            } else {
                print("D'oh")
            }
        }
    }
    
    // MARK: Notifications
    func scheduleLocal() {
        let center = UNUserNotificationCenter.current()
        
        
        // Cancel all previously scheduled
        center.removeAllPendingNotificationRequests()
        // Cancel all previously scheduled
        
        registerCategories()
        
        let content = UNMutableNotificationContent()
        content.title = "Come back to COUNTRIES"
        content.body = "Remember to come back and play your favorite game"
        content.categoryIdentifier = "weeklyAlarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound.defaultCritical
        
        // Set for all days in week
        for i in 1...7 {
            var dateComponents = DateComponents()
            dateComponents.hour = 14
            dateComponents.minute = 57
            // sunday = 1 ... saturday = 7
            dateComponents.weekday = i
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
        
        print("scheduleLocal succesful")
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "comingback", title: "I'm coming back!", options: .foreground)
        
        let category = UNNotificationCategory(identifier: "weeklyAlarm", actions: [show], intentIdentifiers: [])
        
        center.setNotificationCategories([category])
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
                    
                    let ac = UIAlertController(title: "Welcome", message: "Welcome back!", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "Ok", style: .default) { action in
                        self.scheduleLocal()
                    }
                    
                    ac.addAction(okAction)
                    
                    present(ac, animated: true)
                case "comingback":
                    print("Coming back")
                    let ac = UIAlertController(title: "Welcome", message: "Welcome back!", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "Ok", style: .default) { action in
                        self.scheduleLocal()
                    }
                    
                    ac.addAction(okAction)
                    
                    present(ac, animated: true)
                default:
                    break
            }
        }
        completionHandler()
        
    }
        
}

