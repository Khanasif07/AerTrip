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
    private var isDataLoaded: Bool = false
    private var completion: (() -> Void)? = nil

    private var initialPanPoint: CGPoint = .zero
    private weak var imagesCollectionView: UICollectionView?
    private var expandHeight: CGFloat = 0.0
    private var currentIndexPath: IndexPath?
    
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
            self.headerView.roundTopCornersByClipsToBounds(cornerRadius: 10.0)
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
    
    private var sourceFrame: CGRect = .zero
    private var tableFrameHidden: CGRect {
        return CGRect(x: 40.0, y: self.sourceFrame.origin.y, width: (UIDevice.screenWidth - 80.0), height: self.sourceFrame.size.height)
    }
    private weak var parentVC: UIViewController?
    private weak var sourceView: UIView?
    private let hotelImageHeight: CGFloat = 211.0
    
    private var initialStickyPosition: CGFloat = -1.0
    private var oldScrollPosition: CGPoint = .zero
    
    //Mark:- LifeCycle
    //================
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func initialSetup() {
        self.headerView.shouldAddBlurEffect = true
        self.viewModel.getHotelDistanceAndTimeInfo()
        self.configUI()
        self.registerNibs()
        self.completion = { [weak self] in
            self?.hotelTableView.reloadData()
            self?.viewModel.getHotelInfoApi()
        }
        
        
        let stickyView = getStickyFooter()
        stickyView.frame = self.footerView.bounds
        self.footerView.addSubview(stickyView)
        
        
        let footerView = getStickyFooter()
        footerView.frame = self.footerView.bounds
        self.hotelTableView.tableFooterView = footerView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delay(seconds: 0.2) {
            self.viewModel.getHotelInfoApi()
        }
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    override func setupColors() {
        self.footerView.addGredient(isVertical: false, cornerRadius: 0.0, colors: [AppColors.themeGreen, AppColors.shadowBlue])
        let whiteColor = AppColors.themeWhite
        self.footerView.backgroundColor = AppColors.themeGreen
    }
    
    private func getStickyFooter() -> HotelFilterResultFooterView {
        let stV = HotelFilterResultFooterView(reuseIdentifier: "temp")
        stV.hotelFeesLabel.text = LocalizedString.rupeesText.localized + "\(self.viewModel.hotelInfo?.price ?? 0.0)"
        
        return stV
    }
    
    func show(onViewController: UIViewController, sourceView: UIView, animated: Bool) {
        self.parentVC = onViewController
        self.sourceView = sourceView
        onViewController.add(childViewController: self)
        self.setupBeforeAnimation()
        let newImageFrame = CGRect(x: 0.0, y: UIApplication.shared.statusBarFrame.height, width: self.view.width, height: hotelImageHeight)
        let newTableFrame = CGRect(x: 0.0, y: UIApplication.shared.statusBarFrame.height, width: UIDevice.screenWidth, height: UIDevice.screenHeight)
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
    private func setupBeforeAnimation() {
        guard let sourceV = self.sourceView, let parant = self.parentVC else {return}

        //setup image view
        self.imageView.setImageWithUrl(self.viewModel.hotelInfo?.thumbnail?.first ?? "", placeholder: AppPlaceholderImage.hotelCard, showIndicator: true)
        self.imageView.isHidden = false
        self.imageView.roundTopCornersByClipsToBounds(cornerRadius: 10.0)
        
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
        self.hotelTableView.roundTopCornersByClipsToBounds(cornerRadius: 10.0)
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
        self.hotelTableView.register(SearchBarHeaderView.self, forHeaderFooterViewReuseIdentifier: "SearchBarHeaderView")
        self.hotelTableView.registerCell(nibName: HotelDetailsBedsTableViewCell.reusableIdentifier)
        self.hotelTableView.registerCell(nibName: HotelDetailsInclusionTableViewCell.reusableIdentifier)
        self.hotelTableView.registerCell(nibName: HotelDetailsCancelPolicyTableCell.reusableIdentifier)
        self.hotelTableView.registerCell(nibName: NotesTableCell.reusableIdentifier)
        self.hotelTableView.registerCell(nibName: HotelDetailsCheckOutTableViewCell.reusableIdentifier)
        self.hotelTableView.registerCell(nibName: HotelDetailsEmptyStateTableCell.reusableIdentifier)
    }
    
    private func redirectToMap() {
        let buttons = AppGlobals.shared.getPKAlertButtons(forTitles: [LocalizedString.Maps.localized,LocalizedString.GMap.localized], colors: [AppColors.themeGreen,AppColors.themeGreen])
        let titleFont = [NSAttributedString.Key.font: AppFonts.Regular.withSize(16.0), NSAttributedString.Key.foregroundColor: AppColors.themeGray40]
        let titleAttrString = NSMutableAttributedString(string: LocalizedString.Choose_App.localized, attributes: titleFont)
        
        _ = PKAlertController.default.presentActionSheetWithAttributed(nil, message: titleAttrString, sourceView: view, alertButtons: buttons, cancelButton: AppGlobals.shared.pKAlertCancelButton) { _, index in
            
            if index == 0 {
                if let reqParams = self.viewModel.hotelSearchRequest?.requestParameters,let destParams = self.viewModel.hotelData {
                    self.openAppleMap(originLat: reqParams.latitude, originLong: reqParams.longitude, destLat: destParams.lat, destLong: destParams.long)
                }
            } else {
                self.openGoogleMaps(lat: self.viewModel.hotelData?.lat ?? "", long: self.viewModel.hotelData?.long ?? "")
            }
        }
    }
    
    private func openGoogleMaps(lat: String,long:String) {
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            if let url = URL(string:
                "comgooglemaps://?center=\(lat),\(long)&zoom=14&views=traffic"), !url.absoluteString.isEmpty {
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
    
    private func heightForRow(tableView: UITableView, indexPath: IndexPath) -> CGFloat {
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
        } else if let index = self.currentIndexPath, index == indexPath, expandHeight > 0.0  {
            return self.expandHeight
        }
        return UITableView.automaticDimension
    }
    
    private func heightForHeaderView(tableView: UITableView, section: Int) -> CGFloat {
        switch section {
        case 1:
            return 114.0
        default:
            return 0.0//CGFloat.leastNonzeroMagnitude
        }
    }
    
    private func heightForFooterView(tableView: UITableView, section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0.0
        default:
            return 16.0
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

//Mark:- UITableView Delegate And Datasource
//==========================================
extension HotelDetailsVC: UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let rates = self.viewModel.hotelData?.rates {
            return rates.count + 1 + 1
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let rates = self.viewModel.hotelData?.rates {
            switch section {
            case 0:
                return 6
            case 1:
                return 0
            default:
                self.viewModel.roomRates.append(rates[section - 2].roomData)
                return rates[section - 2].tableViewRowCell.count
            }
        }
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let hotelDetails = self.viewModel.hotelData, let ratesData = hotelDetails.rates {
            if indexPath.section == 0 {
                switch indexPath.row {
                case 0:
                    let cell = self.getImageSlideCell(indexPath: indexPath, hotelDetails: hotelDetails)
                    return cell
                case 1:
                    let cell = self.getHotelRatingInfoCell(indexPath: indexPath, hotelDetails: hotelDetails)
                    return cell
                case 2:
                    let cell = self.getHotelInfoAddressCell(indexPath: indexPath, hotelDetails: hotelDetails)
                    return cell
                case 3:
                    let cell = self.getHotelOverViewCell(indexPath: indexPath, hotelDetails: hotelDetails)
                    return cell
                case 4:
                    let cell = self.getHotelDetailsAmenitiesCell(indexPath: indexPath, hotelDetails: hotelDetails)
                    return cell
                case 5:
                    let cell = self.getTripAdviserCell(indexPath: indexPath, hotelDetails: hotelDetails)
                    return cell
                default:
                    return UITableViewCell()
                }
            } else if (indexPath.section != 1) {
                let currentRatesData = ratesData[indexPath.section - 2]
                switch currentRatesData.tableViewRowCell[indexPath.row] {
                case .roomBedsType:
                    if let cell = self.getBedDeailsCell(indexPath: indexPath, ratesData: currentRatesData, roomData: currentRatesData.roomData) {
                        return cell
                    }
                case .inclusion:
                    if let cell = self.getInclusionCell(indexPath: indexPath, ratesData: currentRatesData) {
                        return cell
                    }
                case .otherInclusion:
                    if let cell = self.otherInclusionCell(indexPath: indexPath, ratesData: currentRatesData) {
                        return cell
                    }
                case .cancellationPolicy:
                    if let cell = self.getCancellationCell(indexPath: indexPath, ratesData: currentRatesData) {
                        return cell
                    }
                case .paymentPolicy:
                    if let cell = self.getPaymentInfoCell(indexPath: indexPath, ratesData: currentRatesData) {
                        return cell
                    }
                case .notes:
                    if let cell = self.getNotesCell(indexPath: indexPath, ratesData: currentRatesData) {
                        return cell
                    }
                case .checkOut:
                    if let cell = self.getCheckOutCell(indexPath: indexPath, ratesData: currentRatesData) {
                        return cell
                    }
                }
            }
        } else {
            guard let hotelInfo = self.viewModel.hotelInfo else { return UITableViewCell() }
            switch indexPath.row {
            case 0:
                let cell = self.getImageSlideCellWithInfo(indexPath: indexPath, hotelInfo: hotelInfo)
                return cell
            case 1:
                let cell = self.getHotelRatingCellWithInfo(indexPath: indexPath, hotelInfo: hotelInfo)
                return cell
            case 2:
                let cell = self.getLoaderCell(indexPath: indexPath)
                return cell
            default: return UITableViewCell()
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView.cellForRow(at: indexPath) as? HotelInfoAddressCell) != nil {
            if indexPath.row == 2 {
                self.redirectToMap()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 1:
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SearchBarHeaderView") as? SearchBarHeaderView  else { return UITableViewHeaderFooterView() }
            return headerView
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.heightForRow(tableView: tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.heightForRow(tableView: tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return self.heightForHeaderView(tableView: tableView, section: section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.heightForHeaderView(tableView: tableView, section: section)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return self.heightForFooterView(tableView: tableView, section: section)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return self.heightForFooterView(tableView: tableView, section: section)
    }
}

extension HotelDetailsVC: HotelDetailDelegate {

    func getHotelDetailsSuccess() {
        self.isDataLoaded = true
        let index = IndexPath(row: 2, section: 0)
        if let cell = self.hotelTableView.cellForRow(at: index) as? HotelDetailsLoaderTableViewCell {
            cell.activityIndicator.stopAnimating()
        }
        self.hotelTableView.reloadData()
    }
    
    func getHotelDetailsFail() {
        let index = IndexPath(row: 2, section: 0)
        if let cell = self.hotelTableView.cellForRow(at: index) as? HotelDetailsLoaderTableViewCell {
            cell.activityIndicator.stopAnimating()
            delay(seconds: AppConstants.kAnimationDuration) {
                cell.activityIndicator.isHidden = true
            }
        }
        AppToast.default.showToastMessage(message: LocalizedString.InformationUnavailable.localized, onViewController: self, buttonTitle: LocalizedString.ReloadResults.localized, buttonImage: nil, buttonAction: self.completion)
        printDebug("API Parsing Failed")
    }
    
    func updateFavouriteSuccess(withMessage: String) {
        self.hotelTableView.reloadData()
        self.sendDataChangedNotification(data: self)
        let buttonImage: UIImage = self.viewModel.hotelInfo?.fav == "1" ? #imageLiteral(resourceName: "saveHotelsSelected") : #imageLiteral(resourceName: "saveHotels")
        self.headerView.leftButton.setImage(buttonImage, for: .normal)
    }
    
    func updateFavouriteFail() {
        AppNetworking.hideLoader()
        let buttonImage: UIImage = self.viewModel.hotelInfo?.fav == "1" ? #imageLiteral(resourceName: "saveHotelsSelected") : #imageLiteral(resourceName: "saveHotels")
        self.headerView.leftButton.setImage(buttonImage, for: .normal)
    }
    
    func getHotelDistanceAndTimeSuccess() {
        if let placeModel = self.viewModel.placeModel {
            if !(placeModel.durationValue/60 < 10) {
                self.viewModel.mode = .driving
                self.viewModel.getHotelDistanceAndTimeInfo()
            }
        }
        self.hotelTableView.reloadData()
    }
    
    func getHotelDistanceAndTimeFail() {
        printDebug("time and distance not found")
    }
}

extension HotelDetailsVC {
    private func manageHeaderView(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        
        if (hotelImageHeight - headerView.height) < yOffset {
            //show
            self.headerView.navTitleLabel.text = self.viewModel.hotelInfo?.hotelName
            self.headerView.animateBackView(isHidden: false, completion: nil)
            let selectedFevImage: UIImage = self.viewModel.hotelInfo?.fav == "1" ? #imageLiteral(resourceName: "saveHotelsSelected") : #imageLiteral(resourceName: "save_icon_green")
            self.headerView.leftButton.setImage(selectedFevImage, for: .normal)
            self.headerView.firstRightButton.setImage(#imageLiteral(resourceName: "black_cross"), for: .normal)
        }
        else {
            //hide
            self.headerView.navTitleLabel.text = ""
            self.headerView.animateBackView(isHidden: true, completion: nil)
            let buttonImage: UIImage = self.viewModel.hotelInfo?.fav == "1" ? #imageLiteral(resourceName: "saveHotelsSelected") : #imageLiteral(resourceName: "saveHotels")
            self.headerView.leftButton.setImage(buttonImage, for: .normal)
            self.headerView.firstRightButton.setImage(#imageLiteral(resourceName: "CancelButtonWhite"), for: .normal)
        }
    }
    
    func manageBottomRateView(_ scrollView: UIScrollView) {
        if hotelTableView.numberOfSections > 2 {
            let rows = hotelTableView.numberOfRows(inSection: 2)
            let indexPath = IndexPath(row: rows-1, section: 2)
            
            var finalY: CGFloat = 0.0
            if let cell = hotelTableView.cellForRow(at: indexPath) as? HotelDetailsCheckOutTableViewCell {
                
                finalY = self.view.convert(cell.contentView.frame, to: hotelTableView).origin.y + UIApplication.shared.statusBarFrame.height + 10.0
                if self.initialStickyPosition <= 0.0 {
                    self.initialStickyPosition = finalY
                }
                
                let bottomCons = (scrollView.contentOffset.y - self.initialStickyPosition)
                if 0...self.footerView.height ~= bottomCons {
                    self.stickyBottomConstraint.constant = -bottomCons
                }
                else if self.initialStickyPosition <= 0.0 {
                    self.stickyBottomConstraint.constant = 0.0
                }
                else if (self.initialStickyPosition + self.footerView.height) < finalY {
                    self.stickyBottomConstraint.constant = -(self.footerView.height)
                }
            }
            else {
                if (self.initialStickyPosition + self.footerView.height) > scrollView.contentOffset.y {
                    self.stickyBottomConstraint.constant = 0.0
                }
                self.initialStickyPosition = -1.0
            }
        }
        else {
            self.stickyBottomConstraint.constant = 0.0
        }
        self.oldScrollPosition = scrollView.contentOffset
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.manageHeaderView(scrollView)
        self.manageBottomRateView(scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate {
            self.manageBottomRateView(scrollView)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.manageHeaderView(scrollView)
        self.manageBottomRateView(scrollView)
    }
}

extension HotelDetailsVC: HotelDetailsImgSlideCellDelegate {
    func hotelImageTapAction(at index: Int) {
        // open gallery with show image at index
        if let topVC = UIApplication.topViewController() {
            ATGalleryViewController.show(onViewController: topVC, sourceView: self.imageView, startShowingFrom: index, datasource: self, delegate: self)
        }
    }
    
    func willShowImage(at index: Int, image: UIImage?) {
        self.imageView.image = image
    }
}


extension HotelDetailsVC: ATGalleryViewDelegate, ATGalleryViewDatasource {
    
    func numberOfImages(in galleryView: ATGalleryViewController) -> Int {
        return self.viewModel.hotelData?.photos.count ?? 0
    }
    
    func galleryView(galleryView: ATGalleryViewController, galleryImageAt index: Int) -> ATGalleryImage {
        var image = ATGalleryImage()
        
        image.imagePath = self.viewModel.hotelData?.photos[index]
        
        return image
    }
    
    func galleryView(galleryView: ATGalleryViewController, willShow image: ATGalleryImage, for index: Int) {
        self.imagesCollectionView?.scrollToItem(at: IndexPath(item: index, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: false)
    }
}

extension HotelDetailsVC: GetFullInfoDelegate {
    func expandCell(expandHeight: CGFloat, indexPath: IndexPath) {
        self.expandHeight = expandHeight
        self.currentIndexPath = indexPath
        self.hotelTableView.reloadRow(at: indexPath, with: .fade)
    }
}
