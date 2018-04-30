//
//  DictionaryViewController.swift
//  isla
//
//  Created by Alexander Lim on 4/21/18.
//  Copyright © 2018 nyu.edu. All rights reserved.
//

import UIKit
import AVFoundation

/**
 This is the DictionaryViewController. It is used to hold Word objects and display them using a UITableView. Also, this view controller allows the user to tap on each cell to learn how to pronounce any word.
 */
class DictionaryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DictionaryCellDelegate {
    
    @IBOutlet weak var table: UITableView!
    var savedWords = [Word]()
    var fromLanguageIndex = 0
    var toLanguageIndex = 0
    var currentCell = DictionaryCell()
    // language codes for AVFoundation
    let speechLanguages = ["en-US","ar-SA","zh-CN", "cs-CZ", "da-DK", "nl-NL", "fi-FI", "fr-FR", "de-DE", "el-GR", "he-IL", "hi-IN", "hu-HU", "id-ID", "it-IT", "ja-JP", "ko-KR", "no-NO", "pl-PL", "pt-BR", "ro-RO", "ru-RU", "sk-SK", "es-ES", "th-TH", "tr-TR"]
    
    /**
     This is the first of the table view methods. It tells the table view how many cells should be displayed.
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedWords.count
    }
    
    /**
     This table view method creates and populates cell in the table view.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DictionaryCell") as! DictionaryCell
        cell.translateFromText.text = savedWords[indexPath.row].originalText
        cell.translateToText.text = savedWords[indexPath.row].translatedText
        cell.delegate = self
        return cell
    }
    
    
    /**
     This function is used to add swipe to delete feature for our table view.
     */
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.savedWords.remove(at: indexPath.row)
            self.table.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    /**
     Loads the DictionaryViewController. Sets up the swiping gestures for segues, and sets up the table view.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        // swipe right to go to HomeViewController
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeRight))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        table.delegate = self
        table.dataSource = self
    }
    
    /**
     Sets up for segue unwind back to MainViewController. It sends back the list of the saved Word objects.
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "unwindFromDictVC"){
            let mainVC = segue.destination as! MainViewController
            mainVC.savedWords = self.savedWords
        }
    }
    
    /**
     Swipe right to perform unwind segue back to MainViewController.
     */
    @objc func respondToSwipeRight(gesture : UIGestureRecognizer) {
        self.performSegue(withIdentifier: "unwindFromDictVC", sender: self)
    }
    
    /**
     This function is used for text to speech for the left hand of the cell (original text). It chooses the language based on the picker view in the HomeViewController.
     */
    func didPressTranslateFrom(fromWord: String) {
        let voice = AVSpeechSynthesisVoice(language: speechLanguages[self.fromLanguageIndex])
        let toSay = AVSpeechUtterance(string: fromWord)
        toSay.voice = voice

        let getReady = AVSpeechSynthesizer()
        getReady.speak(toSay)
    }
    
     /**
     This function is used for text to speech for the right hand of the cell (translated text). It chooses the language based on the picker view in the HomeViewController.
     */
    func didPressTranslateTo(toWord: String) {
        let voice = AVSpeechSynthesisVoice(language: speechLanguages[self.toLanguageIndex])
        let toSay = AVSpeechUtterance(string: toWord)
        toSay.voice = voice
        
        let getReady = AVSpeechSynthesizer()
        getReady.speak(toSay)
    }
    

}
