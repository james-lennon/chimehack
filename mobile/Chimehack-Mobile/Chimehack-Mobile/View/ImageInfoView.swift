//
//  ImageInfoView.swift
//  Chimehack-Mobile
//
//  Created by James Lennon on 6/10/17.
//  Copyright © 2017 James Lennon. All rights reserved.
//

import UIKit

class ImageInfoView: UIView {
    
    private let userLangLabel = UILabel()
    private let learnLangLabel = UILabel()
    private let sendButton = UIButton()
    private let speakButton = UIButton()
    
    private let onSend : ()->()
    
    init(onSend: @escaping ()->()) {
        
        self.onSend = onSend
        
        super.init(frame: CGRect.zero)
        
        backgroundColor = UIColor.white
        
        
        /* Extra Content */
        
        
        
    }
    
    public func setData(data: [String : Any]) {
        
        var word = data["vocab"] as? String ?? ""
        var t_word = data["t_vocab"] as? String ?? ""
        let t_sentence = data["t_sentence"] as? String ?? ""
        let sentence = data["sentence"] as? String ?? ""
        let gif = data["giphy_url"] as? String ?? ""

        
        if word == "no person" {
            word = "not hotdog"
        }
        
        let font = UIFont.systemFont(ofSize: 30)
        
        addSubview(userLangLabel)
        userLangLabel.text = word
        userLangLabel.font = font
        userLangLabel.sizeToFit()
        userLangLabel.snp.makeConstraints { (make) in
            make.size.equalTo(userLangLabel)
            make.left.equalTo(self).offset(20)
            make.top.equalTo(self).offset(10)
        }
        
        addSubview(learnLangLabel)
        learnLangLabel.text = t_word
        learnLangLabel.font = font
        learnLangLabel.sizeToFit()
        learnLangLabel.snp.makeConstraints { (make) in
            make.size.equalTo(learnLangLabel)
            make.left.equalTo(self).offset(20)
            make.top.equalTo(userLangLabel.snp.bottom).offset(10)
        }
        
        addSubview(sendButton)
        sendButton.setImage(#imageLiteral(resourceName: "send"), for: .normal)
        sendButton.addTarget(self, action: #selector(sendPressed), for: .touchUpInside)
        sendButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(30)
            make.right.equalTo(self).inset(20)
            make.top.equalTo(self).offset(30)
        }
        
        addSubview(speakButton)
        speakButton.setImage(#imageLiteral(resourceName: "speaker"), for: .normal)
        speakButton.addTarget(self, action: #selector(speakTapped), for: .touchUpInside)
        speakButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(30)
            make.centerY.equalTo(sendButton)
            make.right.equalTo(sendButton.snp.left).offset(-10)
        }
        
        let borderView = UIView()
        borderView.backgroundColor = UIColor.lightGray
        addSubview(borderView)
        borderView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self)
            make.height.equalTo(1)
        }
        
        let dividerView = UIView()
        dividerView.backgroundColor = UIColor.lightGray
        addSubview(dividerView)
        dividerView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self).inset(30)
            make.height.equalTo(1)
            make.top.equalTo(learnLangLabel.snp.bottom).offset(20)
        }
        
        let sentLabel = UILabel()
        addSubview(sentLabel)
        sentLabel.text = sentence
        sentLabel.numberOfLines = 0
//        sentLabel.sizeToFit()
        sentLabel.snp.makeConstraints { (make) in
            make.height.equalTo(100)
            make.left.right.equalTo(self).inset(30)
            make.top.equalTo(dividerView).offset(20)
        }
        
        
        let t_sentLabel = UILabel()
        t_sentLabel.text = t_sentence
        
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func sendPressed() {
        onSend()
    }
    
    func speakTapped() {
        
    }
    
}
