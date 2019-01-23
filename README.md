# isla

## Overview

_Breaking language barriers with the tap of a button._

International travel is becoming more prevalent in an average person’s life. Language barriers should not hinder one’s ability to effectively communicate and to be fully immersed in another culture. _isla_ aims to help people learn new languages more effectively and efficiently when traveling abroad. Using CoreML and using Yandex's Translate API, _isla_ will be able to identify and translate any object in real time.

While _isla_ is initially focused on the uses of an average traveler, it can also be expanded to the everyday language learner. Its ease of use and adaptability allows anyone to use the app and to cater it to their daily lives. With _isla_, we can make learning languages easier by allowing users to customize exactly what they want to learn. 

## Workflow Design
<img src="images/flowchart.jpg" alt="flowchart" width="600" height="100">

## Languages Available
<img src="images/languages.jpg" alt="languages" width="500" height="300">

## Buttons
<img src="images/buttons.jpg" alt="buttons" width="400" height="230">

## Libraries

### CoreML and Vision
- Using Inceptionv3 model
  - From Apple’s Developer page: “Detects the dominant objects present in an image from a set of 1000 categories such as trees, animals, food, vehicles, people, and more.”
- Vision ➔ framework that works with CoreML (classifications, object detection)
  - Display classification with the highest probability
- How detection works
  - Capture current frame of the ARSCNView
  - Stores current pixels in a CVPixelBuffer
  - Converts buffer to CIImage
  - CIImage is fed to the Vision Request

### Yandex API
- Online machine translation service 
- Steps 
  - Use API key and encode URL
  - Perform an HTTP request (GET)
  - Receive in JSON format, then parse it
- Use of DispatchGroup to synchronize threads
Asynchronous code

### AVFoundation 
- Framework for time-based audio + visual media on iOS, macOS, watchOS, and tvOS
- In this app, utilized to make Siri do text to speech
- Steps
  - AVSpeechSynthesizerVoice() ➔ choose Siri’s voice
  - AVSpeechUtterance() ➔ Siri will speak
  - AVSpeechSynthesizer ➔ prepare for sound 
  - Speak!
  
## Screenshots

<img src="images/home.jpg" alt="home" width="200" height="325"> <img src="images/main.jpg" alt="main" width="200" height="325"> <img src="images/dictionary.jpg" alt="dictionary" width="200" height="325">
