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
        self.setupFont()
    }
    
    private func setupFont(){
        self.continueButton.setTitle("Continue", for: .normal)
        self.continueButton.setTitleColor(AppColors.themeGreen, for: .normal)
        self.continueButton.titleLabel?.font = AppFonts.SemiBold.withSize(20)
        self.titleLabel.attributedText = self.viewModel.title
    }


}
