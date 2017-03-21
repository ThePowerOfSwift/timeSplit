//
//  AddCommentVC.swift
//  timeSplit
//
//  Created by Cory Billeaud on 3/14/17.
//  Copyright © 2017 Cory. All rights reserved.
//

import UIKit

class AddCommentVC: UIViewController {

    var selectedEffect: Effect?
    var commentBy: String!
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var commentTitleTextField: UITextField!
    @IBOutlet weak var commentTextView: UITextView!
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let effect = selectedEffect {
            headerLabel.text = effect.name
        } else {
            headerLabel.text = "Error"
        }
        commentBy = defaults.value(forKey: DEFAULTS_EMAIL) as! String
    }
    
    @IBAction func addCommentTapped(sender: UIButton) {
        guard let effect = selectedEffect else {
            showAlert(with: "Error", message: "Could not get selected Effect")
            return
        }
        guard let title = commentTitleTextField.text, commentTitleTextField.text != "" else {
            showAlert(with: "Error", message: "Please enter a title for your Comment")
            return
        }
        
        guard let commentText = commentTextView.text, commentTextView.text != "" else {
            showAlert(with: "Error", message: "Please enter a Comment about this Effect")
            return
        }
        DataService.instance.addNewComment(effect.id, title: title, text: commentText, commentBy: commentBy, completion: { Success in
            if Success {
                print("We saved successfully")
                DataService.instance.getAllComments(for: effect)
                self.dismissViewController()
            } else {
                self.showAlert(with: "Error", message: "An error occured saving the new Comment")
                print("Save was unsuccessful")
            }
        })
    }

    @IBAction func cancelButtonTapped(sender: UIButton) {
        dismissViewController()
        }
    
    func dismissViewController() {
        OperationQueue.main.addOperation {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    func showAlert(with title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Error", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

}
