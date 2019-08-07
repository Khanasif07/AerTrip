//
//  HotelsSearchVC.swift
//  AERTRIP
//
//  Created by Admin on 11/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

class HotelsSearchVC: BaseVC {
    
    //MARK:- Properties
    //=================
    internal var checkInOutView: CheckInOutView?
    internal var recentSearchesView: RecentHotelSearcheView?
    private var previousOffSet = CGPoint.zero
    private var collectionViewHeight: CGFloat = 85.5
    private var containerViewHeight: CGFloat = 544.0
    private var scrollViewContentSize: CGSize = CGSize.zero
    private var recentSearchHeight: CGFloat = 194.0
    private var addRoomPicIndex: IndexPath?
    private(set) var viewModel = HotelsSearchVM()
    private var needToGetRecentSearches: Bool = false
    private var returnUserId: String? {
        return UserInfo.loggedInUserId
    }
    
    //MARK:- IBOutlets
    //================
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var whereContainerView: UIView!
    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var addRoomView: UIView!
    @IBOutlet weak var starView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var whereBtnOutlet: UIButton!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var stateNameLabel: UILabel!
    @IBOutlet weak var firstLineView: ATDividerView!
    @IBOutlet weak var secondLineView: ATDividerView!
    @IBOutlet weak var thirdLineView: ATDividerView!
    @IBOutlet weak var fourthLineView: ATDividerView!
    @IBOutlet weak var starRatingLabel: UILabel!
    @IBOutlet weak var allStarLabel: UILabel!
    @IBOutlet weak var oneStarLabel: UILabel!
    @IBOutlet weak var twoStarLabel: UILabel!
    @IBOutlet weak var threeStarLabel: UILabel!
    @IBOutlet weak var fourStarLabel: UILabel!
    @IBOutlet weak var fiveStarLabel: UILabel!
    @IBOutlet var starButtonsOutlet: [UIButton]!
    @IBOutlet weak var searchBtnOutlet: ATButton!
    @IBOutlet weak var bulkBookingsLbl: UILabel!
    @IBOutlet weak var addRoomCollectionView: UICollectionView! {
        didSet {
            self.addRoomCollectionView.delegate = self
            self.addRoomCollectionView.dataSource = self
        }
    }
    @IBOutlet weak var containerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var whereLabel: UILabel!
    @IBOutlet weak var recentContainerParentView: UIView!
    @IBOutlet weak var recentContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var recentSearchesContainerView: UIView! {
        didSet {
            self.recentSearchesContainerView.layoutMargins = UIEdgeInsets(top: -20.0, left: -20.0, bottom: -20.0, right: -20.0)
        }
    }
    
    
    //MARK:- ViewLifeCycle
    //MARK:-
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func initialSetup() {
        
        self.cityNameLabel.text = ""
        self.stateNameLabel.text = ""
        self.manageAddressLabels()
        
        self.shadowSetUp()
        self.containerView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        self.scrollView.delegate = self
        self.searchBtnOutlet.layer.cornerRadius = 25.0
        self.configureCheckInOutView()
        self.configureRecentSearchesView()
        self.hideRecentSearchesView()
        self.setDataFromPreviousSearch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.getRecentSearchesData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let view = self.checkInOutView {
            view.frame = self.datePickerView.bounds
        }
        if let view = self.recentSearchesView {
            view.frame = self.recentSearchesContainerView.bounds
        }
        if !(self.scrollViewContentSize == .zero) {
            self.updateCollectionViewFrame()
        }
        self.shadowSetUp()
    }
    
    override func bindViewModel() {
        self.addRoomCollectionView.registerCell(nibName: AddRoomCell.reusableIdentifier)
        self.addRoomCollectionView.registerCell(nibName: AddRoomPictureCell.reusableIdentifier)
        self.viewModel.delegate = self
    }
    
    override func setupFonts() {
        let regularFontSize16 = AppFonts.Regular.withSize(16.0)
        self.cityNameLabel.font = AppFonts.SemiBold.withSize(26.0)
        self.stateNameLabel.font = AppFonts.Regular.withSize(16.0)
        self.starRatingLabel.font = regularFontSize16
        self.allStarLabel.font = AppFonts.Regular.withSize(14.0)
        self.oneStarLabel.font = regularFontSize16
        self.twoStarLabel.font = regularFontSize16
        self.threeStarLabel.font = regularFontSize16
        self.fourStarLabel.font = regularFontSize16
        self.fiveStarLabel.font = regularFontSize16
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
        self.attributeLabelSetUp()
    }
    
