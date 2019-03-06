//
//  ResultVC.swift
//  AERTRIP
//
//  Created by Admin on 31/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import CoreData
import GoogleMaps
import UIKit

enum FetchRequestType {
    case FilterApplied
    case Searching
}

enum HotelResultViewType {
    case MapView
    case ListView
}

class HotelResultVC: BaseVC {
    // MARK: - IBOutlets
    
    // MARK: -
    
    @IBOutlet var headerContainerView: UIView!
    @IBOutlet var navContainerView: UIView!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var filterButton: UIButton!
    @IBOutlet var mapButton: UIButton!
    @IBOutlet var searchBar: ATSearchBar!
    @IBOutlet var dividerView: ATDividerView!
    @IBOutlet var progressView: UIProgressView!
    @IBOutlet var unPinAllFavouriteButton: UIButton!
    @IBOutlet var emailButton: UIButton!
    @IBOutlet var shareButton: UIButton!
    @IBOutlet var switchView: ATSwitcher!
    
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet {
            collectionView.registerCell(nibName: HotelCardCollectionViewCell.reusableIdentifier)
            collectionView.registerCell(nibName: HotelGroupCardCollectionViewCell.reusableIdentifier)
            collectionView.isPagingEnabled = true
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.showsVerticalScrollIndicator = false
            collectionView.showsHorizontalScrollIndicator = false
        }
    }
    
    @IBOutlet var tableViewVertical: UITableView! {
        didSet {
            tableViewVertical.registerCell(nibName: HotelCardTableViewCell.reusableIdentifier)
            tableViewVertical.register(HotelResultSectionHeader.self, forHeaderFooterViewReuseIdentifier: "HotelResultSectionHeader")
            tableViewVertical.register(UINib(nibName: "HotelResultSectionHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "HotelResultSectionHeader")
            tableViewVertical.delegate = self
            tableViewVertical.dataSource = self
            tableViewVertical.separatorStyle = .none
            tableViewVertical.showsVerticalScrollIndicator = false
            tableViewVertical.showsHorizontalScrollIndicator = false
        }
    }
    
    @IBOutlet var tableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var headerContainerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var shimmerView: UIView!
    @IBOutlet var headerContatinerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var floatingView: UIView!
    @IBOutlet var floatingButtonOnMapView: UIButton!
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var floatingViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var floatingButtonBackView: UIView!
    @IBOutlet weak var mapContainerView: UIView!
    @IBOutlet weak var mapContainerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var switchContainerView: UIView!
    
    // MARK: - Properties
    private var clusterManager: GMUClusterManager!
    
    var mapView: GMSMapView?
    
    var container: NSPersistentContainer!
    var predicateStr: String = ""
    var time: Float = 0.0
    var timer: Timer?
    var isAboveTwentyKm: Bool = false
    var isFotterVisible: Bool = false
    var searchIntitialFrame: CGRect = .zero
    private var completion: (() -> Void)?
    private weak var hotelsGroupExpendedVC: HotelsGroupExpendedVC?
    
    private var visibleMapHeightInVerticalMode: CGFloat = 160.0
    private var oldScrollPosition: CGPoint = CGPoint.zero
    private let mapIntitalZoomLabel: Float = 8.0
    
    fileprivate var fetchedResultsController: NSFetchedResultsController<HotelSearched> = {
        var fetchRequest: NSFetchRequest<HotelSearched> = HotelSearched.fetchRequest()
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "sectionTitle", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.shared.managedObjectContext, sectionNameKeyPath: "sectionTitle", cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            printDebug("Error in performFetch: \(error) at line \(#line) in file \(#file)")
        }
        return fetchedResultsController
    }()
    
    var fetchRequestType: FetchRequestType = .Searching
    var hoteResultViewType: HotelResultViewType = .ListView
    var favouriteHotels: [HotelSearched] = []
    
    // MARK: - Public
    
    // MARK: - Private
    
    let viewModel = HotelsResultVM()
    var locManager = CLLocationManager()
    var currentLocation: CLLocation?
    var filterApplied: UserInfo.HotelFilter = UserInfo.HotelFilter()
    var hideSection = 0
    var footeSection = 1
    let defaultDuration: CGFloat = 1.2
    let defaultDamping: CGFloat = 0.70
    let defaultVelocity: CGFloat = 15.0
    
    private var isShowingGroupedCell: Bool = false
    
    // MARK: - ViewLifeCycle
    
    // MARK: -
    override func initialSetup() {
        
//        self.relocateSwitchButton(shouldMoveUp: false, animated: false)
//        self.relocateCurrentLocationButton(shouldMoveUp: false, animated: false)
        
        self.animateCollectionView(isHidden: true, animated: false)
        self.floatingButtonBackView.addGredient(colors: [AppColors.themeWhite.withAlphaComponent(0.01), AppColors.themeWhite])

        self.view.backgroundColor = AppColors.themeWhite
        
        self.container = NSPersistentContainer(name: "AERTRIP")
        
        self.container.loadPersistentStores { _, error in
            self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            if let error = error {
                print("Unresolved error \(error.localizedDescription)")
            }
        }
        
        self.initialSetups()

        self.startProgress()
        self.completion = { [weak self] in
            self?.loadSaveData()
        }
        self.applyPreviousFilter()
        self.viewModel.hotelListOnPreferenceResult()
        self.getFavouriteHotels()
        self.getPinnedHotelTemplate()
        self.statusBarStyle = .default
        
        self.addMapView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getSavedFilter()
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    // MARK: - Methods
    
    // MARK: - Private
    
    private func initialSetups() {
        self.setUpFloatingView()
        self.setupTableHeader()
        self.searchBar.delegate = self
        self.progressView.transform = self.progressView.transform.scaledBy(x: 1, y: 1)
        self.searchIntitialFrame = self.searchBar.frame
        self.reloadHotelList()
        self.floatingView.isHidden = false
        self.floatingButtonOnMapView.isHidden = true
    }
    
    private func setUpFloatingView() {
        self.switchView.delegate = self
        self.unPinAllFavouriteButton.isHidden = true
        self.emailButton.isHidden = true
        self.shareButton.isHidden = true
    }
    
    override func setupFonts() {
        self.titleLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.descriptionLabel.font = AppFonts.SemiBold.withSize(13.0)
    }
    
    override func setupTexts() {
        self.titleLabel.text = "New Delhi"
        self.descriptionLabel.text = "30 Jun - 1 Jul • 2 Rooms"
        self.searchBar.placeholder = LocalizedString.SearchHotelsOrLandmark.localized
    }
    
    override func setupColors() {
        self.titleLabel.textColor = AppColors.themeBlack
        self.descriptionLabel.textColor = AppColors.themeBlack
    }
    
    private func setupTableHeader() {
        self.tableViewVertical.backgroundView = nil
        self.tableViewVertical.backgroundColor = AppColors.clear
        
        let shadowsHeight: CGFloat = 60.0
        
        let hView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIDevice.screenWidth, height: visibleMapHeightInVerticalMode))
        hView.backgroundColor = AppColors.clear
        
        let shadowView = UIView(frame: CGRect(x: 0.0, y: (hView.frame.height - shadowsHeight), width: UIDevice.screenWidth, height: shadowsHeight))
        shadowView.addGredient(colors: [AppColors.themeWhite.withAlphaComponent(0.01), AppColors.themeWhite])
        hView.addSubview(shadowView)
        
        self.tableViewVertical.tableHeaderView = hView
    }
    
    private func reloadHotelList() {
        
        self.tableViewVertical.isHidden = true
        if let section = self.fetchedResultsController.sections, !section.isEmpty {
            self.tableViewVertical.isHidden = false
        }
        self.tableViewVertical.reloadData()
        self.collectionView.reloadData()
    }
    
    private func searchHotels(forText: String) {
        self.fetchRequestType = .Searching
        printDebug("searching text is \(forText)")
        self.predicateStr = forText
        self.loadSaveData()
        self.reloadHotelList()
    }

    private func startProgress() {
        // Invalid timer if it is valid
        if self.timer?.isValid == true {
            self.timer?.invalidate()
        }
        
        self.time = 0.0
        self.progressView.setProgress(0.0, animated: false)
        
        self.timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.setProgress), userInfo: nil, repeats: true)
    }
    
    private func getSavedFilter() {
        guard let filter = UserInfo.loggedInUser?.hotelFilter else {
            printDebug("filter not found")
            return
        }
        self.filterApplied = filter
    }
    
    private func applyPreviousFilter() {
        AppToast.default.showToastMessage(message: LocalizedString.ApplyPreviousFilter.localized, onViewController: self, buttonTitle: LocalizedString.apply.localized, buttonImage: nil, buttonAction: self.completion)
    }
    
    func convertToMapView() {
        self.animateCollectionView(isHidden: false, animated: true)
    }
    
    func convertToListView() {
        self.animateCollectionView(isHidden: true, animated: true)
    }
    
    private func animateCollectionView(isHidden: Bool, animated: Bool) {
        collectionView.translatesAutoresizingMaskIntoConstraints = true
        let hiddenFrame: CGRect = CGRect(x: collectionView.width, y: (UIDevice.screenHeight - collectionView.height), width: collectionView.width, height: collectionView.height)
        let shownFrame: CGRect = CGRect(x: 0.0, y: (UIDevice.screenHeight - (collectionView.height + AppFlowManager.default.safeAreaInsets.bottom)), width: collectionView.width, height: collectionView.height)

        if !isHidden {
            self.collectionView.isHidden = false
            self.floatingButtonBackView.isHidden = false
        }
        
        
        //resize the map view for map/list view
        let mapFrame = CGRect(x: 0.0, y: 0.0, width: mapContainerView.width, height: isHidden ? visibleMapHeightInVerticalMode : mapContainerView.height)
        
        self.mapView?.animate(toZoom: isHidden ? mapIntitalZoomLabel : (mapIntitalZoomLabel+4.0))
        self.moveMapToCurrentCity()
        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, animations: {
            
            //map resize animation
            self.mapView?.frame = mapFrame
            
            //vertical list animation
            self.collectionView.frame = isHidden ? hiddenFrame : shownFrame
            self.collectionView.alpha = isHidden ? 0.0 : 1.0
            
            //floating buttons animation
            self.floatingViewBottomConstraint.constant = isHidden ? 10.0 : (hiddenFrame.height)
            self.currentLocationButton.isHidden = isHidden
            self.floatingButtonBackView.alpha = isHidden ? 0.0 : 1.0
            
            //horizontal list animation
            self.tableViewTopConstraint.constant = isHidden ? 100.0 : UIDevice.screenHeight
            self.tableViewVertical.alpha = isHidden ? 1.0 : 0.0
            
            self.view.layoutIfNeeded()
        }, completion: { (isDone) in
            if isHidden {
                self.floatingButtonBackView.isHidden = true
                self.collectionView.isHidden = true
                self.relocateSwitchButton(shouldMoveUp: true, animated: true)
            }
        })
    }
    
    func animateHeaderToListView() {
        self.headerContatinerViewHeightConstraint.constant = 100
        self.tableViewTopConstraint.constant = 100
        mapContainerTopConstraint.constant = 100
        UIView.animate(withDuration: AppConstants.kAnimationDuration, animations: {
            self.searchBar.frame = self.searchIntitialFrame
            self.titleLabel.transform = .identity
            self.descriptionLabel.transform = .identity
            self.view.layoutIfNeeded()
        })
    }
    
    func animateHeaderToMapView() {
        self.headerContatinerViewHeightConstraint.constant = 50
        self.tableViewTopConstraint.constant = 50
        mapContainerTopConstraint.constant = 50
        UIView.animate(withDuration: AppConstants.kAnimationDuration) {
            self.searchBar.frame = CGRect(x: self.searchBar.frame.origin.x + 10
                                          , y: self.searchBar.frame.origin.y - 45, width: self.searchBar.frame.width - 80, height: 50)
            self.titleLabel.transform = CGAffineTransform(translationX: 0, y: -60)
            self.descriptionLabel.transform = CGAffineTransform(translationX: 0, y: -60)
            self.view.layoutIfNeeded()
        }
    }
    
    private func getFavouriteHotels() {
        self.favouriteHotels = self.fetchedResultsController.fetchedObjects?.filter { $0.fav == "1" } ?? []
    }
    
    private func getPinnedHotelTemplate() {
        if !self.favouriteHotels.isEmpty {
            self.viewModel.getPinnedTemplate(hotels: self.favouriteHotels)
        }
    }
    
    // MARK: Show progress
    
    @objc func setProgress() {
        self.time += 1.0
        self.progressView.setProgress(self.time / 10, animated: true)
        
        if self.time == 8 {
            self.timer?.invalidate()
            return
        }
        if self.time == 2 {
            self.timer!.invalidate()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                self.timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(self.setProgress), userInfo: nil, repeats: true)
            }
        }
        
        if self.time >= 10 {
            self.timer!.invalidate()
            delay(seconds: 0.8) {
                self.progressView.isHidden = true
            }
        }
    }
    
    private func loadSaveData() {
        if self.fetchRequestType == .FilterApplied {
            self.fetchedResultsController.fetchRequest.sortDescriptors?.removeAll()
            self.fetchedResultsController.fetchRequest.sortDescriptors = [NSSortDescriptor(key: "sectionTitle", ascending: true)]
            
            switch self.filterApplied.sortUsing {
            case .BestSellers:
                self.fetchedResultsController.fetchRequest.sortDescriptors?.append(NSSortDescriptor(key: "bc", ascending: true))
            case .PriceLowToHigh:
                self.fetchedResultsController.fetchRequest.sortDescriptors?.append(NSSortDescriptor(key: "price", ascending: true))
            case .TripAdvisorRatingHighToLow:
                self.fetchedResultsController.fetchRequest.sortDescriptors?.append(NSSortDescriptor(key: "rating", ascending: false))
            case .StartRatingHighToLow:
                self.fetchedResultsController.fetchRequest.sortDescriptors?.append(NSSortDescriptor(key: "star", ascending: false))
            case .DistanceNearestFirst:
                self.fetchedResultsController.fetchRequest.sortDescriptors?.append(NSSortDescriptor(key: "distance", ascending: true))
            }
            
            var amentitiesPredicate: NSPredicate?
            var predicates = [AnyHashable]()
            for amentities: String in self.filterApplied.amentities {
                predicates.append(NSPredicate(format: "amenities == \(String(amentities))"))
            }
            if predicates.count > 0 {
                if let predicates = predicates as? [NSPredicate] {
                    amentitiesPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
                }
            }
            
//            let distancePredicate = NSPredicate(format: "distance <= \(self.filterApplied.distanceRange)")
//            let minimumPricePredicate = NSPredicate(format: "price >= \(HotelFilterVM.shared.minimumPrice)")
//            let maximumPricePredicate = NSPredicate(format: "price <= \(HotelFilterVM.shared.maximumPrice)")
//
//            let starPredicate = NSPredicate(format: "star IN %@", HotelFilterVM.shared.ratingCount)
//            let tripAdvisorPredicate = NSPredicate(format: "rating IN %@", HotelFilterVM.shared.tripAdvisorRatingCount)
            
//            let amentitiesPredicate = NSPredicate(format: "amenities CONTAINS %@", HotelFilterVM.shared.amenitites)
            
            //  let andPredicate = NSCompoundPredicate(type: .and, subpredicates: [distancePredicate, minimumPricePredicate,starPredicate,tripAdvisorPredicate])
            //  let andPredicate = NSCompoundPredicate(type: .and, subpredicates: [distancePredicate, minimumPricePredicate])
            self.fetchedResultsController.fetchRequest.predicate = amentitiesPredicate
        } else {
            if self.predicateStr == "" {
                self.fetchedResultsController.fetchRequest.predicate = nil
                
            } else {
                self.fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "hotelName CONTAINS[cd] %@", self.predicateStr)
            }
        }
        
        do {
            try self.fetchedResultsController.performFetch()
            self.reloadHotelList()
        } catch {
            print("Fetch failed")
        }
    }
    
    private func openSharingSheet() {
        let textToShare = [self.viewModel.shortUrl]
        let activityViewController =
            UIActivityViewController(activityItems: textToShare as [Any],
                                     applicationActivities: nil)
        UIApplication.shared.keyWindow?.tintColor = AppColors.themeGreen
        present(activityViewController, animated: true)
    }
    
    private func removeAllFavouritesHotels() {
        self.viewModel.updateFavourite(forHotels: self.favouriteHotels, isUnpinHotels: true)
    }
    
    private func expandGroup() {
        if let topVC = UIApplication.topViewController() {
            let dataVC = HotelsGroupExpendedVC.instantiate(fromAppStoryboard: .HotelsSearch)
            self.hotelsGroupExpendedVC = dataVC
            let sheet = PKBottomSheet.instanceFromNib
            sheet.headerHeight = 24.0
            sheet.headerView = dataVC.headerView
            sheet.frame = topVC.view.bounds
            sheet.delegate = self
            topVC.view.addSubview(sheet)
            sheet.present(presentedViewController: dataVC, animated: true)
        }
    }
    
    private func relocateSwitchButton(shouldMoveUp: Bool, animated: Bool) {
        let trans = shouldMoveUp ? CGAffineTransform.identity : CGAffineTransform(translationX: 0.0, y: 30.0)
        
        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0) { [weak self] in
            self?.switchContainerView.transform = trans
            self?.view.layoutIfNeeded()
        }
    }
    
    private func relocateCurrentLocationButton(shouldMoveUp: Bool, animated: Bool) {
        let trans = shouldMoveUp ? CGAffineTransform.identity : CGAffineTransform(translationX: 0.0, y: 30.0)
        
        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0) { [weak self] in
            self?.currentLocationButton.transform = trans
            self?.view.layoutIfNeeded()
        }
    }
    
    private func moveMapToCurrentCity() {
        if let loc = self.viewModel.searchedCityLocation {
            self.updateMarker(coordinates: loc)
        }
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
        self.hideButtons()
        if self.hoteResultViewType == .ListView {
            self.animateHeaderToMapView()
            self.convertToMapView()
            self.hoteResultViewType = .MapView
        } else {
            self.animateHeaderToListView()
            self.convertToListView()
            self.hoteResultViewType = .ListView
        }
    }
    
    @IBAction func unPinAllFavouriteButtonTapped(_ sender: Any) {
        self.removeAllFavouritesHotels()
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        self.openSharingSheet()
    }
    
    @IBAction func EmailButtonTapped(_ sender: Any) {
        AppFlowManager.default.presentMailComposerVC(self.favouriteHotels)
    }
    
    @IBAction func floatingButtonOptionOnMapViewTapped(_ sender: Any) {
        let buttons = AppGlobals.shared.getPKAlertButtons(forTitles: [LocalizedString.Email.localized, LocalizedString.Share.localized, LocalizedString.RemoveFromFavourites.localized], colors: [AppColors.themeGreen, AppColors.themeGreen, AppColors.themeRed])
        
        _ = PKAlertController.default.presentActionSheet(LocalizedString.FloatingButtonsTitle.localized, message: nil, sourceView: self.view, alertButtons: buttons, cancelButton: AppGlobals.shared.pKAlertCancelButton) { [weak self] _, index in
            
            if index == 0 {
                printDebug("Email")
                
            } else if index == 1 {
                printDebug("Share")
                self?.openSharingSheet()
            } else if index == 2 {
                self?.removeAllFavouritesHotels()
                printDebug("Remove All photo")
            }
        }
    }
    @IBAction func currentLocationButtonAction(_ sender: UIButton) {
        self.moveMapToCurrentCity()
        self.mapView?.animate(toZoom: mapIntitalZoomLabel+4.0)
    }
}

