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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupFont()
    }
    
    func setupFont(){
        self.exampleLabel.text = "Example"
        self.exampleLabel.font = AppFonts.SemiBold.withSize(18)
        self.exampleLabel.textColor = AppColors.themeBlack
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
//            topVC.add(childViewController: obj)
        }
    }
    
    @IBAction func tappedCrossButton(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame.origin.y = UIScreen.height
        }) { _ in
           self.removeFromParentVC
        }
        
    }
    
}