    override func setupTexts() {
        self.whereLabel.text = LocalizedString.WhereButton.localized
        self.starRatingLabel.text = LocalizedString.StarRating.localized
        self.searchBtnOutlet.setTitle(LocalizedString.search.localized, for: .normal)
    }
    
    //ScrollViewDidScroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //dont do anything if bouncing
        let difference = scrollView.contentOffset.y - previousOffSet.y
        if let parent = parent as? DashboardVC{
            if difference > 0 {
                //check if reached bottom
                if parent.mainScrollView.contentOffset.y + parent.mainScrollView.height < parent.mainScrollView.contentSize.height{
                    if scrollView.contentOffset.y > 0.0 {
                        parent.mainScrollView.contentOffset.y = min(parent.mainScrollView.contentOffset.y + difference, parent.mainScrollView.contentSize.height - parent.mainScrollView.height)
                        scrollView.contentOffset = CGPoint.zero
                    }
                }
            } else {
                if parent.mainScrollView.contentOffset.y > 0.0 {
                    if scrollView.contentOffset.y <= 0.0 {
                        parent.mainScrollView.contentOffset.y = max(parent.mainScrollView.contentOffset.y + difference, 0.0)
                    }
                }
            }
        }
        previousOffSet = scrollView.contentOffset
    }
    
    //MARK:- Methods
    //=============
    
    //MARK:- Private
    ///Shadow Set Up
    private func shadowSetUp() {
        // corner radius
        self.containerView.layer.cornerRadius = 10
        // border
        //self.containerView.layer.borderWidth = 1.0
        //        self.containerView.layer.borderColor = UIColor.black.cgColor
        // shadow
        self.containerView.layer.shadowColor = AppColors.themeBlack.withAlphaComponent(0.16).cgColor// UIColor.black.cgColor
        self.containerView.layer.shadowOffset = CGSize(width: 0, height: 16)
        self.containerView.layer.shadowOpacity = 0.7
        self.containerView.layer.shadowRadius = 6.0
    }
    
    ///ConfigureCheckInOutView
    private func configureCheckInOutView() {
        self.checkInOutView = CheckInOutView(frame: self.datePickerView.bounds)
        if let view = self.checkInOutView {
            view.delegate = self
            self.datePickerView.addSubview(view)
        }
    }
    
    ///ConfigureRecentSearchesView
    private func configureRecentSearchesView() {
        self.recentSearchesView = RecentHotelSearcheView(frame: self.recentSearchesContainerView.bounds)
        if let view = self.recentSearchesView {
            view.delegate = self
            self.recentSearchesContainerView.addSubview(view)
        }
    }
    
    ///AttributeLabelSetup
    private func attributeLabelSetUp() {
        let attributedString = NSMutableAttributedString()
        let grayAttribute = [NSAttributedString.Key.font: AppFonts.Regular.withSize(14.0), NSAttributedString.Key.foregroundColor: AppColors.themeGray40] as [NSAttributedString.Key : Any]
        let greenAtrribute = [NSAttributedString.Key.font: AppFonts.SemiBold.withSize(14.0), NSAttributedString.Key.foregroundColor: AppColors.themeGreen]
        let greyAttributedString = NSAttributedString(string: LocalizedString.WantMoreRooms.localized, attributes: grayAttribute)
        let greenAttributedString = NSAttributedString(string: " " + LocalizedString.RequestBulkBooking.localized, attributes: greenAtrribute)
        attributedString.append(greyAttributedString)
        attributedString.append(greenAttributedString)
        self.bulkBookingsLbl.attributedText = attributedString
        let tapGestureOnText = UITapGestureRecognizer(target: self, action: #selector(self.tapLabel))
        self.bulkBookingsLbl.addGestureRecognizer(tapGestureOnText)
    }
    
    ///UpdateCollectionViewFrame
    private func updateCollectionViewFrame() {
        if self.viewModel.searchedFormData.adultsCount.count == 2 {
            UIView.animate(withDuration: AppConstants.kAnimationDuration, animations: {
                self.containerViewHeightConstraint.constant = self.containerViewHeight + self.collectionViewHeight
                //self.scrollView.contentSize.height = self.scrollViewContentSize.height + self.collectionViewHeight
                self.view.layoutIfNeeded()
            }) { (isComleted) in
                //                self.scrollView.contentSize.height = self.scrollViewContentSize.height + self.collectionViewHeight
                if self.recentContainerParentView.isHidden == false {
                    self.scrollView.contentSize.height = self.containerViewHeight + self.collectionViewHeight + self.recentSearchHeight + 20.0
                } else {
                    self.scrollView.contentSize.height = self.containerViewHeight + self.collectionViewHeight + 20.0
                }
            }
        } else if self.viewModel.searchedFormData.adultsCount.count == 1 {
            UIView.animate(withDuration: AppConstants.kAnimationDuration, animations: {
                self.containerViewHeightConstraint.constant =  self.containerViewHeight
                //                self.scrollView.contentSize.height = self.scrollViewContentSize.height
                self.view.layoutIfNeeded()
            }) { (isComleted) in
                //self.scrollView.contentSize.height = self.scrollViewContentSize.height
                if self.recentContainerParentView.isHidden == false {
                    self.scrollView.contentSize.height = self.containerViewHeight + self.recentSearchHeight + 20.0
                } else {
                    self.scrollView.contentSize.height = self.containerViewHeight + 20.0
                }
            }
        }
    }
    
    private func manageAddressLabels() {
        self.whereLabel.font = (self.cityNameLabel.text ?? "").isEmpty ? AppFonts.Regular.withSize(20.0) : AppFonts.Regular.withSize(16.0)
        self.cityNameLabel.isHidden = (self.cityNameLabel.text ?? "").isEmpty
        self.stateNameLabel.isHidden = (self.stateNameLabel.text ?? "").isEmpty
    }
    
    ///GetDataFromPreviousSearch
    private func setDataFromPreviousSearch(olddata: HotelFormPreviosSearchData? = nil, isSettingForFirstTime: Bool = false) {
        let date = Date()
        var oldData = olddata ?? HotelsSearchVM.hotelFormData
        if olddata != nil {
            self.viewModel.searchedFormData = olddata ?? HotelFormPreviosSearchData()
        } else {
            self.viewModel.searchedFormData = oldData
        }
        
        //set selected city
        self.cityNameLabel.text = self.viewModel.searchedFormData.cityName
        self.stateNameLabel.text = self.viewModel.searchedFormData.stateName
        self.manageAddressLabels()
        
        //set checkIn/Out Date
        if let checkInDate = oldData.checkInDate.toDate(dateFormat: "yyyy-MM-dd") {
            
            //if checkIn date didn't expired then checkIn and checkOut date will be same
            //no need to do anything
            
            if checkInDate.daysFrom(date) < 0 {
                /*if checkIn date expired then
                 1. Make today as checkIn date
                 2. Check if checkOut date expired
                */
                self.viewModel.searchedFormData.checkInDate = Date().addDay(days: 0) ?? ""
                let newCheckInData = self.viewModel.searchedFormData.checkInDate.toDate(dateFormat: "yyyy-MM-dd") ?? Date()
                //if checkOut date didn't expired then checkOut date will be same
                //no need to do anything
                if let checkOutDate = oldData.checkOutDate.toDate(dateFormat: "yyyy-MM-dd"), checkOutDate.daysFrom(newCheckInData) < 0 {
                    //if checkOut date expired and not equal to checkIn date then make blank it.
                    self.viewModel.searchedFormData.checkOutDate = ""
                }
            }
            else if checkInDate.daysFrom(date) == 0, let checkOutDate = oldData.checkOutDate.toDate(dateFormat: "yyyy-MM-dd"), checkOutDate.daysFrom(checkInDate) <= 0 {
                /* if checkIn date is today then check if checkout date is not today
                 
                 */
                //if checkOut date expired and not equal to checkIn date then make blank it.
                self.viewModel.searchedFormData.checkOutDate = ""
            }
        }
        self.checkInOutView?.setDates(fromData: self.viewModel.searchedFormData)
        
        //setting stars
        if !self.viewModel.searchedFormData.ratingCount.isEmpty, self.viewModel.searchedFormData.ratingCount.count < 5 {
            self.viewModel.searchedFormData.ratingCount.removeAll()
        }
        if oldData.ratingCount.isEmpty {
            oldData.ratingCount = [1,2,3,4,5]
        }
        
        //reset all the buttons first
        for starBtn in self.starButtonsOutlet {
            starBtn.isSelected = false
            starBtn.isHighlighted = false
        }
        for star in oldData.ratingCount {
            self.updateStarButtonState(forStar: star, isSettingFirstTime: isSettingForFirstTime)
        }
        self.allStarLabel.text = self.getStarString(fromArr: self.viewModel.searchedFormData.ratingCount, maxCount: 5)
        
        //set room selection data
        if self.viewModel.searchedFormData.adultsCount.count >= 2 {
            self.containerViewHeightConstraint.constant = self.containerViewHeight + self.collectionViewHeight
        } else if self.viewModel.searchedFormData.adultsCount.count == 1 {
            self.containerViewHeightConstraint.constant = self.containerViewHeight
        }
        self.addRoomCollectionView.reloadData()
    }

    ///RecentSearchData
    private func getRecentSearchData() {
        if let _ = self.returnUserId  {
            self.viewModel.getRecentSearchesData()
        } else {
            self.hideRecentSearchesView()
            printDebug("User is not logged in")
        }
    }
    
    ///ReloadCollectionView
    private func reloadCollectionView() {
        UIView.performWithoutAnimation {
            self.addRoomCollectionView.reloadData()
        }
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
            if self.viewModel.searchedFormData.ratingCount.contains(forStar) {
                self.viewModel.searchedFormData.ratingCount.remove(at: self.viewModel.searchedFormData.ratingCount.firstIndex(of: forStar)!)
            }
            else {
                self.viewModel.searchedFormData.ratingCount.append(forStar)
            }
        }
        if self.viewModel.searchedFormData.ratingCount.isEmpty || self.viewModel.searchedFormData.ratingCount.count == 5 {
            delay(seconds: 0.1) {
                for starBtn in self.starButtonsOutlet {
                    starBtn.isSelected = false
                    starBtn.isHighlighted = true
                }
                self.viewModel.searchedFormData.ratingCount.removeAll()
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
                        final += (s != e) ? "\(s) - \(e), " : "\(s), "
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
            final += (s != e) ? "\(s) - \(e), " : "\(s), "
            start = nil
            end = nil
        }
        final.removeLast(2)
        return final + " \(LocalizedString.stars.localized)"
    }
    
    ///Hide Recent Search View
    private func hideRecentSearchesView() {
        self.recentContainerParentView.isHidden = true
        self.recentContainerHeightConstraint.constant = 0.0
        if let recentSearchesView = self.recentSearchesView {
            recentSearchesView.isHidden = true
        }
        self.setScrollViewHeight(isRcentSearches: false)
    }
    
    ///Show Recent Search View
    private func showRecentSearchView() {
        self.recentContainerParentView.isHidden = false
        self.recentContainerHeightConstraint.constant = self.recentSearchHeight
        if let recentSearchesView = self.recentSearchesView {
            recentSearchesView.isHidden = false
        }
        self.setScrollViewHeight(isRcentSearches: true)
    }
    
    private func setScrollViewHeight(isRcentSearches: Bool) {
        if isRcentSearches {
            if self.viewModel.searchedFormData.adultsCount.count < 2 {
                self.scrollView.contentSize.height = self.containerViewHeight + self.recentSearchHeight + 20.0
            } else {
                self.scrollView.contentSize.height = self.containerViewHeight + self.collectionViewHeight + self.recentSearchHeight + 20.0
            }
        } else {
            if self.viewModel.searchedFormData.adultsCount.count < 2 {
                self.scrollView.contentSize.height = self.containerViewHeight + 20.0
            } else {
                self.scrollView.contentSize.height = self.containerViewHeight + self.collectionViewHeight + 20.0
            }
        }
    }
    
    private func validateData() -> Bool {
        var flag = true
        if self.viewModel.searchedFormData.destName.isEmpty {
            AppToast.default.showToastMessage(message: "Please select destination name.")
            flag = false
        }
        else if self.viewModel.searchedFormData.checkInDate.isEmpty {
            AppToast.default.showToastMessage(message: "Please select check in date.")
            flag = false
        }
        else if self.viewModel.searchedFormData.checkOutDate.isEmpty {
            AppToast.default.showToastMessage(message: "Please select check out date.")
            flag = false
        }
        
        return flag
    }
    
    //MARK:- Public
    //MARK:- IBAction
    //===============
    
    @IBAction func starButtonsAction(_ sender: UIButton) {
        self.updateStarButtonState(forStar: sender.tag)
        self.allStarLabel.text = self.getStarString(fromArr: self.viewModel.searchedFormData.ratingCount, maxCount: 5)
    }
    
    @IBAction func whereButtonAction(_ sender: UIButton) {
        AppFlowManager.default.showSelectDestinationVC(delegate: self,currentlyUsingFor: .hotelForm)
    }
    
    @IBAction func searchButtonAction(_ sender: ATButton?) {
        if validateData() {
            sender?.isLoading = true
            if let _ = sender {
                self.viewModel.setRecentSearchesData()
            }
            delay(seconds: 0.1) {
                //send to result screen for current selected form data
                CoreDataManager.shared.deleteData("HotelSearched")
                HotelsSearchVM.hotelFormData = self.viewModel.searchedFormData
                
                if 1...4 ~= self.viewModel.searchedFormData.ratingCount.count {
                    var filter = UserInfo.HotelFilter()
                    filter.ratingCount = self.viewModel.searchedFormData.ratingCount
                    UserInfo.hotelFilterApplied = filter
                    UserDefaults.setObject(true, forKey: "shouldApplyFormStars")
                }
                else {
                    UserInfo.hotelFilterApplied = nil
                    UserDefaults.setObject(false, forKey: "shouldApplyFormStars")
                }
                
                AppFlowManager.default.moveToHotelsResultVc(withFormData: HotelsSearchVM.hotelFormData)
                sender?.isLoading = false
            }
        }
    }
    
    ///Tap Label Action
    @IBAction func tapLabel(gesture: UITapGestureRecognizer) {
        let string = "\(self.bulkBookingsLbl.text ?? "")"
        let text = LocalizedString.RequestBulkBooking.localized
        if let range = string.range(of: text) {
            if gesture.didTapAttributedTextInLabel(label: self.bulkBookingsLbl, inRange: NSRange(range, in: string)) {
                printDebug("Tapped BulkBookings")
                AppFlowManager.default.showBulkBookingVC(withOldData: self.viewModel.searchedFormData)
            } else {
                printDebug("This is not bulk bookings text")
            }
        }
    }
}

