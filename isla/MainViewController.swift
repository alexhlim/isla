//
//  ViewController.swift
//  isla
//
//  Created by Alexander Lim on 4/13/18.
//  Copyright © 2018 nyu.edu. All rights reserved.
//

import UIKit
import ARKit
import Vision

/**
 This is the MainViewController. It is where we use the camera to capture
 images and feed it into CoreML, and then translate it using Yandex's Translation API.
 */
class MainViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var displayView: UIView!
    @IBOutlet weak var objectText: UITextView!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var favoriteImage: UIImageView!
    
    // custom object to contain original and translated texts
    var currentWord = Word()
    // array to hold Words
    var savedWords = [Word]()
    
    //variables for language selections
    var fromLanguage = ""
    var fromLanguageIndex = 0
    var toLangauge = ""
    var toLanguageIndex = 0
    var fromCode = ""
    var toCode = ""
    
    // booleans for edit view screen
    var isOriginalText = false
    var isTranslatedText = false
    
    // api key for yandex
    var APIKey = "trnsl.1.1.20180422T194443Z.0cefe4aad54a64e7.803240dd4b0f2d8166f7d7ad878d512f2dab58fa"


    // CoreML
    var visionRequest = [VNRequest]()
    let translationDispatchGroup = DispatchGroup()

    /**
     Helps get the view ready: it sets up the swipe gesture for segues, the tap gesture for editing, and sets up the CoreML model, Inceptionv3.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // swipe left: go to DictionaryViewController
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipe))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        
        // swipe right: go to HomeViewController
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipe))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        // for edit button
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // display language translating to
        languageLabel.text = toLangauge;
        
        // disable button until translate is pressed
        favoriteButton.isEnabled = false
        
        // Set the view's delegate
        sceneView.delegate = self

        // set up coreML model
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else{
            fatalError("Could not model. Please input another model.")
        }

        let classRequest = VNCoreMLRequest(model: model, completionHandler: handleClass)
        classRequest.imageCropAndScaleOption = VNImageCropAndScaleOption.centerCrop
        visionRequest = [classRequest]
        
    }

    /**
     Configures the ARSCNView and keeps the session running.
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // create configuration
        let configuration = ARWorldTrackingConfiguration()
        // enable plane detection
        configuration.planeDetection = .horizontal

        // run current view's session
        sceneView.session.run(configuration)
    }

    /**
     Keeps track of the session if it disappears.
     */
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // pause session
        sceneView.session.pause()
    }
    
    /**
     Handles the swiping gestures. When a swipe is detected, it performs a segue to a new destination view controller.
    */
    @objc func respondToSwipe(gesture : UIGestureRecognizer) {
        if let gesture = gesture as? UISwipeGestureRecognizer {
            switch gesture.direction{
            case UISwipeGestureRecognizerDirection.left:
                self.performSegue(withIdentifier: "toDictionaryVC", sender: self)
            case UISwipeGestureRecognizerDirection.right:
                self.performSegue(withIdentifier: "unwindFromMainVC", sender: self)
            default:
                break
            }
        }
    }
    
    /**
     This function is primarily used for dismissing the keyboard for editing text.
     */
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    

    /**
     This is the first of the CoreML methods. It sets up the handler that is needed to perform a Vision request. We take the output of the Inceptionv3 model and take the classification with the highest probability.
     */
    func handleClass(request: VNRequest, error: Error?){
        if error != nil{
            print("Error: " + (error?.localizedDescription)! )
            return
        }
        
        // get results of our vision request (of type [Any?])
        guard let results = request.results else{
            print("No results")
            return
        }
        // get top two results
        var topClassifications = results[0...1]
            // evaluate topClassifications when it is not nil
            .compactMap({ $0 as? VNClassificationObservation })
            // display image label
            .map({ "\($0.identifier)" })

        // string parsing: takes very first input of classification
        if let commaRange = topClassifications[0].range(of: ",") {
            topClassifications[0].removeSubrange(commaRange.lowerBound..<topClassifications[0].endIndex)
        }
        
        self.currentWord.originalText = topClassifications[0]
        // use dispatch group to synchronize threads (needed because of API call)
        translationDispatchGroup.enter()
        self.translate(word: self.currentWord.originalText!, fromL: "en", toL: self.fromCode, from: true)
        translationDispatchGroup.leave()
        
        // wait until all threads finish, then execute block
        translationDispatchGroup.notify(queue: .main) {
            self.objectText.text = self.currentWord.originalText
        }
    }

    /**
     Captures the current frame of the ARSCNView and uses it as an input to feed into the CoreML model. Also, it uses the handler defined previously to handle any errors.
     */
    func updateML(){
        let currentPixels: CVPixelBuffer?
        let currentImage: CIImage
        let currentImageRequestHandler: VNImageRequestHandler

        // gather pixels from current frame
        currentPixels = (sceneView.session.currentFrame?.capturedImage)
        // check if its valid, if so convert to image
        if (currentPixels == nil){
            return
        }
        else {
            currentImage = CIImage(cvPixelBuffer: currentPixels!)
        }

        // create handler for request
        currentImageRequestHandler = VNImageRequestHandler(ciImage: currentImage, options: [:] )

        do{
            // perform vision request with coreML model
            try currentImageRequestHandler.perform(self.visionRequest)
        }
        catch {
            print(error)
        }

    }
    
    // translate function that takes languages specs and the word to be translated
    /**
     Takes the language from the PickerView in the HomeViewController and translates the text according the language chosen. Also, there is use of DispatchGroups to help synchronize threads when making the API call.
     */
    func translate(word: String, fromL: String, toL: String, from: Bool){
        //url encode
        let word = word.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        var translation = ""
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)


        let urlString = "https://translate.yandex.net/api/v1.5/tr.json/translate?key=\(APIKey)&text=\(word)&lang=\(fromL)-\(toL)"

        
        let request : NSMutableURLRequest = NSMutableURLRequest()
        request.url = NSURL(string: urlString)! as URL
        request.httpMethod = "GET"
        request.timeoutInterval = 30

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        // use Dispatch group for thread synchronization
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
                    self.translationDispatchGroup.leave()
                }
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
                self.currentWord.originalText = translation
            }
            else{
                self.currentWord.translatedText = translation
            }
        }
    }

    /**
     This function is used to respond when the detect button is pressed. It creates a new Word object, then it calls the CoreML method to get the classification.
     */
    @IBAction func detectPressed(_ sender: Any) {
        favoriteImage.image = UIImage(named: "favorite.png")
        favoriteButton.isEnabled = false
        // new Word object
        let newWord = Word()
        currentWord = newWord
        updateML()
        // keep track of which text is displayed
        self.isOriginalText = true
        self.isTranslatedText = false
    }
    
    /**
     This function is used to respond when the translate button is pressed. The text displayed in the original text in the label will be replaced with the translated It also uses DispatchGroups to synchronize threads.
     */
    @IBAction func translatePressed(_ sender: Any) {
        // thread synchronization
        translationDispatchGroup.enter()
        self.translate(word: self.currentWord.originalText!, fromL: fromCode, toL: toCode, from: false)
        translationDispatchGroup.leave()
        // wait till all threads are done
        translationDispatchGroup.notify(queue: .main) {
            self.objectText.text = self.currentWord.translatedText
        }
        favoriteButton.isEnabled = true
        self.isOriginalText = false
        self.isTranslatedText = true
    }
    
    /**
     This method is used handle segues to either the HomeViewController or the DictionaryViewController. Depending on which view controller is chosen, the appropriate data will be sent over.
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let mainVC = self
        if (segue.identifier == "toEditTextVC"){
            let editVC = segue.destination as! EditTextViewController
            editVC.mainVC = mainVC
            editVC.currentWord = self.currentWord
            editVC.isOriginalText = self.isOriginalText
            editVC.isTranslatedText = self.isTranslatedText
        }
        if (segue.identifier == "toDictionaryVC" ){
            let dictVC = segue.destination as! DictionaryViewController
            dictVC.savedWords = self.savedWords
            dictVC.fromLanguageIndex = self.fromLanguageIndex
            dictVC.toLanguageIndex = self.toLanguageIndex
            dictVC.fromLanguage = self.fromLanguage
            dictVC.toLanguage = self.toLangauge
        }
        if (segue.identifier == "unwindFromMainVC" ){
            let homeVC = segue.destination as! HomeViewController
            homeVC.fromLanguage = self.fromLanguage
            homeVC.toLangauge = self.toLangauge
        }
    }
    
    /**
     This function is used to respond when the edit button is pressed. It envokes a segue to EditViewController.
     */
    @IBAction func editTextPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "toEditTextVC", sender: self)
    }
    
    /**
     This method is used to repsond when the favorite button is pressed. It considers two options: if the button was already pressed or not. If the button is already pressed, then the current Word will be deleted from the dictionary. If the button is not pressed, the Word will be added to the dictionary.
     */
    @IBAction func favoritePressed(_ sender: Any) {
        let image = UIImage(named: "favorite_yellow.png")
        // if current Word is favorited
        if (favoriteImage.image == image){
            if let index = savedWords.index(of:currentWord) {
                savedWords.remove(at: index)
            }
            favoriteImage.image = UIImage(named: "favorite.png")
        }
        // currentWord is not favorited
        else{
            if (savedWords.contains(currentWord) == false){
                savedWords.append(currentWord)
                favoriteImage.image = UIImage(named: "favorite_yellow.png")
            }
            else{
                print("Word is already contained in Dictionary")
            }
        }
    }
    
    /**
     This is a function that is used to unwind from the DictionaryViewController. Unwind is beneficial as it does not create a new instance of a view controller. 
     */
    @IBAction func didUnwindFromDictVC (_ sender: UIStoryboardSegue){
        let dictVC = sender.source as? DictionaryViewController
        
    }



}





































