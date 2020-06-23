//
//  DateTableHeaderView.swift
//  AERTRIP
//
//  Created by Admin on 16/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class DateTableHeaderView: UITableViewHeaderFooterView {
    
    //Mark:- Variables
    //===============
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var dataLabelBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var topDividerView: ATDividerView!
    @IBOutlet weak var bottomDividerView: ATDividerView!
    
    //Mark:- LifeCycle
    //================
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.initialSetUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialSetUp()
    }
    
    //Mark:- PrivateFunctions
    //=======================
    //.InitialSetUp
    private func initialSetUp() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "DateTableHeaderView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.backgroundColor =  AppColors.themeWhite
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        self.configUI()
        self.topDividerView.isHidden = true
        self.bottomDividerView.isHidden = true
    }
    
    ///ConfigureUI
    private func configUI() {
        self.parentView.backgroundColor = AppColors.themeWhite
        self.dateLabel.textColor = AppColors.themeBlack
        self.dateLabel.font = AppFonts.SemiBold.withSize(16.0)
    }
    
    internal func configView(date: String , isFirstHeaderView: Bool) {
        self.dateLabel.text = date
        self.dateLabelTopConstraint.constant = isFirstHeaderView ? 16.0 : 25.0
        self.dataLabelBottomConstraint.constant = 5.0
    }
    
    internal func configViewForBooking(date: String , isFirstHeaderView: Bool) {
        self.dateLabel.text = date
        self.dateLabelTopConstraint.constant = isFirstHeaderView ? 16 : 8
        self.dataLabelBottomConstraint.constant = 8
        self.contentView.backgroundColor = AppColors.themeWhite
        self.backgroundColor = AppColors.themeWhite
        self.contentView.layoutIfNeeded()
    }
}