//Mark:- UICollectionView Delegate and Datasource
//===============================================
extension HotelsSearchVC: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.searchedFormData.adultsCount.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if self.viewModel.searchedFormData.adultsCount.count < 4 && self.viewModel.searchedFormData.adultsCount.count == indexPath.item{
            guard let addRoomCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddRoomCell", for: indexPath) as? AddRoomCell else {
                return UICollectionViewCell()
            }
            addRoomCell.delegate = self
            return addRoomCell
        } else {
            guard let addRoomPicCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddRoomPictureCell", for: indexPath) as? AddRoomPictureCell else {
                return UICollectionViewCell()
            }
            addRoomPicCell.delegate = self
            addRoomPicCell.configureCell(for: indexPath, viewModel: self.viewModel)
            return addRoomPicCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (collectionView.cellForItem(at: indexPath) as? AddRoomCell) != nil {
            self.plusButtonTouched(indexPath: indexPath)
        } else if (collectionView.cellForItem(at: indexPath) as? AddRoomPictureCell) != nil {
            self.addRoomPicIndex = indexPath
            AppFlowManager.default.showRoomGuestSelectionVC(selectedAdults: self.viewModel.searchedFormData.adultsCount[indexPath.item], selectedChildren: self.viewModel.searchedFormData.childrenCounts[indexPath.item], selectedAges: self.viewModel.searchedFormData.childrenAge[indexPath.item], roomNumber: (indexPath.row + 1) , delegate: self)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch self.viewModel.searchedFormData.adultsCount.count {
        case 2:
            let width = (indexPath.item == 2) ? collectionView.frame.width : collectionView.frame.width/2
            return CGSize(width: width , height: self.collectionViewHeight)
        default:
            return CGSize(width: collectionView.frame.width/2 , height: self.collectionViewHeight)
        }
    }
}

