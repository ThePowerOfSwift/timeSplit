//
//  AddTheoryCommentVC.swift
//  timeSplit
//
//  Created by Cory Billeaud on 3/16/17.
//  Copyright © 2017 Cory. All rights reserved.
//

import UIKit

class AddTheoryCommentVC: UIViewController {
    
    var selectedTheory: Theory?
    var commentBy: String!
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var commentTitleTextField: UITextField!
    @IBOutlet weak var commentTextView: UITextView!
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let theory = selectedTheory {
            headerLabel.text = theory.title
        } else {
            headerLabel.text = "Error"
        }
        commentBy = defaults.value(forKey: DEFAULTS_EMAIL) as! String

    }
    
    @IBAction func addCommentTapped(sender: UIButton) {
        guard let theory = selectedTheory else {
            showAlert(with: "Error", message: "Could not get selected Theory")
            return
        }
        guard let title = commentTitleTextField.text, commentTitleTextField.text != "" else {
            showAlert(with: "Error", message: "Please enter a title for your Comment")
            return
        }
        guard let commentText = commentTextView.text, commentTextView.text != "" else {
            showAlert(with: "Error", message: "Please enter comment about this Theory")
            return
        }
        DataService.instance.addNewTheoryComment(theory.id, title: title, text: commentText, commentBy: commentBy, completion: { Success in
            if Success {
                print("We saved Successfully")
                DataService.instance.getAllTheoryComments(for: theory)
                self.dismissViewController()
            } else {
                self.showAlert(with: "Error", message: "An error occured saving the new comment")
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

