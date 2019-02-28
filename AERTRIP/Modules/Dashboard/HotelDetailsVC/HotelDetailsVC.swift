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
            self.headerView.roundCornersByClipsToBounds(cornerRadius: 10.0)
        }
    }
    @IBOutlet weak var smallLineView: UIView! {
        didSet {
            self.smallLineView.cornerRadius = self.smallLineView.height/2.0
            self.smallLineView.clipsToBounds = true
        }
    }
    @IBOutlet weak var imageView: UIImageView!
    
    
    private var sourceFrame: CGRect = .zero
    private var tableFrameHidden: CGRect {
        return CGRect(x: 40.0, y: self.sourceFrame.origin.y, width: (UIDevice.screenWidth - 80.0), height: self.sourceFrame.size.height)
    }
    private weak var parentVC: UIViewController?
    private weak var sourceView: UIView?
    private let hotelImageHeight: CGFloat = 211.0
    
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
        self.imageView.roundCornersByClipsToBounds(cornerRadius: 10.0)
        
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
        self.hotelTableView.roundCornersByClipsToBounds(cornerRadius: 10.0)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panGestureRecognizerHandler))
        self.view.addGestureRecognizer(panGesture)
    }
    
    private func registerNibs() {
        let nib = UINib(nibName: "HotelDetailsImgSlideCell", bundle: nil)
        self.hotelTableView.register(nib, forCellReuseIdentifier: "HotelDetailsImgSlideCell")
        let hotelInfoNib = UINib(nibName: "HotelRatingInfoCell", bundle: nil)
        self.hotelTableView.register(hotelInfoNib, forCellReuseIdentifier: "HotelRatingInfoCell")
        let loaderNib = UINib(nibName: "HotelDetailsLoaderTableViewCell", bundle: nil)
        self.hotelTableView.register(loaderNib, forCellReuseIdentifier: "HotelDetailsLoaderTableViewCell")
        let hotelInfoAddressNib = UINib(nibName: "HotelInfoAddressCell", bundle: nil)
        self.hotelTableView.register(hotelInfoAddressNib, forCellReuseIdentifier: "HotelInfoAddressCell")
        self.hotelTableView.register(HotelFilterResultFooterView.self, forHeaderFooterViewReuseIdentifier: "HotelFilterResultFooterView")
        let amenitiesNib = UINib(nibName: "HotelDetailAmenitiesCell", bundle: nil)
        self.hotelTableView.register(amenitiesNib, forCellReuseIdentifier: "HotelDetailAmenitiesCell")
        let tripAdvisorNib = UINib(nibName: "TripAdvisorTableViewCell", bundle: nil)
        self.hotelTableView.register(tripAdvisorNib, forCellReuseIdentifier: "TripAdvisorTableViewCell")
        self.hotelTableView.register(SearchBarHeaderView.self, forHeaderFooterViewReuseIdentifier: "SearchBarHeaderView")
        let hotelBedsNib = UINib(nibName: "HotelDetailsBedsTableViewCell", bundle: nil)
        self.hotelTableView.register(hotelBedsNib, forCellReuseIdentifier: "HotelDetailsBedsTableViewCell")
        let inclusionNib = UINib(nibName: "HotelDetailsInclusionTableViewCell", bundle: nil)
        self.hotelTableView.register(inclusionNib, forCellReuseIdentifier: "HotelDetailsInclusionTableViewCell")
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
            return rates.count + 1
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let rates = self.viewModel.hotelData?.rates {
            switch section {
            case 0:
                return 6
            default:
                return rates[section - 1].getTotalNumberOfRows()
            }
        }
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let hotelDetails = self.viewModel.hotelData, let ratesData = hotelDetails.rates {
            if indexPath.section == 0 {
                switch indexPath.row {
                case 0:
                    
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "HotelDetailsImgSlideCell", for: indexPath) as? HotelDetailsImgSlideCell  else { return UITableViewCell() }
                    if let hotelDetails = self.viewModel.hotelInfo {
                        cell.configCell(hotelData: hotelDetails)
                    }
                    return cell
                    
                case 1:
                    
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "HotelRatingInfoCell", for: indexPath) as? HotelRatingInfoCell  else { return UITableViewCell() }
                    if let hotelDetails = self.viewModel.hotelInfo, let placeData = self.viewModel.placeModel {
                        cell.configureCell(hotelData: hotelDetails, placeData: placeData)
                    } else if let hotelDetails = self.viewModel.hotelInfo {
                        cell.configureCell(hotelData: hotelDetails)
                    }
                    return cell
                    
                case 2:
                    
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "HotelInfoAddressCell", for: indexPath) as? HotelInfoAddressCell  else { return UITableViewCell() }
                    if let hotelDetails = self.viewModel.hotelData {
                        cell.configureAddressCell(hotelData: hotelDetails)
                    }
                    return cell
                    
                case 3:
                    
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "HotelInfoAddressCell", for: indexPath) as? HotelInfoAddressCell  else { return UITableViewCell() }
                    if let hotelDetails = self.viewModel.hotelData {
                        cell.configureOverviewCell(hotelData: hotelDetails)
                    }
                    return cell
                    
                case 4:
                    
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "HotelDetailAmenitiesCell", for: indexPath) as? HotelDetailAmenitiesCell  else { return UITableViewCell() }
                    if let hotelDetails = self.viewModel.hotelData {
                        cell.amenitiesDetails = hotelDetails.amenities
                    }
                    return cell
                    
                case 5:
                    
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "TripAdvisorTableViewCell", for: indexPath) as? TripAdvisorTableViewCell  else { return UITableViewCell() }
                    return cell
                    
                default:
                    return UITableViewCell()
                }
            } else {
                let roomData = ratesData[indexPath.section - 1 ].getRoomData()
                switch indexPath {
                case IndexPath(row: 0, section: indexPath.section)...IndexPath(row: roomData.count, section: indexPath.section):
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "HotelDetailsBedsTableViewCell", for: indexPath) as? HotelDetailsBedsTableViewCell  else { return UITableViewCell() }
                    //cell.configCell(numberOfRooms: Array(roomData.values)[indexPath.row] , roomData: Array(roomData.keys)[indexPath.row])
                    return cell
                default:
                    return UITableViewCell()
                }
            }
        } else {
            switch indexPath.row {
            case 0:
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "HotelDetailsImgSlideCell", for: indexPath) as? HotelDetailsImgSlideCell  else { return UITableViewCell() }
                if let hotelDetails = self.viewModel.hotelInfo {
                    cell.configCell(hotelData: hotelDetails)
                }
                return cell
                
            case 1:
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "HotelRatingInfoCell", for: indexPath) as? HotelRatingInfoCell  else { return UITableViewCell() }
                if let hotelDetails = self.viewModel.hotelInfo, let placeData = self.viewModel.placeModel {
                    cell.configureCell(hotelData: hotelDetails, placeData: placeData)
                } else if let hotelDetails = self.viewModel.hotelInfo {
                    cell.configureCell(hotelData: hotelDetails)
                }
                
                return cell
                
            case 2:
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "HotelDetailsLoaderTableViewCell", for: indexPath) as? HotelDetailsLoaderTableViewCell  else { return UITableViewCell() }
                cell.activityIndicator.startAnimating()
                return cell
                
            default: return UITableViewCell()
            }
        }
        
    /*    if !self.isDataLoaded {
            switch indexPath.row {
            case 0:
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "HotelDetailsImgSlideCell", for: indexPath) as? HotelDetailsImgSlideCell  else { return UITableViewCell() }
                if let hotelDetails = self.viewModel.hotelInfo {
                    cell.configCell(hotelData: hotelDetails)
                }
                return cell
                
            case 1:
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "HotelRatingInfoCell", for: indexPath) as? HotelRatingInfoCell  else { return UITableViewCell() }
                if let hotelDetails = self.viewModel.hotelInfo, let placeData = self.viewModel.placeModel {
                    cell.configureCell(hotelData: hotelDetails, placeData: placeData)
                } else if let hotelDetails = self.viewModel.hotelInfo {
                    cell.configureCell(hotelData: hotelDetails)
                }

                return cell
                
            case 2:
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "HotelDetailsLoaderTableViewCell", for: indexPath) as? HotelDetailsLoaderTableViewCell  else { return UITableViewCell() }
                    cell.activityIndicator.startAnimating()
                return cell
                
            default: return UITableViewCell()
                
            }
        } else {
            if indexPath.section == 0 {
                switch indexPath.row {
                case 0:
                    
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "HotelDetailsImgSlideCell", for: indexPath) as? HotelDetailsImgSlideCell  else { return UITableViewCell() }
                    if let hotelDetails = self.viewModel.hotelInfo {
                        cell.configCell(hotelData: hotelDetails)
                    }
                    return cell
                    
                case 1:
                    
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "HotelRatingInfoCell", for: indexPath) as? HotelRatingInfoCell  else { return UITableViewCell() }
                    if let hotelDetails = self.viewModel.hotelInfo, let placeData = self.viewModel.placeModel {
                        cell.configureCell(hotelData: hotelDetails, placeData: placeData)
                    } else if let hotelDetails = self.viewModel.hotelInfo {
                        cell.configureCell(hotelData: hotelDetails)
                    }
                    return cell
                    
                case 2:
                    
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "HotelInfoAddressCell", for: indexPath) as? HotelInfoAddressCell  else { return UITableViewCell() }
                    if let hotelDetails = self.viewModel.hotelData {
                        cell.configureAddressCell(hotelData: hotelDetails)
                    }
                    return cell
                    
                case 3:
                    
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "HotelInfoAddressCell", for: indexPath) as? HotelInfoAddressCell  else { return UITableViewCell() }
                    if let hotelDetails = self.viewModel.hotelData {
                        cell.configureOverviewCell(hotelData: hotelDetails)
                    }
                    return cell
                    
                case 4:
                    
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "HotelDetailAmenitiesCell", for: indexPath) as? HotelDetailAmenitiesCell  else { return UITableViewCell() }
                    if let hotelDetails = self.viewModel.hotelData {
                        cell.amenitiesDetails = hotelDetails.amenities
                    }
                    return cell
                    
                case 5:
                    
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "TripAdvisorTableViewCell", for: indexPath) as? TripAdvisorTableViewCell  else { return UITableViewCell() }
                    return cell
                    
                default:
                    return UITableViewCell()
                }
            } else if indexPath.section == 1 {
                switch indexPath.row {
                case 0:
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "HotelDetailsBedsTableViewCell", for: indexPath) as? HotelDetailsBedsTableViewCell  else { return UITableViewCell() }
                    return cell
                case 1:
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "HotelDetailsInclusionTableViewCell", for: indexPath) as? HotelDetailsInclusionTableViewCell  else { return UITableViewCell() }
                    return cell
                default:
                    return UITableViewCell()
                }
            } else {
                return UITableViewCell()
            }
        } */
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
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch section {
        case 0:
            guard let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HotelFilterResultFooterView") as? HotelFilterResultFooterView  else { return UITableViewHeaderFooterView()
            }
            if let safeHotelInfo = self.viewModel.hotelInfo {
                footerView.hotelFeesLabel.text = "₹ \(safeHotelInfo.price)"
            }
            //self.hotelFeesLabel.text = "₹ 35,500"
            return footerView
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.heightForRow(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.heightForRow(at: indexPath)
    }
    
    private func heightForRow(at indexPath: IndexPath) -> CGFloat {
        if !self.isDataLoaded {
            switch indexPath {
            case IndexPath(row: 0, section: 0):
                return hotelImageHeight
            case IndexPath(row: 1, section: 0):
                return 126.5
            case IndexPath(row: 2, section: 0):
                return view.bounds.height - (hotelImageHeight + 126.5 + 50)
            default:
                return UITableView.automaticDimension
            }
        } else {
            switch indexPath {
            case IndexPath(row: 0, section: 0):
                return hotelImageHeight
            case IndexPath(row: 1, section: 0):
                return 126.5
            case IndexPath(row: 2, section: 0):
                if let hotelData = self.viewModel.hotelData {
                    let text = hotelData.address + "Maps   "
                    let size = text.sizeCount(withFont: AppFonts.Regular.withSize(18.0), bundingSize: CGSize(width: UIDevice.screenWidth - 32.0, height: 10000.0))
                    return size.height + 46.5
                        + 14.0//y of textview 46.5 + bottom space 14.0
                }
                return CGFloat.leastNonzeroMagnitude
            case IndexPath(row: 3, section: 0):
                return 137.0
            case IndexPath(row: 4, section: 0):
                return 144.0
            case IndexPath(row: 5, section: 0):
                return 49.0
            case IndexPath(row: 0, section: 1):
                return 118.0
            case IndexPath(row: 1, section: 1):
                return 60.0
            default:
                return UITableView.automaticDimension
            }
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        //return CGFloat.leastNonzeroMagnitude
        switch section {
        case 1:
            return 112.0
        default:
            return CGFloat.leastNonzeroMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //return CGFloat.leastNonzeroMagnitude
        switch section {
        case 1:
            return 112.0
            
        default:
            return CGFloat.leastNonzeroMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 50.0
        default:
            return CGFloat.leastNonzeroMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 50.0
        default:
            return CGFloat.leastNonzeroMagnitude
        }
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.manageHeaderView(scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.manageHeaderView(scrollView)
    }
}
