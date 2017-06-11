//
//  BackendModel.swift
//  Chimehack-Mobile
//
//  Created by James Lennon on 6/10/17.
//  Copyright © 2017 James Lennon. All rights reserved.
//

import UIKit
import Alamofire

class BackendModel {
    
    public static let sharedInstance = BackendModel()
    
    private var _friends : [Friend]? = nil
    
    public func load() {
        
        getFriends { (list) in
            self._friends = list
        }
        
    }
    
    public func uploadImage(image: UIImage, callback: ()->()) {
        
        callback()
    }
    
    public func getUserScore(callback: (Int?)->()) {
        
        callback(17)
    }
    
    public func getFriends(callback: ([Friend]?)->()) {
        
        callback([
            Friend(name: "Eli", score: 3),
            Friend(name: "Jenny", score: 5),
            Friend(name: "Madhav", score: 4),
            Friend(name: "Dan", score: 6)
            ])
    }
}
