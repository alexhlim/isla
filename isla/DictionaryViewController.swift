//
//  DictionaryViewController.swift
//  isla
//
//  Created by Alexander Lim on 4/21/18.
//  Copyright © 2018 nyu.edu. All rights reserved.
//

import UIKit
import AVFoundation

class DictionaryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DictionaryCellDelegate {
    
    @IBOutlet weak var table: UITableView!
    var savedWords = [Word]()
    var fromLanguageIndex = 0
    var toLanguageIndex = 0
    var currentCell = DictionaryCell()
    // language codes for AVFoundation
    let speechLanguages = ["en-US","ar-SA","zh-CN", "cs-CZ", "da-DK", "nl-NL", "fi-FI", "fr-FR", "de-DE", "el-GR", "he-IL", "hi-IN", "hu-HU", "id-ID", "it-IT", "ja-JP", "ko-KR", "no-NO", "pl-PL", "pt-BR", "ro-RO", "ru-RU", "sk-SK", "es-ES", "th-TH", "tr-TR"]
    
    // table view methods
    // get number of cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedWords.count
    }
    
    // create cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DictionaryCell") as! DictionaryCell
        cell.translateFromText.text = savedWords[indexPath.row].originalText
        cell.translateToText.text = savedWords[indexPath.row].translatedText
        cell.delegate = self
        return cell
    }
    
    
    // adding swipe to delete feature
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.savedWords.remove(at: indexPath.row)
            self.table.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // swipe right to go to HomeViewController
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeRight))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        table.delegate = self
        table.dataSource = self
    }
    
    // prepare segue method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "unwindFromDictVC"){
            let mainVC = segue.destination as! MainViewController
            mainVC.savedWords = self.savedWords
        }
    }
    
    // segue back to MainViewController
    @objc func respondToSwipeRight(gesture : UIGestureRecognizer) {
        self.performSegue(withIdentifier: "unwindFromDictVC", sender: self)
    }
    
    // text to speech for original text
    func didPressTranslateFrom(fromWord: String) {
        let voice = AVSpeechSynthesisVoice(language: speechLanguages[self.fromLanguageIndex])
        let toSay = AVSpeechUtterance(string: fromWord)
        toSay.voice = voice

        let getReady = AVSpeechSynthesizer()
        getReady.speak(toSay)
    }
    
    // text to speech for translated text
    func didPressTranslateTo(toWord: String) {
        let voice = AVSpeechSynthesisVoice(language: speechLanguages[self.toLanguageIndex])
        let toSay = AVSpeechUtterance(string: toWord)
        toSay.voice = voice
        
        let getReady = AVSpeechSynthesizer()
        getReady.speak(toSay)
    }
    

}
