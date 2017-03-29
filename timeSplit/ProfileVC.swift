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
    
    var dataService = DataService.instance
    var authService = AuthService.instance
    
    var logInVC: LogInVC?
    
    var profile: Profile?
    var account: Account!

    override func viewDidLoad() {
        super.viewDidLoad()

        dataService.delegate = self
        authService.delegate = self
        
        nameLabel.text = profile?.name
        bioLabel.text = profile?.bio
        

        print(authService.account)
        print(authService.authToken!)
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

extension ProfileVC: DataServiceDelegate {
    func addLikes() {
    }
    
    func profileLoaded() {
        print(dataService.profile)
        OperationQueue.main.addOperation {
            if self.authService.isAuthenticated == true {

            }
        }
    }
    
    func effectsLoaded() {
    }
    
    func theoriesLoaded() {
    }
    
    func theoryCommentsLoaded() {
    }
    
    func commentsLoaded() {
    }
}

extension ProfileVC: AuthServiceDelegate {
    func loadMe() {
//        authService.getAccount(for: Account)
//        print(account.id)
////        if let user = account {
////            account.id = account.id
////            if let userProfile = profile {
////                profile?.name = userProfile.name
////                profile?.bio = userProfile.bio
////            }
////        }
//        
    }
}


