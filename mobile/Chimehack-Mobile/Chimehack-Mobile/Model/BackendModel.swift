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
    
    
    private let UPLOAD_URL = "https://39a34bb3.ngrok.io/api/ios/image_recognition"
    
    private var _friends : [Friend]? = nil
    
    public func load() {
        
        getFriends { (list) in
            self._friends = list
        }
        
    }
    
    private func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    public func uploadImage(image: UIImage, callback: (String)->()) {
        
        let imageData:Data = UIImagePNGRepresentation(resizeImage(image: image, newWidth: 600))!
        let strBase64:String = imageData.base64EncodedString()
        
        print(strBase64)
        
        let data = ["media_url" : strBase64, "target_language": LanguageModel.sharedInstance.userLanguage()]
        
        Alamofire.request(UPLOAD_URL, method: .post, parameters: data).responseJSON { responseJSON in
            
            if let json = responseJSON.result.value {
                print("JSON: \(json)")
            }
        }
        
        callback("ASDFASDF")
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
    
    public func sendChallenge(image: UIImage, word: String, friends: [String], callback: ()->()) {
        
        callback()
    }
}
