//
//  ViewController.swift
//  Day50
//
//  Created by Victor Rolando Sanchez Jara on 2/24/20.
//  Copyright © 2020 Victor Rolando Sanchez Jara. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    // MARK: Properties
    var images = [Image]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Image Manager"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewImage))
        
        let defaults = UserDefaults.standard
        
        if let savedImages = defaults.object(forKey: "images") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                images = try jsonDecoder.decode([Image].self, from: savedImages)
                tableView.reloadData()
            } catch {
                print("Failed to load people")
            }
        }
    }
    
    // MARK: Functions
    @objc func addNewImage(){
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        }
        present(picker, animated: true)
    }
    
    // Save to User Defaults
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(images) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "images")
        } else {
            print("Failed to save images.")
        }
    }
    
    // MARK: UITableView Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Image", for: indexPath)
        let image = images[indexPath.row]
        cell.textLabel?.text = image.fileName
        cell.detailTextLabel?.text = image.caption
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            let image = images[indexPath.row]
            vc.image = image
            navigationController?.pushViewController(vc, animated: true)
        }
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
        
        var newImage = Image(fileName: imageName, caption: "")
        
        dismiss(animated: true) {
            let ac = UIAlertController(title: "Enter caption", message: nil, preferredStyle: .alert)
            ac.addTextField()
            
            let submitAction = UIAlertAction(title: "Ok", style: .default) { [weak self, weak ac] action in
                // Need to capture newImage strongly, otherwise it gets deallocated
                guard let caption = ac?.textFields?[0].text else { return }
                newImage.caption = caption
                self?.images.append(newImage)
                self?.tableView.reloadData()
                self?.save()
            }
            
            ac.addAction(submitAction)
            self.present(ac, animated: true)
        }
//        dismiss(animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
}