//Mark:- Expanded Cell Delegate
//=============================
extension HotelsSearchVC: ExpandedCellDelegate {
    
    ///Plus Button Tapped
    func plusButtonTouched(indexPath: IndexPath) {
        self.viewModel.searchedFormData.adultsCount.append(2)
        self.viewModel.searchedFormData.childrenCounts.append(0)
        self.viewModel.searchedFormData.childrenAge.append([])
        if self.viewModel.searchedFormData.adultsCount.count < 4 {
            UIView.animate(withDuration: AppConstants.kAnimationDuration) {
                self.updateCollectionViewFrame()
                self.addRoomCollectionView.performBatchUpdates({ () -> Void in
                    self.addRoomCollectionView.insertItems(at: [indexPath])
                }, completion: { (true) in
                    self.reloadCollectionView()
                })
            }
        } else {
            self.reloadCollectionView()
        }
    }
    
    ///Cancel Button Tapped
    func cancelButtonTouched(indexPath: IndexPath) {
        if self.viewModel.searchedFormData.adultsCount.count <= 4 {
            self.viewModel.searchedFormData.adultsCount.remove(at: indexPath.item)
            self.viewModel.searchedFormData.childrenCounts.remove(at: indexPath.item)
            if !(self.viewModel.searchedFormData.childrenAge.isEmpty) && (indexPath.item <= self.viewModel.searchedFormData.childrenAge.count) {
                self.viewModel.searchedFormData.childrenAge.remove(at: indexPath.item)
            }
            if  self.viewModel.searchedFormData.adultsCount.count == 3 {
                self.reloadCollectionView()
            } else {
                UIView.animate(withDuration: AppConstants.kAnimationDuration) {
                    self.addRoomCollectionView.performBatchUpdates({ () -> Void in
                        self.updateCollectionViewFrame()
                        self.addRoomCollectionView.deleteItems(at: [indexPath])
                    }) { (true) in
                        self.reloadCollectionView()
                    }
                }
            }
        }
    }
    
