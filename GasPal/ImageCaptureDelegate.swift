//
//  ImageReceivedProtocol.swift
//  GasPal
//
//  Created by Tyler Hackley Lewis on 5/7/17.
//  Copyright © 2017 Tyler Hackley Lewis. All rights reserved.
//

import UIKit

protocol ImageCaptureDelegate: class {
    func onImageCaptured(capturedImage: UIImage)
}
