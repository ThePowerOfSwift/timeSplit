//
//  Comment.swift
//  timeSplit
//
//  Created by Cory Billeaud on 3/13/17.
//  Copyright © 2017 Cory. All rights reserved.
//

import Foundation

class EffectComment {
    
    var id: String = ""
    var title: String = ""
    var text: String = ""
    var commentBy: String = ""
    
    static func parseCommentJSONData(data: Data) -> [EffectComment] {
        var effectComments = [EffectComment]()
        
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            
            // Parse JSON data
            if let comments = jsonResult as? [Dictionary<String, AnyObject>] {
                for comment in comments {
                    
                    var newComment = EffectComment()
                    newComment.id = comment["_id"] as! String
                    newComment.title = comment["title"] as! String
                    newComment.text = comment["text"] as! String
                    newComment.commentBy = comment["commentBy"] as! String
                    
                    effectComments.append(newComment)
                }
            }
        } catch let err {
            print(err)
        }
        return effectComments
    }
}
