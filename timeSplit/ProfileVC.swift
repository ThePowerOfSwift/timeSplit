//
//  ProfileVC.swift
//  timeSplit
//
//  Created by Cory Billeaud on 3/21/17.
//  Copyright © 2017 Cory. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    
    var authService = AuthService.instance
    var defaults = UserDefaults.standard
    var logInVC: LogInVC?
    var DEFAULTS_ID = UserDefaults.standard.object(forKey: "DEFAULTS_ID")
    
    var account: Account?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        authService.delegate = self
        authService.fetchProfile()
        
        dump(self.account)
        
        if let info = self.account {

            self.account = authService.myAccount
            
            bioLabel.text = self.account?.bio
            
            
            print("This is working \(info)")
            
        }
        
        print(DEFAULTS_ID!)
        
        //Hide Autolayout Warning
        UserDefaults.standard.setValue(false, forKey:"_UIConstraintBasedLayoutLogUnsatisfiable")

    }
    
    func showLogInVC() {
        logInVC = LogInVC()
        logInVC?.modalPresentationStyle = UIModalPresentationStyle.formSheet
        self.present(logInVC!, animated: true, completion: nil)
    }

    @IBAction func effectButtonTapped(sender: UIButton) {
        performSegue(withIdentifier: "ShowEffectVC", sender: self)
    }
    
    @IBAction func theoryButtonTapped(sender: UIButton) {
        performSegue(withIdentifier: "ShowTheoryVC", sender: self)
    }
    
    @IBAction func infoButtonTapped(sender: UIButton) {
        performSegue(withIdentifier: "ShowInfoVC", sender: self)
    }
}

extension ProfileVC: AuthServiceDelegate {

    func loadMe() {

        self.account = authService.myAccount
    
    }
}



