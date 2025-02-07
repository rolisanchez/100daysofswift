//
//  ViewController.swift
//  Project13
//
//  Created by Victor Rolando Sanchez Jara on 2/26/20.
//  Copyright © 2020 Victor Rolando Sanchez Jara. All rights reserved.
//

import UIKit
import CoreImage

class ViewController: UIViewController {

    // MARK: Properties
    // MARK: Storyboard
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var intensityLabel: UILabel!
    @IBOutlet weak var intensity: UISlider!
    @IBOutlet weak var radiusLabel: UILabel!
    @IBOutlet weak var radius: UISlider!
    @IBOutlet weak var scaleLabel: UILabel!
    @IBOutlet weak var scale: UISlider!
    @IBOutlet weak var changeFilterButton: UIButton!
    
    // MARK: Non-storyboard
    var currentImage: UIImage!
    var context: CIContext!
    var currentFilter: CIFilter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "YACIFP"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
        
        context = CIContext()
        currentFilter = CIFilter(name: "CISepiaTone")
        
        changeFilterButton.setTitle("CISepiaTone (Click to change)", for: .normal)
        
        setupSlidersForFilter()
    }
    
    func setupSlidersForFilter(){
        let inputKeys = currentFilter.inputKeys
        
        let containsIntensity = inputKeys.contains(kCIInputIntensityKey)
        intensityLabel.isHidden = !containsIntensity
        intensity.isHidden = !containsIntensity
        
        let containsRadius = inputKeys.contains(kCIInputRadiusKey)
        radiusLabel.isHidden = !containsRadius
        radius.isHidden = !containsRadius
        
        let containsScale = inputKeys.contains(kCIInputScaleKey)
        scaleLabel.isHidden = !containsScale
        scale.isHidden = !containsScale
    
    }

    // MARK: Storyboard Actions
    @IBAction func changeFilterPressed(_ sender: Any) {
        let ac = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    @IBAction func savePressed(_ sender: Any) {
        guard let image = imageView.image else {
            let ac = UIAlertController(title: "Save error", message: "You didn't choose any image!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @IBAction func intensityChanged(_ sender: Any) {
        applyProcessing()
    }
    
    @IBAction func radiusChanged(_ sender: Any) {
        applyProcessing()
    }
    
    @IBAction func scaleChanged(_ sender: Any) {
        applyProcessing()
    }
    
    // MARK: Non-storyboard methods - @objc
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        }
        present(picker, animated: true)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    // MARK: Other methods
    
    func applyProcessing() {
        guard let image = currentFilter.outputImage else { return }
        
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(radius.value * 200, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(scale.value * 10, forKey: kCIInputScaleKey) }
        if inputKeys.contains(kCIInputCenterKey) { currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey) }
                
        if let cgimg = context.createCGImage(image, from: image.extent) {
            let processedImage = UIImage(cgImage: cgimg)
            imageView.image = processedImage
            UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
                self.imageView.alpha = 1
            })
        }
    }
    
    func setFilter(action: UIAlertAction) {
        // safely read the alert action's title
        guard let actionTitle = action.title else { return }
        
        changeFilterButton.setTitle("\(actionTitle) (Click to change)", for: .normal)
        setupSlidersForFilter()
        
        currentFilter = CIFilter(name: actionTitle)
        
        // make sure we have a valid image before continuing!
        guard currentImage != nil else { return }
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)

        applyProcessing()
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        dismiss(animated: true)

        UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
            self.imageView.alpha = 0
        })

        currentImage = image
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        applyProcessing()
    }
}

