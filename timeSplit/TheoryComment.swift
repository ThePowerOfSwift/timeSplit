//
//  TheoryComment.swift
//  timeSplit
//
//  Created by Cory Billeaud on 3/16/17.
//  Copyright © 2017 Cory. All rights reserved.
//

import Foundation

class TheoryComment {
    
    var id: String = ""
    var title: String = ""
    var text: String = ""
    var commentBy: String = ""
    
    static func parseCommentJSONData(data: Data) -> [TheoryComment] {
        var theoryComments = [TheoryComment]()
        
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            
            // Parse JSON data
            if let comments = jsonResult as? [Dictionary<String, AnyObject>] {
                for comment in comments {
                    
                    var newComment = TheoryComment()
                    newComment.id = comment["_id"] as! String
                    newComment.title = comment["title"] as! String
                    newComment.text = comment["text"] as! String
                    newComment.commentBy = comment["commentBy"] as! String
                    
                    theoryComments.append(newComment)
                }
            }
        } catch let err {
            print(err)
        }
        return theoryComments
    }
}
