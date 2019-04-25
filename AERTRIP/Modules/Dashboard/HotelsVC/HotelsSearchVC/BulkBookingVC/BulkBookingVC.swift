//
//  BulkBookingVC.swift
//  AERTRIP
//
//  Created by Admin on 24/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit
import IQKeyboardManager

class BulkBookingVC: BaseVC {
    
    //Mark:- Properties
    //=================
    internal var checkInOutView: CheckInOutView?
    var returnUserId: String? {
        return UserInfo.loggedInUserId
    }
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var rectangleView: UIView!
    @IBOutlet weak var topNavView: TopNavigationView!
    @IBOutlet weak var mainCintainerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var childContainerView: UIView!
    @IBOutlet weak var whereContainerView: UIView!
    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var bulkBookingView: UIView!
    @IBOutlet weak var dateInfoView : UIView!
    @IBOutlet weak var starView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var whereBtnOutlet: UIButton!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var stateNameLabel: UILabel!
    @IBOutlet weak var firstLineView: ATDividerView!
    @IBOutlet weak var secondLineView: ATDividerView!
    @IBOutlet weak var thirdLineView: ATDividerView!
    @IBOutlet weak var fourthLineView: ATDividerView!
    @IBOutlet weak var fifthLineView: ATDividerView!
    @IBOutlet weak var starRatingLabel: UILabel!
    @IBOutlet weak var allStarLabel: UILabel!
    @IBOutlet weak var oneStarLabel: UILabel!
    @IBOutlet weak var twoStarLabel: UILabel!
    @IBOutlet weak var threeStarLabel: UILabel!
    @IBOutlet weak var fourStarLabel: UILabel!
    @IBOutlet weak var fiveStarLabel: UILabel!
    @IBOutlet var starButtonsOutlet: [UIButton]!
    @IBOutlet weak var searchButtonOutlet: ATButton!
    @IBOutlet weak var bulkBookingLabel: UILabel!
    @IBOutlet weak var roomCountLabel: UILabel!
    @IBOutlet weak var adultCountLabel: UILabel!
    @IBOutlet weak var childCountLabel: UILabel!
    @IBOutlet weak var preferredHotelsLabel: UILabel!
    @IBOutlet weak var specialReqLabel: UILabel!
    @IBOutlet weak var bulkBookingPopUpBtn: UIButton!
    @IBOutlet weak var preferredTextField: UITextField! {
        didSet {
            self.preferredTextField.delegate = self
        }
    }
    @IBOutlet weak var specialReqTextField: UITextField! {
        didSet{
            self.specialReqTextField.delegate = self
        }
    }
    @IBOutlet weak var whereLabel: UILabel!
    @IBOutlet weak var bottomViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var prefredTextContainer: UIView!
    @IBOutlet weak var specialTextContainer: UIView!
    
    
    //MARK:- Properties
    //MARK:- Public
    let viewModel = BulkBookingVM()
    
