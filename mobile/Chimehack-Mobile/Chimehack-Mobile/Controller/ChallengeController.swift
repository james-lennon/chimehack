//
//  ChallengeController.swift
//  Chimehack-Mobile
//
//  Created by James Lennon on 6/11/17.
//  Copyright © 2017 James Lennon. All rights reserved.
//

import UIKit
import SnapKit

class ChallengeControler: UIViewController {
    
    private let challenge : Challenge
    
    private let typingBar = UITextField()
    private let sendButton = UIButton()
    
    init(challenge: Challenge) {
        
        self.challenge = challenge
        
        super.init(nibName: nil, bundle: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let dataDecoded : Data = Data(base64Encoded: challenge.imageData, options: .ignoreUnknownCharacters)!
        let image = UIImage(data: dataDecoded)

        let imageView = UIImageView(image: image)
        view.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(view)
        }
        
        view.addSubview(typingBar)
        typingBar.backgroundColor = UIColor.white
        typingBar.placeholder = "Enter word here:"
        typingBar.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.height.equalTo(60)
        }
        
        typingBar.addSubview(sendButton)
        sendButton.setTitle("Send", for: .normal)
        sendButton.backgroundColor = UIColor.red
        sendButton.setTitleColor(UIColor.white, for: .normal)
        sendButton.addTarget(self, action: #selector(sendPressed), for: .touchUpInside)
        sendButton.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(typingBar).inset(3)
            make.right.equalTo(typingBar).inset(3)
            make.width.equalTo(70)
        }
    }
    
    func keyboardNotification(notification: Notification) {
        
        if let userInfo = notification.userInfo {
            
            UIView.animate(withDuration: 0.25, animations: { 
                let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
                if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                    self.typingBar.frame.origin.y = 0.0 - 60
                } else {
                    self.typingBar.frame.origin.y = self.view.frame.height - (endFrame?.size.height ?? 0.0) - 60
                }
            })
            
        }
    }
    
    func sendPressed() {
        
        sendButton.isEnabled = false
        
//        BackendModel.sharedInstance.sendChallenge(image: <#T##UIImage#>, word: <#T##String#>, friends: <#T##[String]#>, callback: <#T##() -> ()#>)
        
    }
    
}
