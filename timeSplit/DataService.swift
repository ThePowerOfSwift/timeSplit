//
//  DataService.swift
//  timeSplit
//
//  Created by Cory Billeaud on 3/13/17.
//  Copyright © 2017 Cory. All rights reserved.
//

import Foundation

protocol DataServiceDelegate: class {
    func effectsLoaded()
    func commentsLoaded()
    func theoriesLoaded()
    func theoryCommentsLoaded()
    func addLikes()
}

class DataService {
    static let instance = DataService()
    
    weak var delegate: DataServiceDelegate?
    var effects = [Effect]()
    var comments = [EffectComment]()
    var theories = [Theory]()
    var theoriesComments = [TheoryComment]()
//    var likes = [Effect]()

    
// ---- EFFECTS
    // GET all effects
    func getAllEffects() {
        let sessionConfig = URLSessionConfiguration.default
        
        // Create session, and optionally set a URLSessionDelegate
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        // Create the request
        // Get all effects (GET /api/v1/effect)
        guard let URL = URL(string: GET_ALL_EF_URL) else { return }
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if (error == nil) {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("URL Session Task Succeeded: HTTP \(statusCode)")
                if let data = data {
                    self.effects = Effect.parseEffectJSONData(data: data)
                    self.delegate?.effectsLoaded()
                }
            }
            else {
                // Failure
                print("URL Session Task Failed: \(error!.localizedDescription)")
            }
        })
        task.resume()
        session.finishTasksAndInvalidate()
    }
    
    // GET all comments for a specific effect
    func getAllComments(for effect: Effect) {
        let sessionConfig = URLSessionConfiguration.default
        
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        guard let URL = URL(string: "\(GET_ALL_EF_Comments)/\(effect.id)") else { return }
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if (error == nil) {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("URL Session Task Succeeded: HTTP \(statusCode)")
                // Parase JSON data
                if let data = data {
                    self.comments = EffectComment.parseCommentJSONData(data: data)
                    self.delegate?.commentsLoaded()
                }
            } else {
                // Failure
                print("URL Session Task Failed: \(error!.localizedDescription)")
            }
        })
        task.resume()
        session.finishTasksAndInvalidate()
    }
    
    // PUT a new like
    func addLikes(_ effectId: String, likes: Int, completion: @escaping callback) {
        
        let json: [String: Any] = [
        
        "effect": effectId,
        "likes": likes
        ]
        
        do {
            // Serialize JSON
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            let sessionConfig = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
            guard let URL = URL(string: "\(PUT_ADD_NEW_EF_LIKE)/\(effectId)") else { return }
            var request = URLRequest(url: URL)
            request.httpMethod = "PUT"
            
            guard let token = AuthService.instance.authToken else {
                completion(false)
                return
            }
            
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
                if (error == nil) {
                    // Success
                    // Check fpr status code 200 here. If It's not 200, then
                    // authentication was not successful. It if is we're done
                    let statusCode = (response as! HTTPURLResponse).statusCode
                    print("URL Session Task Succeeded: HTTP: \(statusCode)")
                    if statusCode != 200 {
                        completion(false)
                        return
                    } else {
                        completion(true)
                    }
                } else {
                    // Failure
                    print("URL Session Task Failed: \(error!.localizedDescription)")
                    completion(false)
                }
            })
            task.resume()
            session.finishTasksAndInvalidate()
            
        } catch let err {
            completion(false)
            print(err)
        }
    }
    
    
    // POST add a new effect
    func addNewEffect(_ name: String, category: String, description: String, effectedDate: String, submittedBy: String, likes: Int, completion: @escaping callback) {
        
        // Construct our JSON
        let json: [String: Any] = [
            "name": name,
            "category": category,
            "description": description,
            "effectedDate": effectedDate,
            "submittedBy": submittedBy,
            "likes": likes
            ]
        
        do {
            // Serialize JSON
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            
            let sessionConfig = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
            
            guard let URL = URL(string: POST_ADD_NEW_EFFECT) else { return }
            var request = URLRequest(url: URL)
            request.httpMethod = "POST"
            
            guard let token = AuthService.instance.authToken else {
                completion(false)
                return
            }
            
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
                if (error == nil) {
                    // Success
                    // Check for status code 200 here. If it's not 200, then
                    // authentication was not successful. If it is, we're done
                    let statusCode = (response as! HTTPURLResponse).statusCode
                    print("URL Session Task Succeeded: HTTP: \(statusCode)")
                    if statusCode != 200 {
                        completion(false)
                        return
                    } else {
                        self.getAllEffects()
                        completion(true)
                    }
                } else {
                    // Failure
                    print("URL Session Task Failed: \(error!.localizedDescription)")
                    completion(false)
                }
            })
            task.resume()
            session.finishTasksAndInvalidate()
            
        } catch let err {
            completion(false)
            print(err)
        }
    }
    
    // POST an image from effect
