import UIKit
import SnapKit

class UserController: UIViewController {
    
    private let backButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        view.addSubview(backButton)
        backButton.setImage(#imageLiteral(resourceName: "cameralogo"), for: .normal)
        backButton.addTarget(self, action: #selector(backPressed), for: .touchUpInside)
        backButton.backgroundColor = UIColor.magenta
        backButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(30)
            make.top.equalTo(self.view).offset(30)
            make.right.equalTo(self.view).inset(20)
        }
        
        view.addSubview(challengesButton)
        challengesButton.setImage(#imageLiteral(resourceName: "armmuscle"), for: .normal)
        challengesButton.addTarget(self, action: #selector(challengesPressed), for: .touchUpInside)
        chalengesButton.backgroundColor = UIColor.orange
        challengesButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(30)
            make.bottom.equalTo(self.view).offset(30)
            make.left.equalTo(self.view).inset(20)
        }
        
        view.addSubview(pointsButton)
        pointsButton.setImage(#imageLiteral(resourceName: "treasurechest"), for: .normal)
        pointsButton.addTarget(self, action: #selector(pointsPressed), for: .touchUpInside)
        pointsButton.backgroundColor = UIColor.cyan
        pointsButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(30)
            make.top.equalTo(self.view).offset(30)
            make.left.equalTo(self.view).inset(20)
        }
        
        view.addSubview(friendsButton)
        friendsButton.setImage(#imageLiteral(resourceName: "dancinggirl"), for: .normal)
        friendsButton.addTarget(self, action: #selector(friendsPressed), for: .touchUpInside)
        friendsButton.backgroundColor = UIColor.yellow
        friendsButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(30)
            make.bottom.equalTo(self.view).offset(30)
            make.right.equalTo(self.view).inset(20)
        }


    }
    
    func backPressed() {
        UIView.animate(withDuration: 0.25) {
            self.MainCameraController.view.frame.origin = CGPoint.zero
        }
    }
    
    func challengesPressed() {
        UIView.animate(withDuration: 0.25) {
            self.ChallengesController.view.frame.origin = CGPoint.zero
        }
    }
    
    func pointsPressed() {
        UIView.animate(withDuration: 0.25) {
            self.WordsController.view.frame.origin = CGPoint.zero
        }
    }
    
    func friendsPressed() {
        UIView.animate(withDuration: 0.25) {
            self.FriendsController.view.frame.origin = CGPoint.zero
        }
    }
}