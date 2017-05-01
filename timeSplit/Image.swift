//
//  Image.swift
//  timeSplit
//
//  Created by Cory Billeaud on 4/4/17.
//  Copyright © 2017 Cory. All rights reserved.
//

import Foundation

class Image {
    
    var id: String = ""
    var fieldname: String = ""
    var originalname: String = ""
    var encoding: String = ""
    var mimetype: String = ""
    var destination: String = ""
    var filename: String = ""
    var path: String = ""
    var size: Int!
    var created_at: Date!
    var updated_at: Date!

    
    func fullPath() -> String {
        return "\(path).\(mimetype)"
    }
    
    
    static func parseImageJSONData(data: Data) -> Image {
        
        var myProfilePhoto = Image()
        
        do {
            
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            print(jsonResult)
            
            if let data = jsonResult as? [String:AnyObject] {
                
                    var imageData = Image()
                    imageData.id = data["_id"] as! String
                    imageData.path = data["path"] as! String
                    
                    print(imageData.path)
                    print(imageData.id)
                    
                }
            
        } catch let err {
            print(err.localizedDescription)
        }
        return myProfilePhoto
    }
    
}

