//
//  HotelCheckOutDetailsVIew.swift
//  AERTRIP
//
//  Created by Admin on 29/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HotelCheckOutDetailsVIew: UIView {
    
    //Mark:- Variables
    //================
    internal var sectionData: [[TableCellType]] = []
    internal var viewModel: HotelDetails?
    internal var placeModel: PlaceModel?
    private var allIndexPath = [IndexPath]()
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var hotelDetailsTableView: ATTableView! {
        didSet {
            self.hotelDetailsTableView.delegate = self
            self.hotelDetailsTableView.dataSource = self
            self.hotelDetailsTableView.backgroundColor = AppColors.screensBackground.color
        }
    }
    @IBOutlet weak var headerView: TopNavigationView! {
        didSet{
            self.headerView.roundTopCorners(cornerRadius: 10.0)
        }
    }
    
    
    //Mark:- LifeCycle
    //================
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialSetUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialSetUp()
    }
    
    //Mark:- PrivateFunctions
    //=======================
    //.InitialSetUp
    private func initialSetUp() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "HotelCheckOutDetailsVIew", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        self.configureUI()
    }
    
    ///ConfigureUI
    private func configureUI() {
        self.headerView.shouldAddBlurEffect = true
        self.registerXibs()
    }
    
    private func headerViewSetUp() {
        self.backgroundColor = .clear
        self.headerView.delegate = self
        self.headerView.configureNavBar(title: nil , isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false, isDivider: false)
        let buttonImage: UIImage = self.viewModel?.fav == "1" ? #imageLiteral(resourceName: "saveHotelsSelected") : #imageLiteral(resourceName: "saveHotels")
        let selectedFevImage: UIImage = self.viewModel?.fav == "1" ? #imageLiteral(resourceName: "saveHotelsSelected") : #imageLiteral(resourceName: "save_icon_green")
        self.headerView.configureLeftButton(normalImage: buttonImage, selectedImage: selectedFevImage, normalTitle: nil, selectedTitle: nil, normalColor: nil, selectedColor: nil)
        self.headerView.configureFirstRightButton(normalImage: #imageLiteral(resourceName: "CancelButtonWhite"), selectedImage: #imageLiteral(resourceName: "black_cross"), normalTitle: nil, selectedTitle: nil, normalColor: nil, selectedColor: nil)
        self.hotelDetailsTableView.roundTopCorners(cornerRadius: 10.0)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panGestureRecognizerHandler))
        self.addGestureRecognizer(panGesture)
    }
    
    private func registerXibs() {
        self.hotelDetailsTableView.registerCell(nibName: HotelDetailsImgSlideCell.reusableIdentifier)
        self.hotelDetailsTableView.registerCell(nibName: HotelRatingInfoCell.reusableIdentifier)
        self.hotelDetailsTableView.registerCell(nibName: HotelInfoAddressCell.reusableIdentifier)
        self.hotelDetailsTableView.registerCell(nibName: HotelDetailAmenitiesCell.reusableIdentifier)
        self.hotelDetailsTableView.registerCell(nibName: TripAdvisorTableViewCell.reusableIdentifier)
        self.hotelDetailsTableView.registerCell(nibName: HotelDetailsBedsTableViewCell.reusableIdentifier)
        self.hotelDetailsTableView.registerCell(nibName: HotelDetailsInclusionTableViewCell.reusableIdentifier)
        self.hotelDetailsTableView.registerCell(nibName: HotelDetailsCancelPolicyTableCell.reusableIdentifier)
        self.hotelDetailsTableView.registerCell(nibName: HCCheckInOutTableViewCell.reusableIdentifier)
        self.hotelDetailsTableView.registerCell(nibName: HCRoomTableViewCell.reusableIdentifier)
    }
    
    private func openAppleMap(originLat: String ,originLong:String ,destLat: String ,destLong:String) {
        
        let directionsURL = "http://maps.apple.com/?saddr=\(originLat),\(originLong)&daddr=\(destLat),\(destLong)"
        if let url = URL(string: directionsURL), !url.absoluteString.isEmpty {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            print("Can't use apple map://")
        }
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

    
    private func redirectToMap() {
        let buttons = AppGlobals.shared.getPKAlertButtons(forTitles: [LocalizedString.Maps.localized,LocalizedString.GMap.localized], colors: [AppColors.themeGreen,AppColors.themeGreen])
        let titleFont = [NSAttributedString.Key.font: AppFonts.Regular.withSize(14.0), NSAttributedString.Key.foregroundColor: AppColors.themeGray40]
        let titleAttrString = NSMutableAttributedString(string: LocalizedString.Choose_App.localized, attributes: titleFont)
        
        _ = PKAlertController.default.presentActionSheetWithAttributed(nil, message: titleAttrString, sourceView: self, alertButtons: buttons, cancelButton: AppGlobals.shared.pKAlertCancelButton) { _, index in
            guard let parentVC = self.parentViewController as? HCDataSelectionVC else { return }
            if index == 0 {
                if let reqParams = parentVC.viewModel.hotelSearchRequest?.requestParameters,let destParams = self.viewModel {
                    self.openAppleMap(originLat: reqParams.latitude, originLong: reqParams.longitude, destLat: destParams.lat, destLong: destParams.long)
                }
            } else {
                if let reqParams = parentVC.viewModel.hotelSearchRequest?.requestParameters,let destParams = self.viewModel {
                    self.openGoogleMaps(originLat: reqParams.latitude, originLong: reqParams.longitude, destLat: destParams.lat, destLong: destParams.long)
                }
            }
        }
    }
    
    func hide(animated: Bool) {
//        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, animations: { [weak self] in
//            guard let sSelf = self else {return}
//            sSelf.imageView.frame = sSelf.sourceFrame
//            sSelf.hotelDetailsTableView.alpha = 0.0
//            sSelf.hotelDetailsTableView.frame = sSelf.tableFrameHidden
//            }, completion: { [weak self](isDone) in
//                guard let sSelf = self else {return}
//                sSelf.removeFromParentVC
//        })
    }
    
    @IBAction func panGestureRecognizerHandler(_ sender: UIPanGestureRecognizer) {
//        guard self.imageView.isHidden else {return}
//        let touchPoint = sender.location(in: self.view?.window)
//        if sender.state == UIGestureRecognizer.State.began {
//            self.initialPanPoint = touchPoint
//        }
//        else  if (initialPanPoint.y + 10) < touchPoint.y {
//            self.hide(animated: true)
//            initialPanPoint = touchPoint
//        }
    }

}

