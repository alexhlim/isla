//
//  DictionaryViewController.swift
//  isla
//
//  Created by Alexander Lim on 4/21/18.
//  Copyright © 2018 nyu.edu. All rights reserved.
//

import UIKit

class DictionaryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    let temp = Word(originalText: "apple", translatedText: "la manzana")
    var savedWords = [Word]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedWords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "currentCell")
        cell?.textLabel?.text = savedWords[indexPath.row].originalText
        cell?.textLabel?.textColor = DARKBLUE
        cell?.detailTextLabel?.text = savedWords[indexPath.row].translatedText
        cell?.detailTextLabel?.textColor = DARKBLUE
        
        cell?.backgroundColor = LIGHTBLUE
        return cell!
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // swipe right: go to home vc
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeRight))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        table.delegate = self
        table.dataSource = self
        
        savedText.append(temp)
        table.backgroundColor = LIGHTBLUE

        // Do any additional setup after loading the view.
    }
    
    @objc func respondToSwipeRight(gesture : UIGestureRecognizer) {
        self.performSegue(withIdentifier: "backToMainScreen", sender: self)
    }


}
