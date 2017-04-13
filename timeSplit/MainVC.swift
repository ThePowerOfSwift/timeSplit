//
//  MainVC.swift
//  timeSplit
//
//  Created by Cory Billeaud on 3/13/17.
//  Copyright © 2017 Cory. All rights reserved.
//

import UIKit

class MainVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var dataService = DataService.instance
    var authService = AuthService.instance
    
    var logInVC: LogInVC?
    
    var DEFAULTS_ID = UserDefaults.standard.object(forKey: "DEFAULTS_ID")
    
    var me: [Account] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataService.delegate = self
        authService.delegate = self

        tableView.delegate = self
        tableView.dataSource = self
        DataService.instance.getAllEffects()
        
        authService.fetchMe()
        print("This is defaults_id from fetchMe AuthService Function \(DEFAULTS_ID!)")
        
//        authService.fetchProfile(for: me)


        //Hide Autolayout Warning
        UserDefaults.standard.setValue(false, forKey:"_UIConstraintBasedLayoutLogUnsatisfiable")
        
    }
    
    func showLogInVC() {
        logInVC = LogInVC()
        logInVC?.modalPresentationStyle = UIModalPresentationStyle.formSheet
        self.present(logInVC!, animated: true, completion: nil)
    }
    
    @IBAction func addButtonTapped(sender: UIButton) {
        if AuthService.instance.isAuthenticated == true {
            performSegue(withIdentifier: "ShowAddEffectVC", sender: self)
        } else {
            showLogInVC()
        }
    }
    
    @IBAction func theoryButtonTapped(sender: UIButton) {
        performSegue(withIdentifier: "ShowTheoryVC", sender: self)
    }
    
    @IBAction func profileButtonTapped(sender: UIButton) {
        if AuthService.instance.isAuthenticated == true {
            performSegue(withIdentifier: "ShowProfileVC", sender: self)
        } else {
            showLogInVC()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetailVC" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationVC = segue.destination as! DetailVC
                destinationVC.selectedEffect = dataService.effects[indexPath.row]
            }
        }
        
        if segue.identifier == "ShowProfileVC" {
            let destinationVC = segue.destination as! ProfileVC
//            destinationVC.myAccount = authService.myAccount
        }
    }
}

extension MainVC: DataServiceDelegate {
    func effectsLoaded() {
        print(DataService.instance.effects)
        OperationQueue.main.addOperation {
            self.tableView.reloadData()
        }
    }
    
    func commentsLoaded() {
        print(DataService.instance.comments)
    }
    
    func theoriesLoaded() {
    }
    
    func theoryCommentsLoaded() {
    }
    
    func addLikes() {
    }
}

extension MainVC: AuthServiceDelegate {
    func loadMe() {
        
    }

    
    func loadMe(data: Account) {
        
    }
        
}

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataService.effects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "EffectCell", for: indexPath) as?
            EffectCell {
            cell.configureCell(effect: dataService.effects[indexPath.row])
            cell.backgroundColor = UIColor.clear
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
