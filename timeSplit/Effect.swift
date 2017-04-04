//
//  Effect.swift
//  timeSplit
//
//  Created by Cory Billeaud on 3/13/17.
//  Copyright © 2017 Cory. All rights reserved.
//

import Foundation

class Effect {
    
    var id: String = ""
    var name: String = ""
    var category: String = ""
    var desc: String = ""
    var effectedDate: String = ""
    var likes: Int!
    var submittedBy: String = ""
    var commentNumber: Int!

    
    static func parseEffectJSONData(data: Data) -> [Effect] {
        var mEffects = [Effect]()
        var commentsNumber = [EffectComment]()

        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            
            // Parse JSON Data
            if let effects = jsonResult as? [Dictionary<String, AnyObject>] {
                for effect in effects {
                    var newEffect = Effect()
                    newEffect.id = effect["_id"] as! String
                    newEffect.name = effect["name"] as! String
                    newEffect.category = effect["category"] as! String
                    newEffect.desc = effect["description"] as! String
                    newEffect.effectedDate = effect["effectedDate"] as! String
                    newEffect.submittedBy = effect["submittedBy"] as! String
                    newEffect.likes = effect["likes"] as! Int
                    newEffect.commentNumber = effect["comments"]!.count as! Int
                    
                    mEffects.append(newEffect)
                }
            }
        } catch let err {
            print(err)
        }
        return mEffects
    }
    
    func adjustLikes(_ addLike:Bool) {
        if addLike {
            likes = likes + 1
        } else {
            likes = likes - 1
        }
    
    }
}
