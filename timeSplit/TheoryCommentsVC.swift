//
//  TheoryCommentsVC.swift
//  timeSplit
//
//  Created by Cory Billeaud on 3/17/17.
//  Copyright © 2017 Cory. All rights reserved.
//

import UIKit

class TheoryCommentsVC: UIViewController {
    
    var selectedTheory: Theory?
    
    var dataService = DataService.instance
    var authService = AuthService.instance
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        dataService.delegate = self

        if let theory = selectedTheory {
            titleLabel.text = theory.title
            dataService.getAllTheoryComments(for: theory)
        }
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140

    }
    
    @IBAction func backButtonTapped(sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
}

extension TheoryCommentsVC: DataServiceDelegate {
    func addLikes() {
    }
    
    func effectsLoaded() {
    }
    
    func commentsLoaded() {
    }
    
    func theoriesLoaded() {
    }
    
    func theoryCommentsLoaded() {
        OperationQueue.main.addOperation {
            self.tableView.reloadData()
            print(self.dataService.theoriesComments)
        }
    }
}


extension TheoryCommentsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataService.theoriesComments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TheoryCommentCell", for: indexPath) as? TheoryCommentCell {
            cell.configureCell(comment: dataService.theoriesComments[indexPath.row])
            cell.backgroundColor = UIColor.clear
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
