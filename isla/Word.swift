//
//  WordObject.swift
//  isla
//
//  Created by Alexander Lim on 4/25/18.
//  Copyright © 2018 nyu.edu. All rights reserved.
//

import Foundation

// Custom object that is intended to hold two Strings: the original text and the translated text
class Word {
    
    var originalText: String?
    var translatedText: String?
    
    init(originalText: String = "", translatedText: String = "") {
        self.originalText = originalText
        self.translatedText = translatedText
    }
    
}

// need equtable to use contains method
extension Word: Equatable {
    static func == (lhs: Word, rhs: Word) -> Bool {
        print("Original Text: " + "LHS: " + lhs.originalText! + "RHS: " + rhs.originalText!)
        print("Translated Text: " + "LHS: " + lhs.translatedText! + "RHS: " + rhs.translatedText!)
        return
            lhs.originalText == rhs.originalText &&
                lhs.translatedText == rhs.translatedText
    }
}

