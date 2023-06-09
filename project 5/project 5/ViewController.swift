//
//  ViewController.swift
//  project 5
//
//  Created by Артем Чжен on 26/12/22.
//

import UIKit

class ViewController: UITableViewController {
    
    var allWords = [String]()
    var usedWords = [String]()
    
    var words = [Words]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshGame))
        
        let defaults = UserDefaults.standard
        if let savedWords = defaults.object(forKey: "savedWords") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                words = try jsonDecoder.decode([Words].self, from: savedWords)
            } catch {
                print("Failed to upload previous words.")
            }
        }
        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            } else {
                allWords = ["silkworm"]
            }
        }
        
        startGame()
    }
    
    func startGame() {
        if words.isEmpty {
            title = allWords.randomElement()
            let wordList = Words(currentWord: title!, usedWords: [String]())
            words.append(wordList)
            save()
            tableView.reloadData()
        } else {
            title = words[0].currentWord
            usedWords = words[0].usedWords
        }
    }
    
    @objc func refreshGame() {
        title = allWords.randomElement()
        let wordList = Words(currentWord: title!, usedWords: [String]())
        usedWords.removeAll()
        words.append(wordList)
        save()
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()
        let errorTitle: String
        let errorMessage: String
        
        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    usedWords.insert(lowerAnswer, at: 0)
                    words[0].usedWords = usedWords
                    save()
                    // Adds new row from the top down automatically
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    return
                } else {
                    errorTitle = "Word not recognized"
                    errorMessage = "You can't just make them up, you know"
                    return showErrorMessage(errorTitle: errorTitle, errorMessage: errorMessage)
                }
            } else {
                errorTitle = "Word already used"
                errorMessage = "Be more original"
                return showErrorMessage(errorTitle: errorTitle, errorMessage: errorMessage)
            }
        } else {
            errorTitle = "Word not possible"
            errorMessage = "You can't spell that word from \(title!.lowercased())"
            return showErrorMessage(errorTitle: errorTitle, errorMessage: errorMessage)
        }
        
    }
    
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        return true
    }
    
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    func isReal(word: String) -> Bool {
        if (word.count < 3) || (word.lowercased() == title?.lowercased()) {
            return false
        }
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    func showErrorMessage(errorTitle: String, errorMessage: String) {
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(words) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "savedWords")
        } else {
            print("Failed to save words.")
        }
    }

}
