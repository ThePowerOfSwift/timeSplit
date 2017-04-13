//
//  DetailVC.swift
//  timeSplit
//
//  Created by Cory Billeaud on 3/14/17.
//  Copyright © 2017 Cory. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {

    var selectedEffect: Effect?
    var logInVC: LogInVC?
    var dataService = DataService.instance
    var authService = AuthService.instance
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var userSubmittedLabel: UILabel!
    @IBOutlet weak var originalImage: UIImageView!
    @IBOutlet weak var effectImage: UIImageView!
    @IBOutlet weak var commentsNumberLabel: UILabel!
    @IBOutlet weak var likesHeart: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        nameLabel.text = selectedEffect?.name
        categoryLabel.text = selectedEffect?.category
        descLabel.text = selectedEffect?.desc
        dateLabel.text = selectedEffect?.effectedDate
        userSubmittedLabel.text = selectedEffect?.submittedBy
        commentsNumberLabel.text = "\(selectedEffect!.commentNumber!)"
        
        if let effect = selectedEffect {
            nameLabel.text = effect.name
            dataService.getAllComments(for: effect)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(DetailVC.likeTapped(_:)))
        tap.numberOfTapsRequired = 1
        likesHeart.addGestureRecognizer(tap)
        likesHeart.isUserInteractionEnabled = true
        
        //Hide Autolayout Warning
        UserDefaults.standard.setValue(false, forKey:"_UIConstraintBasedLayoutLogUnsatisfiable")
        
    }

    @IBAction func commentsButtonTapped(sender: UIButton) {
        performSegue(withIdentifier: "ShowCommentsVC", sender: self)
    }
    
    @IBAction func addCommentButtonTapped(sender: UIButton) {
        if authService.isAuthenticated == true {
            performSegue(withIdentifier: "ShowAddCommentVC", sender: self)
        } else {
            showLogInVC()
        }
    }
    
    @IBAction func backButtonTapped(sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func likeTapped(_ sender: UITapGestureRecognizer) {
    
    }
    
    func showLogInVC() {
        logInVC = LogInVC()
        logInVC?.modalPresentationStyle = UIModalPresentationStyle.formSheet
        self.present(logInVC!, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCommentsVC" {
            let destinationVC = segue.destination as! CommentsVC
            destinationVC.selectedEffect = selectedEffect
        } else if segue.identifier == "ShowAddCommentVC" {
            let destinationVC = segue.destination as! AddCommentVC
            destinationVC.selectedEffect = selectedEffect
        }
    }
}

extension DetailVC: DataServiceDelegate {
    func addLikes() {
    }

    func effectsLoaded() {
    }
    
    func theoriesLoaded() {
    }
    
    func commentsLoaded() {
    }
    
    func theoryCommentsLoaded() {
    }
}
