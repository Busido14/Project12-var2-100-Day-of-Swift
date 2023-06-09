//
//  ViewController.swift
//  project2
//
//  Created by Артем Чжен on 13/12/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    
    var countries = [String]()
    var score = 0
    var theBestResult = [TheBestResults]()
    var correctAnswer = 0
    var stepCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Score", style: .plain, target: self, action: #selector(scoreSum))
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        let defaults = UserDefaults.standard
        if let saveHighScore = defaults.object(forKey: "saveScore") as? Data {
            let jsonDecoder = JSONDecoder()
            do {
                theBestResult = try jsonDecoder.decode([TheBestResults].self, from: saveHighScore)
            } catch {
                print("Failed to load high score")
            }
        }
        
        if theBestResult.isEmpty {
            let highScore = TheBestResults(highestScore: 0)
            theBestResult.append(highScore)
        }
        
        askQuestion()
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)

        title = "\(countries[correctAnswer].uppercased()) you use attempt = \(stepCount)"
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String?
        stepCount += 1
        
        if sender.tag == correctAnswer {
            title = "Correct That’s the flag \(countries[correctAnswer])"
            score += 1
        }
        else {
            title = "Wrong!That’s the flag \(countries[sender.tag])"
            score -= 1
        }
        
        if stepCount == 4 {
            let highScore = theBestResult[0]
            if score > highScore.highestScore {
                highScore.highestScore = score
                save()
            }
            let ac = UIAlertController(title: "Game Over!", message: "This game: \(score) Highest: \(highScore.highestScore)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Quit", style: .default, handler: askQuestion))
            present(ac, animated: true)
            stepCount = 0
            score = 0
        } else {
            let ac = UIAlertController(title: title, message: "Your score is \(score)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
            present(ac, animated: true)
        }
    }
        @objc func scoreSum() {
            let scoreAlert = UIAlertController(title: "Score", message: nil, preferredStyle: .actionSheet)
            scoreAlert.addAction(UIAlertAction(title: "Your score \(score) points", style: .default, handler: nil))
            present(scoreAlert, animated: true)
        }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(theBestResult) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "savedScore")
        } else {
            print("Failed to save high score.")
        }
    }
}
