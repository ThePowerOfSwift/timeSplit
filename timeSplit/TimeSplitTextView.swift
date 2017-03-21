//
//  TimeSplitTextView.swift
//  timeSplit
//
//  Created by Cory Billeaud on 3/20/17.
//  Copyright © 2017 Cory. All rights reserved.
//

import UIKit

class TimeSplitTextView: UITextView {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
            
        self.layer.cornerRadius = 0.0
        self.layer.borderColor = UIColor.customBlue().cgColor
        self.layer.borderWidth = 1.0
        self.textColor = UIColor.customBlue()
    }
}
    
extension UIColor {
    class func customBlue() -> UIColor {
        return UIColor(red: 153/255, green: 255/255, blue: 255/255, alpha: 1.0)
    }
        
    class func customRed() -> UIColor {
        return UIColor(red: 204/255, green: 51/255, blue: 51/255, alpha: 1.0)
    }
    
    class func customBgColor() -> UIColor {
        return UIColor(red: 153/255, green: 255/255, blue: 255/255, alpha: 0.2)
    }

}
