//
//  ViewController.swift
//  Day59Challenge
//
//  Created by Victor Rolando Sanchez Jara on 3/4/20.
//  Copyright © 2020 Victor Rolando Sanchez Jara. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    // MARK: Properties
    var countries = [Country]()
    
    // MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Countries of the World"
        loadCountries()
    }

    // MARK: Functions
    func loadCountries(){
        guard let countriesFileURL = Bundle.main.url(forResource: "countries", withExtension: "json") else {
            print("No countries file")
            return
        }
        guard let data = try? Data(contentsOf: countriesFileURL) else {
            print("No data in URL")
            return
        }
        
        parse(json: data)
    }

    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonCountries = try? decoder.decode(Countries.self, from: json) {
            countries = jsonCountries.countries            
        }
    }
}

// MARK: Table View Data Source and Delegate
extension ViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let country = countries[indexPath.row]
        cell.textLabel?.text = country.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.country = countries[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}