    ///Data For Api
    private func dataForApi(hotel: SearchedDestination) {
        self.viewModel.searchedFormData.destType = hotel.dest_type
        self.viewModel.searchedFormData.destName = hotel.dest_name
        self.viewModel.searchedFormData.destId = hotel.dest_id
    }
}

//MARK:- RoomGuestSelectionVCDelegate
//===================================
extension HotelsSearchVC: RoomGuestSelectionVCDelegate {
    
    func didSelectedRoomGuest(adults: Int, children: Int, childrenAges: [Int], roomNumber: Int) {
        if let indexPath = addRoomPicIndex {
            self.viewModel.searchedFormData.adultsCount[indexPath.item] = adults
            self.viewModel.searchedFormData.childrenCounts[indexPath.item]  = children
            self.viewModel.searchedFormData.childrenAge[indexPath.item] = childrenAges
            self.viewModel.searchedFormData.roomNumber = roomNumber
        }
        self.addRoomCollectionView.reloadData()
        printDebug("adults: \(adults), children: \(children), ages: \(childrenAges), roomNumber: \(roomNumber)")
    }
}

//MARK:- SelectDestinationVCDelegate
//==================================
extension HotelsSearchVC: SelectDestinationVCDelegate {
    func didSelectedDestination(hotel: SearchedDestination) {
        printDebug("selected: \(hotel)")
        if !hotel.city.isEmpty {
            self.cityNameLabel.text = hotel.city
            self.viewModel.searchedFormData.cityName = hotel.city
        } else {
            let newValue = hotel.value.components(separatedBy: ",")
            printDebug(newValue.first)
            self.cityNameLabel.text = newValue.first ?? ""
            self.viewModel.searchedFormData.cityName = newValue.first ?? ""
        }
        //Logic for after string
        var splittedStringArray = hotel.value.components(separatedBy: ",")
        splittedStringArray.removeFirst()
        let stateName = splittedStringArray.joined(separator: ",")
        self.stateNameLabel.text = stateName//hotel.value
        self.viewModel.searchedFormData.stateName = stateName//hotel.value
        self.manageAddressLabels()
        self.dataForApi(hotel: hotel)
    }
}

