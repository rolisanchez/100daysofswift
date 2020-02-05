//
//  ViewController.swift
//  Day32Challenge
//
//  Created by Victor Rolando Sanchez Jara on 2/5/20.
//  Copyright © 2020 Victor Rolando Sanchez Jara. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var shoppingList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Shopping List"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(clearListPressed))

    }
    
    @objc func addItem() {
        let ac = UIAlertController(title: "Enter item name", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let saveItemAction = UIAlertAction(title: "Add", style: .default) { [weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.saveItem(answer)
        }
        
        ac.addAction(saveItemAction)
        present(ac, animated: true)
    }
    
    @objc func clearListPressed(){
        let ac = UIAlertController(title: "Are you sure you want to clear your list?", message: nil, preferredStyle: .alert)

        let okAction = UIAlertAction(title: "Yes", style: .default, handler: clearList)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        ac.addAction(okAction)
        ac.addAction(cancelAction)
        present(ac, animated: true)
    }
    
    func clearList(action: UIAlertAction! = nil){
        shoppingList = [String]()
        tableView.reloadData()
    }
    
    func saveItem(_ item: String) {
        shoppingList.insert(item, at: 0)
        
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }

    // MARK: TableView Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingItem", for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        return cell
    }
    
    // MARK: TableView Extra Sugar

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            shoppingList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

}

