//
//  ResultVC.swift
//  AERTRIP
//
//  Created by Admin on 31/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import CoreData
import GoogleMaps
import MXParallaxHeader
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
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var progressView: UIProgressView!
    @IBOutlet var unPinAllFavouriteButton: UIButton!
    @IBOutlet var emailButton: UIButton!
    @IBOutlet var shareButton: UIButton!
    @IBOutlet var switchView: ATSwitcher!
    
    @IBOutlet var collectionViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var headerContainerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var shimmerView: UIView!
    @IBOutlet var headerContatinerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var floatingView: UIView!
    @IBOutlet var floatingButtonOnMapView: UIButton!
    
    // MARK: - Properties
    
    var container: NSPersistentContainer!
    var predicateStr: String = ""
    var time: Float = 0.0
    var timer: Timer?
    var isAboveTwentyKm: Bool = false
    var isFotterVisible: Bool = false
    var searchIntitialFrame: CGRect = .zero
    private var completion: (() -> Void)?
    
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
    
    let parallexHeaderHeight = CGFloat(200.0)
    var fetchRequestType: FetchRequestType = .Searching
    var hoteResultViewType: HotelResultViewType = .ListView
    var favouriteHotels: [HotelSearched] = []
    
    // MARK: - Public
    
    // MARK: - Private
    
    let viewModel = HotelsResultVM()
    var header = HotelsResultHeaderView.instanceFromNib()
    var locManager = CLLocationManager()
    var currentLocation: CLLocation?
    var filterApplied: UserInfo.HotelFilter = UserInfo.HotelFilter()
    var hideSection = 0
    var footeSection = 1
    let defaultDuration: CGFloat = 1.2
    let defaultDamping: CGFloat = 0.70
    let defaultVelocity: CGFloat = 15.0
    
    // MARK: - ViewLifeCycle
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.container = NSPersistentContainer(name: "AERTRIP")
        
        self.container.loadPersistentStores { _, error in
            self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            if let error = error {
                print("Unresolved error \(error.localizedDescription)")
            }
        }
        
        self.initialSetups()
        self.registerXib()
        delay(seconds: 0.5) {
            self.setupMapView()
        }
        
        self.startProgress()
        self.collectionView.addSubview(self.shimmerView)
        self.completion = { [weak self] in
            self?.loadSaveData()
        }
        self.applyPreviousFilter()
        self.viewModel.hotelListOnPreferenceResult()
        self.getFavouriteHotels()
        self.getPinnedHotelTemplate()
        self.statusBarStyle = .default
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getSavedFilter()
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    // MARK: - Methods
    
    // MARK: - Private
    
    private func initialSetups() {
        self.setUpFloatingView()
        self.setupParallaxHeader()
        self.collectionView.backgroundView?.backgroundColor = AppColors.clear
        self.collectionView.register(UINib(nibName: "HotelCardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HotelCardCollectionViewCell")
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
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
    
    private func setupParallaxHeader() {
        let parallexHeaderMinHeight = CGFloat(0.0)
        
        // header = HotelsResultHeaderView.instanceFromNib()
        
        self.collectionView.parallaxHeader.view = header
        self.collectionView.parallaxHeader.minimumHeight = parallexHeaderMinHeight
        self.collectionView.parallaxHeader.height = parallexHeaderHeight
        self.collectionView.parallaxHeader.mode = MXParallaxHeaderMode.fill
        self.collectionView.parallaxHeader.delegate = self
    }
    
    private func setupMapView() {
        self.locManager.requestWhenInUseAuthorization()
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == .authorizedAlways {}
        
        let camera = GMSCameraPosition.camera(withLatitude: currentLocation?.coordinate.latitude ?? 0.0, longitude: currentLocation?.coordinate.longitude ?? 0.0, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: CGRect(x: header.frame.origin.x, y: header.frame.origin.y, width: UIDevice.screenWidth, height: UIDevice.screenHeight), camera: camera)
        
        mapView.isMyLocationEnabled = true
        mapView.isUserInteractionEnabled = false
        self.locManager.delegate = self
        self.locManager.startUpdatingLocation()
        
        self.header.addSubview(mapView)
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: currentLocation?.coordinate.latitude ?? 0.0, longitude: currentLocation?.coordinate.longitude ?? 0.0)
        
        marker.title = marker.title
        marker.snippet = "Australia"
        marker.map = mapView
    }
    
    private func reloadHotelList() {
        self.collectionView.reloadData()
    }
    
    private func searchHotels(forText: String) {
        self.fetchRequestType = .Searching
        printDebug("searching text is \(forText)")
        self.predicateStr = forText
        self.loadSaveData()
        self.reloadHotelList()
    }
    
    private func registerXib() {
        self.collectionView.register(UINib(nibName: "SectionHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader")
        self.collectionView.register(UINib(nibName: "SectionFooter", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "SectionFooter")
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
    
    func animateHeaderToListView() {
        self.headerContatinerViewHeightConstraint.constant = 100
        self.collectionViewTopConstraint.constant = 100
        UIView.animate(withDuration: 0.5, animations: {
            self.searchBar.frame = self.searchIntitialFrame
            self.titleLabel.transform = .identity
            self.descriptionLabel.transform = .identity
            self.view.layoutIfNeeded()
        })
    }
    
    func animateHeaderToMapView() {
        self.headerContatinerViewHeightConstraint.constant = 50
        self.collectionViewTopConstraint.constant = 50
        UIView.animate(withDuration: 0.5) {
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
            
            let distancePredicate = NSPredicate(format: "distance <= \(self.filterApplied.distanceRange)")
            let minimumPricePredicate = NSPredicate(format: "price >= \(HotelFilterVM.shared.minimumPrice)")
//            let maximumPricePredicate = NSPredicate(format: "price <= \(HotelFilterVM.shared.maximumPrice)")
//
            let starPredicate = NSPredicate(format: "star IN %@", HotelFilterVM.shared.ratingCount)
            let tripAdvisorPredicate = NSPredicate(format: "rating IN %@", HotelFilterVM.shared.tripAdvisorRatingCount)
            
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
    
    // MARK: - Public
    
    // MARK: - Action
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        AppFlowManager.default.popViewController(animated: true)
    }
    
    @IBAction func filterButtonAction(_ sender: UIButton) {
        AppFlowManager.default.showFilterVC(self)
    }
    
    @IBAction func mapButtonAction(_ sender: Any) {
        if self.hoteResultViewType == .ListView {
            self.animateHeaderToMapView()
            self.hoteResultViewType = .MapView
        } else {
            self.animateHeaderToListView()
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
}

// MARK: - Collection view datasource and delegate methods

// MARK: -

extension HotelResultVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return (self.fetchedResultsController.sections?.count ?? 0) - self.hideSection
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HotelCardCollectionViewCell", for: indexPath) as? HotelCardCollectionViewCell else {
            fatalError("HotelCardCollectionViewCell not found")
        }
        
        let hData = fetchedResultsController.object(at: indexPath)
        self.isAboveTwentyKm = hData.isHotelBeyondTwentyKm
        self.isFotterVisible = self.isAboveTwentyKm
        cell.hotelListData = hData
        cell.indexPath = indexPath
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIDevice.screenWidth - 16, height: 200.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIDevice.screenWidth, height: 53.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if (self.fetchedResultsController.sections?.count ?? 0) - self.footeSection == section, self.filterApplied.distanceRange > 0 {
            return CGSize(width: UIDevice.screenWidth, height: 106.0)
        } else {
            return CGSize(width: UIDevice.screenWidth, height: 0.0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let sections = fetchedResultsController.sections else {
            fatalError("section not found")
        }
        
        if kind == "UICollectionElementKindSectionHeader" {
            if let sectionHeader = self.collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as? SectionHeader {
                sectionHeader.backgroundColor = .clear
                
                var removeFirstChar = sections[indexPath.section].name
                _ = removeFirstChar.removeFirst()
                sectionHeader.sectionHeaderLabel.text = removeFirstChar + " kms"
                return sectionHeader
            }
        } else if kind == "UICollectionElementKindSectionFooter" {
            if let sectionFooter = self.collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionFooter", for: indexPath) as? SectionFooter {
                sectionFooter.delegate = self
                if self.isAboveTwentyKm, self.filterApplied.distanceRange > 0 {
                    sectionFooter.showHotelBeyondButton.setTitle(LocalizedString.HideHotelBeyond.localized, for: .normal)
                    sectionFooter.firstView.isHidden = true
                    sectionFooter.secondView.isHidden = true
                } else {
                    sectionFooter.showHotelBeyondButton.setTitle(LocalizedString.ShowHotelsBeyond.localized, for: .normal)
                    sectionFooter.firstView.isHidden = false
                    sectionFooter.secondView.isHidden = false
                }
                sectionFooter.backgroundColor = .white
                return sectionFooter
            }
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let hData = fetchedResultsController.object(at: indexPath)
        AppFlowManager.default.presentHotelDetailsVC(hotelInfo: hData, sid: self.viewModel.sid, hotelSearchRequest: self.viewModel.hotelSearchRequest)
    }
}

// MARK: - MXParallaxHeaderDelegate methods

extension HotelResultVC: MXParallaxHeaderDelegate {
    func parallaxHeaderDidScroll(_ parallaxHeader: MXParallaxHeader) {
        printDebug("progress \(parallaxHeader.progress)")
        if parallaxHeader.progress < 0.9 {
            self.headerContainerViewTopConstraint.constant = -140
            self.collectionViewTopConstraint.constant = 0
            
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
        } else {
            self.headerContainerViewTopConstraint.constant = 0
            self.collectionViewTopConstraint.constant = 100
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
        }
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
        self.setupMapView()
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
        if let cell = collectionView.cellForItem(at: indexPath) as? HotelCardCollectionViewCell {
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
            self.reloadHotelList()
            self.loadSaveData()
            self.getFavouriteHotels()
            self.floatingView.isHidden = self.favouriteHotels.count < 0
            self.getPinnedHotelTemplate()
            self.time += 1
            self.timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(self.setProgress), userInfo: nil, repeats: true)
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
