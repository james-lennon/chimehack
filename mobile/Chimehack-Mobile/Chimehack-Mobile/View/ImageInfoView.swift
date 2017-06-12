//
//  ImageInfoView.swift
//  Chimehack-Mobile
//
//  Created by James Lennon on 6/10/17.
//  Copyright © 2017 James Lennon. All rights reserved.
//

import AVFoundation
import UIKit
import SwiftyGif
import DGActivityIndicatorView

class ImageInfoView: UIView {
    
    private let userLangLabel = UILabel()
    private let learnLangLabel = UILabel()
    private let sendButton = UIButton()
    private let speakButton = UIButton()
    
    private let indicator = DGActivityIndicatorView(type: .doubleBounce, tintColor: UIColor.lightGray)!
    
    private let onSend : ()->()
    
    private var word: String? = nil
    
    init(onSend: @escaping ()->()) {
        
        self.onSend = onSend
        
        super.init(frame: CGRect.zero)
        
        backgroundColor = UIColor.white
        
        
        /* Extra Content */
        
        addSubview(indicator)
        indicator.snp.makeConstraints { (make) in
            make.width.height.equalTo(50)
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(20)
        }
        indicator.startAnimating()
//        indicator.backgroundColor = UIColor.green
        
    }
    
    public func setData(data: [String : Any]) {
        
        indicator.stopAnimating()
        
        var word = data["vocab"] as? String ?? ""
        var t_word = data["t_vocab"] as? String ?? ""
        let t_sentence = data["t_sentence"] as? String ?? ""
        let sentence = data["sentence"] as? String ?? ""
        let gif = data["giphy_url"] as? String ?? ""

        
        if word == "no person" {
            word = "not hotdog"
        }
        
        self.word = word
        
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
        addSubview(t_sentLabel)
        t_sentLabel.text = t_sentence
        t_sentLabel.numberOfLines = 0
        t_sentLabel.snp.makeConstraints { (make) in
            make.height.equalTo(100)
            make.left.right.equalTo(self).inset(30)
            make.top.equalTo(sentLabel.snp.bottom).offset(20)
        }
        
        
//        let gifImg = UIImage
//        let gifImg = UIImage(gif) //UIImage.gifImageWithURL(gifUrl: BackendModel.sharedInstance.BASE_URL + gif)
//        let imgView = UIImageView(image: gifImg)
//        
//        addSubview(imgView)
//        imgView.snp.makeConstraints { (make) in
//            make.left.right.equalTo(self).inset(10)
//            make.top.equalTo(sentLabel.snp.bottom).offset(10)
//            make.height.equalTo(200)
//        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func sendPressed() {
        onSend()
    }
    
    func speakTapped() {
        speakWord(word: self.word ?? "")
    }
    
    func speakWord(word: String){
        let synthesizer = AVSpeechSynthesizer()
        let utterance = AVSpeechUtterance(string: word)
        utterance.rate = 0.2
        synthesizer.speak(utterance)
    }
    
}
