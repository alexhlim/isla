//
//  DictionaryCell.swift
//  isla
//
//  Created by Alexander Lim on 4/28/18.
//  Copyright © 2018 nyu.edu. All rights reserved.
//

import Foundation
import UIKit

// delegate for using text to speech
protocol DictionaryCellDelegate{
    func didPressTranslateFrom(fromWord: String)
    func didPressTranslateTo(toWord: String)
}

// this is a custom UITableViewCell class for the DictionaryViewController
class DictionaryCell: UITableViewCell{
    
    @IBOutlet weak var translateFromText: UILabel!
    @IBOutlet weak var translateToText: UILabel!
    var delegate: DictionaryCellDelegate?
    
    // say original word
    @IBAction func pressedTranslateFrom(_ sender: Any) {
        self.delegate?.didPressTranslateFrom(fromWord: translateFromText.text!)
    }
    
    // say translated word
    @IBAction func pressedTranslateTo(_ sender: Any) {
        self.delegate?.didPressTranslateTo(toWord: translateToText.text!)
    }
    
}
