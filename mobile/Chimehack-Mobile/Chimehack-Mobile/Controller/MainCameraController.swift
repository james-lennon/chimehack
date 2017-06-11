//
//  MainCameraController.swift
//  Chimehack-Mobile
//
//  Created by James Lennon on 6/10/17.
//  Copyright © 2017 James Lennon. All rights reserved.
//

import UIKit
import SnapKit

class MainCameraController: UIViewController {
    
    private let cameraButton = CameraButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = UIColor.white
        
        view.addSubview(cameraButton)
        cameraButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.bottom.equalTo(view).offset(-20)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if LanguageModel.sharedInstance.userLanguage() == nil {
            let navVc = UINavigationController(rootViewController: SetupController())
            navVc.navigationBar.isHidden = true
            self.present(navVc, animated: false, completion: nil)
        }
    }
    
}
