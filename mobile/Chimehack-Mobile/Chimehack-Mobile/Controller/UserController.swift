//
//  UserController.swift
//  Chimehack-Mobile
//
//  Created by James Lennon on 6/10/17.
//  Copyright © 2017 James Lennon. All rights reserved.
//

import UIKit
import SnapKit

class UserController: UIViewController {
    
    private let backButton = UIButton()
    private let challengesButton = UIButton()
    private let pointsButton = UIButton()
    private let friendsButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        let titleView = UIView()
        view.addSubview(titleView)
        titleView.backgroundColor = UIColor.magenta
        titleView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(view)
            make.height.equalTo(20 + 55)
        }
        
        titleView.addSubview(backButton)
        backButton.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        backButton.addTarget(self, action: #selector(backPressed), for: .touchUpInside)
        backButton.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) / 180.0)
        backButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(30)
            make.top.equalTo(self.view).offset(30)
            make.right.equalTo(self.view).inset(20)
        }
        
        let pointsView = UIView()
        view.addSubview(pointsView)
        pointsView.backgroundColor = UIColor.cyan
        pointsView.snp.makeConstraints { (make) in
            make.left.equalTo(view)
            make.width.equalTo(view.frame.width / 2.0)
            make.height.equalTo(view.frame.height / 2.0)
            make.top.equalTo(titleView.snp.bottom)
        }
        let userLabel = UILabel()
        pointsView.addSubview(userLabel)
        userLabel.text = BackendModel.sharedInstance.username()
        userLabel.sizeToFit()
        userLabel.snp.makeConstraints { (make) in
            make.size.equalTo(userLabel)
            make.centerX.equalTo(pointsView)
            make.top.equalTo(pointsView).offset(20)
        }
        view.addSubview(pointsButton)
        pointsButton.setImage(#imageLiteral(resourceName: "treasurechest"), for: .normal)
        pointsButton.addTarget(self, action: #selector(pointsPressed), for: .touchUpInside)
        pointsButton.backgroundColor = UIColor.cyan
        pointsButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(60)
        }
        pointsButton.center = pointsView.center
        
        let challengesView = UIView()
        view.addSubview(challengesView)
        challengesView.backgroundColor = UIColor.orange
        challengesView.snp.makeConstraints { (make) in
            make.left.bottom.equalTo(view)
            make.top.equalTo(pointsView.snp.bottom)
            make.width.equalTo(view.frame.width / 2.0)
            make.height.equalTo(view.frame.height / 2.0)
        }
        view.addSubview(challengesButton)
        challengesButton.setImage(#imageLiteral(resourceName: "armmuscle"), for: .normal)
        challengesButton.addTarget(self, action: #selector(challengesPressed), for: .touchUpInside)
        challengesButton.backgroundColor = UIColor.orange
        challengesButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(60)
        }
        challengesButton.center = challengesView.center
        
        let logoView = UIImageView(image: #imageLiteral(resourceName: "icon-blank"))
        view.addSubview(logoView)
        logoView.contentMode = .scaleAspectFit
        logoView.backgroundColor = UIColor.white
        logoView.snp.makeConstraints { (make) in
            make.right.equalTo(view)
            make.top.equalTo(titleView.snp.bottom)
            make.width.equalTo(view.frame.width / 2.0)
            make.height.equalTo(view.frame.height / 2.0)
        }
        
        let friendsView = UIView()
        view.addSubview(friendsView)
        friendsView.backgroundColor = UIColor.yellow
        friendsView.snp.makeConstraints { (make) in
            make.right.equalTo(view)
            make.top.equalTo(logoView.snp.bottom)
            make.bottom.equalTo(view)
            make.width.equalTo(view.frame.width / 2.0)
            make.height.equalTo(view.frame.height / 2.0)
        }
        view.addSubview(friendsButton)
        friendsButton.setImage(#imageLiteral(resourceName: "dancinggirl"), for: .normal)
        friendsButton.addTarget(self, action: #selector(friendsPressed), for: .touchUpInside)
        friendsButton.backgroundColor = UIColor.yellow
        friendsButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(60)
        }
        friendsButton.center = friendsView.center
        
    }
    
    func backPressed() {
        UIView.animate(withDuration: 0.25) {
            self.view.frame.origin = CGPoint(x: -self.view.frame.width, y: 0)
        }
    }
    
    func challengesPressed() {
        //        UIView.animate(withDuration: 0.25) {
        //            self.ChallengesController.view.frame.origin = CGPoint.zero
        //        }
    }
    
    func pointsPressed() {
        //        UIView.animate(withDuration: 0.25) {
        //            self.WordsController.view.frame.origin = CGPoint.zero
        //        }
    }
    
    func friendsPressed() {
        //        UIView.animate(withDuration: 0.25) {
        //            self.FriendsController.view.frame.origin = CGPoint.zero
        //        }
    }
}
