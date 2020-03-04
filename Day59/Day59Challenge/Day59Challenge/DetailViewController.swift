//
//  DetailViewController.swift
//  Day59Challenge
//
//  Created by Victor Rolando Sanchez Jara on 3/4/20.
//  Copyright © 2020 Victor Rolando Sanchez Jara. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    // MARK: Properties
    var country: Country!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var capitalLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var populationLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    
    // MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "\(country.name)"
        
        setupView()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
    }
    
    // MARK: Functions
    func setupView() {
        print("Country \(country)")
        
        nameLabel.text = "Name: \(country.name)"
        capitalLabel.text = "Capital: \(country.capital)"
        sizeLabel.text = "Size: \(country.size) km^2"
        populationLabel.text = "Population: \(country.population)"
        currencyLabel.text = "Currency: \(country.currency)"
        languageLabel.text = "Language: \(country.mainLanguage)"
    }
    
    @objc func shareTapped() {
        let countryDescription =
        """
        \(country.name) sounds very interesting! Its capital is \(country.capital). It's size is \(country.size) squared kilometers.
        Their population is \(country.population). The currency they use is \(country.currency). Their main language is \(country.mainLanguage)
        """
        
        let vc = UIActivityViewController(activityItems: [countryDescription], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }


}
