//
//  HomeViewController.swift
//  isla
//
//  Created by Alexander Lim on 4/21/18.
//  Copyright © 2018 nyu.edu. All rights reserved.
//

import UIKit

/**
 This is the MainViewController. It is the first view the user sees when the app is loaded. It contains two picker views, one for translating from, and the other for translating to. Once the user picks the two languages, they may swipe right to go to the MainViewController.
 */
class HomeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var fromPicker: UIPickerView!
    @IBOutlet weak var toPicker: UIPickerView!
    
    var fromLanguage = ""
    var fromLanguageIndex = 0
    var toLangauge = ""
    var toLanguageIndex = 0
    
    // Yandex API's languages + language codes
    let languages = ["English", "Arabic", "Chinese", "Czech", "Danish", "Dutch", "Finnish", "French", "German", "Greek", "Hebrew", "Hindi", "Hungarian", "Indonesian", "Italian", "Japanese", "Korean", "Norwegian", "Polish", "Portuguese", "Romanian", "Russian", "Slovakian", "Spanish",  "Thai", "Turkish"]
    
    let languageCodes = ["en", "ar", "zh", "cs", "da", "nl", "fi", "fr", "de", "el", "he", "hi", "hu", "id", "it", "ja", "ko", "no", "pl", "pt", "ro", "ru", "sk", "es", "th", "tr"]
    
    /**
     Sets up the MainViewController, specifically, the swiping gestures and picker delegate and data sources. Also, the default of this picker views is "From English, to French".
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // adding swipe left to segue to MainViewController
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeLeft))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        
        // Connect data:
        self.fromPicker.delegate = self
        self.fromPicker.dataSource = self
        
        self.toPicker.delegate = self
        self.toPicker.dataSource = self
        
        // set default value to from English to French
        fromLanguage = languages[0]
        toLangauge = languages[7]
        self.fromPicker.selectRow(0, inComponent: 0, animated: true)
        self.fromLanguageIndex = 0
        self.toPicker.selectRow(7, inComponent: 0, animated: true)
        self.toLanguageIndex = 7
    }
    
    /**
     Respond to swiping left: goes perform segue to MainViewController.
     */
    @objc func respondToSwipeLeft(gesture : UIGestureRecognizer) {
        self.performSegue(withIdentifier: "toMainVC", sender: self)
    }
    

    /**
     This is the first of the picker methods. It selects the number of components for the picker views.
     */
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    /**
     This picker method selects the number of rows of data for the picker views.
     */
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languages.count
    }
    
    /**
     This picker method is for the data to be return for the row and component (column) that's being passed in.
     */
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return languages[row]
    }
    
    /**
     This picker method capture the picker view selection.
     */
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case fromPicker:
            self.fromLanguage = languages[row]
            self.fromLanguageIndex = row
        case toPicker:
            self.toLangauge = languages[row]
            self.toLanguageIndex = row
        default:
            fromLanguage = languages[row]
            self.fromLanguageIndex = row
            toLangauge = languages[row]
            self.toLanguageIndex = row
        }
    }
    
    /**
     This prepares the segue and sends all the necessary information to the next view controller, MainViewController. It sends over the langauges along with their codes for the API calls.
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toMainVC")
        {
            // send relevant data to MainViewController
            let mainVC = segue.destination as! MainViewController
            mainVC.toLangauge = self.toLangauge
            mainVC.toLanguageIndex = self.toLanguageIndex
            mainVC.fromLanguage = self.fromLanguage
            mainVC.fromLanguageIndex = self.fromLanguageIndex
            mainVC.fromCode = languageCodes[languages.index(of: self.fromLanguage)!]
            mainVC.toCode = languageCodes[languages.index(of: self.toLangauge)!]
        }
    }
    
    /**
     This method is the unwind segue method that is used by the MainViewController. Unwinding segues is important as new view controllers are not created, so the ViewController stack stays limited to the number of main view controllers.
     */
    @IBAction func didUnwindFromMainVC (_ sender: UIStoryboardSegue){
        let mainVC = sender.source as? MainViewController
    }

    

}
