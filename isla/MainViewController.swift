//
//  ViewController.swift
//  isla
//
//  Created by Alexander Lim on 4/13/18.
//  Copyright © 2018 nyu.edu. All rights reserved.
//

import UIKit
// use scene or sprite kit?
import SceneKit
import SpriteKit
import ARKit

// check if I need this
import Vision

let LIGHTBLUE = UIColor(red: (189.0/255.0), green: (232.0/255.0), blue: (248.0/255.0), alpha: (255.0/255.0))
let DARKBLUE = UIColor(red: (35.0/255.0), green: (103.0/255.0), blue: (145.0/255.0), alpha: (255.0/255.0))



class MainViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var displayView: UIView!
    @IBOutlet weak var objectText: UITextView!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var favoriteImage: UIImageView!
    
    //var currentText: String!
    var currentWord = Word()
    var savedWords = [Word]()
    
    //variables for language selections
    var fromLanguage = "";
    var toLangauge = "";
    var fromCode = "";
    var toCode = "";
    
    // translated boolean for save button
    var isTranslated = false
    
    //api key for yandex
    var APIKey = "trnsl.1.1.20180422T194443Z.0cefe4aad54a64e7.803240dd4b0f2d8166f7d7ad878d512f2dab58fa"
    //var testword = "cellular telephone"
    
    ////////////////////////////////////////
    // SCENE
    let bubbleDepth : Float = 0.01 // the 'depth' of 3D text
    var latestPrediction : String = "…" // a variable containing the latest CoreML prediction
    ///////////////////////////////////////////////////////


    // CoreML
    var visionRequest = [VNRequest]()
    // hmm label
//    let mlDispatchQueue = DispatchQueue(label: "com.hw.dispatchqueueml")
    let translationDispatchGroup = DispatchGroup()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(self.toCode);
        //print (self.translate(word: testword, fromL: "en", toL: self.toCode))
        
        // swipe left: go to dictionary vc
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipe))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        
        // swipe right: go to home vc
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipe))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        // for editing
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
//        objectText.text = "point at object & press DETECT!"
        objectText.font = UIFont(name: "Arial", size: 18)
        objectText.textColor = UIColor.white
        
        languageLabel.text = toLangauge;
        languageLabel.font = UIFont(name: "Arial", size: 18)
        languageLabel.textColor = DARKBLUE
        
        // disable button until translate is pressed
        favoriteButton.isEnabled = false
        
        
        // Set the view's delegate
        sceneView.delegate = self

        // Create a new scene
        let scene = SCNScene()

        // Set the scene to the view
        sceneView.scene = scene

        // Enable Default Lighting - makes the 3D text a bit poppier.
        sceneView.autoenablesDefaultLighting = true


        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else{
            fatalError("Could not model. Please input another model.")
        }

        let classRequest = VNCoreMLRequest(model: model, completionHandler: handleClass)
        classRequest.imageCropAndScaleOption = VNImageCropAndScaleOption.centerCrop
        visionRequest = [classRequest]
        
    }

    //////////////////////////////////////////////
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        // Enable plane detection
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
    }


    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Pause the view's session
        sceneView.session.pause()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    @objc func respondToSwipe(gesture : UIGestureRecognizer) {
        
        if let gesture = gesture as? UISwipeGestureRecognizer {
            switch gesture.direction{
            case UISwipeGestureRecognizerDirection.left:
                self.performSegue(withIdentifier: "toDictionaryScreen", sender: self)
            case UISwipeGestureRecognizerDirection.right:
                self.performSegue(withIdentifier: "backToHomeScreen", sender: self)
            default:
                break
            }
            
        }
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    // MARK: - ARSCNViewDelegate

    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            // Do any desired updates to SceneKit here.
        }
    }

    func handleClass(request: VNRequest, error: Error?){
        if error != nil{
            print("Error: " + (error?.localizedDescription)! )
            return
        }
        // results of type [Any?]
        guard let results = request.results else{
            print("No results")
            return
        }
        //[0...3]
        var topClassifications = results[0...1]
            .compactMap({ $0 as? VNClassificationObservation })
            // display image identifier
            .map({ "\($0.identifier)" })
            //.filter({ $0.confidence > 0.2 })

    
        // takes very first input of classification
        if let commaRange = topClassifications[0].range(of: ",") {
            topClassifications[0].removeSubrange(commaRange.lowerBound..<topClassifications[0].endIndex)
            print(topClassifications[0])
        }
        
        
        //var translatedWord: String!
        //let queue = DispatchQueue(label: "MyArrayQueue", attributes: .concurrent)
        // DispatchQueue
        //.main.async
        //queue.async(flags: .barrier) {
        
        self.currentWord.originalText = topClassifications[0]
        translationDispatchGroup.enter()
        self.translate(word: self.currentWord.originalText!, fromL: "en", toL: self.fromCode, from: true)
        translationDispatchGroup.leave()
        
        translationDispatchGroup.notify(queue: .main) {
            self.objectText.text = self.currentWord.originalText
        }

        
    }

    func updateML(){
        
        let currentPixels: CVPixelBuffer?
        let currentImage: CIImage
        let currentImageRequestHandler: VNImageRequestHandler

        // gather pixels from current frame
        currentPixels = (sceneView.session.currentFrame?.capturedImage)
        // check if its valid, then convert to image
        if (currentPixels == nil){
            return
        }
        else {
            currentImage = CIImage(cvPixelBuffer: currentPixels!)
        }

        // create handler for request
        currentImageRequestHandler = VNImageRequestHandler(ciImage: currentImage, options: [:] )

        do{
            try currentImageRequestHandler.perform(self.visionRequest)
        }
        catch {
            print(error)
        }

    }
    
