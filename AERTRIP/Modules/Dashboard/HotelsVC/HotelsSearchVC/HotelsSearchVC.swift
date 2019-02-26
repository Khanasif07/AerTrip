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
    private var collectionViewHeight: CGFloat = 0.0
    private var containerViewHeight: CGFloat = 0.0
    private var scrollViewContentSize: CGSize = CGSize.zero
    private var recentSearchHeight: CGFloat = 150.0
    private var addRoomPicIndex: IndexPath?
    private(set) var viewModel = HotelsSearchVM()
    
    ///Computed Properties
    private var cellHeight: CGFloat{
        return self.addRoomCollectionView.frame.size.height
    }
    private var cellWidth: CGFloat{
        return self.addRoomCollectionView.frame.size.width / 2.0
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.collectionViewHeight = self.addRoomCollectionView.frame.size.height
        self.containerViewHeight = self.containerView.frame.size.height
        self.scrollViewContentSize = self.scrollView.contentSize
    }
    
    override func viewDidLayoutSubviews() {
        if let view = self.checkInOutView {
            view.frame = self.datePickerView.bounds
        }
        if let view = self.recentSearchesView {
            view.frame = self.recentSearchesContainerView.bounds
        }
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
        self.containerView.cornerRadius = 10.0
        self.containerView.clipsToBounds = true
        self.containerView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        self.scrollView.delegate = self
        self.searchBtnOutlet.layer.cornerRadius = 25.0
        self.configureCheckInOutView()
        self.configureRecentSearchesView()
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
            self.scrollView.contentSize.height = self.scrollViewContentSize.height + self.collectionViewHeight
            self.containerViewHeightConstraint.constant = self.containerViewHeight + self.collectionViewHeight
            UIView.animate(withDuration: AppConstants.kAnimationDuration) {
                self.view.layoutIfNeeded()
            }
        } else if self.viewModel.adultsCount.count == 1 {
            self.containerViewHeightConstraint.constant =  self.containerViewHeight
            self.scrollView.contentSize.height = self.scrollViewContentSize.height
            UIView.animate(withDuration: AppConstants.kAnimationDuration) {
                self.view.layoutIfNeeded()
            }
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
            if self.viewModel.ratingCount.contains(forStar) {
                self.viewModel.ratingCount.remove(at: self.viewModel.ratingCount.firstIndex(of: forStar)!)
            }
            else {
                self.viewModel.ratingCount.append(forStar)
                
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
        
        if arr.isEmpty {
            final = "0 \(LocalizedString.stars.localized)"
            return final
        }
        else if arr.count == maxCount {
            final = "All \(LocalizedString.stars.localized)"
            return final
        }
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
    
    //MARK:- Public
    
    //MARK:- IBAction
    //===============
    @IBAction func starButtonsAction(_ sender: UIButton) {
        self.updateStarButtonState(forStar: sender.tag)
        self.allStarLabel.text = self.getStarString(fromArr: self.viewModel.ratingCount, maxCount: 5)
        sender.setImage(#imageLiteral(resourceName: "starRatingUnfill"), for: .normal)
        sender.setImage(#imageLiteral(resourceName: "starRatingFilled"), for: .selected)
    }
    
    @IBAction func whereButtonAction(_ sender: UIButton) {
        AppFlowManager.default.showSelectDestinationVC(delegate: self)
    }
    
    @IBAction func searchButtonAction(_ sender: ATButton) {
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
            addRoomCell.indexPath = indexPath
            addRoomCell.delegate = self
            return addRoomCell
        } else {
            guard let addRoomPicCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddRoomPictureCell", for: indexPath) as? AddRoomPictureCell else {
                return UICollectionViewCell()
            }
            addRoomPicCell.indexPath = indexPath
            addRoomPicCell.delegate = self
            addRoomPicCell.configureCell(viewModel: self.viewModel)
            return addRoomPicCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (collectionView.cellForItem(at: indexPath) as? AddRoomCell) != nil {
            self.plusButtonTouched(indexPath: indexPath)
        } else if (collectionView.cellForItem(at: indexPath) as? AddRoomPictureCell) != nil {
            self.addRoomPicIndex = indexPath
            AppFlowManager.default.showRoomGuestSelectionVC(selectedAdults: 1, selectedChildren: 0, selectedAges: [0], roomNumber: (indexPath.row + 1) , delegate: self)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.collectionViewHeight != 0.0 {
            return CGSize(width: self.cellWidth , height: self.collectionViewHeight)
        } else {
            return CGSize(width: self.cellWidth , height: self.cellHeight)
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

//MARK:- SearchHoteslOnPreferencesDelegate
//========================================
extension HotelsSearchVC: SearchHoteslOnPreferencesDelegate {
    
    func getAllHotelsOnPreferenceSuccess() {
      //  self.viewModel.hotelListOnPreferenceResult()
            self.searchBtnOutlet.isLoading = false
           AppFlowManager.default.moveToHotelsResultVc(self.viewModel.hotelSearchRequst ?? HotelSearchRequestModel())
    }
    
    func getAllHotelsOnPreferenceFail() {
        printDebug("getAllHotelsOnPreferenceFail")
        self.searchBtnOutlet.isLoading = false
        AppFlowManager.default.moveToHotelsResultVc(self.viewModel.hotelSearchRequst ?? HotelSearchRequestModel())
    }
    
    func getAllHotelsListResultSuccess() {
        printDebug("data")
        AppFlowManager.default.moveToHotelsResultVc(self.viewModel.hotelSearchRequst ?? HotelSearchRequestModel())
        self.searchBtnOutlet.isLoading = false
    }
    
    func getAllHotelsListResultFail() {
        printDebug("getAllHotelsListResultFail")
        self.searchBtnOutlet.isLoading = false
        AppFlowManager.default.moveToHotelsResultVc(self.viewModel.hotelSearchRequst ?? HotelSearchRequestModel())
    }
    
}