extension HotelCheckOutDetailsVIew: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sectionData[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let hotelDetails = self.viewModel , let rates = hotelDetails.rates?.first else { return UITableViewCell() }
        let sectionData = self.sectionData[indexPath.section]
        switch sectionData[indexPath.row] {
            
        case .imageSlideCell:
            let cell = self.getImageSlideCell(indexPath: indexPath, hotelDetails: hotelDetails)
            return cell
        case .hotelRatingCell:
            let cell = self.getHotelRatingInfoCell(indexPath: indexPath, hotelDetails: hotelDetails)
            return cell
        case .addressCell:
            let cell = self.getHotelInfoAddressCell(indexPath: indexPath, hotelDetails: hotelDetails)
            return cell
        case .checkInOutDateCell:
            if let cell = self.getCheckInOutCell(tableView, indexPath: indexPath) {
                return cell
            }
        case .amenitiesCell:
            let cell = self.getHotelDetailsAmenitiesCell(indexPath: indexPath, hotelDetails: hotelDetails)
            return cell
        case .overViewCell:
            let cell = self.getHotelOverViewCell(indexPath: indexPath, hotelDetails: hotelDetails)
            return cell
        case .tripAdvisorRatingCell:
            let cell = self.getTripAdviserCell(indexPath: indexPath)
            return cell
        case .roomDetailsCell:
            if let cell = self.getRoomCell(tableView, indexPath: indexPath) {
                return cell
            }
        case .roomBedsTypeCell:
            if let cell = self.getBedDeailsCell(indexPath: indexPath, ratesData: rates, roomData: rates.roomData){
                return cell
            }
        case .inclusionCell:
            if let cell = self.getInclusionCell(indexPath: indexPath, ratesData: rates) {
                return cell
            }
        case .otherInclusionCell:
            if let cell = self.otherInclusionCell(indexPath: indexPath, ratesData: rates) {
                return cell
            }
        case .cancellationPolicyCell:
            if let cell = self.getCancellationCell(indexPath: indexPath, ratesData: rates) {
                return cell
            }
        case .paymentPolicyCell:
            if let cell = self.getPaymentInfoCell(indexPath: indexPath, ratesData: rates) {
                return cell
            }
        case .notesCell:
            if let cell = self.getNotesCell(indexPath: indexPath, ratesData: rates) {
                return cell
            }
        case .checkOutCell:
//            if let cell = self.getNotesCell(indexPath: indexPath, ratesData: rates) {
//                return cell
//            }
            printDebug("cell is not in UI")
        default:
            printDebug("cell is not in UI")
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if (tableView.cellForRow(at: indexPath) as? HotelInfoAddressCell) != nil {
                if indexPath.row == 2 {
                    self.redirectToMap()
                } else if indexPath.row == 3 {
                    AppFlowManager.default.presentHotelDetailsOverViewVC(overViewInfo: self.viewModel?.info ?? "")
                }
            } else if (tableView.cellForRow(at: indexPath) as? TripAdvisorTableViewCell) != nil , let locid = self.viewModel?.locid {
                !locid.isEmpty ? AppFlowManager.default.presentHotelDetailsTripAdvisorVC(hotelId: self.viewModel?.hid ?? "") : printDebug(locid + "location id is empty")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0, indexPath.row == 2 {
            if let hotelData = self.viewModel {
                let text = hotelData.address + "Maps   "
                let size = text.sizeCount(withFont: AppFonts.Regular.withSize(18.0), bundingSize: CGSize(width: UIDevice.screenWidth - 32.0, height: 10000.0))
                return size.height + 46.5
                    + 14.0//y of textview 46.5 + bottom space 14.0
            }
        }
        return UITableView.automaticDimension
    }
}

//Mark:- Hotel TableView Cells
//============================
extension HotelCheckOutDetailsVIew {
    
    internal func getImageSlideCell(indexPath: IndexPath, hotelDetails: HotelDetails) -> UITableViewCell {
        guard let cell = self.hotelDetailsTableView.dequeueReusableCell(withIdentifier: "HotelDetailsImgSlideCell", for: indexPath) as? HotelDetailsImgSlideCell  else { return UITableViewCell() }
        cell.imageUrls = hotelDetails.photos
        cell.delegate = self
        cell.configCell(imageUrls: hotelDetails.photos)
        return cell
    }
    
    internal func getHotelRatingInfoCell(indexPath: IndexPath, hotelDetails: HotelDetails) -> UITableViewCell {
        guard let cell = self.hotelDetailsTableView.dequeueReusableCell(withIdentifier: "HotelRatingInfoCell", for: indexPath) as? HotelRatingInfoCell  else { return UITableViewCell() }
        if let hotelDetails = self.viewModel, let placeData = self.placeModel {
            cell.configHCDetailsCell(hotelData: hotelDetails, placeData: placeData)
        }
        return cell
    }
    
    internal func getHotelInfoAddressCell(indexPath: IndexPath, hotelDetails: HotelDetails) -> UITableViewCell {
        guard let cell = self.hotelDetailsTableView.dequeueReusableCell(withIdentifier: "HotelInfoAddressCell", for: indexPath) as? HotelInfoAddressCell  else { return UITableViewCell() }
        cell.configureAddressCell(hotelData: hotelDetails)
        return cell
    }
    
    internal func getHotelOverViewCell(indexPath: IndexPath, hotelDetails: HotelDetails) -> UITableViewCell {
        guard let cell = self.hotelDetailsTableView.dequeueReusableCell(withIdentifier: "HotelInfoAddressCell", for: indexPath) as? HotelInfoAddressCell  else { return UITableViewCell() }
        cell.configureOverviewCell(hotelData: hotelDetails)
        return cell
    }
    
    internal func getHotelDetailsAmenitiesCell(indexPath: IndexPath, hotelDetails: HotelDetails) -> UITableViewCell {
        guard let cell = self.hotelDetailsTableView.dequeueReusableCell(withIdentifier: "HotelDetailAmenitiesCell", for: indexPath) as? HotelDetailAmenitiesCell  else { return UITableViewCell() }
        cell.delegate = self
        cell.amenitiesDetails = hotelDetails.amenities
        return cell
    }

    internal func getTripAdviserCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.hotelDetailsTableView.dequeueReusableCell(withIdentifier: "TripAdvisorTableViewCell", for: indexPath) as? TripAdvisorTableViewCell  else { return UITableViewCell() }
        return cell
    }
    
    internal func getBedDeailsCell(indexPath: IndexPath, ratesData: Rates , roomData: [RoomsRates: Int]) -> UITableViewCell? {
        guard let cell = self.hotelDetailsTableView.dequeueReusableCell(withIdentifier: "HotelDetailsBedsTableViewCell", for: indexPath) as? HotelDetailsBedsTableViewCell  else { return nil }
        
        cell.delegate = self
        let key = Array(roomData.keys).first//[indexPath.row]
        let value = roomData[key ?? RoomsRates()]
        var isOnlyOneRoom: Bool = false
        if roomData.count == 1 && value == 1 {
            isOnlyOneRoom = true
        } else {
            isOnlyOneRoom = false
        }
        cell.configCell(numberOfRooms: value ?? 0 , roomData: key ?? RoomsRates(), isOnlyOneRoom: isOnlyOneRoom)
        if roomData.count == 1 {
            cell.showHideSetUp(cornerRaduis: 10.0, bookmarkBtnHidden: false, dividerViewHidden: false)
        } else {
            if indexPath.row == 0 {
                cell.showHideSetUp(cornerRaduis: 10.0, bookmarkBtnHidden: false, dividerViewHidden: true)
            } else if indexPath.row < roomData.count - 1 {
                cell.showHideSetUp(cornerRaduis: 0.0, bookmarkBtnHidden: true, dividerViewHidden: true)
            } else {
                cell.showHideSetUp(cornerRaduis: 0.0, bookmarkBtnHidden: true, dividerViewHidden: false)
            }
        }
        cell.clipsToBounds = true
        return cell
    }
    
    internal func getInclusionCell(indexPath: IndexPath, ratesData: Rates) -> UITableViewCell? {
        if let boardInclusion =  ratesData.inclusion_array[APIKeys.boardType.rawValue] as? [String], !boardInclusion.isEmpty {
            guard let cell = self.hotelDetailsTableView.dequeueReusableCell(withIdentifier: "HotelDetailsInclusionTableViewCell", for: indexPath) as? HotelDetailsInclusionTableViewCell  else { return nil }
            cell.configureCell(ratesData: ratesData)
            cell.clipsToBounds = true
            return cell
        } else if let internetInclusion =  ratesData.inclusion_array[APIKeys.internet.rawValue] as? [String], !internetInclusion.isEmpty {
            guard let cell = self.hotelDetailsTableView.dequeueReusableCell(withIdentifier: "HotelDetailsInclusionTableViewCell", for: indexPath) as? HotelDetailsInclusionTableViewCell  else { return nil }
            cell.configureCell(ratesData: ratesData)
            cell.clipsToBounds = true
            return cell
        }
        return nil
    }
    
    internal func otherInclusionCell(indexPath: IndexPath, ratesData: Rates) -> UITableViewCell? {
        if let otherInclusion =  ratesData.inclusion_array[APIKeys.other_inclusions.rawValue] as? [String], !otherInclusion.isEmpty {
            guard let cell = self.hotelDetailsTableView.dequeueReusableCell(withIdentifier: "HotelDetailsInclusionTableViewCell", for: indexPath) as? HotelDetailsInclusionTableViewCell  else { return nil }
            cell.configureOtherInclusionCell(otherInclusion: otherInclusion)
            cell.clipsToBounds = true
            return cell
        }
        return nil
    }
    
    internal func getCancellationCell(indexPath: IndexPath, ratesData: Rates) -> HotelDetailsCancelPolicyTableCell? {
        if ratesData.cancellation_penalty != nil {
            guard let cell = self.hotelDetailsTableView.dequeueReusableCell(withIdentifier: HotelDetailsCancelPolicyTableCell.reusableIdentifier, for: indexPath) as? HotelDetailsCancelPolicyTableCell  else { return nil }
            cell.configureCancellationCell(ratesData: ratesData, isHotelDetailsScreen: true)
            cell.containerView.roundBottomCorners(cornerRadius: 0.0)
            cell.delegate = self
            if self.allIndexPath.contains(indexPath) {
                cell.allDetailsLabel.isHidden = false
                cell.allDetailsLabel.attributedText = cell.fullPenaltyDetails(ratesData: ratesData)?.trimWhiteSpace()
                cell.infoBtnOutlet.isHidden = true
            }
            else {
                cell.allDetailsLabel.isHidden = true
                cell.allDetailsLabel.attributedText = nil
            }
            cell.shadowViewBottomConstraints.constant = 0.0
            cell.clipsToBounds = true
            return cell
        }
        return nil
    }
    
    internal func getPaymentInfoCell(indexPath: IndexPath, ratesData: Rates) -> UITableViewCell? {
        guard let cell = self.hotelDetailsTableView.dequeueReusableCell(withIdentifier: HotelDetailsCancelPolicyTableCell.reusableIdentifier, for: indexPath) as? HotelDetailsCancelPolicyTableCell  else { return nil }
        cell.containerView.roundBottomCorners(cornerRadius: 00.0)
        cell.delegate = self
        cell.configurePaymentCell(ratesData: ratesData, isHotelDetailsScreen: true)
        if self.allIndexPath.contains(indexPath) {
            cell.allDetailsLabel.isHidden = false
            cell.allDetailsLabel.attributedText = cell.fullPaymentDetails()?.trimWhiteSpace()
            cell.infoBtnOutlet.isHidden = true
        }
        else {
            cell.allDetailsLabel.isHidden = true
            cell.allDetailsLabel.attributedText = nil
            cell.infoBtnOutlet.isHidden = false
        }
        cell.shadowViewBottomConstraints.constant = 0.0
        cell.clipsToBounds = true
        return cell
    }
    
    internal func getNotesCell(indexPath: IndexPath, ratesData: Rates) -> UITableViewCell? {
        if let notesInclusion =  ratesData.inclusion_array[APIKeys.notes_inclusion.rawValue] as? [String], !notesInclusion.isEmpty {
            guard let cell = self.hotelDetailsTableView.dequeueReusableCell(withIdentifier: HotelDetailsCancelPolicyTableCell.reusableIdentifier, for: indexPath) as? HotelDetailsCancelPolicyTableCell  else { return nil }
            cell.containerView.roundBottomCorners(cornerRadius: 10.0)
            cell.delegate = self
            cell.configureNotesCell(ratesData: ratesData, isHotelDetailsScreen: true)
            if self.allIndexPath.contains(indexPath) {
                cell.descriptionLabel.text = ""
                cell.allDetailsLabel.isHidden = false
                cell.moreInfoContainerView.isHidden = true
                cell.allDetailsLabel.attributedText = cell.fullNotesDetails(ratesData: ratesData)?.trimWhiteSpace()
                cell.moreBtnOutlet.isHidden = true
            }
            else {
                cell.moreInfoContainerView.isHidden = false
                cell.allDetailsLabel.isHidden = true
                cell.allDetailsLabel.attributedText = nil
                cell.moreBtnOutlet.isHidden = false
            }
            cell.shadowViewBottomConstraints.constant = 26.0
            cell.clipsToBounds = true
            return cell
        }
        return nil
    }

    internal func getCheckInOutCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HCCheckInOutTableViewCell.reusableIdentifier, for: indexPath) as? HCCheckInOutTableViewCell else { return nil }
        cell.configCell()
        return cell
    }
    
    internal func getRoomCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HCRoomTableViewCell.reusableIdentifier, for: indexPath) as? HCRoomTableViewCell else { return nil }
        return cell
    }
}

