//
//  SelectionViewController.swift
//  Project30
//
//  Created by TwoStraws on 20/08/2016.
//  Copyright (c) 2016 TwoStraws. All rights reserved.
//

import UIKit

class SelectionViewController: UITableViewController {
    var items = [String]() // this is the array that will store the filenames to load
    var images = [UIImage]()
    // viewControllers: THIS SHOULDNT BE HERE AND IS USELESS. CREATES MEMORY THAT IS NOT USED
//    var viewControllers = [UIViewController]() // create a cache of the detail view controllers for faster loading
    var dirty = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Reactionist"
        
        tableView.rowHeight = 90
        tableView.separatorStyle = .none
        
        // load all the JPEGs into our array
        let fm = FileManager.default
        
        if let resourcePath = Bundle.main.resourcePath, let tempItems = try? fm.contentsOfDirectory(atPath: resourcePath) {
            for item in tempItems {
                if item.range(of: "Large") != nil {
                    items.append(item)
                }
            }
        }
        loadOrPrepareImages()
        // Alternative 1
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if dirty {
            // we've been marked as needing a counter reload, so reload the whole table
            tableView.reloadData()
        }
    }
    
    func loadOrPrepareImages(){
        for item in items {
            let savePath = getDocumentsDirectory().appendingPathComponent(item)
            
            // Check if image does not exist
            if let img = UIImage(contentsOfFile: savePath.path) {
                images.append(img)
            } else {
                print("Image does not exist yet")
                let imageRootName = item.replacingOccurrences(of: "Large", with: "Thumb")
                
                guard let path = Bundle.main.path(forResource: imageRootName, ofType: nil) else {
                    fatalError("Path not found")
                }
                guard let original = UIImage(contentsOfFile: path) else {
                    fatalError("UIImage not found")
                }
                
                // THIS WAS TOO LARGE
                //        let renderer = UIGraphicsImageRenderer(size: original.size)
                
                let renderRect = CGRect(origin: .zero, size: CGSize(width: 90, height: 90))
                let renderer = UIGraphicsImageRenderer(size: renderRect.size)
                let rounded = renderer.image { ctx in
                    ctx.cgContext.addEllipse(in: renderRect)
                    ctx.cgContext.clip()
                    
                    original.draw(in: renderRect)
                }
                
//                if let jpegData = rounded.jpegData(compressionQuality: 0.8) {
//                    try? jpegData.write(to: savePath)
//                }
                
                if let pngData = rounded.pngData(){
                    try? pngData.write(to: savePath)
                }
                
                images.append(rounded)
    //        let rounded = renderer.image { ctx in
    // TRY TO ADD THIS SHADOW FOR PERFORMANCE -> DOES NOT LOOK GOOD
    //            ctx.cgContext.setShadow(offset: CGSize.zero, blur: 200, color: UIColor.black.cgColor)
    //            ctx.cgContext.fillEllipse(in: CGRect(origin: CGPoint.zero, size: original.size))
    //            ctx.cgContext.setShadow(offset: CGSize.zero, blur: 0, color: nil)
    
    //            ctx.cgContext.addEllipse(in: CGRect(origin: CGPoint.zero, size: original.size))
    //            ctx.cgContext.clip()
    //
    //            original.draw(at: CGPoint.zero)
                //        }
            }
            
            tableView.reloadData()
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return images.count * 10
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        // Alternative 1: Dequeue instead of creating
        // Combine with viewdidload registering
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // Alternative2:
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        }
        
        // find the image for this cell, and load its thumbnail
        let currentImage = items[indexPath.row % items.count]
        let rounded = images[indexPath.row % items.count]

        cell.imageView?.image = rounded
        
        let renderRect = CGRect(origin: .zero, size: CGSize(width: 90, height: 90))

        // TRY TO REMOVE THIS SHADOW FOR PERFORMANCE?
        // give the images a nice shadow to make them look a bit more dramatic
//        cell.imageView?.layer.shadowColor = UIColor.black.cgColor
//        cell.imageView?.layer.shadowOpacity = 1
//        cell.imageView?.layer.shadowRadius = 10
//        cell.imageView?.layer.shadowOffset = CGSize.zero
        // Updated shadow code
        cell.imageView?.layer.shadowColor = UIColor.black.cgColor
        cell.imageView?.layer.shadowOpacity = 1
        cell.imageView?.layer.shadowRadius = 10
        cell.imageView?.layer.shadowOffset = CGSize.zero
        cell.imageView?.layer.shadowPath = UIBezierPath(ovalIn: renderRect).cgPath
        
        // each image stores how often it's been tapped
        let defaults = UserDefaults.standard
        cell.textLabel?.text = "\(defaults.integer(forKey: currentImage))"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ImageViewController()
        vc.image = items[indexPath.row % items.count]
        vc.owner = self
        
        // mark us as not needing a counter reload when we return
        dirty = false
        
        // viewControllers THIS SHOULDNT BE HERE AND IS USELESS. CREATES MEMORY THAT IS NOT USED
        // add to our view controller cache and show
//        viewControllers.append(vc)
        if let navigationController = navigationController {
            navigationController.pushViewController(vc, animated: true)
        }
        
    }
}
