//
//  EditTextViewController.swift
//  isla
//
//  Created by Alexander Lim on 4/21/18.
//  Copyright © 2018 nyu.edu. All rights reserved.
//

import UIKit

/**
 This class is for the EditViewController. It is a view controller that is stacked on top of the MainViewController when the edit button is pressed. Users are able to edit any text and send it back over to be displayed in the MainViewController.
 */
class EditTextViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var editTextView: UITextView!
    var mainVC: MainViewController!
    var currentWord = Word()
    var isOriginalText = false
    var isTranslatedText = false
    
    /**
     Sets of the view controller. It syncs the current labels with the current MainViewController and enables taps for editing.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.editTextView.text = mainVC.objectText.text
        
        // gesture to exit keyboard
        let tapOffKeyboard: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tapOffKeyboard)
        
        editTextView.delegate = self
    }

    /**
     Dismisses keyboard when user taps away from it.
    */
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
  
    
    /**
     For the submit button. Considers three cases to decide where in the Word object the text should be stored. Once it finishes, it dismisses itself (because the view controller was on top of MainViewController).
     */
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
    
    /**
     For the cancel button. Dismisses the view controller when user taps it.
    */
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
