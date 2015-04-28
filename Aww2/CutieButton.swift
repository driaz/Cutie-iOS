//
//  CutieButton.swift
//  Cutie
//
//  Created by Daniel Riaz on 4/27/15.
//  Copyright (c) 2015 Daniel Riaz. All rights reserved.
//

import UIKit

class CutieButton: UIButton {
    
    override func awakeFromNib() {
        self.layer.borderColor = UIColor.whiteColor().CGColor
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowOpacity = 0.8
        self.layer.shadowRadius = 1
        self.layer.shadowOffset = CGSizeMake(2.0, 2.0)
        self.layer.cornerRadius = 5.0
        self.layer.borderWidth = 1.0
        self.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 2.0, right: 0.0)
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
}