    //MARK:- Private
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initialSetups()
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        IQKeyboardManager.shared().isEnableAutoToolbar = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        IQKeyboardManager.shared().isEnableAutoToolbar = true
    }
    
    override func viewDidLayoutSubviews() {
        if let view = self.checkInOutView {
            view.frame = self.datePickerView.bounds
        }
    }
    
    override func setupFonts() {
        self.whereLabel.font = ((self.cityNameLabel.text ?? "").isEmpty && (self.stateNameLabel.text ?? "").isEmpty ) ? AppFonts.Regular.withSize(20.0) : AppFonts.Regular.withSize(16.0)
        self.cityNameLabel.font = (self.cityNameLabel.text ?? "").isEmpty ? AppFonts.SemiBold.withSize(26.0) : AppFonts.SemiBold.withSize(20.0)
        self.stateNameLabel.font = AppFonts.Regular.withSize(16.0)
        self.starRatingLabel.font = AppFonts.Regular.withSize(16.0)
        self.allStarLabel.font = AppFonts.Regular.withSize(14.0)
        self.oneStarLabel.font = AppFonts.Regular.withSize(16.0)
        self.twoStarLabel.font = AppFonts.Regular.withSize(16.0)
        self.threeStarLabel.font = AppFonts.Regular.withSize(16.0)
        self.fourStarLabel.font = AppFonts.Regular.withSize(16.0)
        self.fiveStarLabel.font = AppFonts.Regular.withSize(16.0)
        self.bulkBookingLabel.font = AppFonts.Regular.withSize(16.0)
        self.preferredHotelsLabel.font = AppFonts.Regular.withSize(16.0)
        self.specialReqLabel.font = AppFonts.Regular.withSize(16.0)
        self.roomCountLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.adultCountLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.childCountLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.preferredTextField.font = AppFonts.Regular.withSize(16.0)
        self.specialReqTextField.font = AppFonts.Regular.withSize(16.0)
    }
    
    override func setupTexts() {
        self.whereLabel.text = LocalizedString.WhereButton.localized
        self.starRatingLabel.text = LocalizedString.StarRating.localized
        if let _ = self.returnUserId {
            self.searchButtonOutlet.setTitle(LocalizedString.Submit.localized, for: .normal)
        } else {
            self.searchButtonOutlet.setTitle(LocalizedString.LoginAndSubmit.localized, for: .normal)
        }
        self.bulkBookingLabel.text = LocalizedString.Guests.localized
        self.preferredHotelsLabel.text = LocalizedString.PreferredHotels.localized
        self.specialReqLabel.text = LocalizedString.SpecialRequest.localized
    }
    
    override func setupColors() {
        
        self.whereLabel.textColor = AppColors.themeGray40
        self.cityNameLabel.textColor = AppColors.textFieldTextColor51
        self.stateNameLabel.textColor = AppColors.textFieldTextColor51
        self.starRatingLabel.textColor = AppColors.themeGray40
        self.allStarLabel.textColor = AppColors.themeGray40
        self.oneStarLabel.textColor = AppColors.themeGray40
        self.twoStarLabel.textColor = AppColors.themeGray40
        self.threeStarLabel.textColor = AppColors.themeGray40
        self.fourStarLabel.textColor = AppColors.themeGray40
        self.fiveStarLabel.textColor = AppColors.themeGray40
        self.bulkBookingLabel.textColor = AppColors.themeGray40
        self.preferredHotelsLabel.textColor = AppColors.themeGray40
        self.specialReqLabel.textColor = AppColors.themeGray40
        self.specialReqTextField.textColor = AppColors.textFieldTextColor51
        self.preferredTextField.textColor = AppColors.textFieldTextColor51
        let regularFontSize16 = AppFonts.Regular.withSize(16.0)
        self.specialReqTextField.attributedPlaceholder = NSAttributedString(string: LocalizedString.IfAny.localized, attributes: [NSAttributedString.Key.foregroundColor: AppColors.themeGray20,NSAttributedString.Key.font: regularFontSize16])
        self.preferredTextField.attributedPlaceholder = NSAttributedString(string: LocalizedString.IfAny.localized, attributes: [NSAttributedString.Key.foregroundColor: AppColors.themeGray20,NSAttributedString.Key.font: regularFontSize16])
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let finalText = (textField.text ?? "").removeSpaceAsSentence
        textField.text = finalText
        (textField === self.preferredTextField) ? (self.viewModel.preferred = finalText) : (self.viewModel.specialRequest = finalText)
    }
    
    //MARK:- Methods
    //MARK:- Private
    ///InitialSetUp
    private func initialSetups() {
        self.view.alpha = 1.0
        self.view.backgroundColor = AppColors.themeBlack.withAlphaComponent(0.3)
        self.bottomViewHeightConstraint.constant = AppFlowManager.default.safeAreaInsets.bottom
        
        self.topNavView.delegate = self
        self.topNavView.configureNavBar(title: LocalizedString.BulkBooking.localized, isLeftButton: false, isFirstRightButton: true, isSecondRightButton: false, isDivider: true)
        self.topNavView.configureFirstRightButton(normalTitle: LocalizedString.Cancel.localized, selectedTitle: LocalizedString.Cancel.localized, normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen, font: AppFonts.Regular.withSize(18.0))
        
        self.searchButtonOutlet.layer.cornerRadius = 25.0
        for starBtn in self.starButtonsOutlet {
            starBtn.isHighlighted = true
        }
        //self.rectangleView.roundCorners(corners: [.topLeft, .topRight], radius: 15.0)
        self.rectangleView.cornerRadius = 15.0
        self.rectangleView.layer.masksToBounds = true
        self.configureCheckInOutView()
        self.cityNameLabel.isHidden = true
        self.stateNameLabel.isHidden = true
        self.hide(animated: false)
        delay(seconds: 0.1) { [weak self] in
            self?.show(animated: true)
        }
        
        self.setSearchFormData()
        
        let prefTapGest = UITapGestureRecognizer(target: self, action: #selector(preferredButtonAction))
        self.prefredTextContainer.addGestureRecognizer(prefTapGest)
        
        let specTapGest = UITapGestureRecognizer(target: self, action: #selector(specialReqAction))
        self.specialTextContainer.addGestureRecognizer(specTapGest)

    }
    
    private func setSearchFormData() {
        let oldData = self.viewModel.oldData
        
        self.viewModel.destination = oldData.destName
        self.viewModel.source = oldData.destName
        self.viewModel.checkInDate = oldData.checkInDate
        self.viewModel.checkOutDate = oldData.checkOutDate
        self.viewModel.roomCounts = 5
        self.viewModel.adultsCount = 10
        self.viewModel.childrenCounts = 0
        
        self.cityNameLabel.text = oldData.cityName
        self.stateNameLabel.text = oldData.stateName
        self.cityNameLabel.isHidden = (self.cityNameLabel.text ?? "").isEmpty
        self.stateNameLabel.isHidden = (self.stateNameLabel.text ?? "").isEmpty
        
        self.checkInOutView?.setDates(fromData: oldData)
        
        self.updateRoomData(rooms: self.viewModel.roomCounts, adults: self.viewModel.adultsCount, children: self.viewModel.childrenCounts)
        
        for star in oldData.ratingCount {
            self.updateStarButtonState(forStar: star)
        }
        
        self.allStarLabel.text = self.getStarString(fromArr: self.viewModel.ratingCount, maxCount: 5)
        
    }
    
    ///ConfigureCheckInOutView
    private func configureCheckInOutView() {
        self.checkInOutView = CheckInOutView(frame: self.datePickerView.bounds)
        if let view = self.checkInOutView {
            view.delegate = self
            self.datePickerView.addSubview(view)
        }
    }
    
    ///Show View
    private func show(animated: Bool) {
        self.bottomView.isHidden = false
        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, animations: {
            self.mainCintainerBottomConstraint.constant = 0.0
            self.view.layoutIfNeeded()
        }, completion: { (isDone) in
        })
    }
    
    ///Hide View
    private func hide(animated: Bool, shouldRemove: Bool = false) {
        self.bottomView.isHidden = true
        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, animations: {
            self.mainCintainerBottomConstraint.constant = -(self.mainContainerView.frame.height + 100)
            self.view.layoutIfNeeded()
        }, completion: { (isDone) in
            if shouldRemove {
                self.removeFromParentVC
            }
        })
    }
    
    ///Star Button State
    private func updateStarButtonState(forStar: Int, isSettingFirstTime: Bool = false) {
        guard 1...5 ~= forStar else {return}
        if let currentButton = self.starButtonsOutlet.filter({ (button) -> Bool in
            button.tag == forStar
        }).first {
            if isSettingFirstTime {
                currentButton.isSelected = true
            }
            else {
                currentButton.isSelected = !currentButton.isSelected
            }
            currentButton.isHighlighted = false
            if self.viewModel.ratingCount.contains(forStar) {
                self.viewModel.ratingCount.remove(at: self.viewModel.ratingCount.firstIndex(of: forStar)!)
            }
            else {
                self.viewModel.ratingCount.append(forStar)
            }
        }
        if self.viewModel.ratingCount.isEmpty || self.viewModel.ratingCount.count == 5 {
            delay(seconds: 0.1) {
                for starBtn in self.starButtonsOutlet {
                    starBtn.isSelected = false
                    starBtn.isHighlighted = true
                }
                self.viewModel.ratingCount.removeAll()
            }
        } else {
            for starBtn in self.starButtonsOutlet {
                starBtn.isHighlighted = false
            }
        }
    }
    
    ///Get Star Rating
    private func getStarString(fromArr: [Int], maxCount: Int) -> String {
        var arr = Array(Set(fromArr))
        arr.sort()
        var final = ""
        var start: Int?
        var end: Int?
        var prev: Int?
        
        if arr.isEmpty || arr.count == maxCount {
            final = "All \(LocalizedString.stars.localized)"//"0 \(LocalizedString.stars.localized)"
            return final
        }
            //        else if arr.count == maxCount {
            //            final = "All \(LocalizedString.stars.localized)"
            //            return final
            //        }
        else if arr.count == 1 {
            final = "\(arr[0]) \((arr[0] == 1) ? "\(LocalizedString.star.localized)" : "\(LocalizedString.stars.localized)")"
            return final
        }
        
        for (idx,value) in arr.enumerated() {
            let diff = value - (prev ?? 0)
            if diff == 1 {
                //number is successor
                if start == nil {
                    start = prev
                }
                end = value
            }
            else if diff > 1 {
                //number is not successor
                if start == nil {
                    
                    if let p = prev {
                        final += "\(p), "
                    }
                    
                    if idx == (arr.count - 1) {
                        final += "\(value), "
                    }
                }
                else {
                    if let s = start, let e = end {
                        final += (s != e) ? "\(s)-\(e), " : "\(s), "
                        start = nil
                        end = nil
                        prev = nil
                        if idx == (arr.count - 1) {
                            final += "\(value), "
                        }
                    }
                    else {
                        if idx == (arr.count - 1) {
                            final += "\(value), "
                        }
                    }
                }
            }
            prev = value
        }
        
        if let s = start, let e = end {
            final += (s != e) ? "\(s)-\(e), " : "\(s), "
            start = nil
            end = nil
        }
        final.removeLast(2)
        return final + " \(LocalizedString.stars.localized)"
    }
    
    ///Data For Api
    private func dataForApi(hotel: SearchedDestination) {
        self.viewModel.destination = hotel.city
        self.viewModel.source = hotel.dest_name
    }
    
    ///Update Room Data
    private func updateRoomData(rooms: Int, adults: Int, children: Int) {
        self.roomCountLabel.text = "\(rooms)"
        self.adultCountLabel.text = "\(adults)"
        self.childCountLabel.text = "\(children)"
    }
    
    //MARK:- Public
    
    
    //MARK:- Action
    @IBAction func starButtonsAction(_ sender: UIButton) {
        self.updateStarButtonState(forStar: sender.tag)
        self.allStarLabel.text = self.getStarString(fromArr: self.viewModel.ratingCount, maxCount: 5)
    }
    
    @IBAction func bulkBookingPopUpAction(_ sender: Any) {
//        dismissKeyboard()
        self.view.endEditing(true)
        AppFlowManager.default.showBulkRoomSelectionVC(rooms: self.viewModel.roomCounts, adults:  self.viewModel.adultsCount, children:  self.viewModel.childrenCounts, delegate: self)
    }
    
    @IBAction func whereButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        AppFlowManager.default.showSelectDestinationVC(delegate: self,currentlyUsingFor: .bulkBooking)
    }
    
    @IBAction func searchButtonAction(_ sender: ATButton) {
        if let _ = self.returnUserId  {
            sender.isLoading = true
            self.viewModel.bulkBookingEnquiryApi()
        }
        else {
            self.statusBarStyle = .default
            AppFlowManager.default.proccessIfUserLoggedIn(verifyingFor: .loginVerificationForBulkbooking) { [weak self] (isGuest) in
                guard let sSelf = self else {return}
                if let vc = sSelf.parent {
                    sSelf.statusBarStyle = .lightContent
                    AppFlowManager.default.popToViewController(vc, animated: true)
                }
                sSelf.searchButtonOutlet.setTitle(LocalizedString.Submit.localized, for: .normal)
                sender.isLoading = true
                sSelf.viewModel.bulkBookingEnquiryApi()
            }
        }
    }
    
    @objc func preferredButtonAction() {
        self.view.endEditing(true)
        self.preferredTextField.becomeFirstResponder()
    }
    
    @objc func specialReqAction() {
        self.view.endEditing(true)
        self.specialReqTextField.becomeFirstResponder()
    }
}

