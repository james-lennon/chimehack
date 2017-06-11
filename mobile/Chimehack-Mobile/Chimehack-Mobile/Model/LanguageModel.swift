//
//  LanguageModel.swift
//  Chimehack-Mobile
//
//  Created by James Lennon on 6/10/17.
//  Copyright © 2017 James Lennon. All rights reserved.
//

import Foundation

class LanguageModel {
    
    static let sharedInstance = LanguageModel()
    
    /* Instance fields */
    private let _languageList = [
        "English",
        "Arabic",
        "Persian"
    ]
    
    private var _userLanguage : String? = nil
    private var _learningLanguage : String? = nil
    
    func languages() -> [String] {
        return _languageList
    }
    
    func load() {
        
        // TODO: load from user defaults
        
    }
    
    func setUserLanguage(language: String) {
        _userLanguage = language
    }
    
    func setLearningLanguage(language: String) {
        _learningLanguage = language
    }
    
    func userLanguage() -> String? {
        return _userLanguage
    }
    
    func learningLanguage() -> String? {
        return _learningLanguage
    }
    
}