// MARK: - Table view datasource and delegate methods
// MARK: -
extension HotelResultVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (self.fetchedResultsController.sections?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = self.fetchedResultsController.sections else {
            printDebug("No sections in fetchedResultsController")
            return 0
        }
        let sectionInfo = sections[section]
        if sectionInfo.numberOfObjects > 0 {
            self.shimmerView.removeFromSuperview()
        }
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 53.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        guard let sections = fetchedResultsController.sections, let hView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HotelResultSectionHeader") as? HotelResultSectionHeader else {
            return nil
        }
        
        var removeFirstChar = sections[section].name
        _ = removeFirstChar.removeFirst()
        let text = removeFirstChar + " kms"
        hView.titleLabel.text = "  \(text)   "
        
        return hView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 203.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HotelCardTableViewCell") as? HotelCardTableViewCell else {
            fatalError("HotelCardTableViewCell not found")
        }
        
        let hData = fetchedResultsController.object(at: indexPath)
        self.isAboveTwentyKm = hData.isHotelBeyondTwentyKm
        self.isFotterVisible = self.isAboveTwentyKm
        cell.hotelListData = hData
        cell.delegate = self
        cell.contentView.backgroundColor = AppColors.themeWhite
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let hData = fetchedResultsController.object(at: indexPath)
        if let cell = tableView.cellForRow(at: indexPath) {
            AppFlowManager.default.presentHotelDetailsVC(hotelInfo: hData, sourceView: cell.contentView,sid: self.viewModel.sid,hotelSearchRequest: self.viewModel.hotelSearchRequest)
        }
    }
}

