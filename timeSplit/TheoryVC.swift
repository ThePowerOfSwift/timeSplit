//
//  TheoryVC.swift
//  timeSplit
//
//  Created by Cory Billeaud on 3/14/17.
//  Copyright © 2017 Cory. All rights reserved.
//

import UIKit

class TheoryVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    var dataService = DataService.instance
    var authService = AuthService.instance
    
    var logInVC: LogInVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataService.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        dataService.getAllTheories()

    }
    
    func showLogInVC() {
        logInVC = LogInVC()
        logInVC?.modalPresentationStyle = UIModalPresentationStyle.formSheet
        self.present(logInVC!, animated: true, completion: nil)
    }


    @IBAction func addButtonTapped(sender: UIButton) {
        if authService.isAuthenticated == true {
            performSegue(withIdentifier: "ShowAddTheoryVC", sender: self)
        } else {
            showLogInVC()
        }
    }
    
    @IBAction func infoButtonTapped(sender: UIButton) {
        performSegue(withIdentifier: "ShowInfoVC", sender: self)
    }
    
    @IBAction func effectButtonTapped(sender: UIButton) {
        performSegue(withIdentifier: "ShowEffectVC", sender: self)
    }
    
    @IBAction func profileButtonTapped(sender: UIButton) {
        performSegue(withIdentifier: "ShowProfileVC", sender: self)
    }
    
    @IBAction func backButtonTapped(sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTheoryDetailVC" {
            if let indexpath = tableView.indexPathForSelectedRow {
                let destinationVC = segue.destination as! TheoryDetailVC
                destinationVC.selectedTheory = dataService.theories[indexpath.row]
            }
        }
    }
}

extension TheoryVC: DataServiceDelegate {
    func addLikes() {
    }

    func theoriesLoaded() {
        print(dataService.theories)
        OperationQueue.main.addOperation {
            self.tableView.reloadData()
        }
    }
    func theoryCommentsLoaded() {
        print(dataService.theoriesComments)
    }
    
    func effectsLoaded() {
    }
    
    func commentsLoaded() {
    }
}

extension TheoryVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataService.theories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TheoryCell", for: indexPath) as? TheoryCell {
            cell.configureCell(theory: dataService.theories[indexPath.row])
            cell.backgroundColor = UIColor.clear
            return cell
        } else {
            return UITableViewCell()
        }
        
    }
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        cell.backgroundColor = UIColor.clear
//    }
}
