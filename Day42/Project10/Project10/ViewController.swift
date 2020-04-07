//
//  ViewController.swift
//  Project10
//
//  Created by Victor Rolando Sanchez Jara on 2/16/20.
//  Copyright © 2020 Victor Rolando Sanchez Jara. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UICollectionViewController {
    var people = [Person]()
    var unlockedApp = false {
        didSet {
            if unlockedApp {
                authenticateButton.isEnabled = false
                addNewPersonButton.isEnabled = true
                collectionView.isHidden = false
            } else {
                authenticateButton.isEnabled = true
                addNewPersonButton.isEnabled = false
                collectionView.isHidden = true
            }
        }
    }
    
    var addNewPersonButton: UIBarButtonItem!
    var authenticateButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        authenticateButton = UIBarButtonItem(title: "Authenticate", style: .plain, target: self, action: #selector(authenticate))
        navigationItem.rightBarButtonItem = authenticateButton

        addNewPersonButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
        addNewPersonButton.isEnabled = false
        navigationItem.leftBarButtonItem = addNewPersonButton
        collectionView.backgroundColor = .black
        collectionView.isHidden = true
        // This will tell us when the application will stop being active – i.e., when our app has been backgrounded or the user has switched to multitasking mode.
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(lockApp), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    // MARK: Functions
    @objc func addNewPerson() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        }
        present(picker, animated: true)
    }
    
    @objc func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [weak self] success, authenticationError in
                
                DispatchQueue.main.async {
                    if success {
                        self?.unlockedApp = true
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
            let ac = UIAlertController(title: "Biometry unavailable", message: "Your device is not configured for biometric authentication.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
    }
    
    @objc func lockApp(){
        unlockedApp = false
    }
    
    // MARK: Collection View
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            // we failed to get a PersonCell – bail out!
            fatalError("Unable to dequeue PersonCell.")
        }
        
        let person = people[indexPath.item]
        
        cell.name.text = person.name
        
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
//        cell.backgroundColor = .red
        // if we're still here it means we got a PersonCell, so we can return it
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.item
        let person = people[index]
        
        let ac = UIAlertController(title: "Choose action", message: nil, preferredStyle: .alert)
        let renameAction = UIAlertAction(title: "Rename person", style: .default) { (UIAlertAction) in
            self.renamePerson(person: person)
        }
        
        ac.addAction(renameAction)
        
        let deleteActon = UIAlertAction(title: "Delete person", style: .destructive) { (UIAlertAction) in
            self.deletePerson(personIndex: index)
        }
        
        ac.addAction(deleteActon)
        
        present(ac, animated: true)
    }
    
    func renamePerson(person: Person){
        let ac = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        ac.addAction(cancelAction)
        
        let renameAction = UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
            print("renameAction")
            guard let newName = ac?.textFields?[0].text else { return }
            person.name = newName
            
            self?.collectionView.reloadData()
        }
        ac.addAction(renameAction)
        
        self.present(ac, animated: true)
    }
    
    func deletePerson(personIndex: Int){
        people.remove(at: personIndex)
        self.collectionView.reloadData()
    }


}
// MARK: Image Picker Delegates

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        collectionView.reloadData()
        
        dismiss(animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
