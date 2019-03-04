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
    private var oldOffset: CGPoint = .zero
    private(set) var viewModel = HotelDetailsVM()
    private var isDataLoaded: Bool = false
    private var completion: (() -> Void)? = nil
    private var initialTouchPoint: CGPoint = CGPoint(x: 0,y: 0)
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
    
    //Mark:- LifeCycle
    //================
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func initialSetup() {
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        guard 105...211 ~= yOffset else {return}
        
        if yOffset > oldOffset.y {
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
        self.oldOffset = scrollView.contentOffset
    }
    
    //Mark:- Methods
    //==============
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
        let cancellationNib = UINib(nibName: "HotelDetailsCancelPolicyTableCell", bundle: nil)
        self.hotelTableView.register(cancellationNib, forCellReuseIdentifier: "HotelDetailsCancelPolicyTableCell")
        let notesNIb = UINib(nibName: "NotesTableCell", bundle: nil)
        self.hotelTableView.register(notesNIb, forCellReuseIdentifier: "NotesTableCell")
        let checkOutNib = UINib(nibName: "HotelDetailsCheckOutTableViewCell", bundle: nil)
        self.hotelTableView.register(checkOutNib, forCellReuseIdentifier: "HotelDetailsCheckOutTableViewCell")
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
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func fevButtonAction(_ sender: UIButton) {
        self.viewModel.updateFavourite()
    }
    
    @IBAction func panGestureRecognizerHandler(_ sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: self.view?.window)
        if sender.state == UIGestureRecognizer.State.began {
            self.initialTouchPoint = touchPoint
        } else if sender.state == UIGestureRecognizer.State.changed {
            if touchPoint.y - self.initialTouchPoint.y > 0 {
                self.view.frame = CGRect(x: 0, y: touchPoint.y - self.initialTouchPoint.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
            }
        } else if sender.state == UIGestureRecognizer.State.ended || sender.state == UIGestureRecognizer.State.cancelled {
            if touchPoint.y - self.initialTouchPoint.y > 100 {
                self.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                })
            }
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
                return rates[section - 2].tableViewRowCell.count //rates[section - 1].getTotalNumberOfRows()
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
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch section {
        case 0:
            guard let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HotelFilterResultFooterView") as? HotelFilterResultFooterView  else { return UITableViewHeaderFooterView()
            }
            if let safeHotelInfo = self.viewModel.hotelInfo {
                footerView.hotelFeesLabel.text = LocalizedString.rupeesText.localized + "\(safeHotelInfo.price)"
            }
            return footerView
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == IndexPath(row: 2, section: 0) {
            if let hotelData = self.viewModel.hotelData {
                let text = hotelData.address + "Maps   "
                let size = text.sizeCount(withFont: AppFonts.Regular.withSize(18.0), bundingSize: CGSize(width: UIDevice.screenWidth - 32.0, height: 10000.0))
                return size.height + 46.5
                    + 14.0//y of textview 46.5 + bottom space 14.0
            } else {
                return tableView.frame.height - (211.0 + 126.5 + 50.0)
            }
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == IndexPath(row: 2, section: 0) {
            if let hotelData = self.viewModel.hotelData {
                let text = hotelData.address + "Maps   "
                let size = text.sizeCount(withFont: AppFonts.Regular.withSize(18.0), bundingSize: CGSize(width: UIDevice.screenWidth - 32.0, height: 10000.0))
                return size.height + 46.5
                    + 14.0//y of textview 46.5 + bottom space 14.0
            }
            else {
                return tableView.frame.height - (211.0 + 126.5)
            }
        } else if let index = self.currentIndexPath, index == indexPath, expandHeight != 0.0  {
            return self.expandHeight
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 1:
            return 114.0
        default:
            return CGFloat.leastNonzeroMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 1:
            return 114.0
            
        default:
            return CGFloat.leastNonzeroMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 50.0
        case 1:
            return CGFloat.leastNonzeroMagnitude
        default:
            return CGFloat.leastNonzeroMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 50.0
        case 1:
            return CGFloat.leastNonzeroMagnitude
        default:
            return 16.0
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

extension HotelDetailsVC: GetFullInfoDelegate {
    func expandCell(expandHeight: CGFloat, indexPath: IndexPath) {
        self.expandHeight = expandHeight
        self.currentIndexPath = indexPath
        self.hotelTableView.reloadRow(at: indexPath, with: .fade)
    }
}
