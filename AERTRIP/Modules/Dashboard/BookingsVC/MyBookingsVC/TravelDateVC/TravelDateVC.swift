//
//  TravelDateVC.swift
//  AERTRIP
//
//  Created by Admin on 15/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol TravelDateVCDelegate: class {
    func didSelect(fromDate: Date)
    func didSelect(toDate: Date)
}

class TravelDateVC: BaseVC {
    
    //Mark:- Variables
    //================
    private var datePickerViewHeightConstraint: CGFloat = 215.0
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var fromView: UIView!
    @IBOutlet weak var fromDateTitleLabel: UILabel!
    @IBOutlet weak var fromDateLabel: UILabel!
    @IBOutlet weak var firstDividerView: ATDividerView!
    @IBOutlet weak var fromDatePicker: UIDatePicker!
    
    @IBOutlet weak var toView: UIView!
    @IBOutlet weak var toDateTitleLabel: UILabel!
    @IBOutlet weak var toDateLabel: UILabel!
    @IBOutlet weak var secondDividerView: ATDividerView!
    @IBOutlet weak var thirdDividerView: ATDividerView!
    @IBOutlet weak var toDatePicker: UIDatePicker!
    @IBOutlet weak var fromViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var toViewHeightConstraint: NSLayoutConstraint!
    
    
    
    weak var delegate: TravelDateVCDelegate?
    var oldFromDate: Date?
    var minFromDate: Date?
    var oldToDate: Date?
    
    private let dateFormate = "E, dd MMM YYYY"
    
    private let closedHeight: CGFloat = 45.0, openedHeight: CGFloat = 259.0
    
    //Mark:- LifeCycle
    //================
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func initialSetup() {
        self.fromDatePicker.datePickerMode = .date
        
        self.fromDatePicker.locale = UserInfo.loggedInUser?.currentLocale
        self.toDatePicker.locale = UserInfo.loggedInUser?.currentLocale
        
        let fromTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.fromTapGestureAction))
        self.fromView.addGestureRecognizer(fromTapGesture)
        let toTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.toTapGestureAction))
        self.toView.addGestureRecognizer(toTapGesture)
        self.toDatePicker.addTarget(self, action: #selector(self.toDatePickerValueChanged), for: .valueChanged)
        self.fromDatePicker.addTarget(self, action: #selector(self.fromDatePickerValueChanged), for: .valueChanged)
        
        let fromDt = self.oldFromDate ?? self.minFromDate
        self.fromDatePicker.setDate(fromDt ?? Date(), animated: false)
        self.toDatePicker.setDate(self.oldToDate ?? Date(), animated: false)
        
        self.fromDatePicker.maximumDate = Date()
        self.toDatePicker.maximumDate = Date()
        
        self.fromDatePicker.minimumDate = self.minFromDate
        self.toDatePicker.minimumDate = self.oldFromDate ?? fromDt
        
        self.toDateLabel.text = (self.oldToDate ?? Date()).toString(dateFormat: dateFormate)
        self.fromDateLabel.text = (fromDt ?? Date()).toString(dateFormat: dateFormate)
        
        self.fromTapGestureAction(fromTapGesture)
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
        UIView.animate(withDuration: AppConstants.kAnimationDuration, animations: {
            //open to close from
            self.fromViewHeightConstraint.constant = self.closedHeight - 1
            self.toViewHeightConstraint.constant = self.openedHeight
            self.fromDatePicker.alpha = 0.0
            self.toDatePicker.alpha = 1.0
            self.view.layoutIfNeeded()
        }) { (isDone) in
        }
    }
    
    @objc func fromTapGestureAction(_ gesture: UITapGestureRecognizer) {
        UIView.animate(withDuration: AppConstants.kAnimationDuration, animations: {
            //open from close to
            self.fromViewHeightConstraint.constant = self.openedHeight
            self.toViewHeightConstraint.constant = self.closedHeight
            self.fromDatePicker.alpha = 1.0
            self.toDatePicker.alpha = 0.0
            self.view.layoutIfNeeded()
        }) { (isDone) in
        }
    }
    
    @objc func toDatePickerValueChanged (_ datePicker: UIDatePicker) {
        self.setLabelsDate()
        self.delegate?.didSelect(toDate: datePicker.date)
    }
    
    @objc func fromDatePickerValueChanged (_ datePicker: UIDatePicker) {
        self.setLabelsDate()
        
//        if datePicker.date.timeIntervalSince1970 > (self.toDatePicker.minimumDate?.timeIntervalSince1970 ?? 0) {
//            self.toDatePicker.setDate(datePicker.date, animated: false)
//            self.toDatePickerValueChanged(self.toDatePicker)
//        }
        self.toDatePicker.minimumDate = datePicker.date
        self.delegate?.didSelect(fromDate: datePicker.date)
    }
    
    private func setLabelsDate() {
        self.fromDateLabel.text = self.fromDatePicker.date.toString(dateFormat: dateFormate)
        self.toDateLabel.text = self.toDatePicker.date.toString(dateFormat: dateFormate)
    }
}

//Mark:- Extensions
//=================
extension TravelDateVC {
    
}
