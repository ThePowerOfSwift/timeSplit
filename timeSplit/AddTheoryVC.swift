//
//  AddTheoryVC.swift
//  timeSplit
//
//  Created by Cory Billeaud on 3/16/17.
//  Copyright © 2017 Cory. All rights reserved.
//

import UIKit

class AddTheoryVC: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    
    var createdBy = AuthService.instance.email!
    var likes = 0

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func addButtonTapped(sender: UIButton) {
        guard let name = nameField.text, nameField.text != "" else {
            showAlert(with: "Error", message: "Please enter a Theory name")
            return
        }
        guard let desc = descriptionField.text, descriptionField.text != "" else {
            showAlert(with: "Error", message: "Please enter a Theory description")
            return
        }
        DataService.instance.addNewTheory(name, description: desc, createdBy: createdBy, likes: likes, completion: { Success in
            if Success {
                print("We saved Theory Successfully")
                self.dismissViewController()
            } else {
                self.showAlert(with: "Error", message: "An error occured saving the new Theory")
                print("We didn't save successfully")
            }
        })
    }
    
    @IBAction func cancelButtonTapped(sender: UIButton) {
        dismissViewController()
        
    }
    
    func dismissViewController() {
        OperationQueue.main.addOperation {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func showAlert(with title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

}
