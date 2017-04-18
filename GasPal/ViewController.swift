//
//  ViewController.swift
//  GasPal
//
//  Created by Tyler Hackley Lewis on 4/18/17.
//  Copyright © 2017 Tyler Hackley Lewis. All rights reserved.
//

import UIKit
import TesseractOCR

class ViewController: UIViewController, G8TesseractDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tesseract:G8Tesseract = G8Tesseract(language:"eng");
        tesseract.delegate = self;
        tesseract.image = UIImage(named: "receipt.jpg");
        tesseract.recognize();
        
        NSLog("%@", tesseract.recognizedText);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func shouldCancelImageRecognitionForTesseract(tesseract: G8Tesseract!) -> Bool {
        return false; // return true if you need to interrupt tesseract before it finishes
    }
}
