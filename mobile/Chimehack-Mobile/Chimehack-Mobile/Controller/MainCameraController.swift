//
//  MainCameraController.swift
//  Chimehack-Mobile
//
//  Created by James Lennon on 6/10/17.
//  Copyright © 2017 James Lennon. All rights reserved.
//

import UIKit
import SnapKit

enum MainViewMode {
    case camera
    case words
    case user
}

class MainCameraController: UIViewController {
    
    private let cameraButton = CameraButton()
    private let wordsButton = UIButton()
    private let userButton = UIButton()
    
    private let userController = UserController()
    private let wordsController = WordsController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = UIColor.white
        
        /* Setup child view controllers */
        
        userController.willMove(toParentViewController: self)
        wordsController.willMove(toParentViewController: self)
        addChildViewController(userController)
        addChildViewController(wordsController)
        userController.didMove(toParentViewController: self)
        wordsController.didMove(toParentViewController: self)
        
        view.addSubview(cameraButton)
        cameraButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.bottom.equalTo(view).offset(-20)
        }
        
        view.addSubview(userButton)
        userButton.setImage(UIImage(named: "user"), for: .normal)
        userButton.imageView?.contentMode = .scaleAspectFit
        userButton.addTarget(self, action: #selector(userTapped), for: .touchUpInside)
        userButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(40)
            make.bottom.equalTo(view).offset(-20)
            make.left.equalTo(view).offset(40)
        }
        
        view.addSubview(wordsButton)
        wordsButton.setImage(UIImage(named: "words"), for: .normal)
        wordsButton.imageView?.contentMode = .scaleAspectFit
        wordsButton.addTarget(self, action: #selector(wordsTapped), for: .touchUpInside)
        wordsButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(40)
            make.bottom.equalTo(view).offset(-20)
            make.right.equalTo(view).offset(-40)
        }
        
        /* child VCs */
        view.addSubview(userController.view)
        userController.view.frame.size = view.frame.size
        userController.view.frame.origin = CGPoint(x: -view.frame.width, y: 0)
        
        view.addSubview(wordsController.view)
        wordsController.view.frame.size = view.frame.size
        wordsController.view.frame.origin = CGPoint(x: view.frame.width, y: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if LanguageModel.sharedInstance.userLanguage() == nil {
            let navVc = UINavigationController(rootViewController: SetupController())
            navVc.navigationBar.isHidden = true
            self.present(navVc, animated: false, completion: nil)
        }
    }
    
    // MARK: - Button Handlers
    
    func userTapped() {
        
        print(self.userController.view.frame)
        UIView.animate(withDuration: 0.25) { 
            self.userController.view.frame.origin = CGPoint.zero
        }
        
    }
    
    func wordsTapped() {
        
        print(self.wordsController.view.frame)
        UIView.animate(withDuration: 0.25) {
            self.wordsController.view.frame.origin = CGPoint.zero
        }
        
    }
    
}
