//
//  WordsController.swift
//  Chimehack-Mobile
//
//  Created by James Lennon on 6/10/17.
//  Copyright © 2017 James Lennon. All rights reserved.
//

import UIKit
import SnapKit

class WordsController: UIViewController {
    
    private let challengeLabel = UILabel()
    private let wordsLabel = UILabel()
    private let backButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        let titleView = UIView()
        view.addSubview(titleView)
        titleView.backgroundColor = UIColor.magenta
        titleView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(view)
            make.height.equalTo(20 + 55)
        }
        
        titleView.addSubview(backButton)
        backButton.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        backButton.addTarget(self, action: #selector(backPressed), for: .touchUpInside)
        backButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(30)
            make.top.equalTo(self.view).offset(30)
            make.left.equalTo(self.view).offset(20)
        }
        
        view.addSubview(challengeLabel)
        challengeLabel.font = UIFont.systemFont(ofSize: 30)
        challengeLabel.text = "Challenges:"
        challengeLabel.sizeToFit()
        challengeLabel.snp.makeConstraints { (make) in
            make.size.equalTo(challengeLabel)
            make.left.equalTo(view).offset(20)
            make.top.equalTo(titleView.snp.bottom).offset(20)
        }
        
        let challengeScrollView = UIScrollView()
        view.addSubview(challengeScrollView)
        challengeScrollView.backgroundColor = UIColor.green
        challengeScrollView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(challengeLabel.snp.bottom).offset(20)
            make.height.equalTo(100)
        }
        
        /* Load challenges */
        BackendModel.sharedInstance.getChallenges { (results) in
            
            DispatchQueue.main.async {
                let views = results.map({ (user, imgData) -> UIView in
                    
                    let v = UIView()
                    v.backgroundColor = UIColor.white
                    let label = UILabel()
                    v.addSubview(label)
                    label.text = "Challenge from \(user)"
                    label.snp.makeConstraints({ (make) in
                        make.left.equalTo(v).offset(20)
                        make.centerY.equalTo(v)
                    })
                    
                    return v
                })
                
                let listView = ListView(subviewList: views, componentHeight: 60)
                
                challengeScrollView.addSubview(listView)
                challengeScrollView.contentSize = CGSize(width: self.view.frame.width, height: CGFloat(60 * views.count))
            }
            
        }
        
        let wordsLabel = UILabel()
        wordsLabel.text = "Words:"
        wordsLabel.font = UIFont.systemFont(ofSize: 30)
        wordsLabel.sizeToFit()
        view.addSubview(wordsLabel)
        wordsLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.size.equalTo(view)
            make.top.equalTo(challengeScrollView.snp.bottom).offset(10)
        }
        
        let wordViewList = DatabaseModel.sharedInstance.viewedWords().map { (viewedWord) -> UIView in
            let v = UIView()
            let label = UILabel()
            v.addSubview(label)
            label.text = viewedWord.word
            label.sizeToFit()
            label.snp.makeConstraints({ (make) in
                make.left.equalTo(v).offset(20)
                make.centerY.equalTo(v)
                make.size.equalTo(label)
            })
            
            return v
        }
        
//        let wordsView = ListView(subviewList: wordViewList, componentHeight: 60)
//        view.addSubview(wordsView)
//        wordsView.snp.makeConstraints { (make) in
//            make.left.right.bottom.equalTo(view)
//            make.top.equalTo(wordsLabel.snp.bottom).offset(10)
//        }
    }
    
    func backPressed() {
        
        UIView.animate(withDuration: 0.25) {
            self.view.frame.origin = CGPoint(x: self.view.frame.width, y: 0)
        }
    }
    
}
