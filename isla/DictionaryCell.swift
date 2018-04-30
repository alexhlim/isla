//
//  DictionaryCell.swift
//  isla
//
//  Created by Alexander Lim on 4/28/18.
//  Copyright © 2018 nyu.edu. All rights reserved.
//

import Foundation
import UIKit

/**
 Delegate for the Dictionary Cell. It is needed so that the cell can communicate with the DictionaryViewController and perform an action when the Dictionary Cell is tapped.
 */
protocol DictionaryCellDelegate{
    func didPressTranslateFrom(fromWord: String)
    func didPressTranslateTo(toWord: String)
}

/**
 This is a custom UITableViewCell class for DictionaryViewController. It contains two labels, for the original and translated text, as well as two buttons for Siri to perform text to speech.
 */
class DictionaryCell: UITableViewCell{
    
    @IBOutlet weak var translateFromText: UILabel!
    @IBOutlet weak var translateToText: UILabel!
    var delegate: DictionaryCellDelegate?
    
    /**
     Make Siri say the original word.
     */
    @IBAction func pressedTranslateFrom(_ sender: Any) {
        self.delegate?.didPressTranslateFrom(fromWord: translateFromText.text!)
    }
    
    /**
     Make Siri say the translated word.
     */
    @IBAction func pressedTranslateTo(_ sender: Any) {
        self.delegate?.didPressTranslateTo(toWord: translateToText.text!)
    }
    
}