//    func uploadImage(_ imageName: String, completion: @escaping callback) {
//        
//        do {
//            let sessionConfig = URLSessionConfiguration.default
//            let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
//            
//            guard let URL = URL(string: "\(POST_UPLOAD_IMAGE)/\(imageName)") else { return }
//            var request = URLRequest(url: URL)
//            request.httpMethod = "POST"
//            
//            guard let token = AuthService.instance.authToken else {
//                completion(false)
//                return
//            }
//            
//            let boundary = generateBoundaryString()
//            
//            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//            request.addValue("multipart/form-data, boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//            
//            var body = NSMutableData()
//            if data.count > 0 {
//                for(key, value) in data {
//                    body.app
//                }
//            }
//            
//        } catch let err {
//            print(err)
//            completion(false)
//        }
//        
//    }
    
    // POST add a new effect comment
    func addNewComment(_ effectId: String, title: String, text: String, commentBy: String, completion: @escaping callback) {
        
        let json: [String: Any] = [
            "title": title,
            "text": text,
            "commentBy": commentBy,
            "effect": effectId
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            let sessionConfig = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
            
            guard let URL = URL(string: "\(POST_ADD_NEW_COMMENT)/\(effectId)") else { return }
            var request = URLRequest(url: URL)
            request.httpMethod = "POST"
            
            guard let token = AuthService.instance.authToken else {
                completion(false)
                return
            }
            
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
                if (error == nil) {
                    // Success
                    let statusCode = (response as! HTTPURLResponse).statusCode
                    print("URL Session Task Succeeded: HTTP \(statusCode)")
                    if statusCode != 200 {
                        completion(false)
                        return
                    } else {
                        completion(true)
                    }
                } else {
                    // Failure
                    print("URL Session Task Failed: \(error!.localizedDescription)")
                    completion(false)
                }
            })
            task.resume()
            session.finishTasksAndInvalidate()
            
        } catch let err {
            print(err)
            completion(false)
        }
    }
    
