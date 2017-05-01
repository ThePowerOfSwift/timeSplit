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
    var profileImage: String?
    var website: String = ""
    var __v: Int?
    

    static func parseAccountJSONData(data: Data) -> Account {
        
        var myAccount = Account()
        
        do {
            
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            print(jsonResult)
            
            if let info = jsonResult as? [String:AnyObject] {
                
//                    for info in accountData {
                        var accountInfo = Account()
                        accountInfo.username = info["username"] as! String
                        accountInfo.id = info["_id"] as! String
                        accountInfo.name = info["name"] as! String
                        accountInfo.bio = info["bio"] as! String
                        accountInfo.website = info["website"] as! String
                        accountInfo.__v = info["__v"] as! Int
                        accountInfo.profileImage = info["profileImage"] as? String
                
                
                
                        
                
//                        myAccount.append(accountInfo)
                
//                        print(accountInfo.profileImage!)
                        print(accountInfo.username)
                        print(accountInfo.name)
                        print(accountInfo.bio)
                        print(accountInfo.website)
//                    }
                }
        } catch let err {
            print(err)
        }
        return myAccount
    }
    
    
    static func parseAccountsJSONData(data: Data) -> [Account] {
        var allAccounts = [Account]()
        
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            
            // Parse JSON Data
            
            if let accounts = jsonResult as? [Dictionary<String,AnyObject>] {
                
                for info in accounts {
                    var newAccount = Account()
                    newAccount.id = info["_id"] as! String
                    newAccount.name = info["name"] as! String
                    newAccount.bio = info["bio"] as! String
                    newAccount.username = info["username"] as! String
                    newAccount.website = info["website"] as! String
                    newAccount.profileImage = info["profileImage"] as? String
                    
                    
                    allAccounts.append(newAccount)
                }
            }
        } catch let err {
            print(err)
        }
        return allAccounts
    }
    
}