// MARK: - MXParallaxHeaderDelegate methods

extension HotelResultVC {
    
    func manageTopHeader(_ scrollView: UIScrollView) {
        
        guard scrollView === tableViewVertical else {
            return
        }

        let yPosition = scrollView.contentOffset.y
        if 20...30 ~= yPosition {
            //hide
            self.headerContainerViewTopConstraint.constant = -140
            self.tableViewTopConstraint.constant = 0
            mapContainerTopConstraint.constant = 0
            
            UIView.animate(withDuration: AppConstants.kAnimationDuration, animations: {
                self.view.layoutIfNeeded()
            })
        }
        else if yPosition < 20 {
            //show
            self.headerContainerViewTopConstraint.constant = 0
            self.tableViewTopConstraint.constant = 100
            mapContainerTopConstraint.constant = 100
            UIView.animate(withDuration: AppConstants.kAnimationDuration, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func manageFloatingButtonOnPaginationScroll(_ scrollView: UIScrollView) {
        guard scrollView === collectionView else {
            return
        }
        
        let xPos = scrollView.contentOffset.x
        
        let fractional: CGFloat = xPos / UIDevice.screenWidth
        let decimal: CGFloat = floor(fractional)
        let progress = fractional - decimal
        
        let currentPoint = CGPoint(x: decimal * UIDevice.screenWidth, y: scrollView.contentOffset.y)
        guard 0.01...0.99 ~= progress else {
            if let _ = self.collectionView.indexPathForItem(at: currentPoint) {
                //current grouped cell
                self.relocateSwitchButton(shouldMoveUp: true, animated: true)
                self.relocateCurrentLocationButton(shouldMoveUp: true, animated: true)
            }
            else {
                //current normal cell
                self.relocateSwitchButton(shouldMoveUp: false, animated: true)
                self.relocateCurrentLocationButton(shouldMoveUp: false, animated: true)
            }
            return
        }
        
        let nextPoint = CGPoint(x: (decimal+1) * UIDevice.screenWidth, y: scrollView.contentOffset.y)
        let prevPoint = CGPoint(x: (decimal-1) * UIDevice.screenWidth, y: scrollView.contentOffset.y)
        
        if xPos > self.oldScrollPosition.x {
            //forward
            printDebug("forward, \(fractional)")
            if let _ = self.collectionView.indexPathForItem(at: currentPoint) {
                //current grouped cell
                if let _ = self.collectionView.indexPathForItem(at: nextPoint) {
                    //next grouped cell
                    self.relocateSwitchButton(shouldMoveUp: true, animated: true)
                    self.relocateCurrentLocationButton(shouldMoveUp: true, animated: true)
                }
                else {
                    //next normal cell
                    if progress < 0.5 {
                        self.relocateCurrentLocationButton(shouldMoveUp: false, animated: true)
                    }
                    else {
                        self.relocateSwitchButton(shouldMoveUp: false, animated: true)
                    }
                }
            }
            else {
                //current normal cell
                if let _ = self.collectionView.indexPathForItem(at: nextPoint) {
                    //next grouped cell
                    if progress < 0.5 {
                        self.relocateCurrentLocationButton(shouldMoveUp: true, animated: true)
                    }
                    else {
                        self.relocateSwitchButton(shouldMoveUp: true, animated: true)
                    }
                }
                else {
                    //next normal cell
                    self.relocateSwitchButton(shouldMoveUp: false, animated: true)
                    self.relocateCurrentLocationButton(shouldMoveUp: false, animated: true)
                }
            }
        }
        else {
            //backward
            printDebug("backward, \(fractional)")
            
            if let _ = self.collectionView.indexPathForItem(at: currentPoint) {
                //current grouped cell
                if let _ = self.collectionView.indexPathForItem(at: prevPoint) {
                    //prev grouped cell
                    self.relocateSwitchButton(shouldMoveUp: true, animated: true)
                    self.relocateCurrentLocationButton(shouldMoveUp: true, animated: true)
                }
                else {
                    //prev normal cell
                    if progress < 0.5 {
                        self.relocateCurrentLocationButton(shouldMoveUp: false, animated: true)
                    }
                    else {
                        self.relocateSwitchButton(shouldMoveUp: false, animated: true)
                    }
                }
            }
            else {
                //current normal cell
                if let _ = self.collectionView.indexPathForItem(at: prevPoint) {
                    //prev grouped cell
                    if progress < 0.5 {
                        self.relocateCurrentLocationButton(shouldMoveUp: true, animated: true)
                    }
                    else {
                        self.relocateSwitchButton(shouldMoveUp: true, animated: true)
                    }
                }
                else {
                    //prev normal cell
                    self.relocateSwitchButton(shouldMoveUp: false, animated: true)
                    self.relocateCurrentLocationButton(shouldMoveUp: false, animated: true)
                }
            }
        }
        self.oldScrollPosition = scrollView.contentOffset
    }
    
    func manageMapViewOnScroll(_ scrollView: UIScrollView) {
        guard scrollView === tableViewVertical, let mView = self.mapView else {
            return
        }
        
        let yPosition = min(scrollView.contentOffset.y, visibleMapHeightInVerticalMode)
        
        mView.frame = CGRect(x: 0.0, y: -(yPosition), width: mView.width, height: mView.height)
        mView.isHidden = scrollView.contentOffset.y > visibleMapHeightInVerticalMode
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        manageTopHeader(scrollView)
        manageMapViewOnScroll(scrollView)
        manageFloatingButtonOnPaginationScroll(scrollView)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        manageTopHeader(scrollView)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        manageTopHeader(scrollView)
    }
}

// MARK: - Hotel filter Delegate methods

extension HotelResultVC: HotelFilteVCDelegate {
    func doneButtonTapped() {
        self.fetchRequestType = .FilterApplied
        HotelFilterVM.shared.saveDataToUserDefaults()
        printDebug("done button tapped")
        self.loadSaveData()
        self.reloadHotelList()
    }
}

extension HotelResultVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        printDebug("location \(String(describing: locations.last))")
        self.currentLocation = locations.last
        self.addMapView()
    }
}

// MARK: - Search bar delegate methods

extension HotelResultVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.fetchRequestType = .Searching
            self.predicateStr = ""
            self.loadSaveData()
            self.reloadHotelList()
        } else {
            self.searchHotels(forText: searchText)
        }
    }
}

