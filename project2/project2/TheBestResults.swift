//
//  Conties.swift
//  project2
//
//  Created by Артем Чжен on 21/04/23.
//

import UIKit

class TheBestResults: NSObject, Codable {
    var highestScore = Int()
    
    init(highestScore: Int) {
        self.highestScore = highestScore
    }
}
