//
//  ViewController.swift
//  Day41
//
//  Created by Victor Rolando Sanchez Jara on 2/15/20.
//  Copyright © 2020 Victor Rolando Sanchez Jara. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var levellLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var enteredLetters: UILabel!
    @IBOutlet weak var guessWordLabel: UILabel!
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var level = 1
    var currentWord: String?
    var levelWords = [String]()
    var usedLetters = [Character]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        performSelector(inBackground: #selector(loadLevel), with: nil)
    }
    
    @objc func loadLevel() {
        if let levelFileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {
            if let levelContents = try? String(contentsOf: levelFileURL) {
                var lines = levelContents.components(separatedBy: "\n")
                lines.shuffle()
                
                for word in lines {
                    if !word.isEmpty {
                        levelWords.append(word)
                    }
                    
                }
            }
        } else {
            print("File not found")
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.levellLabel.text = "Level: \(self.level)"
        }
        
        setNewWord()
    }
    
    func setNewWord(){
        guard let word = levelWords.popLast() else { return }
        currentWord = word
        usedLetters = [Character]()
        
        let promptWord = String.init(repeating: "?", count: word.count)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.guessWordLabel.text = promptWord
            self.enteredLetters.text = "Entered Letters:"
        }
        
        print ("word is \(word)")
        
        
    }
    @IBAction func enterLetterTapped(_ sender: Any) {
        let ac = UIAlertController(title: "Enter a LETTER", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] action in
            guard let searchText = ac?.textFields?[0].text else { return }
            self?.checkLetter(searchText)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func checkLetter(_ searchText: String){
        if searchText.count != 1 {
            let ac = UIAlertController(title: "Instructions", message: "Please enter a LETTER", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            return
        }
        
        guard let word = currentWord else { return }
        let char = Character(searchText.uppercased())
        if !usedLetters.contains(char){
            usedLetters.append(char)
        }
        
        
        var promptWord = ""
        for character in word {
            let strLetter = String(character)
            if usedLetters.contains(character) {
                promptWord += strLetter
            } else {
                promptWord += "?"
            }
        }
        
        guessWordLabel.text = promptWord
        enteredLetters.text = "Entered Letters: \(usedLetters)"
        
        if !promptWord.contains("?") {
            let ac = UIAlertController(title: "Nice", message: "You guessed the word \(word)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            score += 1
            
            if levelWords.isEmpty {
                level += 1
                loadLevel()
            } else {
                setNewWord()
            }
        }
    }
    
}

