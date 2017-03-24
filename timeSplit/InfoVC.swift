//
//  InfoVC.swift
//  timeSplit
//
//  Created by Cory Billeaud on 3/14/17.
//  Copyright © 2017 Cory. All rights reserved.
//

import UIKit

class InfoVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func effectButtonTapped(sender: UIButton) {
        performSegue(withIdentifier: "ShowEffectVC", sender: self)
    }
    
    @IBAction func theoryButtonTapped(sender: UIButton) {
        performSegue(withIdentifier: "ShowTheoryVC", sender: self)
    }
    
    @IBAction func profileButtonTapped(sender: UIButton) {
        performSegue(withIdentifier: "ShowProfileVC", sender: self)
    }


}
