//
//  MainCameraController.swift
//  Chimehack-Mobile
//
//  Created by James Lennon on 6/10/17.
//  Copyright © 2017 James Lennon. All rights reserved.
//

import UIKit
import SnapKit
import Photos
import AVFoundation

enum MainViewMode {
    case camera
    case words
    case user
}

class MainCameraController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private let cameraButton = CameraButton()
    private let wordsButton = UIButton()
    private let userButton = UIButton()
    
    private let userController = UserController()
    private let wordsController = WordsController()
    
    /* Camera stuff */
    private let pickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Load models */
        LanguageModel.sharedInstance.load()
        BackendModel.sharedInstance.load()
    
        view.backgroundColor = UIColor.white
        
        #if (arch(i386) || arch(x86_64)) && os(iOS)
            let DEVICE_IS_SIMULATOR = true
        #else
            let DEVICE_IS_SIMULATOR = false
        #endif
        
        /* Setup child view controllers */
        
        userController.willMove(toParentViewController: self)
        wordsController.willMove(toParentViewController: self)
        pickerController.willMove(toParentViewController: self)
        addChildViewController(userController)
        addChildViewController(wordsController)
        addChildViewController(pickerController)
        userController.didMove(toParentViewController: self)
        wordsController.didMove(toParentViewController: self)
        pickerController.didMove(toParentViewController: self)
        
        view.addSubview(pickerController.view)
        pickerController.sourceType = DEVICE_IS_SIMULATOR ? .photoLibrary : .camera
        pickerController.showsCameraControls = false
        pickerController.delegate = self
        let translate = CGAffineTransform(translationX: 0.0, y: 71.0); //This slots the preview exactly in the middle of the screen by moving it down 71 points
        pickerController.cameraViewTransform = translate;
        
        let scale = translate.scaledBy(x: 1.333333, y: 1.333333);
        pickerController.cameraViewTransform = scale;
        pickerController.view.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        view.addSubview(cameraButton)
        cameraButton.onClick = self.takePicture
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
        
        UIView.animate(withDuration: 0.25) {
            self.userController.view.frame.origin = CGPoint.zero
        }
        
    }
    
    func wordsTapped() {
        
        UIView.animate(withDuration: 0.25) {
            self.wordsController.view.frame.origin = CGPoint.zero
        }
        
    }
    
    func takePicture() {
        pickerController.takePicture()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            let vc = ImageInfoController(image: pickedImage)
            self.present(vc, animated: false, completion: nil)
        }
    }
    
}