extension HotelCheckOutDetailsVIew: GetFullInfoDelegate {
    
    func expandCell(expandHeight: CGFloat, indexPath: IndexPath) {
        if !allIndexPath.contains(indexPath) {
            self.allIndexPath.append(indexPath)
            self.hotelDetailsTableView.reloadData()
        }
        printDebug(indexPath)
    }
    
}


extension HotelCheckOutDetailsVIew: HotelDetailsBedsTableViewCellDelegate {
    
    func bookMarkButtonAction(sender: HotelDetailsBedsTableViewCell) {
        printDebug("bookMarkButtonAction")
    }
}

extension HotelCheckOutDetailsVIew: HotelDetailsImgSlideCellDelegate {
    
    func hotelImageTapAction(at index: Int) {
        printDebug("hotelImageTapAction")
    }
    
    func willShowImage(at index: Int, image: UIImage?) {
        printDebug("willShowImage")
    }

}

extension HotelCheckOutDetailsVIew: TopNavigationViewDelegate {
    
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        printDebug("updateFavourite")
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        //        self.hide(animated: true)
        self.removeFromSuperview()
    }
}

//Mark:- HotelDetailAmenitiesCellDelegate
//=======================================
extension HotelCheckOutDetailsVIew: HotelDetailAmenitiesCellDelegate {
    func viewAllButtonAction() {
        if let hotelData = self.viewModel {
            AppFlowManager.default.showHotelDetailAmenitiesVC(hotelDetails: hotelData)
        }
    }
}

