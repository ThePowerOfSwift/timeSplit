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
    
    var account = Account()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        authService.delegate = self
        authService.fetchProfile(for: account)
        
        self.account = AuthService.instance.myAccount

        
        dump(self.account)
        dump(authService.myAccount)
        
//        configureUI(account: authService.myAccount)

        
//        if let info = self.account {
//
//            
//            bioLabel.text = self.account?.bio
//            
//            
//            print("This is working \(info)")
//            
//        }
        
        print(DEFAULTS_ID!)
        
        //Hide Autolayout Warning
        UserDefaults.standard.setValue(false, forKey:"_UIConstraintBasedLayoutLogUnsatisfiable")

    }
    
    func configureUI(account: Account) {
        
        if let account = self.account {
            bioLabel.text = account.bio
            nameLabel.text = account.name
            websiteLabel.text = account.website
        }
       
    }
    
    func showLogInVC() {
        logInVC = LogInVC()
        logInVC?.modalPresesntationStyle = UIModalPresentationStyle.formSheet
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



