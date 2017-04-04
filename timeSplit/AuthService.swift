//
//  AuthService.swift
//  timeSplit
//
//  Created by Cory Billeaud on 3/13/17.
//  Copyright © 2017 Cory. All rights reserved.
//

import Foundation

protocol AuthServiceDelegate: class {
    func loadMe()
}

class AuthService {
    static let instance = AuthService()
    weak var delegate: AuthServiceDelegate?
    var account = Account()
    var myAccount = [Account]()
    
    let defaults = UserDefaults.standard
    var DEFAULTS_ID = UserDefaults.standard.object(forKey: "DEFAULTS_ID")
    var _id: String?
    
    var isRegistered: Bool? {
        get {
            return defaults.bool(forKey: DEFAULTS_REGISTERED) == true
        }
        set {
            defaults.set(newValue, forKey: DEFAULTS_REGISTERED)
        }
    }
    
    var isAuthenticated: Bool? {
        get {
            return defaults.bool(forKey: DEFAULTS_AUTHENTICATED) == true
        }
        set {
            defaults.set(newValue, forKey: DEFAULTS_AUTHENTICATED)
        }
    }
    
    var email: String? {
        get {
            return defaults.value(forKey: DEFAULTS_EMAIL) as? String
        }
        set {
            defaults.set(newValue, forKey: DEFAULTS_EMAIL)
        }
    }
    
    var authToken: String? {
        get {
            return defaults.value(forKey: DEFAULTS_TOKEN) as? String
        }
        set {
            defaults.set(newValue, forKey: DEFAULTS_TOKEN)
        }
    }
    
    func registerUser(email: String, password: String, completion: @escaping callback) {
        
        let json = ["email": email, "password": password]
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        guard let URL = URL(string: POST_REGISTER_ACCT) else {
            isRegistered = false
            completion(false)
            return
        }
        
        var request = URLRequest(url: URL)
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            
            request.httpBody = try JSONSerialization.data(withJSONObject: json, options: [])
            
            let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
                if (error == nil) {
                    // Success
                    let statusCode = (response as! HTTPURLResponse).statusCode
                    print("URL Session Task Succeeded: HTTP \(statusCode)")
                    
                    // Check for status 200 or 409
                    if statusCode != 200 && statusCode != 409 {
                        self.isRegistered = false
                        completion(false)
                        return
                    } else {
                        self.isRegistered = true
                        completion(true)
                    }
                } else {
                    // Failure
                    print("URL Session Task Failed: \(error?.localizedDescription)")
                    completion(false)
                }
            })
            task.resume()
            session.finishTasksAndInvalidate()
            
        } catch let err {
            self.isRegistered = false
            completion(false)
            print(err)
        }
        
    }
    
    func logIn(email username: String, password: String, completion: @escaping callback) {
        let json = ["email": username, "password": password]
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        guard let URL = URL(string: POST_LOGIN_ACCT) else {
            isAuthenticated = false
            completion(false)
            return
        }
        
        var request = URLRequest(url: URL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: json, options: [])
            
            let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
                if (error == nil) {
                    // Success
                    let statusCode = (response as! HTTPURLResponse).statusCode
                    print("URL Session Task Succeeded: HTTP \(statusCode)")
                    if statusCode != 200 {
                        // Failed
                        completion(false)
                        return
                    } else {
                        guard let data = data else {
                            completion(false)
                            return
                        }
                        do {
                            let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Dictionary<String, AnyObject>
                            if result != nil {
                                if let email = result?["user"] as? String {
                                    if let token = result?["token"] as? String {
                                        // Successfully authenticated and have a token
                                        self.email = email
                                        self.authToken = token
                                        self.isRegistered = true
                                        self.isAuthenticated = true
                                        completion(true)
                                    } else {
                                        completion(false)
                                    }
                                } else {
                                    completion(false)
                                }
                            } else {
                                completion(false)
                            }
                        } catch let err {
                            completion(false)
                            print(err)
                        }
                    }
                } else {
                    // Failure
                    print("URL Task Failed: \(error!.localizedDescription)")
                    completion(false)
                    return
                }
            })
            task.resume()
            session.finishTasksAndInvalidate()
            
        } catch let err {
            completion(false)
            print(err)
        }
    }

    
    func fetchProfile(for id: String) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        guard let URL = URL(string: "\(GET_ACCOUNT_ID)/\(account.id)") else { return }
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
        
        let token = self.authToken
        request.addValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
        request.addValue("Content-Type", forHTTPHeaderField: "application-json")
        
        do {
            let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
                if (error == nil) {
                    // Success
                    let statusCode = (response as! HTTPURLResponse).statusCode
                    print("URL Session Task for fetching Account By ID Succeeded: HTTP \(statusCode) :Account info loaded" )
                    // Parse JSON Data
                    if let data = data {
                        self.myAccount = Account.parseAccountJSONData(data: data)
                        self.delegate?.loadMe()
                    }
                } else {
                    // Failure
                    print("URL Session Task Failed: \(error!.localizedDescription)")
                }
            })
            task.resume()
            session.finishTasksAndInvalidate()

        } catch let err {
            print(err)
        }
    }
    
    func fetchMyProfile() {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        guard let URL = URL(string: GET_ACCOUNT_BY_ID) else { return }
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
        
        let token = self.authToken
        request.addValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
        request.addValue("Content-Type", forHTTPHeaderField: "application-json")
        
        do {
            let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
                if (error == nil) {
                    // Success
                    let statusCode = (response as! HTTPURLResponse).statusCode
                    print("URL Session Task Succeeded: HTTP \(statusCode) :Account id loaded" )
                    // Parse JSON Data
                    if let data = data {
                        self.account = Account.parseAccountInfoJSONData(data: data)
                        self.delegate?.loadMe()
                    }
                } else {
                    // Failure
                    print("URL Session Task Failed: \(error!.localizedDescription)")
                }
            })
            task.resume()
            session.finishTasksAndInvalidate()
            
        } catch let err {
            print(err)
        }
    }
    
    func fetchMe() {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        guard let URL = URL(string: GET_ME) else { return }
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
        
        let token = self.authToken
        request.addValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
        request.addValue("Content-Type", forHTTPHeaderField: "application-json")
        
        do {
            let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
                if (error == nil) {
                    // Success
                    let statusCode = (response as! HTTPURLResponse).statusCode
                    print("URL Session Task Succeeded: HTTP \(statusCode) :Account id loaded")
                    // Parse JSON Data
                    if let data = data {
                        do {
                            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                                print(jsonResult)
                            if let myAccount = jsonResult as? [String:AnyObject] {
                                let _id = myAccount["id"] as! String
                                print(_id)
                                self._id = _id
                                self.DEFAULTS_ID = self.defaults.set(_id, forKey: "DEFAULTS_ID")
                                
                            }
                        } catch let err {
                            print(err)
                        }
                    }
                }
            })
            task.resume()
            session.finishTasksAndInvalidate()
            
        } catch let err {
            print(err)
        }
    }
    
}






