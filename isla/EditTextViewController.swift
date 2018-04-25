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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.editTextView.text = mainVC.objectText.text
        let tapOffKeyboard: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tapOffKeyboard)
        editTextView.delegate = self
    }

    
    @objc func dismissKeyboard() {
        self.editTextView.text = mainVC.objectText.text
        view.endEditing(true)
    }
  
//    func textViewDidBeginEditing(_ textView: UITextView){
//        if (textView.text == "point at object and press DETECT!"){
//            self.editTextView.text = ""
//        }
//    }
    
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        self.mainVC.objectText.text = editTextView.text
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
