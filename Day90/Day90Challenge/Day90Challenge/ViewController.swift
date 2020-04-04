//
//  ViewController.swift
//  Day90Challenge
//
//  Created by Victor Rolando Sanchez Jara on 4/4/20.
//  Copyright © 2020 Victor Rolando Sanchez Jara. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK: Properties
    @IBOutlet weak var memeImage: UIImageView!
    var selectedImage: UIImage!
    var topCaption: String!
    var bottomCaption: String!
    
    // MARK: Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Right bar button items
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareMeme))
        let addImage = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(getMemeImage))
        
        navigationItem.rightBarButtonItems = [addImage, shareButton]
        
        // Right bar button items
        let topTextButton = UIBarButtonItem(title: "Top", style: .plain, target: self, action: #selector(getTopText))
        let bottomTextButton = UIBarButtonItem(title: "Bottom", style: .plain, target: self, action: #selector(getBottomText))
        navigationItem.leftBarButtonItems = [topTextButton, bottomTextButton]
        
        // Set initial text on Image View
        setInitialText()
    }
    
    // MARK: Other Methods
    func setInitialText() {
        memeImage.backgroundColor = .white
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 24),
                .paragraphStyle: paragraphStyle
            ]
            
            let string = "Click on \"+\" to add a new image for your meme, and on \"Top\" and \"Bottom\" to add captions"
            let attributedString = NSAttributedString(string: string, attributes: attrs)
            
            attributedString.draw(with: CGRect(x: 16, y: 256, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)
   
        }
        memeImage.image = img
    }
    
    @objc func getMemeImage(){
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc func getTopText(){
        let ac = UIAlertController(title: "Enter top caption", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned ac] _ in
            let answer = ac.textFields![0]
            self.topCaption = answer.text!
            self.reRenderMeme()
        }
        
        ac.addAction(submitAction)
        
        present(ac, animated: true)
    }
    
    @objc func getBottomText(){
        let ac = UIAlertController(title: "Enter bottom caption", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned ac] _ in
            let answer = ac.textFields![0]
            self.bottomCaption = answer.text!
            self.reRenderMeme()
        }
        
        ac.addAction(submitAction)
        
        present(ac, animated: true)
    }
    
    func reRenderMeme(){
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 48),
                .foregroundColor: UIColor.white,
                .strokeColor: UIColor.black,
                .strokeWidth: -1,
                .paragraphStyle: paragraphStyle
            ]
            
            if let selectedImage = selectedImage {
                selectedImage.draw(at: CGPoint(x: 0, y: 0))
            }
            
            if let topCaption = topCaption {
                let topAttributedString = NSAttributedString(string: topCaption, attributes: attrs)
                
                topAttributedString.draw(with: CGRect(x: 32, y: 32, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)
            }
            if let bottomCaption = bottomCaption {
                let bottomAttributedString = NSAttributedString(string: bottomCaption, attributes: attrs)
                    bottomAttributedString.draw(with: CGRect(x: 32, y: 432, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)
            }
        }
        memeImage.image = img
    }
    
    @objc func shareMeme(){
        guard let image = memeImage.image?.jpegData(compressionQuality: 0.8) else {
            print("No image found")
            return
        }
        
        let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }

}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        selectedImage = image
        reRenderMeme()
        
        dismiss(animated: true)
    }
}
