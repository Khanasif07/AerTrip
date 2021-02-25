//
//  ResultVC.swift
//  AERTRIP
//
//  Created by Admin on 31/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import CoreData
import UIKit
import Kingfisher

enum FetchRequestType {
    case FilterApplied
    case Searching
    case normalInSearching
    case normal
}

enum HotelResultViewType {
    case MapView
    case ListView
}

let visualEffectViewHeight =  CGFloat(20)//CGFloat(200.0)

class HotelResultVC: BaseVC {
    
    // MARK: - IBOutlets
    // MARK: -
    @IBOutlet weak var statusBarViewContainer: UIView!
    @IBOutlet weak var headerContainerView: UIView!
    @IBOutlet weak var navContainerView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var searchBar: ATSearchBar!
    @IBOutlet weak var dividerView: ATDividerView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var unPinAllFavouriteButton: UIButton!
    @IBOutlet weak var emailButton: ATButton! {
        didSet {
            emailButton.isSocial = true
            emailButton.gradientColors = []
            emailButton.shouldShowPressAnimation = false
        }
    }
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var switchView: ATSwitcher!
    @IBOutlet weak var backContainerView: UIView!
    @IBOutlet weak var tableViewVertical: ATTableView! {
        didSet {
            self.tableViewVertical.registerCell(nibName: HotelCardTableViewCell.reusableIdentifier)
            self.tableViewVertical.register(HotelResultSectionHeader.self, forHeaderFooterViewReuseIdentifier: "HotelResultSectionHeader")
            self.tableViewVertical.register(UINib(nibName: "HotelResultSectionHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "HotelResultSectionHeader")
            // self.tableViewVertical.register(UINib(nibName: "HotelSearchResultHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "HotelSearchResultHeaderView")
            
            self.tableViewVertical.delegate = self
            self.tableViewVertical.dataSource = self
            self.tableViewVertical.separatorStyle = .none
            self.tableViewVertical.showsVerticalScrollIndicator = true
            self.tableViewVertical.showsHorizontalScrollIndicator = false
            self.tableViewVertical.contentInset = UIEdgeInsets(top: topContentSpace, left: 0, bottom: 0, right: 0)
            self.tableViewVertical.tableHeaderView = searchResultHeaderView
            self.tableViewVertical.sectionHeaderHeight = hotelSearchResultHeaderViewHeight.min
        }
    }
    
    @IBOutlet weak var headerContainerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var shimmerView: UIView!
    @IBOutlet weak var headerContatinerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var floatingButtonOnMapView: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    // Searching View
    @IBOutlet weak var hotelSearchView: UIView! {
        didSet {
            self.hotelSearchView.backgroundColor = AppColors.themeBlack.withAlphaComponent(0.4)
            self.hotelSearchView.isUserInteractionEnabled = true
        }
    }
    
    @IBOutlet weak var hotelSearchTableView: ATTableView! {
        didSet {
            let tap = UITapGestureRecognizer(target: self, action: #selector(searchTabeleTapped(tap:)))
            self.hotelSearchTableView.addGestureRecognizer(tap)
        }
    }
    @IBOutlet weak var floatingViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var floatingButtonBackView: UIView!
    @IBOutlet weak var switchContainerView: UIView!
    @IBOutlet weak var searchBarContainerView: UIView!
    //    @IBOutlet weak var cardGradientView: UIView!
    //    @IBOutlet weak var shimmerGradientView: UIView!
    @IBOutlet weak var filterView: UIView!
    
    @IBOutlet weak var filterCollectionView: UICollectionView! {
        didSet {
            filterCollectionView.delegate = self
            filterCollectionView.dataSource = self
            filterCollectionView.showsVerticalScrollIndicator = false
            filterCollectionView.showsHorizontalScrollIndicator = false
            filterCollectionView.contentInset = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        }
    }
    @IBOutlet weak var mapButtonIndicator: UIActivityIndicatorView!
    @IBOutlet weak var switchGradientView: UIView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var blurViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerBlurView: BlurView!
    // MARK: - Properties
    
    //    var container: NSPersistentContainer!
    
    let topContentSpace: CGFloat = 96
    var time: Float = 0.0
    var timer: Timer?
    var isAboveTwentyKm: Bool = false
    var isFotterVisible: Bool = false
    var searchIntitialFrame: CGRect = .zero
    var completion: (() -> Void)?
    var toastDidClose : (() -> Void)?
    var aerinFilterUndoCompletion : (() -> Void)?
    weak var hotelsGroupExpendedVC: HotelsGroupExpendedVC?
    
    var visibleMapHeightInVerticalMode: CGFloat = 160.0
    var oldScrollPosition: CGPoint = CGPoint.zero
    var selectedIndexPath: IndexPath?
    var selectedIndexPathForHotelSearch: IndexPath?
    var floatingViewInitialConstraint : CGFloat = 0.0
    
    var oldOffset: CGPoint = .zero //used in colletion view scrolling for map re-focus
    let hotelResultCellIdentifier = "HotelSearchTableViewCell"
    var isDataFetched = false
    //var statusBarBlurView : UIVisualEffectView!
    //var headerBlurView : UIVisualEffectView!
    
    //    override var statusBarAnimatableConfig: StatusBarAnimatableConfig{
    //        return StatusBarAnimatableConfig(prefersHidden: false, animation: .slide)
    //    }
    
    
    // Empty State view
    
    lazy var noResultemptyView: EmptyScreenView = {
        let newEmptyView = EmptyScreenView()
        newEmptyView.vType = .noResult
        return newEmptyView
    }()
    
    lazy var noResultemptyViewVerticalTableView: EmptyScreenView = {
        let newEmptyView = EmptyScreenView()
        newEmptyView.vType = .noResult
        return newEmptyView
    }()
    
    // No Hotel Found empty View
    lazy var noHotelFoundEmptyView: EmptyScreenView = {
        let newEmptyView = EmptyScreenView()
        newEmptyView.vType = .noHotelFound
        return newEmptyView
    }()
    
    // Not hotel Found Empty View on Filter
    lazy var noHotelFoundOnFilterEmptyView: EmptyScreenView = {
        let newEmptyView = EmptyScreenView()
        newEmptyView.vType = .noHotelFoundOnFilter
        newEmptyView.delegate = self
        return newEmptyView
    }()
    
    // MARK: - Public
    
    // MARK: - Private
    
    let viewModel = HotelsResultVM()
    
    var hideSection = 0
    var footeSection = 1
    let defaultDuration: CGFloat = 1.2
    let defaultDamping: CGFloat = 0.70
    let defaultVelocity: CGFloat = 15.0
    var applyButtonTapped: Bool = false
    var isViewDidAppear = false
    var visualEffectViewHeight : CGFloat {
        return statusBarHeight + 96
    }
    var statusBarHeight : CGFloat {
        return UIApplication.shared.isStatusBarHidden ? CGFloat(0) : UIApplication.shared.statusBarFrame.height
    }
    var scrollviewInitialYOffset = CGFloat(0.0)
    
    //used for making collection view centerlized
    var indexOfCellBeforeDragging = 0
    
    //Manage Transition Created by golu
    internal var transition: CardTransition?
    var hotelSearchResultHeaderViewHeight: (min: CGFloat, max: CGFloat) = (min: 36, max: 70)
    lazy var  searchResultHeaderView: HotelSearchResultHeaderView = {
        let view = HotelSearchResultHeaderView.instanceFromNib()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: UIScreen.width).isActive = true
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.width, height: hotelSearchResultHeaderViewHeight.min)
        view.numberOfRooms = viewModel.searchedFormData.roomNumber
        view.resultListPriceType = .perNight
        view.updateHeight(height: hotelSearchResultHeaderViewHeight.min)
        return view
    }()
    // MARK: - ViewLifeCycle
    
    // MARK: -
    
    override func initialSetup() {
        self.view.layoutIfNeeded()
        mapButtonIndicator.tintColor = AppColors.themeGreen
        self.filterCollectionView.isUserInteractionEnabled = false
        //        self.filterButton.isEnabled = false
        //        self.mapButton.isEnabled = false
        //        self.searchButton.isEnabled = false
        self.filterButton.isUserInteractionEnabled = false
        self.mapButton.isUserInteractionEnabled = false
        self.searchButton.isUserInteractionEnabled = false
        //self.floatingButtonBackView.addGredient(colors: [AppColors.themeWhite.withAlphaComponent(0.01), AppColors.themeWhite])
        self.hotelSearchTableView.showsVerticalScrollIndicator = true
        self.searchButton.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 0, right: 0)
        self.view.backgroundColor = AppColors.themeWhite
        
        self.initialSetups()
        self.registerXib()
        
        self.startProgress()
        self.completion = { [weak self] in
            self?.applyButtonTapped = true
            
            UserDefaults.setObject(false, forKey: "shouldApplyFormStars")
            self?.viewModel.fetchRequestType = .FilterApplied
            if let old = self?.viewModel.tempHotelFilter {//UserInfo.hotelFilter {
                HotelFilterVM.shared.setData(from: old)
            }
            self?.doneButtonTapped()
            AppToast.default.hideToast(self, animated: true)
        }
        
        // toast Completion when toast goes way from the screen
        self.toastDidClose = { [weak self] in
            guard let `self` = self else {
                return
            }
            UserDefaults.setObject(false, forKey: "shouldApplyFormStars")
            if !self.applyButtonTapped {
                UserInfo.hotelFilter = nil
                HotelFilterVM.shared.resetToDefault()
            }
            
        }
        
        // toast completion,When undo button tapped
        self.aerinFilterUndoCompletion = {
            printDebug("Undo Button tapped")
        }
        //call API to get vcode, sid
        if AppGlobals.shared.isNetworkRechable() {
            self.viewModel.hotelListOnPreferencesApi()
        } else {
            self.noHotelFound()
            AppToast.default.showToastMessage(message: LocalizedString.NoInternet.localized)
        }
        
        searchBar.setTextField(color: UIColor(displayP3Red: 153/255, green: 153/255, blue: 153/255, alpha: 0.12))
        self.setUpLongPressOnFilterButton()
        //addCustomBackgroundBlurView()
        headerBlurView.backgroundColor = UIColor.white.withAlphaComponent(0.85)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.isViewDidAppear = true
        self.statusBarColor = AppColors.clear
        self.statusBarStyle = .darkContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)        
        // addCustomBackgroundBlurView()
        self.statusBarColor = AppColors.clear
        self.statusBarStyle = .darkContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.statusBarColor = AppColors.clear
        //        self.headerBlurView.removeFromSuperview()
        //        self.statusBarBlurView.removeFromSuperview()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.mapButton.alpha = 1.0
        self.mapButtonIndicator.stopAnimating()
    }
    
    override func bindViewModel() {
        self.viewModel.hotelResultDelegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //        self.configureCollectionViewLayoutItemSize()
        self.blurViewHeightConstraint.constant = self.statusBarHeight
    }
    
    deinit {
        CoreDataManager.shared.deleteData("HotelSearched")
        printDebug("HotelResultVC deinit")
    }
    
    override func dataChanged(_ note: Notification) {
        if let noti = note.object as? ATNotification {
            switch noti {
            case .GRNSessionExpired:
                //re-hit the search API
                self.manageShimmer(isHidden: false)
                CoreDataManager.shared.deleteData("HotelSearched")
                self.viewModel.hotelListOnPreferencesApi()
            default:
                break
            }
        }
        else if let _ = note.object as? HotelDetailsVC {
            //fav updated from hotel details
            //updateFavOnList(forIndexPath: selectedIndexPath)
            // manage favourite switch buttons
            self.viewModel.getFavouriteHotels(shouldReloadData: true)
            //            self.updateMarkers()
            //            updateFavouriteSuccess(isHotelFavourite: true)
        }
        else if let _ = note.object as? HCDataSelectionVC {
            updateFavOnList(forIndexPath: selectedIndexPath)
        }
        else if let _ = note.object as? HotelResultVC {
            updateFavOnList(forIndexPath: selectedIndexPath)
        } else if let _ = note.object as? HotelsGroupExpendedVC {
            
        }
    }
    
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        printDebug("scrollViewShouldScrollToTop")
        delay(seconds: 0.8) {
            self.tableViewVertical.setContentOffset(CGPoint(x: 0, y: -self.topContentSpace), animated: false)
            self.showBluredHeaderViewCompleted()
        }
       // self.tableViewVertical.contentInset = UIEdgeInsets(top: self.topContentSpace, left: 0, bottom: 0, right: 0)