//MARK:- SearchHoteslOnPreferencesDelegate
//========================================
extension HotelsSearchVC: SearchHoteslOnPreferencesDelegate {

    func getRecentSearchesDataSuccess() {
        if let recentSearchesView = self.recentSearchesView, let recentSearchesData = self.viewModel.recentSearchesData {
            if !(recentSearchesData.count > 0) {
                self.hideRecentSearchesView()
            } else {
                self.showRecentSearchView()
                recentSearchesView.recentSearchesData = recentSearchesData
                recentSearchesView.recentCollectionView.reloadData()
            }
        } else {
            self.hideRecentSearchesView()
        }
        self.needToGetRecentSearches = true
        printDebug(self.viewModel.recentSearchesData)
    }
    
    func getRecentSearchesDataFail() {
        self.hideRecentSearchesView()
        printDebug("recent searches data parsing failed")
    }
    
    func setRecentSearchesDataSuccess() {
        printDebug("setRecentSearchesDataSuccess")
    }
    
    func setRecentSearchesDataFail() {
        printDebug("setRecentSearchesDataFail")
    }
}

extension HotelsSearchVC: RecentHotelSearcheViewDelegate {
    
    func passRecentSearchesData(recentSearch: RecentSearchesModel) {

        self.viewModel.searchedFormData.adultsCount.removeAll()
        self.viewModel.searchedFormData.childrenAge.removeAll()
        for roomData in recentSearch.room ?? [] {
            if roomData.isPresent {
                if let adultCounts = roomData.adultCounts.toInt {
                    self.viewModel.searchedFormData.adultsCount.append(adultCounts)
                }
                var childrenArray: [Int] = []
                childrenArray.removeAll()
                for child in roomData.child {
                    if child.isPresent {
                        childrenArray.append(child.childAge)
                    }
                }
                self.viewModel.searchedFormData.childrenAge.append(childrenArray)
            }
        }
        self.viewModel.searchedFormData.ratingCount = recentSearch.filter?.stars ?? []

        self.viewModel.searchedFormData.checkInDate = Date.getDateFromString(stringDate: recentSearch.checkInDate, currentFormat: "E, dd MMM yy", requiredFormat: "yyyy-MM-dd") ?? ""
        self.viewModel.searchedFormData.checkOutDate = Date.getDateFromString(stringDate: recentSearch.checkOutDate, currentFormat: "E, dd MMM yy", requiredFormat: "yyyy-MM-dd") ?? ""
        self.viewModel.searchedFormData.destId = recentSearch.dest_id
        self.viewModel.searchedFormData.destType = recentSearch.dest_type
        self.viewModel.searchedFormData.destName = recentSearch.dest_name
        self.viewModel.searchedFormData.cityName = recentSearch.dest_name.components(separatedBy: ",").first ?? ""
        var splittedStringArray = recentSearch.dest_name.components(separatedBy: ",")
        splittedStringArray.removeFirst()
        let stateName = splittedStringArray.joined(separator: ",")
        self.viewModel.searchedFormData.stateName = stateName
        printDebug("searching again for \(recentSearch.dest_name)")
        self.setDataFromPreviousSearch(olddata: self.viewModel.searchedFormData, isSettingForFirstTime: true)
        self.searchButtonAction(nil)
//        HotelsSearchVM.hotelFormData = self.viewModel.searchedFormData
        //open result screen for the recent
//        AppFlowManager.default.moveToHotelsResultVc(withFormData: self.viewModel.searchedFormData)
//        self.searchBtnOutlet.isLoading = false
    }
}


