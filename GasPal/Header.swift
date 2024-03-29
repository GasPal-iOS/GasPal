//
//  Header.swift
//  GasPal
//
//  Created by Tyler Hackley Lewis on 4/28/17.
//  Copyright © 2017 Tyler Hackley Lewis. All rights reserved.
//

import UIKit

protocol AddIconDelegate: class {
    func onAddIconTapped()
}

protocol LogoutDelegate: class {
    func onLogoutButtonTapped()
}

class Header: UIView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var headerTitleLabel: UILabel!
    
    var title: String? {
        get { return headerTitleLabel.text }
        set { headerTitleLabel.text = newValue }
    }
    
    var doShowCameraIcon: Bool? {
        didSet {
            initCameraIcon()
        }
    }
    
    var doShowAddIcon: Bool? {
        didSet {
            initAddIcon()
        }
    }
    
    var doShowLogoutButton: Bool? {
        didSet {
            initLogoutButton()
        }
    }
    
    weak var addIconDelegate: AddIconDelegate?
    weak var logoutDelegate: LogoutDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews() {
        // Initialize nib
        let nib = UINib(nibName: "Header", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        contentView.layer.borderWidth = 0.3
        contentView.layer.borderColor = UIColor.gray.cgColor
        addSubview(contentView)
        
        headerTitleLabel.text = title
    }
    
    func initCameraIcon() {
        let cameraIcon = UIButton(frame: CGRect(x: 270, y: 26, width: 32, height: 32))
        cameraIcon.addTarget(self, action: #selector(onCameraTap), for: .touchUpInside)
        //cameraIcon.backgroundColor = UIColor.white
        if let image = UIImage(named: "icon-camera") {
            let tintedImage = image.withRenderingMode(.alwaysTemplate)
            cameraIcon.setImage(tintedImage, for: UIControlState.normal)
            cameraIcon.tintColor = self.tintColor
        }

        contentView.addSubview(cameraIcon)
    }
    
    func initAddIcon() {
        let addIcon = UIButton(frame: CGRect(x: 326, y: 30, width: 24, height: 24))
        addIcon.addTarget(self, action: #selector(onAddTap), for: .touchUpInside)
        if let image = UIImage(named: "icon-add") {
            let tintedImage = image.withRenderingMode(.alwaysTemplate)
            addIcon.setImage(tintedImage, for: UIControlState.normal)
            addIcon.tintColor = self.tintColor
        }
        
        contentView.addSubview(addIcon)
    }
    
    func initLogoutButton() {
        let logoutButton = UIButton(frame: CGRect(x: 20, y: 32, width: 20, height: 20))
        logoutButton.addTarget(self, action: #selector(onLogoutTap), for: .touchUpInside)
        if let image = UIImage(named: "logout") {
            let tintedImage = image.withRenderingMode(.alwaysTemplate)
            logoutButton.setImage(tintedImage, for: UIControlState.normal)
            logoutButton.tintColor = self.tintColor
        }

        contentView.addSubview(logoutButton)
    }
    
    func onCameraTap() {
        print("onCameraTap")
        NotificationCenter.default.post(name: GasPalNotification.openCamera, object: nil, userInfo: ["origin": headerTitleLabel.text!])
    }
    
    func onAddTap() {
        addIconDelegate?.onAddIconTapped()
    }
    
    func onLogoutTap() {
        ParseClient.sharedInstance.logout { 
            self.logoutDelegate?.onLogoutButtonTapped()
        }
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
