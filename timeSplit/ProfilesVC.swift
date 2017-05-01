//
//  ProfilesVC.swift
//  timeSplit
//
//  Created by Cory Billeaud on 4/14/17.
//  Copyright © 2017 Cory. All rights reserved.
//

import UIKit

class ProfilesVC: UIViewController, UIViewControllerTransitioningDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var authService = AuthService.instance
    var loginVC: LogInVC?
    let profiles = [Account]()
    
    var halfModalTransitioningDelegate: HalfModalTransitioningDelegate?

    let userID = UserDefaults.standard.object(forKey: "DEFAULTS_ID") as! String
    
    override func viewDidLoad() {
        super.viewDidLoad()

        authService.delegate = self
        authService.getAll()
        authService.fetchMe()
    
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
    }
    
    func showLogInVC() {
        loginVC = LogInVC()
        loginVC?.modalPresentationStyle = UIModalPresentationStyle.formSheet
        self.present(loginVC!, animated: true, completion: nil)
    }
    
    @IBAction func effectButtonClicked(sender: UIButton) {
        performSegue(withIdentifier: "ShowEffectVC", sender: self)
    }
    
    @IBAction func theoryButtonClicked(sender: UIButton) {
        performSegue(withIdentifier: "ShowTheoryVC", sender: self)
    }
    
    @IBAction func infoButtonClicked(sender: UIButton) {
        performSegue(withIdentifier: "ShowInfoVC", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "ShowProfileVC" {
            
            
            if let destination = segue.destination as? ProfileVC {
                if let profile = sender as? Account {
                    destination.selectedAccount = profile
                }
            }
        }
        
        if segue.identifier == "ShowOtherUserProfile" {
            
            // half Modal Call
            self.halfModalTransitioningDelegate = HalfModalTransitioningDelegate(viewController: self, presentingViewController: segue.destination)
            segue.destination.modalPresentationStyle = .custom
            segue.destination.transitioningDelegate = self.halfModalTransitioningDelegate

            
            if let destination = segue.destination as? ViewProfileVC {
                if let profile = sender as? Account {
                    destination.selectedProfile = profile 
                }
            }
        }
    }
}

extension ProfilesVC: AuthServiceDelegate {
    func loadMe() {
    }
    
    func getAll() {
        dump(authService.accounts)
        OperationQueue.main.addOperation {
            self.collectionView.reloadData()
        }
    }
}

extension ProfilesVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return authService.accounts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AccountCell", for: indexPath) as? AccountCell {
            cell.configureCell(account: authService.accounts[indexPath.row])
            cell.backgroundColor = UIColor.clear
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        var profile: Account!
        var loggedInUserID = authService.accounts[indexPath.row].id
        profile = authService.accounts[indexPath.row]

        
        if !(loggedInUserID == self.userID) {
            performSegue(withIdentifier: "ShowProfileVC", sender: profile)
        } else {
            performSegue(withIdentifier: "ShowOtherUserProfile", sender: profile)
        }
    }
    
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = collectionView.bounds.size.width
//        return AccountCell.size(for: width)
//    }
}


