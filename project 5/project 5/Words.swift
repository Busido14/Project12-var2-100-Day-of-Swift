//
//  Words.swift
//  project 5
//
//  Created by Артем Чжен on 21/04/23.
//

import UIKit

class Words: NSObject, Codable {
    var currentWord = String()
    var usedWords = [String]()
    
    init(currentWord: String, usedWords: [String]) {
        self.currentWord = currentWord
        self.usedWords = usedWords
    }
}