//    translate function that takes languages specs and the word to be translated
    //TODO: URL encode strings
    // before -> (String)
    func translate(word: String, fromL: String, toL: String, from: Bool){
        
        //url encode
        let word = word.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        
        //print("urlencoded ", word)

        var translation = ""
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)


        let urlString = "https://translate.yandex.net/api/v1.5/tr.json/translate?key=\(APIKey)&text=\(word)&lang=\(fromL)-\(toL)"

        //print("url string is \(urlString)")
        //let url = NSURL(string: urlString as String)

        let request : NSMutableURLRequest = NSMutableURLRequest()
        request.url = NSURL(string: urlString)! as URL
        request.httpMethod = "GET"
        request.timeoutInterval = 30

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        translationDispatchGroup.enter()
        let dataTask = session.dataTask(with: request as URLRequest) {
             data, response, error in

            // 1: Check HTTP Response for successful GET request
            guard let httpResponse = response as? HTTPURLResponse, let receivedData = data
                else {
                    print("error: not a valid http response")
                    return
            }
            
            switch (httpResponse.statusCode)
            {
            case 200:
                if let json = (try? JSONSerialization.jsonObject(with: receivedData, options: .allowFragments)) as? [String: Any] {
                    let tArray = json["text"] as! [String]
                    translation = tArray[0]
                    
                   
                    
                    print("response is \(translation)")
                    self.translationDispatchGroup.leave()
                    //return translation
                    
                }
                //let response = NSString (data: receivedData, encoding: String.Encoding.utf8.rawValue)
                break
            case 400:
                break
            default:
                print(" GET request got response \(httpResponse.statusCode)")
            }
        }
        
        dataTask.resume()
        translationDispatchGroup.notify(queue: .main) {
            if (from == true){
                print(translation)
                self.currentWord.originalText = translation
            }
            else{
                self.currentWord.translatedText = translation
            }
        }
        
        //return translation
        

        
        

    }


    @IBAction func detectPressed(_ sender: Any) {
        favoriteImage.image = UIImage(named: "favorite.png")
        favoriteButton.isEnabled = true
        updateML()
        isTranslated = false
    }
    
    
    @IBAction func translatePressed(_ sender: Any) {
        translationDispatchGroup.enter()
        self.translate(word: self.currentWord.originalText!, fromL: fromCode, toL: toCode, from: false)
        translationDispatchGroup.leave()
        translationDispatchGroup.notify(queue: .main) {
            self.objectText.text = self.currentWord.translatedText
        }
        isTranslated = true
        favoriteButton.isEnabled = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let mainVC = self
        //segue.destination = mainVC
        if (segue.identifier == "editText"){
            let editVC = segue.destination as! EditTextViewController
            editVC.mainVC = mainVC
        }
        // check if this works
        if (segue.identifier == "toDictionaryScreen" ){
            let dictVC = segue.destination as! DictionaryViewController
            dictVC.savedWords = self.savedWords
            dictVC.fromLanguage = self.fromLanguage
            dictVC.toLangauge = self.toLangauge
            dictVC.toCode = self.toCode
            dictVC.fromCode = self.fromCode
            // maybe save langauge?
        }
        if (segue.identifier == "backToHomeScreen" ){
            let homeVC = segue.destination as! HomeViewController
            homeVC.fromLanguage = self.fromLanguage
            homeVC.toLangauge = self.toLangauge
        }
        
    }
    
    
    @IBAction func editTextPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "editText", sender: self)
    }
    
    @IBAction func favoritePressed(_ sender: Any) {
        let image = UIImage(named: "favorite_yellow.png")
        if (favoriteImage.image == image){
            if let index = savedWords.index(of:currentWord) {
                savedWords.remove(at: index)
            }
            favoriteImage.image = UIImage(named: "favorite.png")
            isTranslated = false
        }
        else{
            if (savedWords.contains(currentWord) == false){
                savedWords.append(currentWord)
                currentWord = Word()
                favoriteImage.image = UIImage(named: "favorite_yellow.png")
                isTranslated = true
            }
            else{
                print("Word is already contained in Dictionary")
                print("OG: " + currentWord.originalText! + " NEWW: " + currentWord.translatedText!)
            }
        }
    }
    

    @IBAction func didUnwindFromDictVC (_ sender: UIStoryboardSegue){
        let dictVC = sender.source as? DictionaryViewController
        
    }



}





































