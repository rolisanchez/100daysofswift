//
//  ViewController.swift
//  Day99Challenge
//
//  Created by Victor Rolando Sanchez Jara on 4/14/20.
//  Copyright © 2020 Victor Rolando Sanchez Jara. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK: Properties
    var activatedButtons = [UIButton]()
    let cardbackImage = UIImage(named: "cardback")
    var countriesCapitals = [String:String]()
    var mixedCountriesWithCapitals = [String]()
    let transitionOptions: UIView.AnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]
    
    var score = 0
    
    // MARK: Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Matching Capitals"
        loadCapitals()
        setupButtonsCards()
    }
    // MARK: Other Methods
    
    func loadCapitals() {
        let defaults = UserDefaults.standard
        // Try to load saved capitals
        if let savedCapitals = defaults.object(forKey: "CountriesCapitals") as? [String:String] {
            countriesCapitals = savedCapitals
            
            // Load only 6 Country/Capital pairs if user added their own
            var countryCount = 0
            for (country, capital) in countriesCapitals {
                mixedCountriesWithCapitals.append(country)
                mixedCountriesWithCapitals.append(capital)
                countryCount += 1
                if countryCount == 6 { break }
            }
            
            mixedCountriesWithCapitals.shuffle()
        }
        // If no capitals saved, load from text
        else {
            var loadedCountriesCapitals = [String:String]()
            if let initialCapitalsURL = Bundle.main.url(forResource: "initialWords", withExtension: "txt"), let fileContents = try? String(contentsOf: initialCapitalsURL) {
                let lines = fileContents.components(separatedBy: "\n")
                
                for line in lines {
                    let parts = line.components(separatedBy: ": ")
                    let country = parts[0]
                    let capital = parts[1]
                    loadedCountriesCapitals[country] = capital
                    mixedCountriesWithCapitals.append(country)
                    mixedCountriesWithCapitals.append(capital)
                }
            }
            mixedCountriesWithCapitals.shuffle()
            defaults.set(loadedCountriesCapitals, forKey: "CountriesCapitals")
            countriesCapitals = loadedCountriesCapitals
        }
    }
    
    func setupButtonsCards() {
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 5),
            buttonsView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -5),
            buttonsView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 30),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -30)
        ])
        
        // Set some values for the width and height of each button
        let width = 100
        let height = 150
        
        var titleIndex = 0
        // Create 12 buttons as a 4x3 grid
        for row in 0..<4 {
            for col in 0..<3 {
                // Create a new button and give it big font size
                let cardButton = UIButton(type: .custom)
                cardButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
                
                // Set button image
                cardButton.setImage(cardbackImage, for: .normal)
                // Give the button some temporary text so we can see it on-screen
                let buttonTitle = mixedCountriesWithCapitals[titleIndex]
                titleIndex += 1
                cardButton.setTitle(buttonTitle, for: .normal)
                
                // Calculate the frame of this button using its column and row
                let frame = CGRect(x: col * width + (col*30), y: row * height + (row*30), width: width, height: height)
                cardButton.frame = frame
                cardButton.backgroundColor = .lightGray
                // add it to the buttons view
                buttonsView.addSubview(cardButton)
             
                // and also to our letterButtons array
//                letterButtons.append(letterButton)
                cardButton.addTarget(self, action: #selector(cardTapped), for: .touchUpInside)
                
            }
        }
    }

    @objc func cardTapped(_ sender: UIButton) {
        
        if let index = activatedButtons.firstIndex(of: sender) {
            flipBackButton(sender)
            activatedButtons.remove(at: index)
        } else {
            flipButton(sender)
            activatedButtons.append(sender)
        }
        
        // If two are selected, check if matches.
        if activatedButtons.count == 2 {
            let button0 = activatedButtons[0]
            let button0Title = (button0.titleLabel?.text!)!
            let button1 = activatedButtons[1]
            let button1Title = (button1.titleLabel?.text!)!
            
            // If first button selected is a country
            if let capital = countriesCapitals[button0Title] {
                // Got it  right
                if capital == button1Title {
                    button0.isEnabled = false
                    button1.isEnabled = false
                    activatedButtons = [UIButton]()
                    // Also score up
                    score += 1
                }
                // Wrong
                else {
                    flipBackButton(button0)
                    flipBackButton(button1)
                    activatedButtons = [UIButton]()
                }
            }
            // Or if second button is a country
            else if let capital = countriesCapitals[button1Title] {
                // Got it  right
                if capital == button0Title {
                    button0.isEnabled = false
                    button1.isEnabled = false
                    activatedButtons = [UIButton]()
                    // Also score up
                    score += 1
                }
                // Wrong
                else {
                    flipBackButton(button0)
                    flipBackButton(button1)
                    activatedButtons = [UIButton]()
                }
            }
            // None is a country - Flip back!
            else {
                flipBackButton(button0)
                flipBackButton(button1)
                activatedButtons = [UIButton]()
            }
        }

        if score == 1 {
            let ac = UIAlertController(title: "Congratulations", message: "You won!! Congratulations", preferredStyle: .alert)
            ac.addAction(.init(title: "Ok", style: .default))
            self.present(ac, animated: true)
        }
        
    }
    
    func flipButton(_ button: UIButton){
        UIView.transition(with: button, duration: 1.0, options: transitionOptions, animations: {
            button.setImage(UIImage(), for: .normal)
        })
    }
    
    func flipBackButton(_ button: UIButton){
        UIView.transition(with: button, duration: 1.0, options: transitionOptions, animations: {
            button.setImage(self.cardbackImage, for: .normal)
        })

        
    }

}

