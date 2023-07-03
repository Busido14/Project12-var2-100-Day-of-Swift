//
//  Picture.swift
//  New Project1
//
//  Created by Артем Чжен on 21/04/23.
//

import UIKit

class Picture: NSObject, Codable {
    
    var image = String()
    var views = Int()
    
    init(image: String, views: Int) {
        self.image = image
        self.views = views
    }
}
