//
//  TravelDateVC.swift
//  AERTRIP
//
//  Created by Admin on 15/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol TravelDateVCDelegate: class {
    func didSelect(fromDate: Date, forType: TravelDateVC.UsingFor)
    func didSelect(toDate: Date, forType: TravelDateVC.UsingFor)
}

class TravelDateVC: BaseVC {
    
    enum UsingFor {
        case travelDate
        case bookingDate
        case account
    }
    
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
    @IBOutlet weak var fromDatePickerContainer: UIView!
    
    @IBOutlet weak var toView: UIView!
    @IBOutlet weak var toDateTitleLabel: UILabel!
    @IBOutlet weak var toDateLabel: UILabel!
    @IBOutlet weak var secondDividerView: ATDividerView!
    @IBOutlet weak var thirdDividerView: ATDividerView!
    @IBOutlet weak var toDatePickerContainer: UIView!
    @IBOutlet weak var fromViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var toViewHeightConstraint: NSLayoutConstraint!
    
    
    var fromDatePicker: UIDatePicker!
    var toDatePicker: UIDatePicker!

    
    var currentlyUsingAs = UsingFor.account
    weak var delegate: TravelDateVCDelegate?
    var oldFromDate: Date?
    var oldToDate: Date?
    var minFromDate: Date?
    
    private let dateFormate = "E, dd MMM YYYY"
    
    private let closedHeight: CGFloat = 45.0, openedHeight: CGFloat = 259.0
    
    //Mark:- LifeCycle
    //================

    override func initialSetup() {
        self.setupDatePickers()
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
    private func setupDatePickers() {
        
        self.setDateOnLabels(fromDate: nil, toDate: nil)
        
        if self.currentlyUsingAs == .travelDate {
            if let _ = self.oldFromDate {
                self.fromTapGestureAction(UITapGestureRecognizer())
            }
            else if let _ = self.oldToDate {
                self.toTapGestureAction(UITapGestureRecognizer())
            }
            else {
                self.closeBothPicker(animated: false)
            }
        }
        else if self.currentlyUsingAs == .bookingDate {
            
            if let _ = self.oldFromDate {
                self.fromTapGestureAction(UITapGestureRecognizer())
            }
            else if let _ = self.oldToDate {
                self.toTapGestureAction(UITapGestureRecognizer())
            }
            else {
                self.closeBothPicker(animated: false)
            }
        }
        else {
            //account
            self.fromTapGestureAction(UITapGestureRecognizer())
        }
        
        let fromTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.fromTapGestureAction))
        self.fromView.addGestureRecognizer(fromTapGesture)