//MARK:- TopNavigationViewDelegate
//==================================
extension BulkBookingVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.hide(animated: true, shouldRemove: true)
    }
}

//MARK:- SelectDestinationVCDelegate
//==================================
extension BulkBookingVC: SelectDestinationVCDelegate {
    func didSelectedDestination(hotel: SearchedDestination) {
        printDebug("selected: \(hotel)")
        if !hotel.city.isEmpty {
            self.cityNameLabel.text = hotel.city
        } else {
            let newValue = hotel.value.components(separatedBy: ",")
            printDebug(newValue.first)
            self.cityNameLabel.text = newValue.first ?? ""
        }
        self.whereLabel.font = AppFonts.Regular.withSize(16.0)
        var splittedStringArray = hotel.value.components(separatedBy: ",")
        splittedStringArray.removeFirst()
        let stateName = splittedStringArray.joined(separator: ",")
        self.stateNameLabel.text = stateName//hotel.value
//        self.stateNameLabel.text = hotel.value
        self.cityNameLabel.isHidden = (self.cityNameLabel.text ?? "").isEmpty
        self.stateNameLabel.isHidden = (self.stateNameLabel.text ?? "").isEmpty
        self.dataForApi(hotel: hotel)
    }
}

//MARK:- BulkRoomSelectionVCDelegate
//==================================
extension BulkBookingVC: BulkRoomSelectionVCDelegate {
    func didSelectRooms(rooms: Int, adults: Int, children: Int) {
        printDebug("\(rooms),\(adults),\(children)")
        self.viewModel.roomCounts = rooms
        self.viewModel.adultsCount = adults
        self.viewModel.childrenCounts = children
        self.updateRoomData(rooms: rooms, adults: adults, children: children)
    }
}