// MARK: - Section Footer Delgate methods

extension HotelResultVC: SectionFooterDelegate {
    func showHotelBeyond() {
        if self.isAboveTwentyKm {
            printDebug("hide hotel beyond ")
            self.isAboveTwentyKm = false
            self.hideSection = 1
            self.footeSection = 2
            self.reloadHotelList()
        } else {
            printDebug("show hotel beyond ")
            self.isAboveTwentyKm = true
            self.hideSection = 0
            self.footeSection = 1
            self.reloadHotelList()
        }
    }
}

// MARK: - Hotel Card collection view Delegate methods

extension HotelResultVC: HotelCardCollectionViewCellDelegate {
    func saveButtonActionFromLocalStorage(_ sender: UIButton, forHotel: HotelSearched) {
        self.viewModel.updateFavourite(forHotels: [forHotel], isUnpinHotels: false)
    }
    
    func saveButtonAction(_ sender: UIButton, forHotel: HotelsModel) {
        //
    }
    
    func pagingScrollEnable(_ indexPath: IndexPath, _ scrollView: UIScrollView) {
        printDebug("Hotel page scroll delegate ")
        
        if let cell = tableViewVertical.cellForRow(at: indexPath) as? HotelCardTableViewCell {
            cell.pageControl.setProgress(contentOffsetX: scrollView.contentOffset.x, pageWidth: scrollView.bounds.width)
        }
    }
}

