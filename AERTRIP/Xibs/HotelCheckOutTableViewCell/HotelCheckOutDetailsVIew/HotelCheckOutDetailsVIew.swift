//
//  HotelCheckOutDetailsVIew.swift
//  AERTRIP
//
//  Created by Admin on 29/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol HotelCheckOutDetailsVIewDelegate: class {
    func addHotelInFevList()
    func crossButtonTapped()
}

class HotelCheckOutDetailsVIew: UIView {
    
    //Mark:- Variables
    //================
    internal var sectionData: [[TableCellType]] = []
    internal var viewModel: HotelDetails?
    internal var placeModel: PlaceModel?
    internal var allIndexPath = [IndexPath]()
    internal weak var delegate: HotelCheckOutDetailsVIewDelegate?
    internal let hotelImageHeight: CGFloat = 211.0
    
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
        self.headerViewSetUp()
    }
    
    internal func updateData() {
        self.headerViewSetUp()
        self.hotelDetailsTableView.reloadData()
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
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panGestureRecognizerHandler))
//        self.addGestureRecognizer(panGesture)
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

    
    internal func redirectToMap() {
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
}
