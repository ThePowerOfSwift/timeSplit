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
    var profileImage: Image?
    var website: String = ""
    var __v: Int?
    

    static func parseAccountJSONData(data: Data) -> Account {
        
        var myAccount = Account()
        
        do {
            
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            print(jsonResult)
            
//            if let accountData = jsonResult as? [Dictionary<String,AnyObject>] {
//            
//            for info in accountData {
//                var accountInfo = Account()
//                accountInfo.username = info["username"] as! String
//                accountInfo.id = info["_id"] as! String
//                accountInfo.name = info["name"] as! String
//                accountInfo.bio = info["bio"] as! String
//                //                    accountInfo.profileImage = info["profileImage"] as! Image
//                accountInfo.website = info["website"] as! String
//                accountInfo.__v = info["__v"] as! Int
//                
//                myAccount.append(accountInfo)


            if let info = jsonResult as? [String:AnyObject] {
                
//                    for info in accountData {
                        var accountInfo = Account()
                        accountInfo.username = info["username"] as! String
                        accountInfo.id = info["_id"] as! String
                        accountInfo.name = info["name"] as! String
                        accountInfo.bio = info["bio"] as! String
                        accountInfo.website = info["website"] as! String
                        accountInfo.__v = info["__v"] as! Int
                    
//                        myAccount.append(accountInfo)
                
//                        print(myAccount)
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

}
