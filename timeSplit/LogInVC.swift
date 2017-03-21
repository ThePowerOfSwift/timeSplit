//
//  LogInVC.swift
//  timeSplit
//
//  Created by Cory Billeaud on 3/14/17.
//  Copyright © 2017 Cory. All rights reserved.
//

import UIKit

class LogInVC: UIViewController {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passTF: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func cancelButtonTapped(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginButtonTapped(sender: UIButton) {
        guard let email = emailTF.text, emailTF.text != "",
                let pass = passTF.text, passTF.text != ""
            else {
                self.showAlert(with: "Error", message: "Please enter an email and a password to continue")
                return
        }
        AuthService.instance.registerUser(email: email, password: pass, completion: { Success in
            if Success {
                AuthService.instance.logIn(email: email, password: pass, completion: { Success in
                    if Success {
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        OperationQueue.main.addOperation {
                            self.showAlert(with: "Error", message: "Incorrect Password")
                        }
                    }
                })
            } else {
                OperationQueue.main.addOperation {
                    self.showAlert(with: "Error", message: "An Unknown Error occured saving the account")
                }
            }
        })
    }
    
    func showAlert(with title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
        
    }



}
