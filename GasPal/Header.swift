//
//  Header.swift
//  GasPal
//
//  Created by Tyler Hackley Lewis on 4/28/17.
//  Copyright © 2017 Tyler Hackley Lewis. All rights reserved.
//

import UIKit

class Header: UIView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var headerTitleLabel: UILabel!
    
    var title: String! {
        get { return headerTitleLabel.text }
        set { headerTitleLabel.text = newValue }
    }
    
    var doShowCameraIcon: Bool!
    var doShowAddIcon: Bool!
    
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
        
        // Set title
        headerTitleLabel.text = title
        
        // Conditionally create camera icon
        
        
        // Conditionally create add icon
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
