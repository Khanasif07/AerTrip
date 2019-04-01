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
    private var sectionData: [[TableCellType]] = []
    private var allIndexPath = [IndexPath]()
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var hotelDetailsTableView: ATTableView! {
        didSet {
            self.hotelDetailsTableView.delegate = self
            self.hotelDetailsTableView.dataSource = self
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
        self.getTableSectionData()
        self.registerXibs()
    }
    
    private func headerViewSetUp() {
        self.backgroundColor = .clear
        self.headerView.delegate = self
        self.headerView.configureNavBar(title: nil , isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false, isDivider: false)
        let buttonImage: UIImage =  #imageLiteral(resourceName: "saveHotels")// self.viewModel.hotelInfo?.fav == "1" ? #imageLiteral(resourceName: "saveHotelsSelected") : #imageLiteral(resourceName: "saveHotels")
        let selectedFevImage: UIImage = #imageLiteral(resourceName: "save_icon_green")//self.viewModel.hotelInfo?.fav == "1" ? #imageLiteral(resourceName: "saveHotelsSelected") : #imageLiteral(resourceName: "save_icon_green")
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
    }
    
    private func getTableSectionData() {
        self.sectionData.append([.imageSlideCell,.hotelRatingCell,.addressCell , .checkInOutDateCell , .amenitiesCell, .tripAdvisorRatingCell])
        self.sectionData.append([.roomBedsTypeCell,.inclusionCell,.otherInclusionCell,.cancellationPolicyCell,.paymentPolicyCell,.notesCell])
    }
    
    func hide(animated: Bool) {
//        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, animations: { [weak self] in
//            guard let sSelf = self else {return}
//            sSelf.imageView.frame = sSelf.sourceFrame
//            sSelf.hotelTableView.alpha = 0.0
//            sSelf.hotelTableView.frame = sSelf.tableFrameHidden
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
        let sectionData = self.sectionData[indexPath.section]
        switch sectionData[indexPath.row] {
            
        case .imageSlideCell:
            let cell = self.getImageSlideCell(indexPath: indexPath)
            return cell
        case .hotelRatingCell:
            let cell = self.getHotelRatingInfoCell(indexPath: indexPath)
            return cell
        case .addressCell:
            let cell = self.getHotelInfoAddressCell(indexPath: indexPath)
            return cell
        case .checkInOutDateCell:
            if let cell = self.getCheckInOutCell(tableView, indexPath: indexPath) {
                return cell
            }
        case .amenitiesCell:
            let cell = self.getHotelDetailsAmenitiesCell(indexPath: indexPath)
            return cell
        case .overViewCell:
            let cell = self.getHotelOverViewCell(indexPath: indexPath)
            return cell
        case .tripAdvisorRatingCell:
            let cell = self.getTripAdviserCell(indexPath: indexPath)
            return cell
        case .roomBedsTypeCell:
            if let cell = self.getBedDeailsCell(indexPath: indexPath){
                return cell
            }
        case .inclusionCell:
            if let cell = self.getInclusionCell(indexPath: indexPath) {
                return cell
            }
        case .otherInclusionCell:
            if let cell = self.otherInclusionCell(indexPath: indexPath) {
                return cell
            }
        case .cancellationPolicyCell:
            if let cell = self.getCancellationCell(indexPath: indexPath) {
                return cell
            }
        case .paymentPolicyCell:
            if let cell = self.getPaymentInfoCell(indexPath: indexPath) {
                return cell
            }
        case .notesCell:
            if let cell = self.getNotesCell(indexPath: indexPath) {
                return cell
            }
        case .roomDetailsCell:
            return UITableViewCell()
        default:
            return UITableViewCell()
        }
        return UITableViewCell()
    }
}

//Mark:- Hotel TableView Cells
//============================
extension HotelCheckOutDetailsVIew {
    
    
    
    
//    internal func getLoaderCell(indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = self.hotelDetailsTableView.dequeueReusableCell(withIdentifier: "HotelDetailsLoaderTableViewCell", for: indexPath) as? HotelDetailsLoaderTableViewCell  else { return UITableViewCell() }
//        cell.activityIndicator.startAnimating()
//        return cell
//    }
    
    internal func getImageSlideCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.hotelDetailsTableView.dequeueReusableCell(withIdentifier: "HotelDetailsImgSlideCell", for: indexPath) as? HotelDetailsImgSlideCell  else { return UITableViewCell() }
//        cell.imageUrls = hotelDetails.photos
        cell.delegate = self
        //cell.configCell(imageUrls: hotelDetails.photos)
        return cell
    }
    
    internal func getHotelRatingInfoCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.hotelDetailsTableView.dequeueReusableCell(withIdentifier: "HotelRatingInfoCell", for: indexPath) as? HotelRatingInfoCell  else { return UITableViewCell() }
