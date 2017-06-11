//
//  UserView.swift
//  Chimehack-Mobile
//
//  Created by James Lennon on 6/10/17.
//  Copyright © 2017 James Lennon. All rights reserved.
//

import UIKit

class FriendView : UIView {
    
    private let nameLabel = UILabel()
    private let scoreLabel = UILabel()
    private let checkImage = UIImageView(image: #imageLiteral(resourceName: "check"))
    
    private let friend : Friend
    
    private var selected : Bool = false
    
    public var onTap : ((Bool)->())? = nil
    
    init(friend: Friend) {
        
        self.friend = friend
        
        super.init(frame: CGRect.zero)
        
        backgroundColor = UIColor.white
        
        addSubview(nameLabel)
        nameLabel.text = "\(friend.name) - \(friend.score)"
        nameLabel.sizeToFit()
        nameLabel.snp.makeConstraints( { make in
            make.size.equalTo(nameLabel)
            make.left.equalTo(self).offset(20)
            make.centerY.equalTo(self)
        })
        
//        addSubview(scoreLabel)
//        scoreLabel.text = "\(friend.name) - \(friend.score)"
//        scoreLabel.sizeToFit()
//        scoreLabel.snp.makeConstraints( { make in
//            make.size.equalTo(scoreLabel)
//            make.right.equalTo(self).offset(-20)
//            make.centerY.equalTo(self)
//        })
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(tapped))
        addGestureRecognizer(tapGR)
        
        addSubview(checkImage)
        checkImage.snp.makeConstraints { (make) in
            make.width.height.equalTo(20)
            make.centerY.equalTo(self)
            make.right.equalTo(self).inset(20)
        }
        checkImage.isHidden = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tapped() {
        selected = !selected
        onTap?(selected)
        
        checkImage.isHidden = !selected
    }
    
}