// MARK: - HotelResultVM Delegate methods

extension HotelResultVC: HotelResultDelegate {
    func willGetPinnedTemplate() {
        //
    }
    
    func getPinnedTemplateSuccess() {
        //
    }
    
    func getPinnedTemplateFail() {
        //
    }
    
    func willUpdateFavourite() {
        //
    }
    
    func updateFavouriteSuccess() {
        self.reloadHotelList()
    }
    
    func updateFavouriteFail() {
        //
    }
    
    func getAllHotelsListResultSuccess(_ isDone: Bool) {
        if !isDone {
            self.viewModel.hotelListOnPreferenceResult()
        } else {
            self.loadSaveData()
            self.getFavouriteHotels()
            self.floatingView.isHidden = self.favouriteHotels.count < 0
            self.getPinnedHotelTemplate()
            self.time += 1
            self.timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(self.setProgress), userInfo: nil, repeats: true)
            self.updateMarkers()
        }
    }
    
    func getAllHotelsListResultFail(errors: ErrorCodes) {
        AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .profile)
    }
    
    private func hideButtons() {
        if self.hoteResultViewType == .ListView {
            self.unPinAllFavouriteButton.transform = CGAffineTransform(translationX: 0, y: 0)
            self.emailButton.transform = CGAffineTransform(translationX: 0, y: 0)
            self.shareButton.transform = CGAffineTransform(translationX: 0, y: 0)
            self.unPinAllFavouriteButton.isHidden = true
            self.emailButton.isHidden = true
            self.shareButton.isHidden = true
        } else {
            self.floatingButtonOnMapView.transform = CGAffineTransform(translationX: 0, y: 0)
            self.floatingButtonOnMapView.isHidden = true
        }
    }
    
    private func animateFloatingButtonOnListView() {
        UIView.animate(withDuration: TimeInterval(self.defaultDuration),
                       delay: 0,
                       usingSpringWithDamping: self.defaultDamping,
                       initialSpringVelocity: self.defaultVelocity,
                       options: .allowUserInteraction,
                       animations: {
                           self.unPinAllFavouriteButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                           self.emailButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                           self.shareButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                           self.unPinAllFavouriteButton.transform = CGAffineTransform(translationX: 54, y: 0)
                           self.emailButton.transform = CGAffineTransform(translationX: 98, y: 0)
                           self.shareButton.transform = CGAffineTransform(translationX: 142, y: 0)
                       },
                       completion: { _ in
                           printDebug("Animation finished")
        })
    }
    
    private func animateFloatingButtonOnMapView() {
        UIView.animate(withDuration: TimeInterval(self.defaultDuration),
                       delay: 0,
                       usingSpringWithDamping: self.defaultDamping,
                       initialSpringVelocity: self.defaultVelocity,
                       options: .allowUserInteraction,
                       animations: {
                           self.floatingButtonOnMapView.transform = CGAffineTransform(translationX: 65, y: 0)
                       },
                       completion: { _ in
                           printDebug("Animation finished")
        })
    }
    
    private func animateButton() {
        if self.hoteResultViewType == .ListView {
            self.animateFloatingButtonOnListView()
        } else {
            self.animateFloatingButtonOnMapView()
        }
    }
}

