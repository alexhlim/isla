//
//  HomeViewController.swift
//  isla
//
//  Created by Alexander Lim on 4/21/18.
//  Copyright © 2018 nyu.edu. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //variables
    @IBOutlet weak var fromPicker: UIPickerView!
    @IBOutlet weak var toPicker: UIPickerView!
    var languages: [String] = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeLeft))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        
        // Connect data:
        self.fromPicker.delegate = self
        self.fromPicker.dataSource = self
        
        self.toPicker.delegate = self
        self.toPicker.dataSource = self
        
        //populatepicker
        languages = ["English", "Albanian", "Amharic", "Arabic", "Bengali", "Bulgarian", "Bosnian", "Chinese", "Croatian", "Czech", "Danish", "Dutch", "Finnish", "French", "German", "Greek", "Haitian (Creole)", "Hebrew", "Hindi", "Hungarian", "Icelandic", "Indonesian", "Irish", "Italian", "Japanese", "Korean", "Laotian", "Latin", "Latvian", "Lithuanian", "Luxembourgish", "Malay", "Malayalam", "Maltese", "Mongolian", "Nepali", "Norwegian", "Punjabi", "Persian", "Polish", "Portuguese", "Romanian", "Russian", "Scottish", "Serbian", "Slovakian", "Slovenian", "Spanish", "Swahili", "Thai", "Turkish", "Ukrainian", "Vietnamese", "Welsh", "Yiddish"];
        
    
    }
    
    @objc func respondToSwipeLeft(gesture : UIGestureRecognizer) {
        self.performSegue(withIdentifier: "toMainScreen", sender: self)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //picker methods!
    
    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languages.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return languages[row]
    }
    
    

}
