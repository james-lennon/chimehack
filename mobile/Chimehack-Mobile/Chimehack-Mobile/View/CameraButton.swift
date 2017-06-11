//
//  CameraButton.swift
//  Chimehack-Mobile
//
//  Created by James Lennon on 6/10/17.
//  Copyright © 2017 James Lennon. All rights reserved.
//

import UIKit

class CameraButton : UIView {
    
    private let SIZE : CGFloat = 60
    private let cameraColor = UIColor.blue
    
    public var onClick : (()->())? = nil
    
    override init(frame: CGRect) {
        
        super.init(frame: CGRect.zero)
        
        layer.cornerRadius = SIZE / 2
        layer.borderColor = cameraColor.cgColor
        layer.borderWidth = 4
        layer.backgroundColor = UIColor.clear.cgColor
        
        snp.makeConstraints { (make) in
            make.width.height.equalTo(self.SIZE)
        }
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(tapped))
        addGestureRecognizer(tapGR)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func tapped() {
        
        /* Notify listener */
        self.onClick?()
    }
    
}
