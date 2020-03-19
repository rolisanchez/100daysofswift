//
//  DetailViewController.swift
//  Day74Challenge
//
//  Created by Victor Rolando Sanchez Jara on 3/19/20.
//  Copyright © 2020 Victor Rolando Sanchez Jara. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    // MARK: Properties
    var notes: [Note]!
    var note: Note!
    
    @IBOutlet weak var textView: UITextView!
    
    // MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        
        textView.text = note.content
        
        let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteNote))
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareNote))
        navigationItem.rightBarButtonItems = [shareButton, deleteButton]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let index = notes.firstIndex { $0.id == note.id }!

        if textView.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            notes.remove(at: index)
        } else {
            note.content = textView.text
            notes[index] = note
        }
        saveNotes()
    }
    
    func saveNotes(){
        let notesToEncode = Notes(notes: notes)
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(notesToEncode) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "SavedNotes")
        }
    }
    
    // MARK: Functions
    @objc func shareNote(){
            
        let vc = UIActivityViewController(activityItems: [note.content], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    @objc func deleteNote(){
        textView.text = ""
        navigationController?.popViewController(animated: true)
    }
}
