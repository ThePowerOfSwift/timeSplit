//
//  Account.swift
//  timeSplit
//
//  Created by Cory Billeaud on 3/25/17.
//  Copyright © 2017 Cory. All rights reserved.
//

import Foundation

class Account {
    
    var id: String = ""
    var username: String = ""
    var name: String = ""
    var bio: String = ""
    var profileImageURL: String = ""
    var website: String = ""
    var __v: Int?
    
    static func parseAccountInfoJSONData(data: Data) -> Account {
        
        var myAccount = Account()
        
        do {
            
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            print(jsonResult)
            
            if let accountData = jsonResult as? [String:AnyObject] {
                    var accountInfo = Account()
                    accountInfo.username = (accountData["username"] as! String)
                    accountInfo.id = (accountData["_id"] as! String)
                    accountInfo.name = (accountData["name"] as! String)
                    accountInfo.bio = (accountData["bio"] as! String)
                    accountInfo.profileImageURL = (accountData["profileImageURL"] as! String)
                    accountInfo.website = (accountData["website"] as! String)
                    
                
                    print("This is your account USER_ID \(accountInfo.id)")
            }
        } catch let err {
            print(err)
        }
        return myAccount
    }
    
    
    static func parseAccountJSONData(data: Data) -> [Account] {
        
        var myAccount = [Account]()
        
        do {
            
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            print(jsonResult)
            
            if let accountData = jsonResult as? [Dictionary<String,AnyObject>] {
                for info in accountData {
                    var accountInfo = Account()
                    accountInfo.username = info["username"] as! String
                    accountInfo.id = info["_id"] as! String
                    accountInfo.name = info["name"] as! String
                    accountInfo.bio = info["bio"] as! String
                    accountInfo.profileImageURL = info["profileImageURL"] as! String
                    accountInfo.website = info["website"] as! String
                    accountInfo.__v = info["__v"] as! Int
                    
                    myAccount.append(accountInfo)
                    
                    print("This is your account USER_ID \(accountInfo.id)")
                    
                } // else // { return }
            }
        } catch let err {
            print(err)
        }
        return myAccount
    }
    
//    func requestData(completion: ((_ data: Data) -> Void)) {
//        
//        let data = Account.parseAccountJSONData(data: Account.)
//        
//    }

    
//    
//    static func parseAccountJSONData(data: Data) -> [Account] {
//        
//        var myAccount = [Account]()
//        
//        do {
//            
//            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
//            print(jsonResult)
//            
//            if let accountData = jsonResult as? [Dictionary<String,AnyObject>] {
//                for info in accountData {
//                    var accountInfo = Account()
//                    accountInfo.username = info["username"] as! String
//                    accountInfo.id = info["_id"] as! String
//                    accountInfo.name = info["name"] as! String
//                    accountInfo.bio = info["bio"] as! String
//                    accountInfo.profileImageURL = info["profileImageURL"] as! String
//                    accountInfo.website = info["website"] as! String
//                    accountInfo.__v = info["__v"] as! Int
//                
////                    myAccount.append(accountInfo)
//                
//                print("This is your account USER_ID \(accountInfo.id)")
//                
//                } // else // { return }
//            }
//        } catch let err {
//            print(err)
//        }
//        return myAccount
//    }
}
