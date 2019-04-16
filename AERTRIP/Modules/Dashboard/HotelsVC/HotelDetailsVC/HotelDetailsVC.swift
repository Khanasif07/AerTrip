//
//  HotelFilterResultsVC.swift
//  AERTRIP
//
//  Created by Admin on 08/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol HotelDetailsVCDelegate : class {
    func hotelFavouriteUpdated()
}

class HotelDetailsVC: BaseVC {
    
    //Mark:- Variables
    //================
    private(set) var viewModel = HotelDetailsVM()
    internal var completion: (() -> Void)? = nil
    internal weak var imagesCollectionView: UICollectionView?
    internal let hotelImageHeight: CGFloat = 211.0
    private var initialPanPoint: CGPoint = .zero
    private var sourceFrame: CGRect = .zero
    private weak var parentVC: UIViewController?
    private weak var sourceView: UIView?
    private var tableFrameHidden: CGRect {
        return CGRect(x: 40.0, y: self.sourceFrame.origin.y, width: (UIDevice.screenWidth - 80.0), height: self.sourceFrame.size.height)
    }
    internal var allIndexPath = [IndexPath]()
    internal var initialStickyPosition: CGFloat = -1.0
    internal var oldScrollPosition: CGPoint = .zero
    internal var didsmissOnScrollPosition: CGFloat = 200.0
    var stickyView: HotelFilterResultFooterView?
    var tableFooterView: HotelFilterResultFooterView?
    weak var delegate : HotelDetailsVCDelegate?
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var headerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var hotelTableView: UITableView! {
        didSet {
            hotelTableView.delegate = self
            hotelTableView.dataSource = self
        }
    }
    @IBOutlet weak var headerView: TopNavigationView! {
        didSet{
            self.headerView.roundTopCorners(cornerRadius: 10.0)
        }
    }
    @IBOutlet weak var smallLineView: UIView! {
        didSet {
            self.smallLineView.cornerRadius = self.smallLineView.height/2.0
            self.smallLineView.clipsToBounds = true
        }
    }
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var stickyBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainView: UIView!
    
