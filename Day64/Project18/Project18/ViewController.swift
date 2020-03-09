//
//  ViewController.swift
//  Project18
//
//  Created by Victor Rolando Sanchez Jara on 3/9/20.
//  Copyright © 2020 Victor Rolando Sanchez Jara. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Print
        print("I'm inside the viewDidLoad() method!")
        print(1, 2, 3, 4, 5)
        print(1, 2, 3, 4, 5, separator: "-")
        print("Some message", terminator: "")
        print("After terminator")
        
        // Assertions
        assert(1 == 1, "Maths failure!")
//        assert(1 == 2, "Maths failure!") // Force crash
        // We can even run a very slow method, it will only be run in debug mode
//        assert(myReallySlowMethod() == true, "The slow method returned false, which is a bad thing!")

        // Breakpoints
        for i in 1 ... 100 {
            print("Got number \(i)")
        }
        
        // LLDB: p i (prints i value)
        // Edit breakpoint: i % 10 == 0 -> Trigger breakpoint when i equals 10
        
        // View Debugging
    }


}

