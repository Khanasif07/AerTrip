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
    private var collectionViewHeight: CGFloat = 86.0
    private var containerViewHeight: CGFloat = 548.0
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
    @IBOutlet weak var firstLineView: UIView!
    @IBOutlet weak var secondLineView: UIView!
    @IBOutlet weak var thirdLineView: UIView!
    @IBOutlet weak var fourthLineView: UIView!
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
        self.initialSetups()
        
        //setting the dummy check-in/out date
        viewModel.checkInDate = Date().addDay(days: 0) ?? ""
        viewModel.checkOutDate = Date().addDay(days: 5) ?? ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getRecentSearchData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        self.addRoomCollectionView.registerCell(nibName: "AddRoomCell")
        self.addRoomCollectionView.registerCell(nibName: "AddRoomPictureCell")
        self.viewModel.delegate = self
    }
    
    override func setupFonts() {
        let regularFontSize16 = AppFonts.Regular.withSize(16.0)
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
    }
    
    override func setupColors() {
        self.whereLabel.textColor = AppColors.themeGray40
        self.cityNameLabel.textColor = AppColors.textFieldTextColor51
        self.stateNameLabel.textColor = AppColors.textFieldTextColor51
        self.firstLineView.backgroundColor = AppColors.themeGray10
        self.secondLineView.backgroundColor = AppColors.themeGray10
        self.thirdLineView.backgroundColor = AppColors.themeGray10
        self.fourthLineView.backgroundColor = AppColors.themeGray10
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
        self.allStarLabel.text = LocalizedString.AllStars.localized
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
    ///InitialSetUp
    private func initialSetups() {
        self.cityNameLabel.isHidden = true
        self.stateNameLabel.isHidden = true
        self.shadowSetUp()
        self.containerView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        self.scrollView.delegate = self
        self.searchBtnOutlet.layer.cornerRadius = 25.0
        self.configureCheckInOutView()
        self.configureRecentSearchesView()
        self.hideRecentSearchesView()
        self.getDataFromPreviousSearch()
    }
    
    ///Shadow Set Up
    private func shadowSetUp() {
        // corner radius
        self.containerView.layer.cornerRadius = 10
        // border
        //self.containerView.layer.borderWidth = 1.0
        //        self.containerView.layer.borderColor = UIColor.black.cgColor
        // shadow
        self.containerView.layer.shadowColor = AppColors.themeDarkGreen.cgColor// UIColor.black.cgColor
        self.containerView.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.containerView.layer.shadowOpacity = 0.7
        self.containerView.layer.shadowRadius = 6.0
    }
    
    ///ConfigureCheckInOutView
    private func configureCheckInOutView() {
        self.checkInOutView = CheckInOutView(frame: self.datePickerView.bounds)
        if let view = self.checkInOutView {
            self.datePickerView.addSubview(view)
        }
    }
    
    ///ConfigureRecentSearchesView
    private func configureRecentSearchesView() {
        self.recentSearchesView = RecentHotelSearcheView(frame: self.recentSearchesContainerView.bounds)
        if let view = self.recentSearchesView {
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
        if self.viewModel.adultsCount.count == 2 {
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
        } else if self.viewModel.adultsCount.count == 1 {
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
    
    ///GetDataFromPreviousSearch
    private func getDataFromPreviousSearch() {
        let date = Date()

        let oldData = HotelsSearchVM.hotelFormData
        if let checkInDate = oldData.checkInDate.toDate(dateFormat: "yyyy-MM-dd") {
            if date.daysBetweenDate(toDate: date, endDate: checkInDate) <= 0 {
                //  self.viewModel.roomNumber = oldData.roomNumber
                self.viewModel.ratingCount = oldData.ratingCount
                self.viewModel.adultsCount = oldData.adultsCount
                self.viewModel.childrenCounts = oldData.childrenCounts
                self.viewModel.childrenAge = oldData.childrenAge
                self.viewModel.destId = oldData.destId
                self.viewModel.destType = oldData.destType
                self.viewModel.destName = oldData.destName
                self.viewModel.cityName = oldData.cityName
                self.viewModel.stateName = oldData.stateName
                self.viewModel.checkInDate = oldData.checkInDate
                self.viewModel.checkOutDate = oldData.checkOutDate
                self.fillDataFromPreviousSearch()
            }
        } else {
            for starBtn in self.starButtonsOutlet {
                starBtn.isHighlighted = true
            }
        }
    }
    
    ///FillDataFromPreviousSearch
    private func fillDataFromPreviousSearch() {
        
        self.cityNameLabel.text = self.viewModel.cityName
        self.stateNameLabel.text = self.viewModel.stateName
        self.cityNameLabel.isHidden = false
        self.stateNameLabel.isHidden = false
        if let checkInOutView = self.checkInOutView {
            checkInOutView.fillPreviousData(viewModel: self.viewModel)
        }
        if self.viewModel.ratingCount.isEmpty || (self.viewModel.ratingCount == [1,2,3,4,5]) {
            for starBtn in self.starButtonsOutlet {
                starBtn.isHighlighted = true
            }
        } else {
            for star in self.viewModel.ratingCount {
                self.starButtonsOutlet[star - 1].isSelected = true
            }
        }
        self.allStarLabel.text = self.getStarString(fromArr: self.viewModel.ratingCount, maxCount: 5)
        if self.viewModel.adultsCount.count >= 2 {
            self.containerViewHeightConstraint.constant = self.containerViewHeight + self.collectionViewHeight
        } else if self.viewModel.adultsCount.count == 1 {
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
    
    ///Hide Recent Search View
    private func hideRecentSearchesView() {
        self.recentContainerParentView.isHidden = true
        self.recentContainerHeightConstraint.constant = 0.0
        if let recentSearchesView = self.recentSearchesView {
            recentSearchesView.isHidden = true
        }
        self.scrollView.contentSize.height = self.containerViewHeight + self.collectionViewHeight + 20.0
    }
    
    ///Show Recent Search View
    private func showRecentSearchView() {
        self.recentContainerParentView.isHidden = false
        self.recentContainerHeightConstraint.constant = self.recentSearchHeight
        if let recentSearchesView = self.recentSearchesView {
            recentSearchesView.isHidden = false
        }
        //        self.scrollView.contentSize.height = self.scrollView.contentSize.height + 95.0//214.0
        if self.viewModel.adultsCount.count < 2 {
            self.scrollView.contentSize.height = self.containerViewHeight + self.recentSearchHeight + 20.0
        } else {
            self.scrollView.contentSize.height = self.containerViewHeight + self.collectionViewHeight + self.recentSearchHeight + 20.0
        }
    }
    
    //MARK:- Public
    //MARK:- IBAction
    //===============
    @IBAction func starButtonsAction(_ sender: UIButton) {
        self.updateStarButtonState(forStar: sender.tag)
        self.allStarLabel.text = self.getStarString(fromArr: self.viewModel.ratingCount, maxCount: 5)
    }
    
    @IBAction func whereButtonAction(_ sender: UIButton) {
        AppFlowManager.default.showSelectDestinationVC(delegate: self)
    }
    
    @IBAction func searchButtonAction(_ sender: ATButton) {
        self.view.isUserInteractionEnabled = false
        sender.isLoading = true
        self.viewModel.hotelListOnPreferencesApi()
    }
    
    ///Tap Label Action
    @IBAction func tapLabel(gesture: UITapGestureRecognizer) {
        let string = "\(self.bulkBookingsLbl.text ?? "")"
        let text = LocalizedString.RequestBulkBooking.localized
        if let range = string.range(of: text) {
            if gesture.didTapAttributedTextInLabel(label: self.bulkBookingsLbl, inRange: NSRange(range, in: string)) {
                printDebug("Tapped BulkBookings")
                AppFlowManager.default.showBulkBookingVC()
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
        return self.viewModel.adultsCount.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if self.viewModel.adultsCount.count < 4 && self.viewModel.adultsCount.count == indexPath.item{
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
            AppFlowManager.default.showRoomGuestSelectionVC(selectedAdults: self.viewModel.adultsCount[indexPath.item], selectedChildren: self.viewModel.childrenCounts[indexPath.item], selectedAges: self.viewModel.childrenAge[indexPath.item], roomNumber: (indexPath.row + 1) , delegate: self)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch self.viewModel.adultsCount.count {
        case 1:
            return CGSize(width: collectionView.frame.width/2 , height: collectionView.frame.height)
        case 2:
            let width = (indexPath.item == 2) ? collectionView.frame.width : collectionView.frame.width/2
            return CGSize(width: width , height: collectionView.frame.height/2)
        default:
            return CGSize(width: collectionView.frame.width/2 , height: collectionView.frame.height/2)
        }
    }
}

//Mark:- Expanded Cell Delegate
//=============================
extension HotelsSearchVC: ExpandedCellDelegate {
    
    ///Plus Button Tapped
    func plusButtonTouched(indexPath: IndexPath) {
        self.viewModel.adultsCount.append(1)
        self.viewModel.childrenCounts.append(0)
        self.viewModel.childrenAge.append([])
        if self.viewModel.adultsCount.count < 4 {
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
        if self.viewModel.adultsCount.count <= 4 {
            self.viewModel.adultsCount.remove(at: indexPath.item)
            self.viewModel.childrenCounts.remove(at: indexPath.item)
            if !(self.viewModel.childrenAge.isEmpty) && (indexPath.item <= self.viewModel.childrenAge.count) {
                self.viewModel.childrenAge.remove(at: indexPath.item)
            }
            if  self.viewModel.adultsCount.count == 3 {
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
        self.viewModel.destType = hotel.dest_type
        self.viewModel.destName = hotel.dest_name
        self.viewModel.destId = hotel.dest_id
    }
}

//MARK:- RoomGuestSelectionVCDelegate
//===================================
extension HotelsSearchVC: RoomGuestSelectionVCDelegate {
    
    func didSelectedRoomGuest(adults: Int, children: Int, childrenAges: [Int], roomNumber: Int) {
        if let indexPath = addRoomPicIndex {
            self.viewModel.adultsCount[indexPath.item] = adults
            self.viewModel.childrenCounts[indexPath.item]  = children
            self.viewModel.childrenAge[indexPath.item] = childrenAges
            self.viewModel.roomNumber = roomNumber
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
            self.viewModel.cityName = hotel.city
        } else {
            let newValue = hotel.value.components(separatedBy: ",")
            printDebug(newValue.first)
            self.cityNameLabel.text = "\(newValue.first ?? "")"
            self.viewModel.cityName = "\(newValue.first ?? "")"
        }
        self.whereLabel.font = AppFonts.Regular.withSize(16.0)
        self.stateNameLabel.text = hotel.value
        self.viewModel.stateName = hotel.value
        self.cityNameLabel.isHidden = false
        self.stateNameLabel.isHidden = false
        self.dataForApi(hotel: hotel)
    }
}

//MARK:- SearchHoteslOnPreferencesDelegate
//========================================
extension HotelsSearchVC: SearchHoteslOnPreferencesDelegate {
    
    func getAllHotelsOnPreferenceSuccess() {
        self.viewModel.saveFormDataToUserDefaults()
        self.view.isUserInteractionEnabled = true
        self.searchBtnOutlet.isLoading = false
        AppFlowManager.default.moveToHotelsResultVc(self.viewModel.hotelSearchRequst ?? HotelSearchRequestModel())
    }
    
    func getAllHotelsOnPreferenceFail() {
        printDebug("getAllHotelsOnPreferenceFail")
        self.searchBtnOutlet.isLoading = false
        self.view.isUserInteractionEnabled = true
    }
    
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
}

