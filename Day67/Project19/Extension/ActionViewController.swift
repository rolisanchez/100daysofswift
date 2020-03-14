//
//  ActionViewController.swift
//  Extension
//
//  Created by Victor Rolando Sanchez Jara on 3/12/20.
//  Copyright © 2020 Victor Rolando Sanchez Jara. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var script: UITextView!
    
    var pageTitle = ""
    var pageURL = ""
    var customScript = ""
    
    // MARK: Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        let chooseScriptButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(chooseScript))
        
        navigationItem.rightBarButtonItems = [doneButton, chooseScriptButton]
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first {
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in
                    guard let itemDictionary = dict as? NSDictionary else { return }
                    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                    self?.pageURL = javaScriptValues["URL"] as? String ?? ""
                    
                    let defaults = UserDefaults.standard
                    
                    if let stringURL = self?.pageURL {
                        let url = URL(string: stringURL)
                        defaults.set(url?.host, forKey: "URL")
                    }

                    print("Defaults URL ", defaults.string(forKey: "URL"))
                    
                    DispatchQueue.main.async { // self is already weak from above
                        self?.title = self?.pageTitle
                    }
                }
            }
        }
    }
    
    // MARK: Other Methods
    @IBAction func chooseScript() {
        let script1 = UIAlertAction(title: "Show title on alert", style: .default) { [weak self] action in
            self?.doneWithChosenScript(chosenScript: "alert(document.title);")
        }
        let script2 = UIAlertAction(title: "Show URL on alert", style: .default) { [weak self] action in
            self?.doneWithChosenScript(chosenScript: "alert(document.URL);")
        }
        let script3 = UIAlertAction(title: "Greet user", style: .default) { [weak self] action in
            self?.doneWithChosenScript(chosenScript: "alert(\"HELLO USER\");")
        }
        let script4 = UIAlertAction(title: "Choose past script", style: .default) { [weak self] action in
            if let vc = self?.storyboard?.instantiateViewController(withIdentifier: "ScriptsTable") as? ScriptsTableViewController {
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        let ac = UIAlertController(title: "Choose Script", message: "Choose a Predefined script from the list", preferredStyle: .actionSheet)
        ac.addAction(script1)
        ac.addAction(script2)
        ac.addAction(script3)
        ac.addAction(script4)
        ac.addAction(cancel)
        
        present(ac, animated: true)
    }
    
    func doneWithChosenScript(chosenScript: String){
        let item = NSExtensionItem()
        // Example: alert(document.title);
        let argument: NSDictionary = ["customJavaScript": chosenScript]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]
        
        extensionContext?.completeRequest(returningItems: [item])
    }
    
    @IBAction func done() {
        let ac = UIAlertController(title: "Do you want to save your script?", message: "Give it a name and save it for later :)", preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Yes! Save this name", style: .default) { [weak self, unowned ac] _ in
            if let answer = ac.textFields![0].text {
                let defaults = UserDefaults.standard
                var urlDict = defaults.object(forKey: "URLDict") as? [String: String] ?? [String: String]()
                urlDict[answer] = self?.script.text
                defaults.set(urlDict, forKey: "URLDict")
                
                let item = NSExtensionItem()
                let argument: NSDictionary = ["customJavaScript": self?.script.text]
                let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
                let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
                item.attachments = [customJavaScript]
                
                self?.extensionContext?.completeRequest(returningItems: [item])
            } else {
                let acError = UIAlertController(title: "The name you entered was empty", message: "Give it a name and save it for later :)", preferredStyle: .actionSheet)
                let okAction = UIAlertAction(title: "Oops", style: .cancel)
                acError.addAction(okAction)
                
                self?.present(acError, animated: true)

            }
            
        }
        
        ac.addAction(submitAction)
        
        let noThanks = UIAlertAction(title: "No thanks", style: .cancel) { [weak self] action in
            let item = NSExtensionItem()
            // Example: alert(document.title);
            let argument: NSDictionary = ["customJavaScript": self?.script.text]
            let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
            let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
            item.attachments = [customJavaScript]
            
            self?.extensionContext?.completeRequest(returningItems: [item])
        }
        ac.addAction(noThanks)
        
        present(ac, animated: true)
        
        
        
        
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            script.contentInset = .zero
        } else {
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        script.scrollIndicatorInsets = script.contentInset
        
        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
    }

}