//MARK:- BulkBookingVMDelegate
//============================
extension BulkBookingVC: BulkBookingVMDelegate {
    func bulkBookingEnquirySuccess(enquiryId: String) {
        print(enquiryId)
        self.searchButtonOutlet.isLoading = false
        self.hide(animated: true, shouldRemove: true)
        AppFlowManager.default.showBulkEnquiryVC()
    }
    
    func bulkBookingEnquiryFail(errors:ErrorCodes) {
        self.searchButtonOutlet.isLoading = false
        AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .hotelsSearch)
    }
}

//MARK:- CheckInOutViewDelegate
//MARK:-
extension BulkBookingVC: CheckInOutViewDelegate {
    
    func selectCheckInDate(_ sender: UIButton) {
        AppFlowManager.default.moveHotelCalenderVC(isHotelCalendar: true,checkInDate: self.viewModel.oldData.checkInDate.toDate(dateFormat: "yyyy-MM-dd") ?? Date(), checkOutDate: self.viewModel.oldData.checkOutDate.toDate(dateFormat: "yyyy-MM-dd"), delegate: self)
    }
    
    func selectCheckOutDate(_ sender: UIButton) {
        
        AppFlowManager.default.moveHotelCalenderVC(isHotelCalendar: true,checkInDate: self.viewModel.oldData.checkInDate.toDate(dateFormat: "yyyy-MM-dd") ?? Date(), checkOutDate: self.viewModel.oldData.checkOutDate.toDate(dateFormat: "yyyy-MM-dd"), delegate: self) }
}

//MARK:- CalendarDataHandler
//MARK:-
extension BulkBookingVC: CalendarDataHandler {
    func selectedDates(fromCalendar startDate: Date!, end endDate: Date!, isHotelCalendar: Bool, isReturn: Bool) {
        if startDate != nil {
            self.viewModel.oldData.checkInDate = startDate.toString(dateFormat: "yyyy-MM-dd")
        }
        if endDate != nil {
            self.viewModel.oldData.checkOutDate = endDate.toString(dateFormat: "yyyy-MM-dd")
        }
        if let checkInOutVw = self.checkInOutView {
            checkInOutVw.setDates(fromData: self.viewModel.oldData)
        }
        printDebug(startDate)
        printDebug(endDate)
        printDebug(isHotelCalendar)
        printDebug(isReturn)
    }
}
