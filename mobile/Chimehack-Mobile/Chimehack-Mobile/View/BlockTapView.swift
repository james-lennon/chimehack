//
//  BlockTapView.swift
//  Chimehack-Mobile
//
//  Created by James Lennon on 6/11/17.
//  Copyright © 2017 James Lennon. All rights reserved.
//

import UIKit

class BlockTapView: UIView {
    
    private let block : () -> ()
    
    init(block: @escaping ()->()) {
        
        self.block = block
        
        super.init(frame: CGRect.zero)
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(tapped))
        addGestureRecognizer(tapGR)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tapped() {
        self.block()
    }
    
}
