//
//  Profile.swift
//  timeSplit
//
//  Created by Cory Billeaud on 3/24/17.
//  Copyright © 2017 Cory. All rights reserved.
//

import Foundation

class Profile {
    
    var account: String = ""
    var id: String = ""
    var name: String = ""
    var bio: String = ""
    var profileImageURL: String = ""
    var commentNumber: Int!
    
    static func parseProfileJSONData(data: Data) -> [Profile] {
        
        var userProfile = [Profile]()
        
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            
            // Parse JSON data
            if let profile = jsonResult as? [Dictionary<String, Any>] {
                for profileDets in profile {
                    
                    var user = Profile()
                    user.account = profileDets["account"] as! String // accounts._id????
                    user.id = profileDets["_id"] as! String
                    user.name = profileDets["name"] as! String
                    user.bio = profileDets["bio"] as! String
                    user.profileImageURL = profileDets["profileImageURL"] as! String
                    user.commentNumber = profileDets["comments"] as! Int
                   
                    userProfile.append(user)
                }
            }
        } catch let err {
            print(err)
        }
        return userProfile
    }
}
