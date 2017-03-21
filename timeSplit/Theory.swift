//
//  Theory.swift
//  timeSplit
//
//  Created by Cory Billeaud on 3/16/17.
//  Copyright © 2017 Cory. All rights reserved.
//

import Foundation

class Theory {
    
    var id: String = ""
    var title: String = ""
    var description: String = ""
    var createdBy: String = ""
    var likes: Int!
    var commentNumber: Int!
    
    static func parseTheoryJSONData(data: Data) -> [Theory] {
        var allTheories = [Theory]()
        var commentsNumber = [TheoryComment]()
        
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            
            // Parse JSON Data
            if let theories = jsonResult as? [Dictionary<String, AnyObject>] {
                for theory in theories {
                    
                    var newTheory = Theory()
                    newTheory.id = theory["_id"] as! String
                    newTheory.title = theory["title"] as! String
                    newTheory.description = theory["description"] as! String
                    newTheory.createdBy = theory["createdBy"] as! String
                    newTheory.likes = theory["likes"] as! Int
                    
                    newTheory.commentNumber = theory["comments"]!.count as! Int
                    
                    allTheories.append(newTheory)
                }
            }
        } catch let err {
            print(err)
        }
        return allTheories
    }
    
    func adjustLikes(_ addLike:Bool) {
        if addLike {
            likes = likes + 1
        } else {
            likes = likes - 1
        }
        
    }

}
