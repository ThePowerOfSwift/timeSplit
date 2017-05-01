//
//  ProfileVC.swift
//  timeSplit
//
//  Created by Cory Billeaud on 3/21/17.
//  Copyright © 2017 Cory. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    
    
    @IBOutlet weak var editNameTF: UITextField!
    @IBOutlet weak var editBioTF: UITextField!
    @IBOutlet weak var editWebsiteTF: UITextField!
    
    var authService = AuthService.instance
    var defaults = UserDefaults.standard
    var logInVC: LogInVC?
    var DEFAULTS_ID = UserDefaults.standard.object(forKey: "DEFAULTS_ID")
    
    var account: Account?
    var selectedAccount: Account!
    var imageProfileData = Image()
    var imageArray = [Image]()
    var imagePath: String!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        authService.delegate = self
        configureUI()
        
        loadProfileImage()
        
        //Hide Autolayout Warning
        UserDefaults.standard.setValue(false, forKey:"_UIConstraintBasedLayoutLogUnsatisfiable")

    }
    
    func configureUI() {
        
        if let account = selectedAccount {
            bioLabel.text = account.bio
            nameLabel.text = account.name
            websiteLabel.text = account.website
            authService.fetchProfile(for: selectedAccount!)
            
            if selectedAccount!.profileImage != nil {
                self.loadImage(for: selectedAccount!.profileImage!)
            } else {
                return
            }
        }
    }
    
    func loadProfileImage() {
       
    if let filepath = Bundle.main.path(forResource: "\(self.imageProfileData.filename)", ofType: "png") {
        
//        let local = "Users/corybilleaud/desktop/projects/timesplit/timesplit-api/images/1493145179736"
//        
//        if let filepath = Bundle.main.path(forResource: local, ofType: "png") {
//        
//            print(filepath)
//
//            let contents = "\(filepath)"
//            self.profileImage.loadImageUsingCacheWithUrlString(contents)
//            print("This is the contents \(contents)")
//
        }
        
        
        let urlString = "https://firebasestorage.googleapis.com/v0/b/pokequest-d706a.appspot.com/o/profileImages%2FFHCmFa7NqGbnc5cIbr7sYxxE9o83%2FprofileImage?alt=media&token=4d4f100e-609e-4fe8-ab2a-024f8d1e6098"
        
        self.profileImage.loadImageUsingCacheWithUrlString(urlString)
        profileImage.applyCircleShadow()
        
    }
    
    func loadImage(for image: String) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        guard let URL = URL(string: "\(GET_PROFILE_IMAGE)/\(self.selectedAccount.profileImage!)") else { return }
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
                if (error == nil) {
                    // Success
                    let statusCode = (response as! HTTPURLResponse).statusCode
                    if let data = data {
                        print(data)
                        self.imageProfileData = Image.parseImageJSONData(data: data)
                        print(self.imageProfileData.path)
//                        self.profileImage.loadImageUsingCacheWithUrlString((self.imageProfileData?.path)!)
                        self.imagePath = self.imageProfileData.path
                        print(self.imagePath)
                        
                    }
                } else {
                    //Failure
                    print("URL Session Fetch Profile Image Data Failed: \(error!.localizedDescription)")
                }
            })
            
        task.resume()
        session.finishTasksAndInvalidate()
    }
    
    func showLogInVC() {
        logInVC = LogInVC()
        logInVC?.modalPresentationStyle = UIModalPresentationStyle.formSheet
        self.present(logInVC!, animated: true, completion: nil)
    }
    
    func UploadRequest() {
        
        let url = NSURL(string: POST_PROFILE_PHOTO)
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "POST"
        let boundary = generateBoundaryString()
        
        // define the multipart request type
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        if (profileImage.image == nil) { return }
        let image_data = UIImagePNGRepresentation(profileImage.image!)
        if (image_data == nil ) { return }
        
        let body = NSMutableData()
        let filename = "test.png"
        let mimetype = "image/png"
        
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"profile\"; filename=\"\(filename)\"\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append(image_data!)
        body.append("\r\n".data(using: String.Encoding.utf8)!)
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        
        request.httpBody = body as Data
        let session = URLSession.shared
        
        do {
            
            let task = try session.dataTask(with: request as URLRequest, completionHandler: {
                (data, response, error) in
                
                guard ((data) != nil), let _:URLResponse = response, error == nil else {
                    print("error")
                    return }
                
                if let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                { print(dataString) }
            })
            task.resume()
        }
    }
    
    @IBAction func selectPicture(sender: AnyObject) {
        let ImagePicker = UIImagePickerController()
        ImagePicker.delegate = self
        ImagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(ImagePicker, animated: true, completion: nil)
    }
    
    @IBAction func upload_request(sender: UIButton) {
        
        UploadRequest()
        
        let nameText = editNameTF.text ?? ""
        let bioText = editBioTF.text ?? ""
        let webText = editWebsiteTF.text ?? ""
        
        authService.updateProfile("\(selectedAccount.id)", name: nameText, bio: bioText, website: webText, completion: { Success in
            
            if Success {
                print("We have updated profile and/or profile Image")
            } else {
                self.showAlert(with: "Error", message: "An error occured updating your profile")
            }
        })
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }

    @IBAction func effectButtonTapped(sender: UIButton) {
        performSegue(withIdentifier: "ShowEffectVC", sender: self)
    }
    
    @IBAction func theoryButtonTapped(sender: UIButton) {
        performSegue(withIdentifier: "ShowTheoryVC", sender: self)
    }
    
    @IBAction func profilesButtonTapped(sender: UIButton) {
        performSegue(withIdentifier: "ShowProfilesVC", sender: self)
    }
    
    @IBAction func infoButtonTapped(sender: UIButton) {
        performSegue(withIdentifier: "ShowInfoVC", sender: self)
    }
    
    func showAlert(with title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Error", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension ProfileVC: AuthServiceDelegate {
    func getAll() {
    }

    func loadMe() {
//        dump(authService.myAccount)
    }
}

extension ProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        profileImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        profileImage.contentMode = .scaleAspectFill
        profileImage.applyCircleShadow()
        self.dismiss(animated: true, completion: nil)
    }
    
}







