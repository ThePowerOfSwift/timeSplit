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

    static func parseAccountJSONData(data: Data) -> Account {
        
        var account = [Account]()
        
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            
            // Parse JSON data
            if let accountArray = jsonResult as? [Dictionary<String, Any>] {
                for details in accountArray {
                    
                    var info = Account()
                    info.id = details["_id"] as! String
                    info.username = details["username"] as! String
                    
                    account.append(info)
                }
            }
        } catch let err {
            print(err)
        }
        return account
    }
}
