//
//  TravelDateVC.swift
//  AERTRIP
//
//  Created by Admin on 15/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol TravelDateVCDelegate: class {
    func didSelect(fromDate: Date?, forType: TravelDateVC.UsingFor)
    func didSelect(toDate: Date?, forType: TravelDateVC.UsingFor)
}

class TravelDateVC: BaseVC {
    enum UsingFor {
        case travelDate
        case bookingDate
        case account
    }
    
    // Mark:- Variables
    //================
    private var datePickerViewHeightConstraint: CGFloat = 215.0
    
    // Mark:- IBOutlets
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
    
    @IBOutlet weak var toDateCloseBtn: UIButton!
    @IBOutlet weak var fromDateCloseBtn: UIButton!
    var fromDatePicker: UIDatePicker!
    var toDatePicker: UIDatePicker!
    
    var currentlyUsingAs = UsingFor.account
    weak var delegate: TravelDateVCDelegate?
    
    //these all will be passed from, where the object is being created
    var oldFromDate: Date?
    var oldToDate: Date?
    var minFromDate: Date?
    
    private let dateFormate = "E, dd MMM YYYY"
    
    private let closedHeight: CGFloat = 45.0, openedHeight: CGFloat = 259.0
    
    // Mark:- LifeCycle
    //================
    