        let toTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.toTapGestureAction))
        self.toView.addGestureRecognizer(toTapGesture)
        
        func setup() {
            //from date picker
            self.fromDatePicker = UIDatePicker(frame: self.fromDatePickerContainer.bounds)
            self.fromDatePickerContainer.addSubview(self.fromDatePicker)
            self.fromDatePicker.datePickerMode = .date
            
            self.fromDatePicker.locale = UserInfo.loggedInUser?.currentLocale
            
            self.fromDatePicker.addTarget(self, action: #selector(self.fromDatePickerValueChanged), for: .valueChanged)
            
            
            //to date picker
            self.toDatePicker = UIDatePicker(frame: self.toDatePickerContainer.bounds)
            self.toDatePickerContainer.addSubview(self.toDatePicker)
            self.toDatePicker.datePickerMode = .date
            
            self.toDatePicker.locale = UserInfo.loggedInUser?.currentLocale
            
            self.toDatePicker.addTarget(self, action: #selector(self.toDatePickerValueChanged), for: .valueChanged)
            
            self.setupDateSpan()
        }
        
        
        perform(#selector(createDatePickers), with: nil, afterDelay: 0.1)
    }
    
    @objc func createDatePickers() {
        //from date picker
        self.fromDatePicker = UIDatePicker(frame: self.fromDatePickerContainer.bounds)
        self.fromDatePickerContainer.addSubview(self.fromDatePicker)
        self.fromDatePicker.datePickerMode = .date
        
        self.fromDatePicker.locale = UserInfo.loggedInUser?.currentLocale
        
        self.fromDatePicker.addTarget(self, action: #selector(self.fromDatePickerValueChanged), for: .valueChanged)
        
        
        //to date picker
        self.toDatePicker = UIDatePicker(frame: self.toDatePickerContainer.bounds)
        self.toDatePickerContainer.addSubview(self.toDatePicker)
        self.toDatePicker.datePickerMode = .date
        
        self.toDatePicker.locale = UserInfo.loggedInUser?.currentLocale
        
        self.toDatePicker.addTarget(self, action: #selector(self.toDatePickerValueChanged), for: .valueChanged)
        
        self.setupDateSpan()
    }
    
    private func setDateOnLabels(fromDate: Date?, toDate: Date?) {
        self.toDateLabel.text = "-"
        if let date = toDate {
            self.toDateLabel.text = date.toString(dateFormat: dateFormate)
        }
        
        self.fromDateLabel.text = "-"
        if let date = fromDate {
            self.fromDateLabel.text = date.toString(dateFormat: dateFormate)
        }
    }
    
    private func setupDateSpan() {
        if self.currentlyUsingAs == .travelDate {
//            if let _ = self.oldFromDate {
//                self.fromTapGestureAction(UITapGestureRecognizer())
//            }
//            else if let _ = self.oldToDate {
//                self.toTapGestureAction(UITapGestureRecognizer())
//            }
//            else {
//                self.closeBothPicker(animated: false)
//            }

            self.fromDatePicker.minimumDate = self.minFromDate
            self.fromDatePicker.maximumDate = Date().add(years: 2)
            
            self.toDatePicker.minimumDate = self.minFromDate
            self.toDatePicker.maximumDate = Date().add(years: 2)
            
            self.fromDatePicker.setDate(self.oldFromDate ?? self.minFromDate ?? Date(), animated: false)
            self.toDatePicker.setDate(self.oldToDate ?? Date(), animated: false)
            
            self.setDateOnLabels(fromDate: self.oldFromDate, toDate: self.oldToDate)
        }
        else if self.currentlyUsingAs == .bookingDate {
            
//            if let _ = self.oldFromDate {
//                self.fromTapGestureAction(UITapGestureRecognizer())
//            }
//            else if let _ = self.oldToDate {
//                self.toTapGestureAction(UITapGestureRecognizer())
//            }
//            else {
//                self.closeBothPicker(animated: false)
//            }
            
            self.fromDatePicker.minimumDate = self.minFromDate
            self.fromDatePicker.maximumDate = Date()
            
            self.toDatePicker.minimumDate = self.minFromDate
            self.toDatePicker.maximumDate = Date()
            
            self.fromDatePicker.setDate(self.oldFromDate ?? self.minFromDate ?? Date(), animated: false)
            self.toDatePicker.setDate(self.oldToDate ?? Date(), animated: false)
            
            self.setDateOnLabels(fromDate: self.oldFromDate, toDate: self.oldToDate)
        }
        else {
            //account
//            self.fromTapGestureAction(UITapGestureRecognizer())

            let fromDt = self.oldFromDate ?? self.minFromDate
            self.fromDatePicker.setDate(fromDt ?? Date(), animated: false)
            self.toDatePicker.setDate(self.oldToDate ?? Date(), animated: false)
            
            self.fromDatePicker.maximumDate = Date()
            self.toDatePicker.maximumDate = Date()
            
            self.fromDatePicker.minimumDate = self.minFromDate
            self.toDatePicker.minimumDate = self.oldFromDate ?? fromDt
            
            self.setDateOnLabels(fromDate: fromDt ?? Date(), toDate: self.oldToDate ?? Date())
        }
    }
    
    private func closeBothPicker(animated: Bool) {
        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, animations: {
            //close from and to both
            self.fromViewHeightConstraint.constant = self.closedHeight - 1
            self.toViewHeightConstraint.constant = self.closedHeight
            self.fromDatePickerContainer.alpha = 0.0
            self.toDatePickerContainer.alpha = 0.0
            self.view.layoutIfNeeded()
        }) { (isDone) in
        }
    }
    
    //Mark:- IBActions
    //================

    @objc func toTapGestureAction(_ gesture: UITapGestureRecognizer) {
        UIView.animate(withDuration: AppConstants.kAnimationDuration, animations: {
            //open to close from
            self.fromViewHeightConstraint.constant = self.closedHeight - 1
            self.toViewHeightConstraint.constant = self.openedHeight
            self.fromDatePickerContainer.alpha = 0.0
            self.toDatePickerContainer.alpha = 1.0
            self.view.layoutIfNeeded()
        }) { (isDone) in
        }
    }
    
    @objc func fromTapGestureAction(_ gesture: UITapGestureRecognizer) {
        UIView.animate(withDuration: AppConstants.kAnimationDuration, animations: {
            //open from close to
            self.fromViewHeightConstraint.constant = self.openedHeight
            self.toViewHeightConstraint.constant = self.closedHeight
            self.fromDatePickerContainer.alpha = 1.0
            self.toDatePickerContainer.alpha = 0.0
            self.view.layoutIfNeeded()
        }) { (isDone) in
        }
    }
    
    @objc func toDatePickerValueChanged (_ datePicker: UIDatePicker) {
        self.setLabelsDate()
        self.delegate?.didSelect(toDate: datePicker.date, forType: self.currentlyUsingAs)
    }
    
    @objc func fromDatePickerValueChanged (_ datePicker: UIDatePicker) {
        self.setLabelsDate()
        
        if self.toDatePicker.date.timeIntervalSince1970 < self.fromDatePicker.date.timeIntervalSince1970 {
            self.toDatePicker.minimumDate = datePicker.date
            self.toDatePicker.setDate(self.fromDatePicker.date, animated: false)
        }
        self.delegate?.didSelect(fromDate: datePicker.date, forType: self.currentlyUsingAs)
    }
    
    private func setLabelsDate() {
        self.setDateOnLabels(fromDate: self.fromDatePicker.date, toDate: self.toDatePicker.date)
    }
}
