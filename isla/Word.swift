//
//  WordObject.swift
//  isla
//
//  Created by Alexander Lim on 4/25/18.
//  Copyright © 2018 nyu.edu. All rights reserved.
//

import Foundation

class Word {
    
    var originalText: String?
    var translatedText: String?
    
    init(originalText: String = "", translatedText: String = "") {
        self.originalText = originalText
        self.translatedText = translatedText
    }
    
}
