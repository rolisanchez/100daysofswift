//
//  DetailViewController.swift
//  Day23
//
//  Created by Victor Rolando Sanchez Jara on 1/27/20.
//  Copyright © 2020 Victor Rolando Sanchez Jara. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var selectedImage: String?
    var flagImage: UIImage?
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        
        if let imageToLoad = selectedImage {
            title = "Flag of \(imageToLoad.uppercased())"
            flagImage = UIImage(named: imageToLoad)
            imageView.image = flagImage
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))

    }
    
    @objc func shareTapped() {
        guard let image = flagImage?.jpegData(compressionQuality: 0.8) else {
            print("No image found")
            return
        }
        
        let vc = UIActivityViewController(activityItems: [image, selectedImage], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
}
