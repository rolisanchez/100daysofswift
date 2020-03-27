//
//  ViewController.swift
//  Day82ViewChallenge
//
//  Created by Victor Rolando Sanchez Jara on 3/27/20.
//  Copyright © 2020 Victor Rolando Sanchez Jara. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var animatableView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func animateViewPressed(_ sender: Any) {
        animatableView.bounceOut(duration: 1.0)
    }
    
}
// Extend UIView so that it has a bounceOut(duration:) method that uses animation to scale its size down to 0.0001 over a specified number of seconds.

extension UIView {
    func bounceOut(duration: TimeInterval){
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
            self.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
            self.transform = .identity
        }) { completed in
            
        }

    }
}
