//
//  CommentsVC.swift
//  timeSplit
//
//  Created by Cory Billeaud on 3/14/17.
//  Copyright © 2017 Cory. All rights reserved.
//

import UIKit

class CommentsVC: UIViewController {

    var selectedEffect: Effect?
    
    var dataService = DataService.instance
    var authService = AuthService.instance

    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        dataService.delegate = self
        
        if let effect = selectedEffect {
            nameLabel.text = effect.name
            dataService.getAllComments(for: effect)
            
        }
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
    }

    @IBAction func backButtonTapped(sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }

}

extension CommentsVC: DataServiceDelegate {
    func addLikes() {
    }
    
    func profileLoaded() {
    }
    
    func effectsLoaded() {
    }
    
    func commentsLoaded() {
        OperationQueue.main.addOperation {
            self.tableView.reloadData()
            print(self.dataService.comments)
        }
    }
    
    func theoriesLoaded() {
    }
    
    func theoryCommentsLoaded() {
    }
}

extension CommentsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataService.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as? CommentCell {
            cell.configureCell(comment: dataService.comments[indexPath.row])
            cell.backgroundColor = UIColor.clear
            return cell
        } else {
            return UITableViewCell()
        }
        
    }
    
}
