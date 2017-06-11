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
    private let CHALLENGE_URL = "https://39a34bb3.ngrok.io/challenge"
    private let SEND_URL = "https://39a34bb3.ngrok.io/challenge"
    
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
    
    public func uploadImage(image: UIImage, callback: @escaping ([String: Any])->()) {
        
        let imageData:Data = UIImagePNGRepresentation(resizeImage(image: image, newWidth: 100))!
        let strBase64:String = imageData.base64EncodedString()
        
//        print(strBase64)
        
        let data = ["media_url" : strBase64, "source_language" : LanguageModel.sharedInstance.userLanguage(), "target_language": LanguageModel.sharedInstance.learningLanguage()]
        
        Alamofire.request(UPLOAD_URL, method: .post, parameters: data).responseJSON { responseJSON in
            
            if let json = responseJSON.result.value as? [String : Any] {
                print("JSON: \(json)")
                
                callback(json)
            } else {
                callback(["word": "ERROR"])
            }
        }
        
        
    }
    
    public func getUserScore(callback: (Int?)->()) {
        
        callback(17)
    }
    
    public func username() -> String {
        return "james"
    }
    
    public func getFriends(callback: ([Friend]?)->()) {
        
        callback([
            Friend(name: "james", score: 17),
            Friend(name: "eli", score: 3),
            Friend(name: "jenny", score: 5),
            Friend(name: "dan", score: 6)
            ])
    }
    
    public func sendChallenge(image: UIImage, word: String, friends: [String], callback: @escaping ()->()) {
        
        var toStr = ""
        for (index, f) in friends.enumerated() {
            
            if index > 0 {
                toStr += ","
            }
            toStr += f
        }
        
        let imageData:Data = UIImagePNGRepresentation(resizeImage(image: image, newWidth: 100))!
        let strBase64:String = imageData.base64EncodedString()
        
        let data = ["fromUser" : username(), "toUsers": toStr, "userLabel": word, "base64Image": strBase64] as [String : Any]
        
        Alamofire.request(SEND_URL, method: .post, parameters: data).responseJSON { responseJSON in
            
            if let json = responseJSON.result.value as? [[String : Any]] {
                print("JSON: \(json)")
                
                callback()
            } else {
                callback()
            }
        }
    }
    
    public func getChallenges(callback: @escaping ([Challenge])->()) {
        
        let data = ["username" : username()]
        
        Alamofire.request(CHALLENGE_URL, method: .get, parameters: data).responseJSON { responseJSON in
            
            if let json = responseJSON.result.value as? [[String : Any]] {
                print("JSON: \(json)")
                
                let lst = json.map({ Challenge(data: $0) })
                
                callback(lst)
            } else {
                callback([])
            }
        }
        
    }
    
    public func confirmChallenge(challengeId: String, callback: ()->()) {
        
        callback()
    }
}
