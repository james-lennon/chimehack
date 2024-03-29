//
//  SetupController.swift
//  Chimehack-Mobile
//
//  Created by James Lennon on 6/10/17.
//  Copyright © 2017 James Lennon. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class SetupController: UIViewController {
    
    private let LANG_HEIGHT : CGFloat = 60
    
    private let _titleLabel = UILabel()
    private var _isSelectingUserLanguage = true
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        print("Setup View controller")
        view.backgroundColor = UIColor.white
        
        /* Title label */
        view.addSubview(_titleLabel)
        _titleLabel.text = "Select your language:"
        _titleLabel.font = UIFont.systemFont(ofSize: 20)
        _titleLabel.sizeToFit()
        
        _titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.size.equalTo(_titleLabel)
            make.top.equalTo(40)
        }
        
        showLanguages()
    }
    
    private func showLanguages() {
        
        let languageButtons = LanguageModel.sharedInstance.languages().map { (language) -> LanguageButton in
            
            let view = LanguageButton(language: language)
            view.onClick = { selected in
                
                if !selected {
                    self.handleLanguageSelection(language: language)
                }
                
            }
            
            return view
        }
        
        let languagesView = ListView(subviewList: languageButtons, componentHeight: LANG_HEIGHT)
        view.addSubview(languagesView)
        
        languagesView.snp.makeConstraints { (make) in
            make.centerY.equalTo(view)
            make.left.right.equalTo(view)
        }
        
    }
    
    private func showSecondLanguageSelection() {
        
        _isSelectingUserLanguage = false
        
        _titleLabel.text = "Select language to learn:"
        
    }
    
    private func handleLanguageSelection(language: String) {
        
        if _isSelectingUserLanguage {
            
            LanguageModel.sharedInstance.setUserLanguage(language: language)
            showSecondLanguageSelection()
            _isSelectingUserLanguage = false
        } else {
            
            LanguageModel.sharedInstance.setLearningLanguage(language: language)
            /* Move on */
            navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
}
