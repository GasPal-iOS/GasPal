//
//  OCRClient.swift
//  GasPal
//
//  Created by Kumawat, Diwakar on 4/28/17.
//  Copyright © 2017 Tyler Hackley Lewis. All rights reserved.
//

import UIKit
import TesseractOCR

class OCRClient: NSObject, G8TesseractDelegate {
    
    static var tesseract: G8Tesseract!
    
    class func initializeTesseract() {
        tesseract = G8Tesseract(language:"eng");
    }
    
    class func extractData(image: UIImage, success: @escaping ([String]) -> (), error: () -> ()) {
        
        tesseract.image = image

        // Extract the data using Tesseract
        tesseract.recognize()
        
        // Format the extracted data into an array of strings
        var result = [String]()
        tesseract.recognizedText.enumerateLines {
            line, _ in result.append(line)
        }
        
        success(result)
    }

}
