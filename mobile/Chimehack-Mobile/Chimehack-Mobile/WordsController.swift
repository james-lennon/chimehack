//
//  WordsController.swift
//  Chimehack-Mobile
//
//  Created by James Lennon on 6/10/17.
//  Copyright © 2017 James Lennon. All rights reserved.
//

import UIKit
import SnapKit

class WordsController: UIViewController {
    
    private let challengeLabel = UILabel()
    private let wordsLabel = UILabel()
    private let backButton = UIButton()
    
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
        backButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(30)
            make.top.equalTo(self.view).offset(30)
            make.right.equalTo(self.view).inset(20)
        }
        
        view.addSubview(challengeLabel)
        challengeLabel.font = UIFont.systemFont(ofSize: 30)
        challengeLabel.text = "Challenges:"
        challengeLabel.sizeToFit()
        challengeLabel.snp.makeConstraints { (make) in
            make.size.equalTo(challengeLabel)
            make.left.equalTo(view).offset(20)
        }
    }
    
    func backPressed() {
        
        UIView.animate(withDuration: 0.25) {
            self.view.frame.origin = CGPoint(x: self.view.frame.width, y: 0)
        }
    }
    
}
