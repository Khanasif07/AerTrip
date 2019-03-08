//
//  BulkBookingVC.swift
//  AERTRIP
//
//  Created by Admin on 24/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class BulkBookingVC: BaseVC {
    
    //Mark:- Properties
    //=================
    internal var checkInOutView: CheckInOutView?
    var returnUserId: String? {
        return UserInfo.loggedInUserId
    }
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var dividerView: ATDividerView!
    @IBOutlet weak var rectangleView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var mainCintainerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
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
    @IBOutlet weak var firstLineView: UIView!
    @IBOutlet weak var secondLineView: UIView!
    @IBOutlet weak var thirdLineView: UIView!
    @IBOutlet weak var fourthLineView: UIView!
    @IBOutlet weak var fifthLineView: UIView!
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
    
    override func viewDidLayoutSubviews() {
        if let view = self.checkInOutView {
            view.frame = self.datePickerView.bounds
        }
    }
    
    override func setupFonts() {
        let semiBold18 = AppFonts.SemiBold.withSize(18.0)
        let regularFontSize16 = AppFonts.Regular.withSize(16.0)
        titleLabel.font = semiBold18
        cancelButton.titleLabel?.font = AppFonts.Regular.withSize(18.0)
        self.whereLabel.font = AppFonts.Regular.withSize(20.0)
        self.cityNameLabel.font = AppFonts.SemiBold.withSize(26.0)
        self.stateNameLabel.font = AppFonts.Regular.withSize(16.0)
        self.starRatingLabel.font = regularFontSize16
        self.allStarLabel.font = AppFonts.Regular.withSize(14.0)
        self.oneStarLabel.font = regularFontSize16
        self.twoStarLabel.font = regularFontSize16
        self.threeStarLabel.font = regularFontSize16
        self.fourStarLabel.font = regularFontSize16
        self.fiveStarLabel.font = regularFontSize16
        self.bulkBookingLabel.font = regularFontSize16
        self.preferredHotelsLabel.font = regularFontSize16
        self.specialReqLabel.font = regularFontSize16
        self.roomCountLabel.font = semiBold18
        self.adultCountLabel.font = semiBold18
        self.childCountLabel.font = semiBold18
        self.preferredTextField.font = regularFontSize16
        self.specialReqTextField.font = regularFontSize16
    }
    
    override func setupTexts() {
        self.titleLabel.text = LocalizedString.BulkBooking.localized
        self.cancelButton.setTitle(LocalizedString.Cancel.localized, for: .normal)
        self.cancelButton.setTitle(LocalizedString.Cancel.localized, for: .selected)
        self.whereLabel.text = LocalizedString.WhereButton.localized
        self.starRatingLabel.text = LocalizedString.StarRating.localized
        self.allStarLabel.text = LocalizedString.AllStars.localized
        if let _ = self.returnUserId {
            self.searchButtonOutlet.setTitle(LocalizedString.Submit.localized, for: .normal)
        } else {
            self.searchButtonOutlet.setTitle(LocalizedString.LoginAndSubmit.localized, for: .normal)
        }
        self.bulkBookingLabel.text = LocalizedString.BulkBooking.localized
        self.preferredHotelsLabel.text = LocalizedString.PreferredHotels.localized
        self.specialReqLabel.text = LocalizedString.SpecialRequest.localized
    }
    
    override func setupColors() {
        
        self.titleLabel.textColor = AppColors.themeBlack
        self.cancelButton.setTitleColor(AppColors.themeGreen, for: .normal)
        self.cancelButton.setTitleColor(AppColors.themeGreen, for: .selected)
        self.cancelButton.setTitle(LocalizedString.Cancel.localized, for: .selected)
        self.whereLabel.textColor = AppColors.themeGray40
        self.cityNameLabel.textColor = AppColors.textFieldTextColor51
        self.stateNameLabel.textColor = AppColors.textFieldTextColor51
        self.dividerView.backgroundColor = AppColors.themeGray10
        self.firstLineView.backgroundColor = AppColors.themeGray10
        self.secondLineView.backgroundColor = AppColors.themeGray10
        self.thirdLineView.backgroundColor = AppColors.themeGray10
        self.fourthLineView.backgroundColor = AppColors.themeGray10
        self.fifthLineView.backgroundColor = AppColors.themeGray10
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
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else { return false }
        let finalText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        print(finalText)
        (textField === self.preferredTextField) ? (self.viewModel.preferred = finalText) : (self.viewModel.specialRequest = finalText)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let finalText = textField.text , finalText.containsWhitespace {
            textField.text = ""
        }
    }
    
    //MARK:- Methods
    //MARK:- Private
    ///InitialSetUp
    private func initialSetups() {
        self.backgroundView.alpha = 1.0
        self.backgroundView.backgroundColor = AppColors.themeBlack.withAlphaComponent(0.3)
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
    }
    
    ///ConfigureCheckInOutView
    private func configureCheckInOutView() {
        self.checkInOutView = CheckInOutView(frame: self.datePickerView.bounds)
        if let view = self.checkInOutView {
            self.datePickerView.addSubview(view)
        }
    }
    
    ///Show View
    private func show(animated: Bool) {
        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, animations: {
            self.mainCintainerBottomConstraint.constant = 0.0
            self.view.layoutIfNeeded()
        }, completion: { (isDone) in
        })
    }
    
    ///Hide View
    private func hide(animated: Bool, shouldRemove: Bool = false) {
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
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.hide(animated: true, shouldRemove: true)
    }
    
    @IBAction func starButtonsAction(_ sender: UIButton) {
        self.updateStarButtonState(forStar: sender.tag)
        self.allStarLabel.text = self.getStarString(fromArr: self.viewModel.ratingCount, maxCount: 5)
    }
    
    @IBAction func bulkBookingPopUpAction(_ sender: Any) {
        AppFlowManager.default.showBulkRoomSelectionVC(rooms: self.viewModel.roomCounts, adults:  self.viewModel.adultsCount, children:  self.viewModel.childrenCounts, delegate: self)
    }
    
    @IBAction func whereButtonAction(_ sender: UIButton) {
        AppFlowManager.default.showSelectDestinationVC(delegate: self)
    }
    
    @IBAction func searchButtonAction(_ sender: ATButton) {
        if let _ = self.returnUserId  {
            sender.isLoading = true
            self.viewModel.bulkBookingEnquiryApi()
        }
        else {
            let currentlyUsingFrom = SocialLoginVC.UsingFor.loginVerification
            AppFlowManager.default.moveToSocialLoginVC(usingFor: currentlyUsingFrom) { [weak self] in
                self?.searchButtonOutlet.setTitle(LocalizedString.Submit.localized, for: .normal)
                sender.isLoading = true
                self?.viewModel.bulkBookingEnquiryApi()
            }
        }
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
            let newValue = hotel.value.split(separator: " ")
            printDebug(newValue.first)
            self.cityNameLabel.text = "\(newValue.first ?? "")"
        }
        self.whereLabel.font = AppFonts.Regular.withSize(16.0)
        self.stateNameLabel.text = hotel.value
        self.cityNameLabel.isHidden = false
        self.stateNameLabel.isHidden = false
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
    
    func bulkBookingEnquiryFail() {
        self.searchButtonOutlet.isLoading = false
    }
}

