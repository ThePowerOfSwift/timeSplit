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
    var currentAccount: Account!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        authService.delegate = self
        
        authService.fetchProfile(for: DEFAULTS_ID as! String)
        
        if let account = currentAccount {
            
            authService.fetchProfile(for: DEFAULTS_ID as! String)
            
            nameLabel.text = account.name
            bioLabel.text = account.bio
            websiteLabel.text = currentAccount.website
        }
        
//        authService.fetchMyProfile()
        
      
        print(DEFAULTS_ID!)

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
        
    }
    
}


