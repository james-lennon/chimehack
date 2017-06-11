//
//  Challenge.swift
//  Chimehack-Mobile
//
//  Created by James Lennon on 6/11/17.
//  Copyright © 2017 James Lennon. All rights reserved.
//

import UIKit

class Challenge {
    
    public let word : String
    public let imageData : String
    public let fromUser : String
    public let challengeID : String
    public let points : Int
    public let completed : Bool
    
    init(data: [String : Any]) {
        
        word = data["userLabel"] as? String ?? ""
        imageData = data["base64Image"] as? String ?? ""
        challengeID = (data["_id"] as? [String : String])?["$oid"] ?? ""
        completed = data["completed"] as? Bool ?? true
        points = data["points"] as? Int ?? 1
        fromUser = data["fromUser"] as? String ?? ""
        
        
    }
    
}
