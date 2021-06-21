//
//  PassportExampleVC.swift
//  Aertrip
//
//  Created by Apple  on 14.05.20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import UIKit

class PassportExampleVC: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var exampleLabel: UILabel!
    @IBOutlet weak var crossButton: UIButton!
    @IBOutlet weak var passportImage: UIImageView!
    @IBOutlet weak var transperentButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupFont()
        self.setUpSubView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isLightTheme(){
            crossButton.setImage(UIImage(named: "GrayCross"), for: .normal)
        }else{
            crossButton.setImage(UIImage(named: "ic_toast_cross"), for: .normal)
        }
        
        UIView.animate(withDuration: 0.33, animations: {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            self.containerView.transform = CGAffineTransform.identity
        })
    }
    
    func setupFont(){
        self.exampleLabel.text = "Example"
        self.exampleLabel.font = AppFonts.SemiBold.withSize(18)
        self.exampleLabel.textColor = AppColors.themeBlack
        self.containerView.backgroundColor = AppColors.themeWhiteDashboard
    }
    
    static func showMe(){
        if let topVC = UIApplication.topViewController() {
            let obj = PassportExampleVC.instantiate(fromAppStoryboard: .PassengersSelection)
            obj.view.backgroundColor = AppColors.themeBlack.withAlphaComponent(0.3)
            var frame = topVC.view.frame
            frame.origin.y = frame.height
            obj.view.frame = frame
            topVC.addChild(obj)
            topVC.view.addSubview(obj.view)
            obj.didMove(toParent: topVC)
            UIView.animate(withDuration: 0.3) {
                obj.view.frame.origin.y = 0
            }
        }
    }
    
    @IBAction func tappedCrossButton(_ sender: UIButton) {
        
        
        UIView.animate(withDuration: 0.33, animations: {
            self.containerView.transform = CGAffineTransform(translationX: 0, y: self.transperentButton.height)
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
        }) { (success) in
            self.dismiss(animated: false, completion: nil)
        }
        
//        UIView.animate(withDuration: 0.3, animations: {
//            self.view.frame.origin.y = UIScreen.height
//        }) { _ in
//           self.removeFromParentVC
//        }
        
    }
    
    func setUpSubView(){
        self.transperentButton.backgroundColor = UIColor.clear
        self.containerView.transform = CGAffineTransform(translationX: 0, y: transperentButton.height)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
        
    }
    
}
