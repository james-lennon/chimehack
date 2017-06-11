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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        view.addSubview(backButton)
        backButton.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        backButton.addTarget(self, action: #selector(backPressed), for: .touchUpInside)
        backButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(30)
            make.top.equalTo(self.view).offset(30)
            make.right.equalTo(self.view).inset(20)
        }
    }
    
    func backPressed() {
        
    }
}