//        revealBlurredHeaderView(self.topContentSpace)

        return true
    }
    
    // MARK: - Methods
    
    // MARK: - Private
    
    override func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            printDebug("notification: Keyboard will show")
            let footerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIDevice.screenWidth, height: keyboardSize.height))
            self.hotelSearchTableView.tableFooterView = footerView
        }
    }
    override func keyboardWillHide(notification: Notification) {
        if let _ = self.view.window {
            //checking if the screen in window only then this method should call
            self.hotelSearchTableView.tableFooterView = nil
        }
    }
    
    func initialSetups() {
        self.setUpFloatingView()
        self.setupTableHeader()
        self.searchBar.delegate = self
        self.progressView.transform = self.progressView.transform.scaledBy(x: 1, y: 1)
        self.searchIntitialFrame = self.searchBarContainerView.frame
        self.reloadHotelList()
        self.floatingButtonOnMapView.isHidden = true
        self.cancelButton.alpha = 0
        self.hotelSearchTableView.separatorStyle = .none
        self.hotelSearchTableView.delegate = self
        self.hotelSearchTableView.dataSource = self
        
        self.completion = { [weak self] in
            self?.viewModel.loadSaveData()
        }
        
        self.hotelSearchTableView.backgroundView = noResultemptyView
        self.hotelSearchTableView.reloadData()
        
        
        //  self.searchBar.backgroundColor = .red
        self.searchBar.searchBarStyle = .default
        
        // replaced the switch with flight switch
        switchView.tintColor = AppColors.themeGray20
        switchView.offTintColor = AppColors.themeGray10
        switchView.isOn = false
        switchView.setupUI()
        /*
         self.switchView.originalColor = AppColors.themeWhite.withAlphaComponent(0.85)
         self.switchView.selectedColor = AppColors.themeRed
         self.switchView.originalBorderColor = AppColors.themeGray04//AppColors.themeGray20
         self.switchView.selectedBorderColor = AppColors.themeRed
         self.switchView.originalBorderWidth = 0.0//1.5
         self.switchView.selectedBorderWidth = 0.0//1.5
         self.switchView.iconBorderWidth = 0.0
         self.switchView.iconBorderColor = AppColors.clear
         self.switchView.originalImage = #imageLiteral(resourceName: "switch_fav_on").maskWithColor(color: UIColor(displayP3Red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1))
         self.switchView.selectedImage = #imageLiteral(resourceName: "switch_fav_on")
         self.switchView.isBackgroundBlurry = true
         */
        
        self.switchGradientView.backgroundColor = AppColors.clear
        self.switchGradientView.isHidden = true
        // self.switchGradientView.addGrayShadow(ofColor: AppColors.themeBlack.withAlphaComponent(0.2), radius: 18, offset: .zero, opacity: 2, cornerRadius: 100)
        self.manageFloatingView(isHidden: true)
        self.searchBarContainerView.isHidden = true
        
    }
    
    override func setupFonts() {
        self.titleLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.descriptionLabel.font = AppFonts.Regular.withSize(13.0)
        self.cancelButton.titleLabel?.font = AppFonts.Regular.withSize(18.0)
    }
    
    override func setupTexts() {
        self.searchBar.placeholder = LocalizedString.SearchHotelsOrLandmark.localized
        self.cancelButton.setTitle(LocalizedString.Cancel.localized, for: .normal)
        self.setupNavigationTitleLabelText()
    }
    
    override func setupColors() {
        self.titleLabel.textColor = AppColors.themeBlack
        self.descriptionLabel.textColor = AppColors.themeBlack
        self.cancelButton.setTitleColor(AppColors.themeGreen, for: .normal)
    }
    
    private func registerXib() {
        self.hotelSearchTableView.register(UINib(nibName: self.hotelResultCellIdentifier, bundle: nil), forCellReuseIdentifier: self.hotelResultCellIdentifier)
    }
    
    
    private func presentEmailVC() {
        func showEmailComposer() {
//            self.emailButton.isLoading = true
//            self.viewModel.getPinnedTemplate(hotels: self.viewModel.favouriteHotels) { [weak self] (status) in
//                guard let strongSelf = self else {return}
//                strongSelf.emailButton.isLoading = false
//                if status {
                    // url fetched
            AppFlowManager.default.presentMailComposerVC(self.viewModel.favouriteHotels, self.viewModel.hotelSearchRequest ?? HotelSearchRequestModel(), self.viewModel.shortUrl, presentingStatusBarStyle: .lightContent, dismissalStatusBarStyle: statusBarStyle)
                    AppFlowManager.default.removeLoginConfirmationScreenFromStack()
//                }
//            }
        }
        AppFlowManager.default.proccessIfUserLoggedIn(verifyingFor: .loginFromEmailShare) { (_) in
            guard AppGlobals.shared.isNetworkRechable(showMessage: true) else {return}
            showEmailComposer()
            self.viewModel.updateRecentSearch()
        }
        
    }
    
    func manageShimmer(isHidden: Bool) {
        self.shimmerView.isHidden = isHidden
        self.tableViewVertical.isHidden = !isHidden
        if isHidden {
            self.view.sendSubviewToBack(self.shimmerView)
        }
        else {
            self.manageSwitchContainer(isHidden: true)
            self.view.bringSubviewToFront(self.shimmerView)
        }
    }
    
    private func setUpLongPressOnFilterButton() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_ :)))
        self.filterButton.addGestureRecognizer(longPressGesture)
    }
    
    // MARK: - Public
    
    // MARK: - Action
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.statusBarStyle = .lightContent
        AppFlowManager.default.popViewController(animated: true)
    }
    
    @IBAction func filterButtonAction(_ sender: UIButton) {
        AppFlowManager.default.showFilterVC(self)
    }
    
    @IBAction func mapButtonAction(_ sender: Any) {
        self.mapButtonIndicator.isHidden = false
        self.mapButton.alpha = 0.5
        self.mapButtonIndicator.startAnimating()
        delay(seconds: 0.1) {
            AppFlowManager.default.moveToHotelsResultMapVC(viewModel: self.viewModel)
        }
    }
    
    @IBAction func unPinAllFavouriteButtonTapped(_ sender: Any) {
        let title = LocalizedString.UnfavouriteAll.localized.capitalized + "?"
        let message = LocalizedString.UnfavouriteAllMessage.localized
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let  cancelAction = UIAlertAction(title: LocalizedString.Cancel.localized, style: .default, handler: nil)
        cancelAction.setValue(AppColors.themeDarkGreen, forKey: "titleTextColor")
        
        let  unFavouriteAction = UIAlertAction(title: LocalizedString.Unfavourite.localized, style: .destructive) { [weak self] (action) in
            self?.removeAllFavouritesHotels()
        }
        unFavouriteAction.setValue(AppColors.themeRed, forKey: "titleTextColor")
        
        alert.addAction(cancelAction)
        alert.addAction(unFavouriteAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        self.openSharingSheet()
    }
    
    @IBAction func EmailButtonTapped(_ sender: Any) {
        self.presentEmailVC()
    }
    
    @IBAction func floatingButtonOptionOnMapViewTapped(_ sender: Any) {
        let buttons = AppGlobals.shared.getPKAlertButtons(forTitles: [LocalizedString.Email.localized, LocalizedString.Share.localized, LocalizedString.RemoveFromFavourites.localized], colors: [AppColors.themeDarkGreen, AppColors.themeDarkGreen, AppColors.themeDarkGreen])
        
        _ = PKAlertController.default.presentActionSheet(LocalizedString.FloatingButtonsTitle.localized, message: nil, sourceView: self.view, alertButtons: buttons, cancelButton: AppGlobals.shared.pKAlertCancelButton) { [weak self] _, index in
            
            if index == 0 {
                printDebug("Email")
                self?.presentEmailVC()
            } else if index == 1 {
                printDebug("Share")
                self?.openSharingSheet()
            } else if index == 2 {
                self?.removeAllFavouritesHotels()
                printDebug("Remove All photo")
            }
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.searchResultHeaderView.updateHeight(height: hotelSearchResultHeaderViewHeight.min)
        self.tableViewVertical.sectionHeaderHeight = hotelSearchResultHeaderViewHeight.min
        self.viewModel.searchedHotels.removeAll()
        self.reloadHotelList()
        self.viewModel.fetchRequestType = .normal
        
        self.hideSearchAnimation()
        self.view.endEditing(true)
        self.searchBar.text = ""
        self.viewModel.searchTextStr = ""
        //self.reloadHotelList()
        delay(seconds: 0.1) { [weak self] in
            self?.viewModel.loadSaveData()
        }
        // nitin       self.getFavouriteHotels(shouldReloadData: false)
    }
    
    
    @IBAction func searchBtnTapped(_ sender: Any) {
        self.showSearchAnimation()
    }
    
    @objc func longPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            printDebug("Long press tapped")
//            AppFlowManager.default.presentAerinTextSpeechVC()
        }
    }
    
    // added tap gesture to handle the tap on mapview when vertical tableview is visible
    @objc func searchTabeleTapped(tap:UITapGestureRecognizer) {
        let location = tap.location(in: self.hotelSearchTableView)
        let path = self.hotelSearchTableView.indexPathForRow(at: location)
        if let indexPathForRow = path {
            self.tableView(self.hotelSearchTableView, didSelectRowAt: indexPathForRow)
        } else if (hotelSearchTableView.backgroundView == nil || hotelSearchTableView.backgroundView?.isHidden ?? false){
            // handle tap on empty space below existing rows however you want
            printDebug("tapped at empty space of table view")
            self.cancelButtonTapped(self.cancelButton)
        }
    }
    
    override func checkForReachability(_ notification: Notification) {
        
        guard let networkReachability = notification.object as? Reachability else {return}
        let remoteHostStatus = networkReachability.currentReachabilityStatus
        
        if remoteHostStatus == .notReachable {
            printDebug("Not Reachable")
            // self.noHotelFound()
            
        }
        else if remoteHostStatus == .reachableViaWiFi {
            printDebug("Reachable via Wifi")
        }
        else {
            printDebug("Reachable")
        }
    }
    
}

