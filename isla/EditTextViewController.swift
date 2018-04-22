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
    var currentText: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapOffKeyboard: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tapOffKeyboard)
        editTextView.delegate = self
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if (segue.identifier == "doneEditText"){
            segue.destination.dismiss(animated: true, completion: nil)
            //segue.destination.dismiss(animated: true, completion: nil)
            //navigationController?.viewControllers.remove(at: 1)
            let mainVC = segue.destination as! MainViewController
            if (self.editTextView.text != nil){
                mainVC.currentText = self.editTextView.text
            }
        }
    }
    
    @objc func dismissKeyboard() {
        self.editTextView.text = "tap to edit object name!"
        view.endEditing(true)
    }
  
    func textViewDidBeginEditing(_ textView: UITextView){
        if (textView == self.editTextView){
            self.editTextView.text = ""
        }
    }
    
    
    @IBAction func submitButtonPressed(_ sender: Any) {
//         self.dismiss(animated: true, completion: self.performSegue(withIdentifier: "doneEditText", sender: self))
        //self.dismiss(animated: true, completion: nil)
        self.performSegue(withIdentifier: "doneEditText", sender: self)
        //self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
