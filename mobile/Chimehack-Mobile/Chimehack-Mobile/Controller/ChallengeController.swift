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
    
    private var image : UIImage! = nil
    
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
        image = UIImage(data: dataDecoded)

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
        
        view.addSubview(sendButton)
        sendButton.setTitle("Send", for: .normal)
        sendButton.backgroundColor = UIColor.red
        sendButton.setTitleColor(UIColor.white, for: .normal)
        sendButton.addTarget(self, action: #selector(sendPressed), for: .touchUpInside)
        let ht : CGFloat = 60 - 2 * 3
        sendButton.frame = CGRect(x: view.frame.width - 70 - 3, y: view.frame.height - 3 - ht, width: 70, height: ht)
//        sendButton.snp.makeConstraints { (make) in
//            make.top.equalTo(typingBar).inset(3)
//            make.bottom.equalTo(view).inset(3)
//            make.right.equalTo(typingBar).inset(3)
//            make.width.equalTo(70)
//        }
    }
    
    func keyboardNotification(notification: Notification) {
        
        if let userInfo = notification.userInfo {
            
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            
            UIView.animate(withDuration: 0.25, animations: {
                if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                    self.typingBar.frame.origin.y = 0.0 - 60
                    self.sendButton.frame.origin.y = -60
                } else {
                    self.typingBar.frame.origin.y = self.view.frame.height - (endFrame?.size.height ?? 0.0) - 60
                    self.sendButton.frame.origin.y = self.view.frame.height - (endFrame?.size.height ?? 0.0) - 60 + 3
                }
            }, completion: { success in
//                self.sendButton.snp.updateConstraints({ (make) in
//                    make.bottom.equalTo(self.view).offset(-(endFrame?.size.height ?? 0.0) - 63)
//                })
//                self.sendButton.snp.remakeConstraints { (make) in
//                    make.top.bottom.equalTo(self.typingBar).inset(3)
//                    make.right.equalTo(self.typingBar).inset(3)
//                    make.width.equalTo(70)
//                }
            })
            
            
            
            
        }
    }
    
    func sendPressed() {
        
        sendButton.isEnabled = false
        
        BackendModel.sharedInstance.confirmChallenge(challengeId: challenge.challengeID) {
            
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
            
        }
        
    }
    
}