// --- THEORIES
    // GET all theories
    func getAllTheories() {
        let sessionConfig = URLSessionConfiguration.default
        
        // Create session, and optionally set a URLSessionDelegate
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        // Create the request
        // Get all theories (GET /api/v1/theory)
        guard let URL = URL(string: GET_ALL_TH_URL) else { return }
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if (error == nil) {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("URL Session Task Succeeded: HTTP \(statusCode)")
                if let data = data {
                    self.theories = Theory.parseTheoryJSONData(data: data)
                    self.delegate?.theoriesLoaded()
                }
            }
            else {
                // Failure
                print("URL Session Task Failed: \(error!.localizedDescription)")
            }
        })
        task.resume()
        session.finishTasksAndInvalidate()
    }

    // GET all comments for a specific theory
    func getAllTheoryComments(for theory: Theory) {
        let sessionConfig = URLSessionConfiguration.default
        
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        guard let URL = URL(string: "\(GET_ALL_TH_Comments)/\(theory.id)") else { return }
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if (error == nil) {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("URL Session Task Succeeded: HTTP \(statusCode)")
                // Parase JSON data
                if let data = data {
                    self.theoriesComments = TheoryComment.parseCommentJSONData(data: data)
                    self.delegate?.theoryCommentsLoaded()
                }
            } else {
                // Failure
                print("URL Session Task Failed: \(error!.localizedDescription)")
            }
        })
        task.resume()
        session.finishTasksAndInvalidate()
    }

    // POST add a new theory
    func addNewTheory(_ title: String, description: String, createdBy: String, likes: Int, completion: @escaping callback) {
        
        // Construct our JSON
        let json: [String: Any] = [
            "title": title,
            "description": description,
            "createdBy": createdBy,
            "likes": likes
        ]
        
        do {
            // Serialize JSON
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            
            let sessionConfig = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
            
            guard let URL = URL(string: POST_ADD_NEW_THEORY) else { return }
            var request = URLRequest(url: URL)
            request.httpMethod = "POST"
            
            guard let token = AuthService.instance.authToken else {
                completion(false)
                return
            }
            
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
                if (error == nil) {
                    // Success
                    // Check for status code 200 here. If it's not 200, then
                    // authentication was not successful. If it is, we're done
                    let statusCode = (response as! HTTPURLResponse).statusCode
                    print("URL Session Task Succeeded: HTTP: \(statusCode)")
                    if statusCode != 200 {
                        completion(false)
                        return
                    } else {
                        self.getAllTheories()
                        completion(true)
                    }
                } else {
                    // Failure
                    print("URL Session Task Failed: \(error!.localizedDescription)")
                    completion(false)
                }
            })
            task.resume()
            session.finishTasksAndInvalidate()
            
        } catch let err {
            completion(false)
            print(err)
        }
    }
    
    // POST add a new theory comment
    func addNewTheoryComment(_ theoryId: String, title: String, text: String, commentBy: String, completion: @escaping callback) {
        
        let json: [String: Any] = [
            "title": title,
            "text": text,
            "commentBy": commentBy,
            "theory": theoryId
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            let sessionConfig = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
            
            guard let URL = URL(string: "\(POST_ADD_NEW_THEORY_COMMENT)/\(theoryId)") else { return }
            var request = URLRequest(url: URL)
            request.httpMethod = "POST"
            
            guard let token = AuthService.instance.authToken else {
                completion(false)
                return
            }
            
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
                if (error == nil) {
                    // Success
                    let statusCode = (response as! HTTPURLResponse).statusCode
                    print("URL Session Task Succeeded: HTTP \(statusCode)")
                    if statusCode != 200 {
                        completion(false)
                        return
                    } else {
                        completion(true)
                    }
                } else {
                    // Failure
                    print("URL Session Task Failed: \(error!.localizedDescription)")
                    completion(false)
                }
            })
            task.resume()
            session.finishTasksAndInvalidate()
            
        } catch let err {
            print(err)
            completion(false)
        }
    }

    // POST add a profile
    func addProfile(_ profileId: String, bio: String, profileImageURL: String, email: String, completion: @escaping callback) {
        
        let json: [String: Any] = [
        
            "profileId": profileId,
            "bio": bio,
            "profileImageURL": profileImageURL,
            "email": "\(AuthService.instance.email!)"
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            let sessionConfig = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
            
            guard let URL = URL(string: "\(POST_PROFILE)/add") else { return }
            var request = URLRequest(url: URL)
            request.httpMethod = "POST"
            
            guard let token = AuthService.instance.authToken else {
                completion(false)
                return
            }
            
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
                if (error == nil) {
                    // Success
                    let statusCode = (response as! HTTPURLResponse).statusCode
                    print("URL Session Task Succeeded: HTTP \(statusCode)")
                    if statusCode != 200 {
                        completion(false)
                        return
                    } else {
                        completion(true)
                    }
                } else {
                    //Failure
                    print("URL Session Task Failed: \(error!.localizedDescription)")
                    completion(false)
                }
            })
            task.resume()
            session.finishTasksAndInvalidate()
            
        } catch let err {
            print(err)
            completion(false)
        }
    }
    
    
    // UPLOAD add a photo for effect
    func UploadRequest(_ theoryId: String, URLString: String, completion: @escaping callback) {
        
        let json: [String: Any] = [
            
            "URLString": URLString,
            "theory": theoryId
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            let sessionConfig = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
            
            guard let URL = URL(string: "\(POST_UPLOAD_IMAGE)/\(theoryId)") else { return }
            var request = URLRequest(url: URL)
            request.httpMethod = "POST"
            
            let boundary = generateBoundaryString()
            guard let token = AuthService.instance.authToken else {
                completion(false)
                return
            }
            
            // define the multipart type
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            let body = NSMutableData()
            let fname: String!
            let mimetype = "image/png"
            
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition:form-data; name=\"test\"\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append(image-data!)
            body.append("\r\n".data(using: String.Encoding.ut8)!)
            body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
            request.httpBody = body as Data
            
            let session = URLSession.shared
            let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
                guard ((data) != nil), let _:URLResponse = response, error == nil else {
                    print("error")
                    return
                }
                
                if let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) {
                    print(dataString)
                }
            })
            task.resume()
            session.finishTasksAndInvalidate()
            
        } catch let err {
            print(err)
            completion(false)
            
        }
    }
    
    // Convert String for upload
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID()).uuidString"
    }
    
}







