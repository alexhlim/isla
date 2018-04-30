//
//  WordObject.swift
//  isla
//
//  Created by Alexander Lim on 4/25/18.
//  Copyright © 2018 nyu.edu. All rights reserved.
//

import Foundation

/**
 This is a custom object that is intended to hold two Strings: the original text and the translated text. It is used primarily so that favorited words can be displayed in the dictionary.
 */
class Word {
    
    var originalText: String?
    var translatedText: String?
    
    init(originalText: String = "", translatedText: String = "") {
        self.originalText = originalText
        self.translatedText = translatedText
    }
    
}

/**
 This Equatable function is necessary when we want to compare Word objects against each other. Also, it allows us to use the contains() method for our array of Word objects.
 */
extension Word: Equatable {
    static func == (lhs: Word, rhs: Word) -> Bool {
        print("Original Text: " + "LHS: " + lhs.originalText! + "RHS: " + rhs.originalText!)
        print("Translated Text: " + "LHS: " + lhs.translatedText! + "RHS: " + rhs.translatedText!)
        return
            lhs.originalText == rhs.originalText &&
                lhs.translatedText == rhs.translatedText
    }
}