//        if let hotelDetails = self.viewModel.hotelInfo, let placeData = self.viewModel.placeModel {
//            cell.configureCell(hotelData: hotelDetails, placeData: placeData)
//        }
        return cell
    }
    
    internal func getHotelInfoAddressCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.hotelDetailsTableView.dequeueReusableCell(withIdentifier: "HotelInfoAddressCell", for: indexPath) as? HotelInfoAddressCell  else { return UITableViewCell() }
//        cell.configureAddressCell(hotelData: hotelDetails)
        return cell
    }
    
    internal func getHotelOverViewCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.hotelDetailsTableView.dequeueReusableCell(withIdentifier: "HotelInfoAddressCell", for: indexPath) as? HotelInfoAddressCell  else { return UITableViewCell() }
//        cell.configureOverviewCell(hotelData: hotelDetails)
        return cell
    }
    
    internal func getHotelDetailsAmenitiesCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.hotelDetailsTableView.dequeueReusableCell(withIdentifier: "HotelDetailAmenitiesCell", for: indexPath) as? HotelDetailAmenitiesCell  else { return UITableViewCell() }
//        cell.amenitiesDetails = hotelDetails.amenities
        return cell
    }
    
    internal func getTripAdviserCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.hotelDetailsTableView.dequeueReusableCell(withIdentifier: "TripAdvisorTableViewCell", for: indexPath) as? TripAdvisorTableViewCell  else { return UITableViewCell() }
        return cell
    }
    
    internal func getBedDeailsCell(indexPath: IndexPath) -> UITableViewCell? {
        guard let cell = self.hotelDetailsTableView.dequeueReusableCell(withIdentifier: "HotelDetailsBedsTableViewCell", for: indexPath) as? HotelDetailsBedsTableViewCell  else { return nil }
        
        cell.delegate = self
//        let key = Array(roomData.keys)[indexPath.row]
//        let value = roomData[key]
//        var isOnlyOneRoom: Bool = false
//        if roomData.count == 1 && value == 1 {
//            isOnlyOneRoom = true
//        } else {
//            isOnlyOneRoom = false
//        }
//        cell.configCell(numberOfRooms: value ?? 0 , roomData: key, isOnlyOneRoom: isOnlyOneRoom)
//        if roomData.count == 1 {
//            cell.showHideSetUp(cornerRaduis: 10.0, bookmarkBtnHidden: false, dividerViewHidden: false)
//        } else {
//            if indexPath.row == 0 {
//                cell.showHideSetUp(cornerRaduis: 10.0, bookmarkBtnHidden: false, dividerViewHidden: true)
//            } else if indexPath.row < roomData.count - 1 {
//                cell.showHideSetUp(cornerRaduis: 0.0, bookmarkBtnHidden: true, dividerViewHidden: true)
//            } else {
//                cell.showHideSetUp(cornerRaduis: 0.0, bookmarkBtnHidden: true, dividerViewHidden: false)
//            }
//        }
        return cell
    }
    
    internal func getInclusionCell(indexPath: IndexPath) -> UITableViewCell? {
        guard let cell = self.hotelDetailsTableView.dequeueReusableCell(withIdentifier: "HotelDetailsInclusionTableViewCell", for: indexPath) as? HotelDetailsInclusionTableViewCell  else { return nil }
//        cell.configureCell(ratesData: ratesData)
        return cell
//        if let boardInclusion =  ratesData.inclusion_array[APIKeys.boardType.rawValue] as? [String], !boardInclusion.isEmpty {
//            guard let cell = self.hotelDetailsTableView.dequeueReusableCell(withIdentifier: "HotelDetailsInclusionTableViewCell", for: indexPath) as? HotelDetailsInclusionTableViewCell  else { return nil }
//            cell.configureCell(ratesData: ratesData)
//            return cell
//        } else if let internetInclusion =  ratesData.inclusion_array[APIKeys.internet.rawValue] as? [String], !internetInclusion.isEmpty {
//            guard let cell = self.hotelDetailsTableView.dequeueReusableCell(withIdentifier: "HotelDetailsInclusionTableViewCell", for: indexPath) as? HotelDetailsInclusionTableViewCell  else { return nil }
//            cell.configureCell(ratesData: ratesData)
//            return cell
//        }
//        return nil
    }
    
    internal func otherInclusionCell(indexPath: IndexPath) -> UITableViewCell? {
        guard let cell = self.hotelDetailsTableView.dequeueReusableCell(withIdentifier: "HotelDetailsInclusionTableViewCell", for: indexPath) as? HotelDetailsInclusionTableViewCell  else { return nil }
//        cell.configureOtherInclusionCell(otherInclusion: otherInclusion)
        return cell

//        if let otherInclusion =  ratesData.inclusion_array[APIKeys.other_inclusions.rawValue] as? [String], !otherInclusion.isEmpty {
//            guard let cell = self.hotelDetailsTableView.dequeueReusableCell(withIdentifier: "HotelDetailsInclusionTableViewCell", for: indexPath) as? HotelDetailsInclusionTableViewCell  else { return nil }
//            cell.configureOtherInclusionCell(otherInclusion: otherInclusion)
//            return cell
//        }
//        return nil
    }
    
    internal func getCancellationCell(indexPath: IndexPath) -> HotelDetailsCancelPolicyTableCell? {
        guard let cell = self.hotelDetailsTableView.dequeueReusableCell(withIdentifier: HotelDetailsCancelPolicyTableCell.reusableIdentifier, for: indexPath) as? HotelDetailsCancelPolicyTableCell  else { return nil }
        cell.delegate = self
        return cell
//        if ratesData.cancellation_penalty != nil {
//            guard let cell = self.hotelDetailsTableView.dequeueReusableCell(withIdentifier: HotelDetailsCancelPolicyTableCell.reusableIdentifier, for: indexPath) as? HotelDetailsCancelPolicyTableCell  else { return nil }
//            cell.delegate = self
//            cell.configureCancellationCell(ratesData: ratesData, isHotelDetailsScreen: true)
//            if self.allIndexPath.contains(indexPath) {
//                cell.allDetailsLabel.isHidden = false
//                cell.allDetailsLabel.attributedText = cell.fullPenaltyDetails(ratesData: ratesData)?.trimWhiteSpace()
//                cell.infoBtnOutlet.isHidden = true
//            }
//            else {
//                cell.allDetailsLabel.isHidden = true
//                cell.allDetailsLabel.attributedText = nil
//            }
//            return cell
//        }
//        return nil
    }
    
    internal func getPaymentInfoCell(indexPath: IndexPath) -> UITableViewCell? {
        guard let cell = self.hotelDetailsTableView.dequeueReusableCell(withIdentifier: HotelDetailsCancelPolicyTableCell.reusableIdentifier, for: indexPath) as? HotelDetailsCancelPolicyTableCell  else { return nil }
        cell.delegate = self
//        cell.configurePaymentCell(ratesData: ratesData, isHotelDetailsScreen: true)
//        if self.allIndexPath.contains(indexPath) {
//            cell.allDetailsLabel.isHidden = false
//            cell.allDetailsLabel.attributedText = cell.fullPaymentDetails()?.trimWhiteSpace()
//            cell.infoBtnOutlet.isHidden = true
//        }
//        else {
//            cell.allDetailsLabel.isHidden = true
//            cell.allDetailsLabel.attributedText = nil
//            cell.infoBtnOutlet.isHidden = false
//        }
        return cell
    }
    
    internal func getNotesCell(indexPath: IndexPath) -> UITableViewCell? {
        guard let cell = self.hotelDetailsTableView.dequeueReusableCell(withIdentifier: HotelDetailsCancelPolicyTableCell.reusableIdentifier, for: indexPath) as? HotelDetailsCancelPolicyTableCell  else { return nil }
        cell.delegate = self
        return cell
//        if let notesInclusion =  ratesData.inclusion_array[APIKeys.notes_inclusion.rawValue] as? [String], !notesInclusion.isEmpty {
//            guard let cell = self.hotelDetailsTableView.dequeueReusableCell(withIdentifier: HotelDetailsCancelPolicyTableCell.reusableIdentifier, for: indexPath) as? HotelDetailsCancelPolicyTableCell  else { return nil }
//            cell.delegate = self
//            cell.configureNotesCell(ratesData: ratesData, isHotelDetailsScreen: true)
//            if self.allIndexPath.contains(indexPath) {
//                cell.descriptionLabel.text = ""
//                cell.allDetailsLabel.isHidden = false
//                cell.moreInfoContainerView.isHidden = true
//                cell.allDetailsLabel.attributedText = cell.fullNotesDetails(ratesData: ratesData)?.trimWhiteSpace()
//                cell.moreBtnOutlet.isHidden = true
//            }
//            else {
//                cell.moreInfoContainerView.isHidden = false
//                cell.allDetailsLabel.isHidden = true
//                cell.allDetailsLabel.attributedText = nil
//                cell.moreBtnOutlet.isHidden = false
//            }
//            return cell
//        }
//        return nil
    }
    
    internal func getCheckInOutCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HCCheckInOutTableViewCell.reusableIdentifier, for: indexPath) as? HCCheckInOutTableViewCell else { return nil }
        cell.configCell()
        return cell
    }
}

extension HotelCheckOutDetailsVIew: GetFullInfoDelegate {
    
    func expandCell(expandHeight: CGFloat, indexPath: IndexPath) {
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
