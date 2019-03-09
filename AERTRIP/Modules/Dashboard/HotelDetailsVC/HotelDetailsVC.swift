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
    internal var completion: (() -> Void)? = nil
    internal weak var imagesCollectionView: UICollectionView?
    internal var expandHeight: CGFloat = 0.0
    internal let hotelImageHeight: CGFloat = 211.0
    private(set) var viewModel = HotelDetailsVM()
    private var initialPanPoint: CGPoint = .zero
    private var sourceFrame: CGRect = .zero
    private weak var parentVC: UIViewController?
    private weak var sourceView: UIView?
    private var tableFrameHidden: CGRect {
        return CGRect(x: 40.0, y: self.sourceFrame.origin.y, width: (UIDevice.screenWidth - 80.0), height: self.sourceFrame.size.height)
    }
    var allIndexPath = [IndexPath]()
    
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
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var hotelFeesLabel: UILabel!
    @IBOutlet weak var selectRoomLabel: UILabel!
    @IBOutlet weak var noRoomsAvailable: UILabel!
    
    //Mark:- LifeCycle
    //================
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func initialSetup() {
        self.headerView.shouldAddBlurEffect = true
        self.viewModel.getHotelDistanceAndTimeInfo()
        self.hotelFeesLabel.text = LocalizedString.rupeesText.localized + "\(self.viewModel.hotelInfo?.price ?? 0.0)"
        self.configUI()
        self.registerNibs()
        self.footerViewSetUpForNormalState()
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
        self.noRoomsAvailable.textColor = AppColors.themeWhite
        self.fromLabel.textColor = AppColors.themeWhite
        self.hotelFeesLabel.textColor = AppColors.themeWhite
        self.selectRoomLabel.textColor = AppColors.themeWhite
    }
    
    override func setupFonts() {
        self.fromLabel.font = AppFonts.Regular.withSize(14.0)
        self.hotelFeesLabel.font = AppFonts.SemiBold.withSize(20.0)
        self.selectRoomLabel.font = AppFonts.SemiBold.withSize(20.0)
        self.noRoomsAvailable.font = AppFonts.SemiBold.withSize(20.0)
    }
    
    override func setupTexts() {
        self.noRoomsAvailable.text = LocalizedString.NoRoomsAvailable.localized
        self.fromLabel.text = LocalizedString.From.localized
        self.selectRoomLabel.text = LocalizedString.SelectRoom.localized
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
    
    internal func footerViewSetUpForEmptyState() {
        self.footerView.addGredient(isVertical: false, cornerRadius: 0.0, colors: [AppColors.themeGray04, AppColors.shadowBlue])
        self.footerView.backgroundColor = AppColors.themeGray04
        self.noRoomsAvailable.isHidden = false
        self.fromLabel.isHidden = true
        self.hotelFeesLabel.isHidden = true
        self.selectRoomLabel.isHidden = true
    }
    
    internal func footerViewSetUpForNormalState() {
        self.footerView.addGredient(isVertical: false, cornerRadius: 0.0, colors: [AppColors.themeGreen, AppColors.shadowBlue])
        self.footerView.backgroundColor = AppColors.themeGreen
        self.noRoomsAvailable.isHidden = true
        self.fromLabel.isHidden = false
        self.hotelFeesLabel.isHidden = false
        self.selectRoomLabel.isHidden = false
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
            self.viewModel.ratesData = self.viewModel.getFilteredData(rates: rates, tagList: tagList)
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
