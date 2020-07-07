//
//  FreeMealAndSeatVC.swift
//  Aertrip
//
//  Created by Apple  on 19.05.20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import UIKit



class FreeMealAndSeatVC: UIViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    
    var viewModel = FreeMealAndSeatVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.continueButton.addTarget(self, action: #selector(tapContinueBtn), for: .touchUpInside)
        self.setupFont()
    }
    
    private func setupFont(){
        self.continueButton.setTitle("Continue", for: .normal)
        self.continueButton.setTitleColor(AppColors.themeGreen, for: .normal)
        self.continueButton.titleLabel?.font = AppFonts.SemiBold.withSize(20)
        self.titleLabel.attributedText = self.viewModel.title
    }
    
    static func showMe(type: FreeServiveType){
        if let topVC = UIApplication.topViewController() {
            let obj = FreeMealAndSeatVC.instantiate(fromAppStoryboard: .PassengersSelection)
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
    @IBAction func tapBackgroundButton(_ sender: UIButton) {
        self.tapContinueBtn(sender)
    }
    
    @objc func tapContinueBtn(_ sender: UIButton){
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame.origin.y = UIScreen.height
        }) { _ in
           self.removeFromParentVC
        }
    }

}
