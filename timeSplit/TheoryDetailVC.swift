//
//  TheoryDetailVC.swift
//  timeSplit
//
//  Created by Cory Billeaud on 3/16/17.
//  Copyright © 2017 Cory. All rights reserved.
//

import UIKit

class TheoryDetailVC: UIViewController {
    
    var selectedTheory: Theory?
    var logInVC: LogInVC?
    var dataService = DataService.instance
    var authService = AuthService.instance
    
    @IBOutlet weak var theoryNameLabel: UILabel!
    @IBOutlet weak var theoryDescLabel: UILabel!
    @IBOutlet weak var createdBy: UILabel!
    @IBOutlet weak var commentNumberLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let theory = selectedTheory {
            theoryNameLabel.text = selectedTheory?.title
            theoryDescLabel.text = selectedTheory?.description
            createdBy.text = selectedTheory?.createdBy
            commentNumberLabel.text = "\(selectedTheory!.commentNumber!)"
            dataService.getAllTheoryComments(for: theory)
        }
    }


    @IBAction func commentsButtonTapped(sender: UIButton) {
        performSegue(withIdentifier: "ShowTheoryCommentsVC", sender: self)
    }
    
    @IBAction func addCommentButtonTapped(sender: UIButton) {
        if authService.isAuthenticated ==  true {
            performSegue(withIdentifier: "ShowAddTheoryCommentVC", sender: self)
        } else {
            showLogInVC()
        }
    }

    func showLogInVC() {
        logInVC = LogInVC()
        logInVC?.modalPresentationStyle = UIModalPresentationStyle.formSheet
        self.present(logInVC!, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTheoryCommentsVC" {
            let destinationVC = segue.destination as! TheoryCommentsVC
            destinationVC.selectedTheory = selectedTheory
        } else if segue.identifier == "ShowAddTheoryCommentVC" {
            let destinationVC = segue.destination as! AddTheoryCommentVC
            destinationVC.selectedTheory = selectedTheory
        }
    }
}