extension HotelResultVC: ATSwitcherChangeValueDelegate {
    func switcherDidChangeValue(switcher: ATSwitcher, value: Bool) {
        if value {
            if self.hoteResultViewType == .MapView {
                self.floatingButtonOnMapView.isHidden = false
            } else {
                self.unPinAllFavouriteButton.isHidden = false
                self.emailButton.isHidden = false
                self.shareButton.isHidden = false
            }
            self.animateButton()
            self.getFavouriteHotels()
        } else {
            self.hideButtons()
        }
    }
}

extension HotelResultVC: PKBottomSheetDelegate {
    func updateNavWhileInMapMode(isHidden: Bool) {
        UIView.animate(withDuration: AppConstants.kAnimationDuration) { [weak self] in
            self?.headerContatinerViewHeightConstraint.constant = isHidden ? 0.0 : 50.0
            self?.tableViewTopConstraint.constant = isHidden ? 0.0 : 50.0
            self?.mapContainerTopConstraint.constant = isHidden ? 0.0 : 50.0
            self?.progressView.isHidden = isHidden
            self?.view.layoutIfNeeded()
        }
    }
    func willShow(_ sheet: PKBottomSheet) {
        self.updateNavWhileInMapMode(isHidden: true)
    }
    
    func willHide(_ sheet: PKBottomSheet) {
        self.updateNavWhileInMapMode(isHidden: false)
        self.hotelsGroupExpendedVC?.animateCardsToClose()
    }
}


