//
//  TravelDateVC.swift
//  AERTRIP
//
//  Created by Admin on 15/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class TravelDateVC: BaseVC {
    
    //Mark:- Variables
    //================
    private var datePickerViewHeightConstraint: CGFloat = 215.0
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var fromView: UIView!
    @IBOutlet weak var toParentView: UIView!
    @IBOutlet weak var fromDateTitleLabel: UILabel!
    @IBOutlet weak var fromDateLabel: UILabel!
    @IBOutlet weak var firstDividerView: ATDividerView!
    @IBOutlet weak var fromDatePicker: UIDatePicker!
    @IBOutlet weak var toDateTitleLabel: UILabel!
    @IBOutlet weak var toDateLabel: UILabel!
    @IBOutlet weak var secondDividerView: ATDividerView!
    @IBOutlet weak var thirdDividerView: ATDividerView!
    @IBOutlet weak var toParentViewTopCons: NSLayoutConstraint!
    @IBOutlet weak var fromDatePickerHeightCons: NSLayoutConstraint!
    @IBOutlet weak var toDatePicker: UIDatePicker!
    @IBOutlet weak var toDatePickerHeightCons: NSLayoutConstraint!
    @IBOutlet weak var fromDatePickerBottomConstraints: NSLayoutConstraint!
    @IBOutlet weak var toDatePickerBottomConstraints: NSLayoutConstraint!
    
    //Mark:- LifeCycle
    //================
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func initialSetup() {
        self.fromDatePicker.datePickerMode = .date
        let fromTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.fromTapGestureAction))
        self.fromView.addGestureRecognizer(fromTapGesture)
        let toTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.toTapGestureAction))
        self.toParentView.addGestureRecognizer(toTapGesture)
        self.toDatePicker.addTarget(self, action: #selector(self.toDatePickerValueChanged), for: .valueChanged)
        self.fromDatePicker.addTarget(self, action: #selector(self.fromDatePickerValueChanged), for: .valueChanged)
    }
    
    override func setupTexts() {
        self.fromDateTitleLabel.text = LocalizedString.FromDate.localized
        self.toDateTitleLabel.text = LocalizedString.ToDate.localized
    }
    
    override func setupFonts() {
        self.fromDateTitleLabel.font = AppFonts.Regular.withSize(18.0)
        self.fromDateLabel.font = AppFonts.Regular.withSize(18.0)
        self.toDateTitleLabel.font = AppFonts.Regular.withSize(18.0)
        self.toDateLabel.font = AppFonts.Regular.withSize(18.0)
    }
    
    override func setupColors() {
        self.fromDateTitleLabel.textColor = AppColors.themeBlack
        self.fromDateLabel.textColor = AppColors.themeGray40
        self.toDateTitleLabel.textColor = AppColors.themeBlack
        self.toDateLabel.textColor = AppColors.themeGray40
    }
    
    //Mark:- Functions
    //================
    
    
    //Mark:- IBActions
    //================
    @objc func toTapGestureAction(_ gesture: UITapGestureRecognizer) {
        self.toDatePicker.isHidden = false
        UIView.animate(withDuration: AppConstants.kAnimationDuration, animations: {
            self.fromDatePickerHeightCons.constant = 0.0
            self.toDatePickerHeightCons.constant = self.datePickerViewHeightConstraint
            self.view.layoutIfNeeded()
        }) { (isDone) in
            self.secondDividerView.isHidden = true
            self.fromDatePicker.isHidden = true
        }
    }
    
    @objc func fromTapGestureAction(_ gesture: UITapGestureRecognizer) {
        self.fromDatePicker.isHidden = false
        self.secondDividerView.isHidden = false
        UIView.animate(withDuration: AppConstants.kAnimationDuration, animations: {
            self.fromDatePickerHeightCons.constant = self.datePickerViewHeightConstraint
            self.toDatePickerHeightCons.constant = 0.0
            self.view.layoutIfNeeded()
        }) { (isDone) in
            self.toDatePicker.isHidden = true
        }
    }
    
    @objc func toDatePickerValueChanged (_ datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, dd MMM yy"
        let dateValue = dateFormatter.string(from: datePicker.date)
        self.toDateLabel.text = dateValue
    }
    
    @objc func fromDatePickerValueChanged (_ datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, dd MMM yy"
        let dateValue = dateFormatter.string(from: datePicker.date)
        self.fromDateLabel.text = dateValue
    }
}

//Mark:- Extensions
//=================
extension TravelDateVC {
    
}
