//
//  LanguageButton.swift
//  Chimehack-Mobile
//
//  Created by James Lennon on 6/10/17.
//  Copyright © 2017 James Lennon. All rights reserved.
//

import UIKit

class LanguageButton: UIView {
    
    private let _languageLabel = UILabel()
    private let _checkImage = UIImageView(image: UIImage(named: "check"))
    private var _selected = false
    
    public var onClick : ((Bool)->())? = nil
    
    init(language: String, showBorder: Bool = true) {
        
        super.init(frame: CGRect.zero)
        
        backgroundColor = UIColor.white
        
        addSubview(_languageLabel)
        _languageLabel.text = language
        _languageLabel.sizeToFit()
        
        _languageLabel.snp.makeConstraints { (make) in
            make.size.equalTo(_languageLabel)
            make.left.equalTo(self).offset(30)
            make.centerY.equalTo(self)
        }
        
        addSubview(_checkImage)
        _checkImage.contentMode = .scaleAspectFit
        _checkImage.snp.makeConstraints { (make) in
            make.width.height.equalTo(30)
            make.centerY.equalTo(self)
            make.right.equalTo(self).inset(20)
        }
        _checkImage.isHidden = true
        
//        if showBorder {
//            let botBorder = borderView()
//            addSubview(botBorder)
//            botBorder.snp.makeConstraints { (make) in
//                make.left.right.equalTo(self).inset(15)
//                make.height.equalTo(1)
//                make.bottom.equalTo(self).inset(2)
//            }
//        }
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(self.tapped))
        addGestureRecognizer(tapGR)
    }
    
    private func borderView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }
    
    @objc private func tapped() {
        
        self.onClick?(_selected)
        
        _selected = true
        _checkImage.isHidden = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
