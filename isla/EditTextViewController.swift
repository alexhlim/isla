//
//  EditTextViewController.swift
//  isla
//
//  Created by Alexander Lim on 4/21/18.
//  Copyright © 2018 nyu.edu. All rights reserved.
//

import UIKit

class EditTextViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var editTextView: UITextView!
    var mainVC: MainViewController!
    var currentWord = Word()
    var isOriginalText = false
    var isTranslatedText = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.editTextView.text = mainVC.objectText.text
        
        // gesture to exit keyboard
        let tapOffKeyboard: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tapOffKeyboard)
        
        editTextView.delegate = self
    }

    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
  
    
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        // determine which text is currently being edited
        if (self.isOriginalText == false && self.isTranslatedText == false){
            self.currentWord.originalText = self.editTextView.text
        }
        if (self.isOriginalText == true && self.isTranslatedText == false){
            self.currentWord.originalText = self.editTextView.text
        }
        if (self.isOriginalText == false && self.isTranslatedText == true){
            self.currentWord.translatedText = self.editTextView.text
        }
        self.mainVC.currentWord = self.currentWord
        self.mainVC.objectText.text = self.editTextView.text
        // since EditViewController is on top of MainViewController, needs to be dismissed
        self.dismiss(animated: true, completion: nil)
    }
    
    // cancel
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
