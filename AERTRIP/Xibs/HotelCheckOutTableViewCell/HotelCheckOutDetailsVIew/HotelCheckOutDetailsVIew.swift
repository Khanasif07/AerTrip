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
    internal var hotelInfo: HotelSearched?
    internal var allIndexPath = [IndexPath]()
    internal weak var delegate: HotelCheckOutDetailsVIewDelegate?
    internal var roomRates = [[RoomsRates : Int]]()
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
    @IBOutlet weak var smallLineView: UIView! {
        didSet {
            self.smallLineView.cornerRadius = self.smallLineView.height/2.0
            self.smallLineView.clipsToBounds = true
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
        let buttonImage: UIImage = self.hotelInfo?.fav == "1" ? #imageLiteral(resourceName: "saveHotelsSelected") : #imageLiteral(resourceName: "saveHotels")
        let selectedFevImage: UIImage = self.hotelInfo?.fav == "1" ? #imageLiteral(resourceName: "saveHotelsSelected") : #imageLiteral(resourceName: "save_icon_green")
        self.headerView.configureLeftButton(normalImage: buttonImage, selectedImage: selectedFevImage, normalTitle: nil, selectedTitle: nil, normalColor: nil, selectedColor: nil)
        self.headerView.configureFirstRightButton(normalImage: #imageLiteral(resourceName: "CancelButtonWhite"), selectedImage: #imageLiteral(resourceName: "black_cross"), normalTitle: nil, selectedTitle: nil, normalColor: nil, selectedColor: nil)
        self.hotelDetailsTableView.roundTopCorners(cornerRadius: 10.0)
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
}
