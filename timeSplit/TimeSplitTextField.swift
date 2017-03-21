//
//  timeSplitTextField.swift
//  timeSplit
//
//  Created by Cory Billeaud on 3/19/17.
//  Copyright © 2017 Cory. All rights reserved.
//

import UIKit

class TimeSplitTextField: UITextField {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.layer.cornerRadius = 0.0
        self.layer.borderColor = UIColor.customBlue().cgColor
        self.layer.borderWidth = 1.0
        self.backgroundColor = UIColor.customBgColor()
        self.textColor = UIColor.customBlue()
    }
}

