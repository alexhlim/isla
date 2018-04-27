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

// to use contains method
extension Word: Equatable {
    static func == (lhs: Word, rhs: Word) -> Bool {
        return
            lhs.originalText == rhs.originalText &&
                lhs.translatedText == rhs.translatedText
    }
}
