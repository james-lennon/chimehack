//
//  ListView.swift
//  Chimehack-Mobile
//
//  Created by James Lennon on 6/10/17.
//  Copyright © 2017 James Lennon. All rights reserved.
//

import UIKit

class ListView: UIView {
    
    init(subviewList: [UIView], componentHeight: CGFloat) {
        
        super.init(frame: CGRect.zero)
        
        var lastView : UIView? = nil
        
        for (index, view) in subviewList.enumerated() {
            
            addSubview(view)
            
            view.snp.makeConstraints({ (make) in
                make.left.right.equalTo(self)
                make.height.equalTo(componentHeight)
                
                if let lv = lastView {
                    make.top.equalTo(lv.snp.bottom)
                } else {
                    make.top.equalTo(self)
                }
            })
            
            if index < subviewList.count - 1 {
                let border = borderView()
                addSubview(border)
                border.snp.makeConstraints({ (make) in
                    make.bottom.equalTo(view)
                    make.height.equalTo(1)
                    make.left.right.equalTo(view).inset(15)
                })
            }
            
            lastView = view
            
        }
        
        snp.makeConstraints { (make) in
            make.bottom.equalTo((lastView ?? self).snp.bottom)
        }
    }
    
    private func borderView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

