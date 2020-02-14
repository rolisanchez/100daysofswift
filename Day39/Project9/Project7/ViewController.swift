//
//  ViewController.swift
//  Project7
//
//  Created by Victor Rolando Sanchez Jara on 2/6/20.
//  Copyright © 2020 Victor Rolando Sanchez Jara. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var petitions = [Petition]()
    
    var filteredPetitions = [Petition]()
    
    var urlString: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(showCredits))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearchAlert))

//        let urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
//        let urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        
//        let urlString: String
//
//        if navigationController?.tabBarItem.tag == 0 {
//            // urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
//            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
//        } else {
//            // urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
//            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
//        }
        
//        if let url = URL(string: urlString) {
//            if let data = try? Data(contentsOf: url) {
//                parse(json: data)
//            } else {
//                showError()
//            }
//        } else {
//            showError()
//        }
        
        // Cleaner
        
//        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
////            guard let self = self else { return }
//            if let url = URL(string: urlString) {
//                if let data = try? Data(contentsOf: url) {
//                    self?.parse(json: data)
//                    return
//                }
//            }
//
//            self?.showError()
//        }
        
        if navigationController?.tabBarItem.tag == 0 {
            //            urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
            
        } else {
            //            urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        // GCD Selectors
        performSelector(inBackground: #selector(fetchJSON), with: nil)
    }

    @objc func fetchJSON() {
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
        
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
    }
    
    @objc func showCredits(){
        let ac = UIAlertController(title: "Credits", message: "The data from this app comes from WE ARE THE PEOPLE API from the White House", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        ac.addAction(okAction)
        present(ac, animated: true)
    }
    
    @objc func showSearchAlert(){
        let ac = UIAlertController(title: "Enter your search text", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] action in
            guard let searchText = ac?.textFields?[0].text else { return }
            self?.search(searchText)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)

    }
    
     func search(_ searchText: String){
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let lowercasedSearchText = searchText.lowercased()
            self?.filteredPetitions = [Petition]()
            guard let petitions = self?.petitions else {
                return
            }
            if searchText.isEmpty {
                self?.filteredPetitions = petitions
            } else {
                for petition in petitions {
                    let lowercasedTitle = petition.title.lowercased()
                    let lowercasedBody = petition.body.lowercased()
                    if lowercasedTitle.contains(lowercasedSearchText) || lowercasedBody.contains(lowercasedSearchText) {
                        self?.filteredPetitions.append(petition)
                    }
                }
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
        
    }
    
//    func parse(json: Data) {
//        let decoder = JSONDecoder()
//
//        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
//            petitions = jsonPetitions.results
//            filteredPetitions = petitions
//            DispatchQueue.main.async { [weak self] in
//                self?.tableView.reloadData()
//            }
//        }
//    }
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            filteredPetitions = petitions
//            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
            performSelector(onMainThread: #selector(reloadTableData), with: nil, waitUntilDone: false)
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }
    
    @objc func reloadTableData(){
        tableView.reloadData()
    }
    
//    func showError() {
//        DispatchQueue.main.async { [weak self] in
//            let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
//            ac.addAction(UIAlertAction(title: "OK", style: .default))
//            self?.present(ac, animated: true)
//        }
//    }
    
    @objc func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = filteredPetitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = filteredPetitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

