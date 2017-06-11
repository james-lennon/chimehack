//
//  SendController.swift
//  Chimehack-Mobile
//
//  Created by James Lennon on 6/10/17.
//  Copyright © 2017 James Lennon. All rights reserved.
//

import UIKit

class SendController: UIViewController {
    
    private let SEND_HEIGHT : CGFloat = 70
    
    private let titleLabel = UILabel()
    private let backButton = UIButton()
    private let sendButton = UIButton()
    
    private var selectedFriends = Set<String>()
    
    private let image: UIImage
    private let word: String
    
    init(image: UIImage, word: String) {
        
        self.image = image
        self.word = word

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        view.addSubview(titleLabel)
        titleLabel.text = "Challenge Friends:"
        titleLabel.font = UIFont.systemFont(ofSize: 30)
        titleLabel.sizeToFit()
        titleLabel.snp.makeConstraints { (make) in
            make.size.equalTo(titleLabel)
            make.centerX.equalTo(view)
            make.top.equalTo(view).offset(40)
        }
        
        view.addSubview(backButton)
        backButton.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        backButton.addTarget(self, action: #selector(backPressed), for: .touchUpInside)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 40)
        backButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(20)
            make.left.equalTo(view).offset(20)
            make.top.equalTo(view).offset(40)
        }
        
        sendButton.backgroundColor = UIColor.red
        sendButton.setTitle("Send!", for: .normal)
        sendButton.setTitleColor(UIColor.white, for: .normal)
        sendButton.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)
        
        BackendModel.sharedInstance.getFriends { (friendList) in
            if let list = friendList {
                let friendViews = list.map({ (friend) -> FriendView in
                    let view = FriendView(friend: friend)
                    view.onTap = { selected in
                        self.friendTapped(friend: friend, selected: selected)
                    }
                    return view
                })
                
                DispatchQueue.main.async {
                    
                    let listView = ListView(subviewList: friendViews, componentHeight: 60)
                    self.view.addSubview(listView)
                    listView.snp.makeConstraints({ (make) in
                        make.left.right.equalTo(self.view)
                        make.top.equalTo(self.titleLabel.snp.bottom).offset(40)
                    })
                    
                    self.view.addSubview(self.sendButton)
                    self.sendButton.snp.makeConstraints({ (make) in
                        make.bottom.left.right.equalTo(self.view)
                        make.height.equalTo(self.SEND_HEIGHT)
                    })
                }
                
            }
        }
    }
    
    func backPressed() {
//        modalTransitionStyle = .flipHorizontal
        dismiss(animated: false, completion: nil)
    }
    
    func friendTapped(friend: Friend, selected: Bool) {
        if selected {
            selectedFriends.insert(friend.name)
        } else {
            selectedFriends.remove(friend.name)
        }
    }
    
    func sendTapped() {
        BackendModel.sharedInstance.sendChallenge(image: image, word: word, friends: Array(selectedFriends)) {
            print("Sent!!")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
