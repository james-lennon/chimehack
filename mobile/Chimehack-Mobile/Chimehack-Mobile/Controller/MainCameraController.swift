//
//  MainCameraController.swift
//  Chimehack-Mobile
//
//  Created by James Lennon on 6/10/17.
//  Copyright © 2017 James Lennon. All rights reserved.
//

import UIKit

class MainCameraController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = UIColor.white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if LanguageModel.sharedInstance.userLanguage() == nil {
            self.present(SetupController(), animated: false, completion: nil)
        }
    }
    
}