extension HotelsSearchVC: CheckInOutViewDelegate {
    
    func selectCheckInDate(_ sender: UIButton) {
        AppFlowManager.default.moveHotelCalenderVC(isHotelCalendar: true,checkInDate: self.viewModel.searchedFormData.checkInDate.toDate(dateFormat: "yyyy-MM-dd") ?? Date(), checkOutDate: self.viewModel.searchedFormData.checkOutDate.toDate(dateFormat: "yyyy-MM-dd"), delegate: self)
    }
    
    func selectCheckOutDate(_ sender: UIButton) {
        
        AppFlowManager.default.moveHotelCalenderVC(isHotelCalendar: true,checkInDate: self.viewModel.searchedFormData.checkInDate.toDate(dateFormat: "yyyy-MM-dd") ?? Date(), checkOutDate: self.viewModel.searchedFormData.checkOutDate.toDate(dateFormat: "yyyy-MM-dd"), delegate: self) }
}

extension HotelsSearchVC: CalendarDataHandler {
    func selectedDates(fromCalendar startDate: Date!, end endDate: Date!, isHotelCalendar: Bool, isReturn: Bool) {
        if startDate != nil {
            self.viewModel.searchedFormData.checkInDate = startDate.toString(dateFormat: "yyyy-MM-dd")
        }
        if endDate != nil {
            self.viewModel.searchedFormData.checkOutDate = endDate.toString(dateFormat: "yyyy-MM-dd")
        }
        if let checkInOutVw = self.checkInOutView {
            checkInOutVw.setDates(fromData: self.viewModel.searchedFormData)
        }
        printDebug(startDate)
        printDebug(endDate)
        printDebug(isHotelCalendar)
        printDebug(isReturn)
    }
}
