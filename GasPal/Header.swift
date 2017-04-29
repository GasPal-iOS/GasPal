//
//  Header.swift
//  GasPal
//
//  Created by Tyler Hackley Lewis on 4/28/17.
//  Copyright © 2017 Tyler Hackley Lewis. All rights reserved.
//

import UIKit

protocol HeaderDelegate: class {
    
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
        addSubview(contentView)
        
        headerTitleLabel.text = title
    }
    
    func initCameraIcon() {
        let cameraIcon = UIButton(frame: CGRect(x: 225, y: 24, width: 60, height: 25))
        cameraIcon.addTarget(self, action: #selector(onCameraTap), for: .touchUpInside)
        cameraIcon.backgroundColor = UIColor.white
        let cameraIconTitle = NSAttributedString(string: "Camera", attributes: [
                NSFontAttributeName: UIFont.systemFont(ofSize: 11),
                NSForegroundColorAttributeName: UIColor.black
            ])
        cameraIcon.setAttributedTitle(cameraIconTitle, for: .normal)
        contentView.addSubview(cameraIcon)
    }
    
    func initAddIcon() {
        let addIcon = UIButton(frame: CGRect(x: 300, y: 24, width: 60, height: 25))
        addIcon.addTarget(self, action: #selector(onAddTap), for: .touchUpInside)
        addIcon.backgroundColor = UIColor.white
        let addIconTitle = NSAttributedString(string: "Add", attributes: [
            NSFontAttributeName: UIFont.systemFont(ofSize: 11),
            NSForegroundColorAttributeName: UIColor.black
            ])
        addIcon.setAttributedTitle(addIconTitle, for: .normal)
        contentView.addSubview(addIcon)
    }
    
    func onCameraTap() {
        
    }
    
    func onAddTap() {
        
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
