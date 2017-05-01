//
//  ProfileView.swift
//  GasPal
//
//  Created by Kumawat, Diwakar on 4/30/17.
//  Copyright © 2017 Tyler Hackley Lewis. All rights reserved.
//

import UIKit

class ProfileView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var licenceNumberLabel: UILabel!
    @IBOutlet weak var licenseExpiryLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    
    @IBOutlet weak var dobLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    func initSubviews() {
        // standard initialization logic
        let nib = UINib(nibName: "ProfileView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
    }
    
    var image: UIImage? {
        get { return profileImage.image }
        set { profileImage.image = newValue }
    }
    
    
}
