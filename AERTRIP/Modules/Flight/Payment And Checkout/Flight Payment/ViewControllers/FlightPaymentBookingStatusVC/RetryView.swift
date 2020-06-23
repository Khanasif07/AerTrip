//
//  RetryView.swift
//  AERTRIP
//
//  Created by Apple  on 23.06.20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

class RetryView:UIView{
    
    @IBOutlet weak var retryImage: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var retryButton: UIButton!
//    private var retryAction:(()->())?
    override func awakeFromNib() {
        self.messageLabel.text = "Opp!\nSomething went worng."
        self.messageLabel.font = AppFonts.Regular.withSize(16)
        let buttonTitleStr = NSMutableAttributedString(string:"Retry", attributes:[
            .font : AppFonts.SemiBold.withSize(18),.foregroundColor : AppColors.themeGreen,.underlineStyle : 1])
        retryButton.setAttributedTitle(buttonTitleStr, for: .normal)
    }
    
    @IBAction func tappedRetryButton(_ sender: UIButton) {
//        self.retryAction?()
    }
    
//    func showMe(on vc: UIViewController, complition: (()->())?)-> RetryView?{
//        let backView = Bundle.main.loadNibNamed("RetryView", owner: vc, options: nil)?.first as? RetryView
//        self.retryAction = complition
//        return backView
//    }
    
}
