//
//  ViewController.swift
//  Project28
//
//  Created by Victor Rolando Sanchez Jara on 4/6/20.
//  Copyright © 2020 Victor Rolando Sanchez Jara. All rights reserved.
//

import LocalAuthentication
import UIKit

class ViewController: UIViewController {
    // MARK: Properties
    @IBOutlet weak var secret: UITextView!
    
    // MARK: Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Nothing to see here"

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(saveSecretMessage))
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        // This will tell us when the application will stop being active – i.e., when our app has been backgrounded or the user has switched to multitasking mode.
        notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)

    }
    
    // MARK: IBActions
    @IBAction func authenticateTapped(_ sender: Any) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [weak self] success, authenticationError in
                
                DispatchQueue.main.async {
                    if success {
                        self?.unlockSecretMessage()
                    } else {
                        // Error
                        let ac = UIAlertController(title: "Authentication failed", message: "You could not be verified; please try again.", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self?.present(ac, animated: true)
                    }
                }
            }
        } else {
            // No biometry
//            let ac = UIAlertController(title: "Biometry unavailable", message: "Your device is not configured for biometric authentication.", preferredStyle: .alert)
//            ac.addAction(UIAlertAction(title: "OK", style: .default))
//            self.present(ac, animated: true)
            // Using Password
            if let password = KeychainWrapper.standard.string(forKey: "Password") {
                let ac = UIAlertController(title: "Enter your password", message: nil, preferredStyle: .alert)
                ac.addTextField()
                
                ac.addAction(UIAlertAction(title: "Cancel", style: .default))
                
                let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned ac] _ in
                    let answer = ac.textFields![0]
                    
                    if answer.text! == password {
                        self.unlockSecretMessage()
                    } else {
                        let ac = UIAlertController(title: "Wrong password", message: "You entered the wrong password. Try again.", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(ac, animated: true)
                    }
                }
                
                ac.addAction(submitAction)
                self.present(ac, animated: true)
            } else {
                // Prompt to add a new Password
                let ac = UIAlertController(title: "Add a new password", message: "You haven't setup a password yet.", preferredStyle: .alert)
                ac.addTextField()
                
                ac.addAction(UIAlertAction(title: "Cancel", style: .default))
                
                let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned ac] _ in
                    let answer = ac.textFields![0]
                    KeychainWrapper.standard.set(answer.text!, forKey: "Password")
                }
                
                ac.addAction(submitAction)
                self.present(ac, animated: true)
            }
        }
        
    }
    
    // MARK: Other Methods
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            secret.contentInset = .zero
        } else {
            secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        secret.scrollIndicatorInsets = secret.contentInset
        
        let selectedRange = secret.selectedRange
        secret.scrollRangeToVisible(selectedRange)
    }
    
    func unlockSecretMessage() {
        secret.isHidden = false
        title = "Secret stuff!"
        
        if let text = KeychainWrapper.standard.string(forKey: "SecretMessage") {
            secret.text = text
        }
        // Alternative with nil coalescing
//        secret.text = KeychainWrapper.standard.string(forKey: "SecretMessage") ?? ""
    }
    
    @objc func saveSecretMessage() {
        guard secret.isHidden == false else { return }
        
        KeychainWrapper.standard.set(secret.text, forKey: "SecretMessage")
        secret.resignFirstResponder()
        secret.isHidden = true
        title = "Nothing to see here"
    }
    
}

