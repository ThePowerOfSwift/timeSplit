//
//  ViewProfileVC.swift
//  timeSplit
//
//  Created by Cory Billeaud on 3/22/17.
//  Copyright © 2017 Cory. All rights reserved.
//

import UIKit

class ViewProfileVC: UIViewController, HalfModalPresentable {
    
    var authService = AuthService.instance
    var selectedProfile: Account!
    
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()

        
        authService.getAll()
        
        configureUI()
        
        
    }
    
    func configureUI() {
        
        if let account = selectedProfile {
            bioLabel.text = account.bio
            nameLabel.text = account.name
            websiteLabel.text = account.website
        }
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        if let delegate = navigationController?.transitioningDelegate as? HalfModalTransitioningDelegate {
            delegate.interactiveDismiss = false
        }
        
        dismiss(animated: true, completion: nil)
    }
}

extension ViewProfileVC: AuthServiceDelegate {
    
    func loadMe() {
        
    }
    
    func getAll() {
        
    }
    
}
