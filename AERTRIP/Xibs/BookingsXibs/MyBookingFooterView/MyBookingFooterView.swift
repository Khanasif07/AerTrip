//
//  MyBookingFooterView.swift
//  AERTRIP
//
//  Created by Admin on 22/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol MyBookingFooterViewDelegate: class {
    func myBookingFooterView(_ sender: MyBookingFooterView, didChangedPendingActionSwitch isOn: Bool)
}

class MyBookingFooterView: UIView {
    
    //MARK:- Variables
    weak var delegate: MyBookingFooterViewDelegate?
    
    //MARK:- IBOutlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var pendingActionsLabel: UILabel!
    @IBOutlet weak var switchContainerView: UIView!
    @IBOutlet weak var pendingActionSwitch: UISwitch!
    @IBOutlet weak var dividerView: ATDividerView!
    
    //MARK:- LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialSetUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialSetUp()
    }
    
    //MARK:- PrivateFunctions
    ///InitialSetUp
    private func initialSetUp() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "MyBookingFooterView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        self.configureUI()
    }
    
    ///ConfigureUI
    private func configureUI() {
        self.pendingActionsLabel.font = AppFonts.Regular.withSize(18.0)
        self.pendingActionsLabel.textColor = AppColors.themeBlack
        self.pendingActionsLabel.text = LocalizedString.ShowPendingActionsOnly.localized
//        self.statusImageView.image = #imageLiteral(resourceName: "pending red image requird")
    }
    
    @IBAction func showPendingActions(_ sender: UISwitch) {
        self.delegate?.myBookingFooterView(self, didChangedPendingActionSwitch: sender.isOn)
    }
}