extension HotelResultVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return (self.fetchedResultsController.sections?.count ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sections = self.fetchedResultsController.sections else {
            printDebug("No sections in fetchedResultsController")
            return 0
        }
        let sectionInfo = sections[section]
        if sectionInfo.numberOfObjects > 0 {
            self.shimmerView.removeFromSuperview()
        }
        return sectionInfo.numberOfObjects
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let hData = fetchedResultsController.object(at: indexPath)
        self.isAboveTwentyKm = hData.isHotelBeyondTwentyKm
        self.isFotterVisible = self.isAboveTwentyKm
        
        if indexPath.item%3 != 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HotelGroupCardCollectionViewCell.reusableIdentifier, for: indexPath) as? HotelGroupCardCollectionViewCell else {
                fatalError("HotelGroupCardCollectionViewCell not found")
            }
            
            cell.hotelListData = hData
            cell.delegate = self
            cell.shouldShowMultiPhotos = false
            
            return cell
        }
        else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HotelCardCollectionViewCell.reusableIdentifier, for: indexPath) as? HotelCardCollectionViewCell else {
                fatalError("HotelCardCollectionViewCell not found")
            }
            
            cell.hotelListData = hData
            cell.delegate = self
            cell.shouldShowMultiPhotos = false
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.item%3 != 0 {
            //grouped cell
            return CGSize(width: UIDevice.screenWidth, height: 230.0)
        }
        else {
            //single cell
            return CGSize(width: UIDevice.screenWidth, height: 200.0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let _ = collectionView.cellForItem(at: indexPath) as? HotelGroupCardCollectionViewCell {
            self.expandGroup()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        self.isShowingGroupedCell = cell.isKind(of: HotelGroupCardCollectionViewCell.self)
        
        let hData = fetchedResultsController.object(at: indexPath)
        updateMarker(coordinates: CLLocationCoordinate2D(latitude: hData.lat?.toDouble ?? 0.0, longitude: hData.long?.toDouble ?? 0))
    }
}


extension HotelResultVC {
    private func addMapView() {
        self.locManager.requestWhenInUseAuthorization()
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == .authorizedAlways {}
        
        let camera = GMSCameraPosition.camera(withLatitude: viewModel.hotelSearchRequest?.requestParameters.latitude.toDouble ?? 0.0, longitude: viewModel.hotelSearchRequest?.requestParameters.longitude.toDouble ?? 0.0, zoom: 10.0)
        
        let mapRact = CGRect(x: 0.0, y: 0.0, width: mapContainerView.width, height: visibleMapHeightInVerticalMode)
        let mapV = GMSMapView.map(withFrame: mapRact, camera: camera)
        mapView = mapV
        mapV.setMinZoom(1.0, maxZoom: 30.0)
        mapV.animate(toZoom: mapIntitalZoomLabel)
        mapV.isMyLocationEnabled = false
        mapV.delegate = self
        
        mapContainerView.addSubview(mapV)
        
        self.setUpClusterManager()
        self.updateMarkers()
    }
    
    private func addCityLocation() {
        if let loc = self.viewModel.searchedCityLocation {
            let cityMarker = GMSMarker()
            
            let iconView = CityMarkerView(frame: CGRect(x: 0.0, y: 0.0, width: 62.0, height: 62.0))
            cityMarker.iconView = iconView
            cityMarker.position = loc
            cityMarker.map = self.mapView
        }
    }
    
    func updateMarkers() {
        self.addCityLocation()
        self.generateClusterItems()
    }
    
    func removeAllMerkers() {
        self.mapView?.clear()
    }
    
    func updateMarker(coordinates: CLLocationCoordinate2D) {
        mapView?.animate(toLocation: coordinates)
    }

    private func setUpClusterManager() {
        // Set up the cluster manager with the supplied icon generator and
        // renderer.
        if let mapView = mapView {
            let iconGenerator = GMUDefaultClusterIconGenerator()
            let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
            let renderer = GMUDefaultClusterRenderer(mapView: mapView,
                                                     clusterIconGenerator: iconGenerator)
            renderer.delegate = self
            clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm,
                                               renderer: renderer)
        }
    }
    
    /// Randomly generates cluster items within some extent of the camera and
    /// adds them to the cluster manager.
    private func generateClusterItems() {
        let hotels = fetchedResultsController.fetchedObjects ?? []
        for hotel in hotels {
            let item = ATClusterItem(position: CLLocationCoordinate2D(latitude: hotel.lat?.toDouble ?? 0.0, longitude: hotel.long?.toDouble ?? 0.0), hotel: hotel)
            clusterManager.add(item)
        }
    }
}