    override func initialSetup()
    {
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
    
    // Mark:- Functions
    //================
    internal func setFilterValues() {
        oldFromDate = MyBookingFilterVM.shared.travelFromDate
        oldToDate = MyBookingFilterVM.shared.travelToDate
        self.setupDateSpan()
    }
    
    private func setupDatePickers() {
       // self.showLoaderOnView(view: self.mainContainerView, show: true)
        
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
            // account
            self.fromTapGestureAction(UITapGestureRecognizer())
        }
        
        let fromTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.fromTapGestureAction))
        self.fromView.addGestureRecognizer(fromTapGesture)
        
        let toTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.toTapGestureAction))
        self.toView.addGestureRecognizer(toTapGesture)
        
        //perform(#selector(createDatePickers), with: nil, afterDelay: 0.1)
        createDatePickers()
    }
    
    @objc func createDatePickers() {
        // from date picker
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
        
        //self.showLoaderOnView(view: self.mainContainerView, show: false)
    }
    
    private func setDateOnLabels(fromDate: Date?, toDate: Date?) {
        self.toDateLabel?.text = "-"
        if let date = toDate {
            self.toDateLabel?.text = date.toString(dateFormat: self.dateFormate)
        }
        
        self.fromDateLabel?.text = "-"
        if let date = fromDate {
            self.fromDateLabel?.text = date.toString(dateFormat: self.dateFormate)
        }
        if self.toDateLabel?.text == "-" {
            self.toDateCloseBtn?.isHidden = true
            self.closeToDatePicker()
        } else {
            self.toDateCloseBtn?.isHidden = false
        }
        
        if self.fromDateLabel?.text == "-" {
            self.fromDateCloseBtn?.isHidden = true
            self.closeFromDatePicker()
        } else {
            self.fromDateCloseBtn?.isHidden = false
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
//            self.fromDatePicker.minimumDate = Date().add(years: -2)
            self.fromDatePicker.maximumDate = Date().add(years: 2)
            
            self.toDatePicker.minimumDate = self.minFromDate
//            self.toDatePicker.minimumDate = Date().add(years: -2)
            self.toDatePicker.maximumDate = Date().add(years: 2)
            
            self.fromDatePicker.setDate(self.oldFromDate ?? Date(), animated: false)
            
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
            
            self.fromDatePicker?.minimumDate = self.minFromDate
//            self.fromDatePicker.minimumDate = Date().add(years: -2)
            self.fromDatePicker?.maximumDate = Date().add(years: 2)
            
            self.toDatePicker?.minimumDate = self.minFromDate
//            self.toDatePicker.minimumDate = Date().add(years: -2)
            self.toDatePicker?.maximumDate = Date().add(years: 2)
            
            self.fromDatePicker?.setDate(self.oldFromDate ?? Date(), animated: false)
            self.toDatePicker?.setDate(self.oldToDate ?? Date(), animated: false)
            
            self.setDateOnLabels(fromDate: self.oldFromDate, toDate: self.oldToDate)
        }
        else {
            // account
//            self.fromTapGestureAction(UITapGestureRecognizer())
            
            let fromDt = self.oldFromDate ?? self.minFromDate
            self.fromDatePicker?.setDate(fromDt ?? Date(), animated: false)
            self.toDatePicker?.setDate(self.oldToDate ?? Date(), animated: false)
            
            self.fromDatePicker?.maximumDate = Date()
            self.toDatePicker?.maximumDate = Date()
            
            self.fromDatePicker?.minimumDate = self.minFromDate
            self.toDatePicker?.minimumDate = self.oldFromDate ?? fromDt
            
            self.setDateOnLabels(fromDate: fromDt ?? Date(), toDate: self.oldToDate ?? Date())
        }

    }
    
    
    private func closeBothPicker(animated: Bool) {
        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, animations: {
            // close from and to both
            self.fromViewHeightConstraint.constant = self.closedHeight - 1
            self.toViewHeightConstraint.constant = self.closedHeight
            self.fromDatePickerContainer.alpha = 0.0
            self.toDatePickerContainer.alpha = 0.0
            self.view.layoutIfNeeded()
        }) { _ in
        }
    }
    
    // Mark:- IBActions
    //================
    
    @objc func toTapGestureAction(_ gesture: UITapGestureRecognizer) {
        UIView.animate(withDuration: AppConstants.kAnimationDuration, animations: {
            // open to close from
            self.fromViewHeightConstraint.constant = self.closedHeight - 1
            self.toViewHeightConstraint.constant = self.openedHeight
            self.fromDatePickerContainer.alpha = 0.0
            self.toDatePickerContainer.alpha = 1.0
            self.view.layoutIfNeeded()
        }) { _ in
        }
        if let _ = gesture.view {
            self.oldToDate = self.toDatePicker.date
            self.setDateOnLabels(fromDate: self.oldFromDate, toDate: self.oldToDate)
        self.delegate?.didSelect(toDate: toDatePicker.date, forType: self.currentlyUsingAs)
        }
    }
    
    @objc func fromTapGestureAction(_ gesture: UITapGestureRecognizer) {
        UIView.animate(withDuration: AppConstants.kAnimationDuration, animations: {
            // open from close to
            self.fromViewHeightConstraint.constant = self.openedHeight
            self.toViewHeightConstraint.constant = self.closedHeight
            self.fromDatePickerContainer.alpha = 1.0
            self.toDatePickerContainer.alpha = 0.0
            self.view.layoutIfNeeded()
        }) { _ in
        }
        if let _ = gesture.view {
            self.oldFromDate = self.fromDatePicker.date
            self.setDateOnLabels(fromDate: self.oldFromDate, toDate: self.oldToDate)
            self.delegate?.didSelect(fromDate: self.fromDatePicker.date, forType: self.currentlyUsingAs)
        }
    }
    
    @objc func fromDatePickerValueChanged(_ datePicker: UIDatePicker) {
        if self.oldToDate == nil {
            if self.currentlyUsingAs == .bookingDate {
                self.setDateOnLabels(fromDate: self.fromDatePicker.date, toDate: self.toDatePicker.date)
            }
            else {
                self.setDateOnLabels(fromDate: self.fromDatePicker.date, toDate: self.toDatePicker.date)
            }
            self.oldFromDate = self.fromDatePicker.date
        }
        else {
            self.oldFromDate = self.fromDatePicker.date
            self.setDateOnLabels(fromDate: self.fromDatePicker.date, toDate: self.toDatePicker.date)
        }
        
        if self.toDatePicker.date.timeIntervalSince1970 < self.fromDatePicker.date.timeIntervalSince1970 {
            //self.toDatePicker.setDate(self.fromDatePicker.date, animated: false)
            //self.oldToDate = self.toDatePicker.date
            //self.setDateOnLabels(fromDate: self.fromDatePicker.date, toDate: self.toDatePicker.date)
        }
        self.delegate?.didSelect(fromDate: datePicker.date, forType: self.currentlyUsingAs)
    }
    
    @objc func toDatePickerValueChanged(_ datePicker: UIDatePicker) {
        if self.oldFromDate == nil {
            if self.currentlyUsingAs == .bookingDate {
                self.setDateOnLabels(fromDate: self.fromDatePicker.date, toDate: self.toDatePicker.date)
            }
            else {
                self.setDateOnLabels(fromDate: self.fromDatePicker.date, toDate:  self.toDatePicker.date)
            }
            
            self.oldToDate = self.toDatePicker.date
        }
        else {
            self.oldToDate = self.toDatePicker.date
            self.setDateOnLabels(fromDate: self.fromDatePicker.date, toDate: self.toDatePicker.date)
        }
        
        if self.toDatePicker.date.timeIntervalSince1970 < self.fromDatePicker.date.timeIntervalSince1970 {
            //self.fromDatePicker.setDate(self.toDatePicker.date, animated: false)
            //self.oldFromDate = self.fromDatePicker.date
            //self.setDateOnLabels(fromDate: self.fromDatePicker.date, toDate: self.toDatePicker.date)
        }
        
        self.delegate?.didSelect(toDate: datePicker.date, forType: self.currentlyUsingAs)
    }
    
    @IBAction func fromDateCloseBtnAction(_ sender: Any) {
        self.oldFromDate = nil
        self.setDateOnLabels(fromDate: self.oldFromDate, toDate: self.oldToDate)
        self.delegate?.didSelect(fromDate: nil, forType: self.currentlyUsingAs)
        closeFromDatePicker()
    }
    
    @IBAction func toDateCloseBtnAction(_ sender: Any) {
        self.oldToDate = nil
        self.setDateOnLabels(fromDate: self.oldFromDate, toDate: self.oldToDate)
        self.delegate?.didSelect(toDate: nil, forType: self.currentlyUsingAs)
        closeToDatePicker()
    }
    
    func closeFromDatePicker() {
        UIView.animate(withDuration: AppConstants.kAnimationDuration, animations: {
            // close from picker
            self.fromViewHeightConstraint.constant = self.closedHeight
            self.fromDatePickerContainer.alpha = 0.0
            self.view.layoutIfNeeded()
        }) { _ in
        }
    }
    
    func closeToDatePicker() {
        UIView.animate(withDuration: AppConstants.kAnimationDuration, animations: {
            // close to picker
            self.toViewHeightConstraint.constant = self.closedHeight
            self.toDatePickerContainer.alpha = 0.0
            self.view.layoutIfNeeded()
        }) { _ in
        }
    }
}
