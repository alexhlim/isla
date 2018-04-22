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
    
    var currentText: String!
    
    ////////////////////////////////////////
    // SCENE
    let bubbleDepth : Float = 0.01 // the 'depth' of 3D text
    var latestPrediction : String = "…" // a variable containing the latest CoreML prediction
    ///////////////////////////////////////////////////////


    // CoreML
    var visionRequest = [VNRequest]()
    // hmm label
    let mlDispatchQueue = DispatchQueue(label: "com.hw.dispatchqueueml")

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        objectText.text = "press DETECT to recognize object!"
        objectText.font = UIFont(name: "Arial", size: 18)
        objectText.textColor = UIColor.white
        
        languageLabel.text = "INSERT LANGUAGE"
        languageLabel.font = UIFont(name: "Arial", size: 18)
        languageLabel.textColor = DARKBLUE
        
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
        
        self.objectText.text = currentText

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
        let topClassifications = results[0...1]
            .flatMap({ $0 as? VNClassificationObservation })
            .map({ "\($0.identifier) \(($0.confidence * 100.0).rounded())" })
            //.filter({ $0.confidence > 0.2 })
            .joined(separator: "\n")

        DispatchQueue.main.async {
            self.currentText = topClassifications
            self.objectText.text = self.currentText
            //request.r
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


    @IBAction func detectPressed(_ sender: Any) {
        updateML()
    }
    
    
    @IBAction func translatePressed(_ sender: Any) {
        // API Req
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if (segue.identifier == "editText"){
            let editVC = segue.destination as! EditTextViewController;
            editVC.currentText = objectText.text
        }
        if (segue.identifier == "toDictionaryScreen" ){
            
        }
        if (segue.identifier == "backToHomeScreen" ){
            
        }
        
    }
    
    
    @IBAction func editTextPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "editText", sender: self)
    }
    
    @IBAction func saveTextPressed(_ sender: Any) {
        // save to dictionary
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user

    }

    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay

    }

    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required

    }



}





