extension HotelResultVC: GMSMapViewDelegate {

    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        guard let lat = mapView.myLocation?.coordinate.latitude,
            let lng = mapView.myLocation?.coordinate.longitude else { return false }
        
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lng, zoom: 20)
        mapView.animate(to: camera)
        
        return true
    }
    
    // MARK: - GMSMarker Dragging
    
    func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
        printDebug("didBeginDragging")
    }
    
    func mapView(_ mapView: GMSMapView, didDrag marker: GMSMarker) {
        printDebug("didDrag")
    }
    
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        printDebug("didEndDragging")
    }
}


// MARK: - GMUClusterManagerDelegate

extension HotelResultVC: GMUClusterManagerDelegate, GMUClusterRendererDelegate {
    func renderer(_ renderer: GMUClusterRenderer, willRenderMarker marker: GMSMarker) {
        if let item = marker.userData as? ATClusterItem, let hotel = item.hotelDetails {
            let LocationAtual: CLLocation = CLLocation(latitude: hotel.lat?.toDouble ?? 0.0, longitude: hotel.long?.toDouble ?? 0.0)
            marker.position = CLLocationCoordinate2D(latitude: LocationAtual.coordinate.latitude, longitude: LocationAtual.coordinate.longitude)
            marker.title = marker.title
            //  marker.icon = hotel.fav == "0" ? UIImage(named: "clusterSmallTag") : UIImage(named: "favHotelWithShadowMarker")
            let customMarkerView = CustomMarker.instanceFromNib()
            customMarkerView.priceLabel.attributedText = (AppConstants.kRuppeeSymbol + "\(hotel.price.delimiter)").addPriceSymbolToLeft(using: AppFonts.SemiBold.withSize(16.0))
            marker.iconView = customMarkerView
        }
    }
    
    private func clusterManager(clusterManager: GMUClusterManager, didTapCluster cluster: GMUCluster) {
        if let mapView = mapView {
            let newCamera = GMSCameraPosition.camera(withTarget: cluster.position,
                                                     zoom: mapView.camera.zoom + 1)
            let update = GMSCameraUpdate.setCamera(newCamera)
            mapView.moveCamera(update)
        }
    }
}
