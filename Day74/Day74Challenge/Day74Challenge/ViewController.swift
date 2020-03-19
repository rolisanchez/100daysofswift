//
//  ViewController.swift
//  Day74Challenge
//
//  Created by Victor Rolando Sanchez Jara on 3/19/20.
//  Copyright © 2020 Victor Rolando Sanchez Jara. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    // MARK: Properties
    let reuseIdentifier = "NoteCell"
    var notes = [Note]()
    
    // MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Notes"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        navigationItem.rightBarButtonItems = [addButton]
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadNotes()
    }
    // MARK: Functions
    func loadNotes(){
        let defaults = UserDefaults.standard
        if let savedNotes = defaults.object(forKey: "SavedNotes") as? Data {
            let decoder = JSONDecoder()
            if let loadedNotes = try? decoder.decode(Notes.self, from: savedNotes) {
                notes = loadedNotes.notes
                tableView.reloadData()
            }
        }
    }
    
    @objc func addNote(){
        notes.append(Note(content: ""))
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.note = notes[notes.count-1]
            vc.notes = notes
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}

// MARK: Table View Data Source and Delegate
extension ViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        let note = notes[indexPath.row]
        cell.textLabel?.text = note.content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.note = notes[indexPath.row]
            vc.notes = notes
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

