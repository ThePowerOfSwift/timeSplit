//
//  AddEffectVC.swift
//  timeSplit
//
//  Created by Cory Billeaud on 3/14/17.
//  Copyright © 2017 Cory. All rights reserved.
//

import UIKit

class AddEffectVC: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var categoryField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var effectDateField: UITextField!
    
    var submittedBy = AuthService.instance.email!
    var imagePicked = 0
    var likes = 0

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func addButtonTapped(sender: UIButton) {
        guard let name = nameField.text, nameField.text != "" else {
            showAlert(with: "Error", message: "Please enter a name")
            return
        }
        guard let category = categoryField.text, categoryField.text != "" else {
            showAlert(with: "Error", message: "Please enter a category")
            return
        }
        guard let  desc = descriptionField.text, descriptionField.text != "" else {
            showAlert(with: "Error", message: "Please enter a description on the Mandela Effect")
            return
        }
        guard let effectDate = effectDateField.text, effectDateField.text != "" else {
            showAlert(with: "Error", message: "Please enter an approximate date of the original")
            return
        }
        DataService.instance.addNewEffect(name, category: category, description: desc, effectedDate: effectDate, submittedBy: submittedBy, likes: likes, completion: { Success in
            if Success {
                print("We saved successfully")
                self.dismissViewController()
            } else {
                self.showAlert(with: "Error", message: "An error occured saving the new Mandela Effect")
                print("We didn't save successfully")
            }
        })
    }
    
    @IBAction func loadImageBtn(_ sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
            imagePicked = sender.tag
        }
    }

    
    @IBAction func cancelButtonTapped(sender: UIButton) {
        dismissViewController()
    }
    
    @IBAction func backButtonTapped(sender: UIButton) {
        dismissViewController()
    }
  
    func dismissViewController() {
        OperationQueue.main.addOperation {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    func showAlert(with title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
}

extension AddEffectVC:  UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
//        if imagePicked == 1 {
//            imagePicked01.image = image
//            imagePicked01.contentMode = .scaleToFill
//            imagePicked01.layer.borderWidth = 2
//            imagePicked01.layer.borderColor = UI.Color.white.cgcolor
//            imagePicked01.clipsToBounds = true
//        } else if imagePicked == 2 {
//            imagePicked02.image = image
//            imagePicked02.contentMode = .scaleToFill
//            imagePicked02.layer.borderWidth = 2
//            imagePicked02.layer.borderColor = UI.Color.white.cgcolor
//            imagePicked02.clipsToBounds = true
//        }
//        dismiss(animated: true, completion: nil)
//    }
    
    
}
