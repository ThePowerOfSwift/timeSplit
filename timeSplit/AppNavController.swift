//
//  AppNavController.swift
//  timeSplit
//
//  Created by Cory Billeaud on 4/17/17.
//  Copyright © 2017 Cory. All rights reserved.
//

import UIKit

class AppNavController: UINavigationController, HalfModalPresentable {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return isHalfModalMaximized() ? .default : .lightContent
    }
}