    //Mark:- LifeCycle
    //================
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.statusBarColor = AppColors.themeWhite
        self.statusBarStyle = .default
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.statusBarColor = AppColors.clear
    }
    
    override func initialSetup() {
        self.viewModel.getHotelDistanceAndTimeInfo()
        self.view.backgroundColor = .clear
        self.headerView.shouldAddBlurEffect = true
        self.configUI()
        self.registerNibs()
        self.footerViewSetUp()
        self.getSavedFilter()
        self.permanentTagsForFilteration()
        self.completion = { [weak self] in
            self?.hotelTableView.reloadData()
            self?.viewModel.getHotelInfoApi()
        }
        self.viewModel.getHotelInfoApi()
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    override func setupColors() {
    }
    
    //Mark:- Methods
    //==============
    private func getStickyFooter() -> HotelFilterResultFooterView {
        let stV = HotelFilterResultFooterView(reuseIdentifier: "temp")
        stV.hotelFeesLabel.text = LocalizedString.rupeesText.localized + "\(self.viewModel.hotelInfo?.price.delimiter ?? "0.0")"
        stV.noRoomsAvailable.isHidden = true
        stV.addSelectRoomTarget(target: self, action: #selector(selectRoomAction))
        return stV
    }
    
    @objc func selectRoomAction() {
        self.hotelTableView.scrollToRow(at: IndexPath(row: 0, section: 1), at: .top, animated: true)
    }
    
    internal func updateStickyFooterView() {
        if self.viewModel.ratesData.isEmpty {
            if let stickyView = self.stickyView {
                stickyView.containerView.backgroundColor = AppColors.noRoomsAvailableFooterColor
                stickyView.containerView.addGredient(isVertical: false, cornerRadius: 0.0, colors: [AppColors.noRoomsAvailableFooterShadow, AppColors.noRoomsAvailableFooterColor])
                stickyView.noRoomsAvailable.isHidden = false
                stickyView.fromLabel.isHidden = true
                stickyView.hotelFeesLabel.isHidden = true
                stickyView.selectRoomLabel.isHidden = true
            }
            
            if let tableFooterView = self.tableFooterView {
                tableFooterView.containerView.backgroundColor = AppColors.noRoomsAvailableFooterColor
                tableFooterView.containerView.addGredient(isVertical: false, cornerRadius: 0.0, colors: [AppColors.noRoomsAvailableFooterShadow, AppColors.noRoomsAvailableFooterColor])
                tableFooterView.noRoomsAvailable.isHidden = false
                tableFooterView.fromLabel.isHidden = true
                tableFooterView.hotelFeesLabel.isHidden = true
                tableFooterView.selectRoomLabel.isHidden = true
            }
            self.hotelTableView.tableFooterView?.isHidden = true
        } else {
            self.hotelTableView.tableFooterView?.isHidden = false
            if let stickyView = self.stickyView {
                stickyView.containerView.backgroundColor = AppColors.themeGreen
                stickyView.containerView.addGredient(isVertical: false, cornerRadius: 0.0, colors: [AppColors.themeGreen, AppColors.shadowBlue])
                stickyView.noRoomsAvailable.isHidden = true
                stickyView.fromLabel.isHidden = false
                stickyView.hotelFeesLabel.isHidden = false
                stickyView.selectRoomLabel.isHidden = false
            }
            
            if let tableFooterView = self.tableFooterView {
                tableFooterView.containerView.backgroundColor = AppColors.themeGreen
                tableFooterView.containerView.addGredient(isVertical: false, cornerRadius: 0.0, colors: [AppColors.themeGreen, AppColors.shadowBlue])
                tableFooterView.noRoomsAvailable.isHidden = true
                tableFooterView.fromLabel.isHidden = false
                tableFooterView.hotelFeesLabel.isHidden = false
                tableFooterView.selectRoomLabel.isHidden = false
            }
        }
    }
    
    func show(onViewController: UIViewController, sourceView: UIView, animated: Bool) {
        self.parentVC = onViewController
        self.sourceView = sourceView
        onViewController.add(childViewController: self)
        self.setupBeforeAnimation()
        let newY = UIApplication.shared.statusBarFrame.height + 8.0
        self.headerTopConstraint.constant = 8.0
        let newImageFrame = CGRect(x: 0.0, y: newY, width: self.view.width, height: hotelImageHeight)
        let newTableFrame = CGRect(x: 0.0, y: newY, width: self.view.width, height: (self.view.height-(newY+AppFlowManager.default.safeAreaInsets.bottom)))
        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, animations: { [weak self] in
            guard let sSelf = self else {return}
            sSelf.imageView.frame = newImageFrame
            sSelf.hotelTableView.frame = newTableFrame
            sSelf.hotelTableView.alpha = 1.0
            }, completion: { [weak self](isDone) in
                guard let sSelf = self else {return}
                sSelf.imageView.isHidden = true
        })
    }
    
    func hideOnScroll() {
        self.imageView.frame = CGRect(x: 0.0, y: didsmissOnScrollPosition, width: self.imageView.frame.size.width, height: self.imageView.frame.size.height)
        self.hide(animated: true)
    }
    
    func hide(animated: Bool) {
        self.imageView.isHidden = false
        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, animations: { [weak self] in
            guard let sSelf = self else {return}
            sSelf.imageView.frame = sSelf.sourceFrame
            sSelf.hotelTableView.alpha = 0.0
            sSelf.hotelTableView.frame = sSelf.tableFrameHidden
            }, completion: { [weak self](isDone) in
                guard let sSelf = self else {return}
                sSelf.mainView.alpha = 0
                sSelf.removeFromParentVC
                sSelf.headerView.isHidden = false
        })
    }
    
    private func footerViewSetUp() {
        self.stickyView = getStickyFooter()
        if let stickyView = self.stickyView {
            stickyView.frame = self.footerView.bounds
            self.footerView.addSubview(stickyView)
        }
        
        self.tableFooterView = getStickyFooter()
        if let footerView = self.tableFooterView {
            footerView.frame = self.footerView.bounds
            self.hotelTableView.tableFooterView = footerView
        }
    }
    
    private func setupBeforeAnimation() {
        guard let sourceV = self.sourceView, let parant = self.parentVC else {return}
        
        //setup image view
        self.imageView.setImageWithUrl(self.viewModel.hotelInfo?.thumbnail?.first ?? "", placeholder: AppPlaceholderImage.hotelCard, showIndicator: true)
        self.imageView.isHidden = false
        self.imageView.roundTopCorners(cornerRadius: 10.0)
        
        //manage frame
        self.imageView.translatesAutoresizingMaskIntoConstraints = true
        self.sourceFrame = parant.view.convert(sourceV.frame, from: sourceV.superview)
        self.imageView.frame = self.sourceFrame
        
        //setup table view
        hotelTableView.alpha = 0.0
        hotelTableView.translatesAutoresizingMaskIntoConstraints = true
        hotelTableView.frame = self.tableFrameHidden
    }
    
    private func configUI() {
        self.view.backgroundColor = AppColors.themeWhite
        self.headerView.configureNavBar(title: nil , isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false, isDivider: false)
        let buttonImage: UIImage = self.viewModel.hotelInfo?.fav == "1" ? #imageLiteral(resourceName: "saveHotelsSelected") : #imageLiteral(resourceName: "saveHotels")
        let selectedFevImage: UIImage = self.viewModel.hotelInfo?.fav == "1" ? #imageLiteral(resourceName: "saveHotelsSelected") : #imageLiteral(resourceName: "save_icon_green")
        self.headerView.configureLeftButton(normalImage: buttonImage, selectedImage: selectedFevImage, normalTitle: nil, selectedTitle: nil, normalColor: nil, selectedColor: nil)
        self.headerView.configureFirstRightButton(normalImage: #imageLiteral(resourceName: "CancelButtonWhite"), selectedImage: #imageLiteral(resourceName: "black_cross"), normalTitle: nil, selectedTitle: nil, normalColor: nil, selectedColor: nil)
        self.headerView.firstRightButton.addTarget(self, action: #selector(self.cancelButtonAction), for: .touchUpInside)
        self.headerView.leftButton.addTarget(self, action: #selector(self.fevButtonAction), for: .touchUpInside)
        self.hotelTableView.roundTopCorners(cornerRadius: 10.0)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panGestureRecognizerHandler))
        self.view.addGestureRecognizer(panGesture)
    }
    
    private func registerNibs() {
        self.hotelTableView.registerCell(nibName: HotelDetailsImgSlideCell.reusableIdentifier)
        self.hotelTableView.registerCell(nibName: HotelRatingInfoCell.reusableIdentifier)
        self.hotelTableView.registerCell(nibName: HotelDetailsLoaderTableViewCell.reusableIdentifier)
        self.hotelTableView.registerCell(nibName: HotelInfoAddressCell.reusableIdentifier)
        self.hotelTableView.registerCell(nibName: HotelDetailAmenitiesCell.reusableIdentifier)
        self.hotelTableView.registerCell(nibName: TripAdvisorTableViewCell.reusableIdentifier)
        self.hotelTableView.registerCell(nibName: HotelDetailsBedsTableViewCell.reusableIdentifier)
        self.hotelTableView.registerCell(nibName: HotelDetailsInclusionTableViewCell.reusableIdentifier)
        self.hotelTableView.registerCell(nibName: HotelDetailsCancelPolicyTableCell.reusableIdentifier)
        self.hotelTableView.registerCell(nibName: HotelDetailsSearchTagTableCell.reusableIdentifier)
        self.hotelTableView.registerCell(nibName: HotelDetailsEmptyStateTableCell.reusableIdentifier)
        self.hotelTableView.registerCell(nibName: HotelDetailsCheckOutTableViewCell.reusableIdentifier)
    }
    
    private func openGoogleMaps(originLat: String ,originLong:String ,destLat: String ,destLong:String) {
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            if let url = URL(string:
                "comgooglemaps://?saddr=\(originLat),\(originLong)&daddr=\(destLat),\(destLong)&directionsmode=driving&zoom=14&views=traffic"), !url.absoluteString.isEmpty {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        } else {
            AppToast.default.showToastMessage(message: "Google Maps is not installed on your device.")
        }
    }
    
    private func openAppleMap(originLat: String ,originLong:String ,destLat: String ,destLong:String) {
        
        let directionsURL = "http://maps.apple.com/?saddr=\(originLat),\(originLong)&daddr=\(destLat),\(destLong)"
        if let url = URL(string: directionsURL), !url.absoluteString.isEmpty {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            print("Can't use apple map://")
        }
    }
    
    internal func getSavedFilter() {
        guard let filter = UserInfo.hotelFilter else {
            printDebug("Filter not found")
            HotelFilterVM.shared.resetToDefault()
            return
        }
        self.viewModel.filterAppliedData = filter
        self.viewModel.roomMealDataCopy = filter.roomMeal
        self.viewModel.roomOtherDataCopy = filter.roomOther
        self.viewModel.roomCancellationDataCopy = filter.roomCancelation
        self.viewModel.permanentTagsForFilteration = filter.roomMeal + filter.roomCancelation + filter.roomOther
        self.viewModel.selectedTags = filter.roomMeal + filter.roomCancelation + filter.roomOther
    }
    
    internal func permanentTagsForFilteration() {
        if self.viewModel.permanentTagsForFilteration.isEmpty {
            self.viewModel.filterAppliedData.roomMeal = ["Breakfast"]
            self.viewModel.roomMealDataCopy = self.viewModel.filterAppliedData.roomMeal
            self.viewModel.filterAppliedData.roomCancelation = ["Refundable"]
            self.viewModel.permanentTagsForFilteration = ["Breakfast","Refundable"]
            self.viewModel.selectedTags = ["Breakfast"]
        }
    }
    
    internal func redirectToMap() {
        let buttons = AppGlobals.shared.getPKAlertButtons(forTitles: [LocalizedString.Maps.localized,LocalizedString.GMap.localized], colors: [AppColors.themeGreen,AppColors.themeGreen])
        let titleFont = [NSAttributedString.Key.font: AppFonts.Regular.withSize(14.0), NSAttributedString.Key.foregroundColor: AppColors.themeGray40]
        let titleAttrString = NSMutableAttributedString(string: LocalizedString.Choose_App.localized, attributes: titleFont)
        
        _ = PKAlertController.default.presentActionSheetWithAttributed(nil, message: titleAttrString, sourceView: view, alertButtons: buttons, cancelButton: AppGlobals.shared.pKAlertCancelButton) { _, index in
            
            if index == 0 {
                if let reqParams = self.viewModel.hotelSearchRequest?.requestParameters,let destParams = self.viewModel.hotelData {
                    self.openAppleMap(originLat: reqParams.latitude, originLong: reqParams.longitude, destLat: destParams.lat, destLong: destParams.long)
                }
            } else {
                if let reqParams = self.viewModel.hotelSearchRequest?.requestParameters,let destParams = self.viewModel.hotelData {
                    self.openGoogleMaps(originLat: reqParams.latitude, originLong: reqParams.longitude, destLat: destParams.lat, destLong: destParams.long)
                }
            }
        }
    }
    
    internal func heightForRow(tableView: UITableView, indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0, indexPath.row == 2 {
            if let hotelData = self.viewModel.hotelData {
                let text = hotelData.address + "Maps   "
                let size = text.sizeCount(withFont: AppFonts.Regular.withSize(18.0), bundingSize: CGSize(width: UIDevice.screenWidth - 32.0, height: 10000.0))
                return size.height + 46.5
                    + 21.0//y of textview 46.5 + bottom space 14.0
            }
            else {
                return (UIDevice.screenHeight - UIApplication.shared.statusBarFrame.height) - (211.0 + 126.5)
            }
        }
        else if indexPath.section == 0, indexPath.row == 3 {
            //overview cell
            if let hotelData = self.viewModel.hotelData {
                let text = hotelData.info
                var height = text.sizeCount(withFont: AppFonts.Regular.withSize(18.0), bundingSize: CGSize(width: UIDevice.screenWidth - 32.0, height: 10000.0)).height
                
                let maxH = AppFonts.Regular.withSize(18.0).lineHeight * 3.0
                let minH = AppFonts.Regular.withSize(18.0).lineHeight
                
                height = max(height, minH)
                height = min(height, maxH)
                return height + 46.5
                    + 21.0//y of textview 46.5 + bottom space 14.0
            }
            return UITableView.automaticDimension
        }
        return UITableView.automaticDimension
    }
    
    internal func heightForHeaderView(tableView: UITableView, section: Int) -> CGFloat {
        return 0.0
    }
    
    internal func heightForFooterView(tableView: UITableView, section: Int) -> CGFloat {
        return 0.0
    }
    
    private func getFirstSectionData( hotelData: HotelDetails) -> [TableCellType] {
        var cellsArray: [TableCellType] = []
        cellsArray.append(.imageSlideCell)
        cellsArray.append(.hotelRatingCell)
        cellsArray.append(.addressCell)
        if !hotelData.info.isEmpty {
            cellsArray.append(.overViewCell)
        }
        if ((hotelData.amenities?.main) != nil) {
            cellsArray.append(.amenitiesCell)
        }
        cellsArray.append(.tripAdvisorRatingCell)
        return cellsArray
    }
    
    internal func filterdHotelData(tagList: [String]) {
        self.viewModel.ratesData.removeAll()
        self.viewModel.roomRates.removeAll()
        self.viewModel.hotelDetailsTableSectionData.removeAll()
        
        if let hotelData = self.viewModel.hotelData , let rates = hotelData.rates {
            self.viewModel.hotelDetailsTableSectionData.append(self.getFirstSectionData(hotelData: hotelData))
            self.viewModel.hotelDetailsTableSectionData.append([.searchTagCell])
            self.viewModel.ratesData = self.viewModel.filteredRates(rates: rates , roomMealData: self.viewModel.roomMealDataCopy, roomOtherData: self.viewModel.roomOtherDataCopy, roomCancellationData: self.viewModel.roomCancellationDataCopy)
            if self.viewModel.ratesData.isEmpty {
                self.viewModel.hotelDetailsTableSectionData.append([.ratesEmptyStateCell])
            } else {
                for singleRate in self.viewModel.ratesData {
                    self.viewModel.roomRates.append(singleRate.roomData)
                    self.viewModel.hotelDetailsTableSectionData.append(singleRate.tableViewRowCell)
                }
            }
        }
    }
    
    //Mark:- IBOActions
    //=================
    @IBAction func cancelButtonAction (_ sender: UIButton) {
        self.headerView.isHidden = true
        self.hide(animated: true)
    }
    
    @IBAction func fevButtonAction(_ sender: UIButton) {
        self.viewModel.updateFavourite()
    }
    
    @IBAction func panGestureRecognizerHandler(_ sender: UIPanGestureRecognizer) {
        guard self.imageView.isHidden else {return}
        let touchPoint = sender.location(in: self.view?.window)
        if sender.state == UIGestureRecognizer.State.began {
            self.initialPanPoint = touchPoint
        }
        else  if (initialPanPoint.y + 10) < touchPoint.y {
            self.hide(animated: true)
            initialPanPoint = touchPoint
        }
    }
}
