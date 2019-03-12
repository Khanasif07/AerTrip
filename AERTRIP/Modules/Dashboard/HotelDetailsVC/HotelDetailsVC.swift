//
//  HotelFilterResultsVC.swift
//  AERTRIP
//
//  Created by Admin on 08/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HotelDetailsVC: BaseVC {
    
    //Mark:- Variables
    //================
    private(set) var viewModel = HotelDetailsVM()
    internal var completion: (() -> Void)? = nil
    internal weak var imagesCollectionView: UICollectionView?
    internal var expandHeight: CGFloat = 0.0
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
    var stickyView: HotelFilterResultFooterView?
    var tableFooterView: HotelFilterResultFooterView?
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var hotelTableView: UITableView! {
        didSet {
            self.hotelTableView.delegate = self
            self.hotelTableView.dataSource = self
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
    
    //Mark:- LifeCycle
    //================
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.statusBarColor = AppColors.themeWhite
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.statusBarColor = AppColors.clear
    }
    
    override func initialSetup() {
        self.headerView.shouldAddBlurEffect = true
        self.viewModel.getHotelDistanceAndTimeInfo()
        self.configUI()
        self.registerNibs()
        self.footerViewSetUp()
        self.getSavedFilter()
        if self.viewModel.permanentTagsForFilteration.isEmpty {
            self.viewModel.currentlyFilterApplying = .roomMealTags
            self.viewModel.roomMealData = ["Breakfast"]
            self.viewModel.roomCancellationData = ["Refundable"]
            self.viewModel.permanentTagsForFilteration = ["Breakfast","Refundable"]
            self.viewModel.selectedTags = ["Breakfast"]
        }

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
        self.footerView.addGredient(isVertical: false, cornerRadius: 0.0, colors: [AppColors.themeGreen, AppColors.shadowBlue])
        self.footerView.backgroundColor = AppColors.themeGreen
    }
    
    private func getStickyFooter() -> HotelFilterResultFooterView {
        let stV = HotelFilterResultFooterView(reuseIdentifier: "temp")
        stV.containerView.addGredient(isVertical: false, cornerRadius: 0.0, colors: [AppColors.themeGreen, AppColors.shadowBlue])
        stV.containerView.backgroundColor = AppColors.themeGreen
        stV.hotelFeesLabel.text = LocalizedString.rupeesText.localized + "\(self.viewModel.hotelInfo?.price.delimiter ?? "0.0")"
        stV.noRoomsAvailable.isHidden = true
        return stV
    }
    
    internal func updateStickyFooterView() {
        if self.viewModel.ratesData.isEmpty {
            if let stickyView = self.stickyView {
                stickyView.containerView.addGredient(isVertical: false, cornerRadius: 0.0, colors: [AppColors.noRoomsAvailableFooterColor, AppColors.noRoomsAvailableFooterShadow])
                stickyView.containerView.backgroundColor = AppColors.noRoomsAvailableFooterColor
                stickyView.noRoomsAvailable.isHidden = false
                stickyView.fromLabel.isHidden = true
                stickyView.hotelFeesLabel.isHidden = true
                stickyView.selectRoomLabel.isHidden = true
                self.footerView.addGredient(isVertical: false, cornerRadius: 0.0, colors: [AppColors.noRoomsAvailableFooterColor, AppColors.noRoomsAvailableFooterShadow])
                self.footerView.backgroundColor = AppColors.noRoomsAvailableFooterColor
            }
            
            if let tableFooterView = self.tableFooterView {
                tableFooterView.containerView.addGredient(isVertical: false, cornerRadius: 0.0, colors: [AppColors.noRoomsAvailableFooterColor, AppColors.noRoomsAvailableFooterShadow])
                tableFooterView.containerView.backgroundColor = AppColors.noRoomsAvailableFooterColor
                tableFooterView.noRoomsAvailable.isHidden = false
                tableFooterView.fromLabel.isHidden = true
                tableFooterView.hotelFeesLabel.isHidden = true
                tableFooterView.selectRoomLabel.isHidden = true
                self.footerView.addGredient(isVertical: false, cornerRadius: 0.0, colors: [AppColors.noRoomsAvailableFooterColor, AppColors.noRoomsAvailableFooterShadow])
                self.footerView.backgroundColor = AppColors.noRoomsAvailableFooterColor
            }
        } else {
            if let stickyView = self.stickyView {
                stickyView.containerView.addGredient(isVertical: false, cornerRadius: 0.0, colors: [AppColors.themeGreen, AppColors.shadowBlue])
                stickyView.containerView.backgroundColor = AppColors.themeGreen
                stickyView.noRoomsAvailable.isHidden = true
                stickyView.fromLabel.isHidden = false
                stickyView.hotelFeesLabel.isHidden = false
                stickyView.selectRoomLabel.isHidden = false
                self.footerView.addGredient(isVertical: false, cornerRadius: 0.0, colors: [AppColors.themeGreen, AppColors.shadowBlue])
                self.footerView.backgroundColor = AppColors.themeGreen
            }
            
            if let tableFooterView = self.tableFooterView {
                tableFooterView.containerView.addGredient(isVertical: false, cornerRadius: 0.0, colors: [AppColors.themeGreen, AppColors.shadowBlue])
                tableFooterView.containerView.backgroundColor = AppColors.themeGreen
                tableFooterView.noRoomsAvailable.isHidden = true
                tableFooterView.fromLabel.isHidden = false
                tableFooterView.hotelFeesLabel.isHidden = false
                tableFooterView.selectRoomLabel.isHidden = false
                self.footerView.addGredient(isVertical: false, cornerRadius: 0.0, colors: [AppColors.themeGreen, AppColors.shadowBlue])
                self.footerView.backgroundColor = AppColors.themeGreen
            }
        }
    }
    
    func show(onViewController: UIViewController, sourceView: UIView, animated: Bool) {
        self.parentVC = onViewController
        self.sourceView = sourceView
        onViewController.add(childViewController: self)
        self.setupBeforeAnimation()
        let newImageFrame = CGRect(x: 0.0, y: UIDevice.isIPhoneX ? UIApplication.shared.statusBarFrame.height : 0.0, width: self.view.width, height: hotelImageHeight)
        let newTableFrame = CGRect(x: 0.0, y: UIDevice.isIPhoneX ? UIApplication.shared.statusBarFrame.height : 0.0, width: UIDevice.screenWidth, height: UIDevice.screenHeight)
        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, animations: { [weak self] in
            guard let sSelf = self else {return}
            sSelf.imageView.frame = newImageFrame
            sSelf.hotelTableView.frame = newTableFrame
            sSelf.hotelTableView.alpha = 1.0
            //            sSelf.hotelTableView.transform = CGAffineTransform.identity
            }, completion: { [weak self](isDone) in
                guard let sSelf = self else {return}
                sSelf.imageView.isHidden = true
        })
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
                sSelf.removeFromParentVC
        })
    }
    
    //Mark:- Methods
    //==============
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
        self.view.backgroundColor = .clear
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
        self.hotelTableView.registerCell(nibName: HotelDetailsSearchTagTableCell.reusableIdentifier)
        self.hotelTableView.registerCell(nibName: HotelDetailsBedsTableViewCell.reusableIdentifier)
        self.hotelTableView.registerCell(nibName: HotelDetailsInclusionTableViewCell.reusableIdentifier)
        self.hotelTableView.registerCell(nibName: HotelDetailsCancelPolicyTableCell.reusableIdentifier)
        self.hotelTableView.registerCell(nibName: HotelDetailsCheckOutTableViewCell.reusableIdentifier)
        self.hotelTableView.registerCell(nibName: HotelDetailsEmptyStateTableCell.reusableIdentifier)
    }
    
    private func openGoogleMaps(originLat: String ,originLong:String ,destLat: String ,destLong:String) {
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            if let url = URL(string:
                "comgooglemaps://?saddr=\(originLat),\(originLong)&daddr=\(destLat),\(destLong)&directionsmode=driving&zoom=14&views=traffic"), !url.absoluteString.isEmpty {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        } else {
            print("Can't use comgooglemaps://")
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
    
    private func getSavedFilter() {
        guard let filter = UserInfo.hotelFilter else {
            printDebug("Filter not found")
            return
        }
        self.viewModel.filterAppliedData = filter
        self.viewModel.roomMealData = filter.roomMeal
        self.viewModel.roomOtherData = filter.roomOther
        self.viewModel.roomCancellationData = filter.roomCancelation
        self.viewModel.permanentTagsForFilteration = filter.roomMeal + filter.roomCancelation + filter.roomOther
        self.viewModel.selectedTags = filter.roomMeal + filter.roomCancelation + filter.roomOther
        self.viewModel.currentlyFilterApplying = .initialTags
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
        if indexPath == IndexPath(row: 2, section: 0) {
            if let hotelData = self.viewModel.hotelData {
                let text = hotelData.address + "Maps   "
                let size = text.sizeCount(withFont: AppFonts.Regular.withSize(18.0), bundingSize: CGSize(width: UIDevice.screenWidth - 32.0, height: 10000.0))
                return size.height + 46.5
                    + 14.0//y of textview 46.5 + bottom space 14.0
            }
            else {
                return (UIDevice.screenHeight - UIApplication.shared.statusBarFrame.height) - (211.0 + 126.5)
            }
        }
        return UITableView.automaticDimension
    }
    
    internal func heightForHeaderView(tableView: UITableView, section: Int) -> CGFloat {
        return 0.0
    }
    
    internal func heightForFooterView(tableView: UITableView, section: Int) -> CGFloat {
        return 0.0
    }
    
    internal func filterdHotelData(tagList: [String]) {
        self.viewModel.ratesData.removeAll()
        self.viewModel.roomRates.removeAll()
        self.viewModel.tableViewRowCell.removeAll()
        if let rates = self.viewModel.hotelData?.rates {
            //            self.viewModel.currentlyFilterApplying = currentlyFilterApplying
            self.viewModel.ratesData = self.viewModel.getFilteredRatesData(rates: rates, tagList: tagList , roomMealData: self.viewModel.roomMealData, roomOtherData: self.viewModel.roomOtherData, roomCancellationData: self.viewModel.roomCancellationData)
            for singleRate in self.viewModel.ratesData {
                self.viewModel.roomRates.append(singleRate.roomData)
                self.viewModel.tableViewRowCell.append(singleRate.tableViewRowCell)
            }
        }
    }
    
    //Mark:- IBOActions
    //=================
    @IBAction func cancelButtonAction (_ sender: UIButton) {
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
