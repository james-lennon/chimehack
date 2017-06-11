//
//  ImageInfoController.swift
//  Chimehack-Mobile
//
//  Created by James Lennon on 6/10/17.
//  Copyright © 2017 James Lennon. All rights reserved.
//

import UIKit
import SnapKit

class ImageInfoController: UIViewController {
    
    private let PEEK_AMT : CGFloat = 80
    
    private let image : UIImage
    private let imageView : UIImageView
    
    private var infoView : ImageInfoView! = nil
    private let closeButton = UIButton()
    
    private var offsetBeforeDrag : CGFloat = 0
    
    private var word: String? = nil
    
    init(image: UIImage) {
        
        self.image = image
        self.imageView = UIImageView(image: image)
                
        super.init(nibName: nil, bundle: nil)
        
        self.infoView = ImageInfoView(onSend: self.sendPressed)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        view.backgroundColor = UIColor.black
        
        view.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        view.addSubview(infoView)
        infoView.frame.size = view.frame.size
        infoView.frame.origin = CGPoint(x: 0, y: view.frame.height - PEEK_AMT)
        
        let panGR = UIPanGestureRecognizer(target: self, action: #selector(viewPanned))
        infoView.addGestureRecognizer(panGR)
        
        let titleView = UIView()
        view.addSubview(titleView)
        titleView.backgroundColor = UIColor.white
        titleView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(view)
            make.height.equalTo(PEEK_AMT)
        }
        let titleLabel = UILabel()
        titleLabel.text = "New Word 😃"
        titleView.addSubview(titleLabel)
        titleLabel.font = UIFont.systemFont(ofSize: 30)
        titleLabel.snp.makeConstraints { (make) in
            make.size.equalTo(titleLabel)
            make.centerX.equalTo(titleView)
            make.centerY.equalTo(titleView).offset(10)
        }
        
        titleView.addSubview(closeButton)
        closeButton.setImage(#imageLiteral(resourceName: "cancel"), for: .normal)
        closeButton.imageView?.contentMode = .scaleAspectFit
        closeButton.addTarget(self, action: #selector(closePressed), for: .touchUpInside)
        closeButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(20)
            make.left.equalTo(titleView).offset(20)
            make.centerY.equalTo(titleLabel)
        }
        
        BackendModel.sharedInstance.uploadImage(image: self.image) { data in
            
            DispatchQueue.main.async {
                self.infoView.setData(data: data)
                
                if let word = data["word"] as? String {
                    self.word = word
                    DatabaseModel.sharedInstance.addWord(word: word)
                }
            }
            
            
        }
        
    }
    
    func viewPanned(gestureRecognizer: UIPanGestureRecognizer) {
        
        switch gestureRecognizer.state {
        case .began:
            offsetBeforeDrag = infoView.frame.origin.y
        case .changed:
            let y = offsetBeforeDrag + gestureRecognizer.translation(in: view).y
            let clippedY = max(PEEK_AMT + 2, min(view.frame.height - PEEK_AMT, y))
            
            infoView.frame.origin.y = clippedY
        case .ended:
            
            let threshold = view.frame.height * 6.0 / 10.0
            
            var destY : CGFloat = -1
            
            if infoView.frame.origin.y < threshold {
                destY = PEEK_AMT + 2
            } else {
                destY = view.frame.height - PEEK_AMT
            }
            
            UIView.animate(withDuration: 0.25, animations: { 
                self.infoView.frame.origin.y = destY
            })
            
        default:
            break
        }
        
    }
    
    func closePressed() {
        dismiss(animated: true, completion: nil)
    }
    
    func sendPressed() {
        let vc = SendController(image: self.image, word: self.word ?? "")
        present(vc, animated: true, completion: nil)
    }
}
