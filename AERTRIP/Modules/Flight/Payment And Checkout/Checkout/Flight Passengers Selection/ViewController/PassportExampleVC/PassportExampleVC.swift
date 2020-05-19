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
    @IBAction func tappedCrossButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
