//
//  EditTextViewController.swift
//  isla
//
//  Created by Alexander Lim on 4/21/18.
//  Copyright © 2018 nyu.edu. All rights reserved.
//

import UIKit

class EditTextViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var editTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapOffKeyboard: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        //editTextView.delegate = self
//        editTextView.delegate = self as! UITextViewDelegate
        //let tapOnText: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.textFieldTapped))
        
        view.addGestureRecognizer(tapOffKeyboard)
        //editTextView.delegate = self
        //editTextView.superview?.addGestureRecognizer(tapOnText)
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if (segue.identifier == "doneEditText"){
            let mainVC = segue.destination as! MainViewController
            if (self.editTextView.text != nil){
                mainVC.currentText = self.editTextView.text
                //print(mainVC.objectText.text)
                //mainVC.objectText.text = self.editTextView.text
            }
            //mainVC.objectText.text = self.editTextView.text
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
  
    private func textViewDidBeginEditing(textView: UITextView!) {
        if (textView == self.editTextView){
            self.editTextView.text = ""
        }
    }
    
    @objc func textFieldTapped(){
        
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "doneEditText", sender: self)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
