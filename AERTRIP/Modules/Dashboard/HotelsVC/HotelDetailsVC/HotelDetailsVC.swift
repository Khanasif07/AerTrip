//
//  HotelFilterResultsVC.swift
//  AERTRIP
// AppGlobals.shared.startLoading()
//  Created by Admin on 08/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol HotelDetailsVCDelegate : class {
    func hotelFavouriteUpdated()
    func imageUpdated()
}

class HotelDetailsVC: BaseVC {
    
    //Mark:- Variables
    //================
    private(set) var viewModel = HotelDetailsVM()
    internal var completion: (() -> Void)? = nil
    internal weak var imagesCollectionView: UICollectionView?
    internal var hotelImageHeight: CGFloat{
        return !(self.viewModel.isAllImageDownloadFails) ? UIScreen.width: 85.0
    }
    private var initialPanPoint: CGPoint = .zero
    private var sourceFrame: CGRect = .zero
    private weak var parentVC: UIViewController?
    private weak var sourceView: UIView?
    private var tableFrameHidden: CGRect {
        return CGRect(x: 40.0, y: self.sourceFrame.origin.y, width: (UIDevice.screenWidth - 80.0), height: self.sourceFrame.size.height)
    }
    internal var allIndexPath = [IndexPath]()
    internal var initialStickyPosition: CGFloat = -1.0
    var stickyView: HotelFilterResultFooterView?
    weak var delegate : HotelDetailsVCDelegate?
    var onCloseHandler: (() -> Void)? = nil
    var isHideWithAnimation: Bool = true
    var needToShowLoaderOnShare:Bool = false
    
    //------------------------ Golu Change --------------------
    
    var backImage:UIImage? = UIImage()
    var isAddingChild = false
    var isDeviceHasBadzel = false
    var currentViewHeight = CGFloat()
    var statusBarHeight:CGFloat{return UIApplication.shared.statusBarFrame.size.height}
    var canDismissViewController = true
    
    
    @IBOutlet weak var heightOfHeader: NSLayoutConstraint!
    @IBOutlet weak var footerViewHeightConstraint: NSLayoutConstraint!
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var headerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var hotelTableView: UITableView! {
        didSet {
            hotelTableView.delegate = self
            hotelTableView.dataSource = self
            hotelTableView.backgroundColor = AppColors.themeGray04
            
        }
    }
    @IBOutlet weak var headerView: TopNavigationView! {
        didSet{
            self.headerView.roundTopCorners(cornerRadius: 10.0)
        }
    }
    @IBOutlet weak var smallLineView: UIView! {
        didSet {
            self.smallLineView.cornerradius = self.smallLineView.height/2.0
            self.smallLineView.clipsToBounds = true
            self.smallLineView.alpha = 0
        }
    }
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var stickyBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    
    var startPanPoint: CGPoint = .zero
    var animator = UIViewPropertyAnimator()
    var viewTranslation = CGPoint(x: 0, y: 0)
    
    //Mark:- LifeCycle
    //================
    override func viewDidLoad() {
        super.viewDidLoad()
        //TripAdiser photo
        TAViewModel.shared.clearData()
        if !(self.viewModel.hotelInfo?.locid?.isEmpty ?? true){
            TAViewModel.shared.hotelId = self.viewModel.hotelInfo?.hid ?? ""
            TAViewModel.shared.getTripAdvisorDetails()
        }
        self.footerView.isHidden = true
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 13.0, *) {
            self.statusBarStyle = .lightContent
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.statusBarColor = AppColors.clear
        if #available(iOS 13.0, *) {
            //            self.isModalInPresentation = true
            self.statusBarStyle = .darkContent
        }
    }
    
    override func initialSetup() {
        self.isDeviceHasBadzel = UIDevice.isIPhoneX
        self.viewModel.getHotelDistanceAndTimeInfo()
        self.configUI()
        self.registerNibs()
        self.footerViewSetUp()
        self.getSavedFilter()
        self.viewModel.getHotelInfoApi()
        self.smallLineView.backgroundColor = AppColors.themeWhite.withAlphaComponent(0.85)
        self.hotelTableView.bounces = true
        self.view.backgroundColor = .clear
        
        if #available(iOS 13.0, *) {} else {
            self.headerTopConstraint.constant = AppFlowManager.default.safeAreaInsets.top + 8
            self.tableViewTopConstraint.constant = AppFlowManager.default.safeAreaInsets.top + 8
            let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
            swipeGesture.delegate = self
            self.view.addGestureRecognizer(swipeGesture)
            self.view.backgroundColor = AppColors.clear
        }
        self.completion = { [weak self] in
            self?.hotelTableView.reloadData()
            self?.viewModel.getHotelInfoApi()
        }
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    override func dataChanged(_ note: Notification) {
        if let _ = note.object as? HCDataSelectionVC {
            delay(seconds: 1.0) { [weak self] in
                self?.hotelTableView.reloadRow(at: IndexPath(row: 0, section: 0), with: .none)
                self?.manageFavIcon()
            }
            
        }
    }
    
    override func setupColors() {
    }
    
    //Mark:- Methods
    //==============
    private func getStickyFooter() -> HotelFilterResultFooterView {
        let stV = HotelFilterResultFooterView(reuseIdentifier: "temp")
        stV.hotelFeesLabel.attributedText = (self.viewModel.hotelInfo?.price ?? 0.0).amountInDelimeterWithSymbol.asStylizedPrice(using: AppFonts.SemiBold.withSize(20.0))
        stV.noRoomsAvailable.isHidden = true
        stV.addSelectRoomTarget(target: self, action: #selector(selectRoomAction))
        return stV
    }
    
    @objc func selectRoomAction() {
        guard self.hotelTableView.numberOfSections > 1 else{return}
        self.hotelTableView.scrollToRow(at: IndexPath(row: 0, section: 1), at: .top, animated: true)
        delay(seconds: 0.6) { [weak self] in
            self?.manageHeaderView()
            self?.manageBottomRateView()
        }
        
    }
    
    internal func updateStickyFooterView() {
        // No Room available, show when rates Data empty based on filtered applies
        if self.viewModel.ratesData.isEmpty {
            if let stickyView = self.stickyView {
                stickyView.containerView.backgroundColor = AppColors.noRoomsAvailableFooterColor
                stickyView.containerView.addGredient(isVertical: false, cornerRadius: 0.0, colors: [AppColors.noRoomsAvailableFooterShadow, AppColors.noRoomsAvailableFooterColor])
                stickyView.noRoomsAvailable.isHidden = false
                stickyView.fromLabel.isHidden = true
                stickyView.hotelFeesLabel.isHidden = true
                stickyView.selectRoomLabel.isHidden = true
            }
        } else {
            //            self.hotelTableView.tableFooterView?.isHidden = false
            if let stickyView = self.stickyView {
                stickyView.containerView.backgroundColor = AppColors.themeGreen
                stickyView.containerView.addGredient(isVertical: false, cornerRadius: 0.0, colors: AppConstants.appthemeGradientColors)
                stickyView.noRoomsAvailable.isHidden = true
                stickyView.fromLabel.isHidden = false
                stickyView.hotelFeesLabel.isHidden = false
                stickyView.selectRoomLabel.isHidden = false
            }
        }
    }
    
    
    func hide(animated: Bool) {
        self.imageView.isHidden = false
        
        self.footerView.isHidden = true
        self.headerView.isHidden = true
        
        func setValue() {
            self.imageView.frame = self.sourceFrame
            self.hotelTableView.alpha = 0.0
            self.hotelTableView.frame = self.tableFrameHidden
            self.mainView.backgroundColor = AppColors.themeBlack.withAlphaComponent(0.001)
            self.view.layoutIfNeeded()
        }
        
        func manageOnComplition() {
            self.removeFromParentVC
            self.headerView.isHidden = false
            self.onCloseHandler?()
        }
        
        if animated {
            let animator = UIViewPropertyAnimator(duration: AppConstants.kAnimationDuration, curve: .linear) {
                setValue()
            }
            animator.addCompletion { (position) in
                manageOnComplition()
            }
            animator.startAnimation()
        }
        else {
            setValue()
            manageOnComplition()
        }
        
    }
    
    func footerViewSetUp() {
        if isDeviceHasBadzel{
            self.footerViewHeightConstraint.constant = 84
        }
        self.stickyView = getStickyFooter()
        if let stickyView = self.stickyView {
            stickyView.frame = self.footerView.bounds
            self.footerView.addSubview(stickyView)
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
        self.view.backgroundColor = AppColors.clear
        self.mainView.backgroundColor = AppColors.themeBlack.withAlphaComponent(0.001)
        self.headerView.configureNavBar(title: nil , isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false, isDivider: false, backgroundType: .blurAnimatedView(isDark: false))
        self.manageFavIcon()
        self.headerView.configureFirstRightButton(normalImage: #imageLiteral(resourceName: "CancelButtonWhite"), selectedImage: #imageLiteral(resourceName: "black_cross"), normalTitle: nil, selectedTitle: nil, normalColor: nil, selectedColor: nil)
        self.headerView.firstRightButton.imageEdgeInsets = UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 0)
        self.headerView.firstLeftButtonLeadingConst.constant = 4.5
        self.headerView.firstRightButton.addTarget(self, action: #selector(self.cancelButtonAction), for: .touchUpInside)
        self.headerView.leftButton.addTarget(self, action: #selector(self.fevButtonAction), for: .touchUpInside)
        // setting to make Close button pixel perfect
        self.headerView.firstRightButtonTrailingConstraint.constant = -3
        self.hotelTableView.roundTopCorners(cornerRadius: 10.0)
        self.headerView.navTitleLabel.numberOfLines = 1
        //------------------------ Golu Change --------------------
        if self.isAddingChild{
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panGestureRecognizerHandler))
            self.view.addGestureRecognizer(panGesture)
        }
        //------------------------ End --------------------
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
        self.hotelTableView.registerCell(nibName: NoImageDetailsCell.reusableIdentifier)
    }
    
    func manageFavIcon() {
        printDebug("Manage fav icon")
        let buttonImage: UIImage = self.viewModel.hotelInfo?.fav == "1" ? #imageLiteral(resourceName: "saveHotelsSelected") : #imageLiteral(resourceName: "saveHotels")
        let selectedFevImage: UIImage = self.viewModel.hotelInfo?.fav == "1" ? #imageLiteral(resourceName: "saveHotelsSelected") : #imageLiteral(resourceName: "save_icon_green")
        self.headerView.configureLeftButton(normalImage: buttonImage, selectedImage: selectedFevImage, normalTitle: nil, selectedTitle: nil, normalColor: nil, selectedColor: nil,isHideBackView: self.headerView.backView.isHidden)
        
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
        
        self.viewModel.syncPermanentTagsWithSelectedFilter()
        //self.viewModel.selectedTags = filter.roomMeal + filter.roomCancelation + filter.roomOther
    }
    
    internal func permanentTagsForFilteration() {
        if self.viewModel.permanentTagsForFilteration.isEmpty {
            self.viewModel.filterAppliedData.roomMeal = [ATMeal.Breakfast.title]
            self.viewModel.roomMealDataCopy = self.viewModel.filterAppliedData.roomMeal
            self.viewModel.filterAppliedData.roomCancelation = [ATCancellationPolicy.Refundable.title]
            self.viewModel.permanentTagsForFilteration = [ATMeal.Breakfast.title, ATCancellationPolicy.Refundable.title]
            self.viewModel.selectedTags = [ATMeal.Breakfast.title]
        }
    }
    
    internal func heightForRow(tableView: UITableView, indexPath: IndexPath, isForEstimateHeight: Bool) -> CGFloat {
        if !self.viewModel.hotelDetailsTableSectionData.isEmpty, self.viewModel.hotelDetailsTableSectionData[indexPath.section][indexPath.row] == .searchTagCell {
            return  isForEstimateHeight ? 100 : UITableView.automaticDimension
        } else {
            if indexPath.section == 0, indexPath.row == 2 {
                if let hotelData = self.viewModel.hotelData {
                    let text = hotelData.address + "\nMaps 1234"
                    let size = text.sizeCount(withFont: AppFonts.Regular.withSize(18.0), bundingSize: CGSize(width: UIDevice.screenWidth - 33.0, height: 10000.0))
                    return size.height + 46.5
                        + 13  + 2.0//y of textview 46.5 + bottom space 14.0 + 7.0
                }
                else {
                    return (UIDevice.screenHeight - UIApplication.shared.statusBarFrame.height) - (self.hotelImageHeight + 126.5)
                }
            }
            else if indexPath.section == 0, indexPath.row == 3 {
                //overview cell
                if !isForEstimateHeight {
                    return UITableView.automaticDimension
                }
                if let hotelData = self.viewModel.hotelData {
                    
                    let textView = UITextView()
                    textView.frame.size = CGSize(width: UIDevice.screenWidth - 32.0, height: 100.0)
                    textView.font = AppFonts.Regular.withSize(18)
                    textView.text = hotelData.info
                    if textView.numberOfLines >= 3{
                        if let lineHeight = textView.font?.lineHeight{
                            return ((3 * lineHeight) + 62)
                        }
                    }else{
                        let text = hotelData.address + "Maps    "
                        let size = text.sizeCount(withFont: AppFonts.Regular.withSize(18.0), bundingSize: CGSize(width: UIDevice.screenWidth - 32.0, height: 10000.0))
                        return size.height + 46.5
                            + 13.0  + 2.0//y of textview 46.5 + bottom space 14.0 + 7.0
                    }
                }
                else {
                    return (UIDevice.screenHeight - UIApplication.shared.statusBarFrame.height) - (self.hotelImageHeight + 126.5)
                }
                let maxH = AppFonts.Regular.withSize(18.0).lineHeight * 3.0
            }
            if !self.viewModel.hotelDetailsTableSectionData.isEmpty, self.viewModel.hotelDetailsTableSectionData[indexPath.section][indexPath.row] == .ratesEmptyStateCell {
                return 550
            }
            else if  !self.viewModel.hotelDetailsTableSectionData.isEmpty, self.viewModel.hotelDetailsTableSectionData[indexPath.section][indexPath.row] == .paymentPolicyCell {
                return isForEstimateHeight ? 100 : CGFloat.leastNormalMagnitude
            }
            else {
                return isForEstimateHeight ? 100 : UITableView.automaticDimension
            }
            
        }
        
    }
    
    internal func heightForHeaderView(tableView: UITableView, section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    internal func heightForFooterView(tableView: UITableView, section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    private func getFirstSectionData( hotelData: HotelDetails) -> [TableCellType] {
        var cellsArray: [TableCellType] = []
        if !self.viewModel.isAllImageDownloadFails{
            cellsArray.append(.imageSlideCell)
        }else{
            cellsArray.append(.noImageCell)
        }
        
        cellsArray.append(.hotelRatingCell)
        cellsArray.append(.addressCell)
        if !hotelData.info.isEmpty {
            cellsArray.append(.overViewCell)
        }
        if ((hotelData.amenities?.main) != nil) {
            cellsArray.append(.amenitiesCell)
        }
        if !hotelData.locid.isEmpty {
            cellsArray.append(.tripAdvisorRatingCell)
        }
        return cellsArray
    }
    
    internal func filterdHotelData(tagList: [String]) {
        self.viewModel.ratesData.removeAll()
        self.viewModel.roomRates.removeAll()
        self.viewModel.hotelDetailsTableSectionData.removeAll()
        self.viewModel.roomMealDataCopy = tagList
        self.viewModel.roomOtherDataCopy = tagList
        self.viewModel.roomCancellationDataCopy = tagList
        
        
        if let hotelData = self.viewModel.hotelData , let rates = hotelData.rates {
            self.viewModel.hotelDetailsTableSectionData.append(self.getFirstSectionData(hotelData: hotelData))
            self.viewModel.hotelDetailsTableSectionData.append([.searchTagCell])
            self.viewModel.ratesData = self.viewModel.newFiltersAccordingToTags(rates: rates, selectedTag: tagList)//self.viewModel.filteredRates(rates: rates , roomMealData: self.viewModel.roomMealDataCopy, roomOtherData: self.viewModel.roomOtherDataCopy, roomCancellationData: self.viewModel.roomCancellationDataCopy)
            if self.viewModel.ratesData.isEmpty {
                self.viewModel.hotelDetailsTableSectionData.append([.ratesEmptyStateCell])
            } else {
                for singleRate in self.viewModel.ratesData {
                    self.viewModel.roomRates.append(singleRate.roomData)
                    self.viewModel.hotelDetailsTableSectionData.append(singleRate.tableViewRowCell)
                }
            }
        }
        
        delay(seconds: 0.2){
            self.hotelTableView.reloadData()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            //self?.manageFavIcon()
        }
    }
    
    //Mark:- IBOActions
    //=================
    @IBAction func cancelButtonAction (_ sender: UIButton) {
        //------------------------ Golu Change --------------------
        if self.isAddingChild{
            self.headerView.isHidden = true
            self.smallLineView.alpha = 0
            //self.hide(animated: isHideWithAnimation)
        }else{
            if let cell = self.hotelTableView.cellForRow(at: [0,0]) as? HotelDetailsImgSlideCell{
                cell.imageCollectionView.scrollToItem(at: [0,0], at: .left, animated: true)
            }
            self.hotelTableView.showsVerticalScrollIndicator = false
            self.imageView.image = backImage
            self.dismiss(animated: true)
            
        }
        //------------------------ End --------------------
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
            // self.hide(animated: isHideWithAnimation)
            initialPanPoint = touchPoint
        }
    }
    
    func openMap() {
        guard let reqParams = self.viewModel.hotelSearchRequest?.requestParameters,let destParams = self.viewModel.hotelData else { return }
        AppGlobals.shared.redirectToMap(sourceView: view, originLat: reqParams.latitude, originLong: reqParams.longitude, destLat: destParams.lat, destLong: destParams.long)
    }
}


extension HotelDetailsVC{
    
    @objc func handleSwipes(_ sender: UIPanGestureRecognizer) {
        func reset() {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view.transform = .identity
            })
        }
        
        func moveView() {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
            })
        }
        
        guard let direction = sender.direction, direction.isVertical, direction == .down, self.hotelTableView.contentOffset.y <= 0
            else {
                reset()
                return
        }
        
        switch sender.state {
        case .changed:
            viewTranslation = sender.translation(in: self.view)
            moveView()
        case .ended:
            if viewTranslation.y < 200 {
                reset()
            } else {
                dismiss(animated: true, completion: nil)
            }
        case .cancelled:
            reset()
        default:
            break
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func downloadImages(){
        let downloadGroup = DispatchGroup()
        for (index, image) in (self.viewModel.hotelData?.atImageData ?? []).enumerated(){
            let imageView = UIImageView()
            if let imageurl = image.imagePath{
                downloadGroup.enter()
                imageView.setImageWithUrl(imageUrl: imageurl, placeholder: UIImage(), showIndicator: false) {[weak self] (img, err) in
                    guard let self = self else { return ()}
                    self.viewModel.hotelData?.atImageData[index].image = img
                    downloadGroup.leave()
                    return ()
                }
            }
        }
        downloadGroup.notify(queue: .main) {
            printDebug("all images downloaded")
            for image in (self.viewModel.hotelData?.atImageData ?? []){
                if image.image == nil, let index = self.viewModel.hotelData?.atImageData.firstIndex(where: {$0.imagePath == image.imagePath}){
                    self.viewModel.hotelData?.atImageData.remove(at: index)
                    self.viewModel.hotelData?.photos.remove(at: index)
                }
            }
            if self.viewModel.hotelData?.atImageData.count != 0{
                self.hotelTableView.reloadData()
                if let info = self.viewModel.hotelInfo {
                    if let url = info.thumbnail?.first, !UIImageView.imageExistForURL(url: url), let firstImage = self.viewModel.hotelData?.atImageData.first?.imagePath {
                        info.thumbnail = [firstImage]
                        _ = info.afterUpdate
                    }
                    self.delegate?.imageUpdated()
                }
            }else{
                self.viewModel.isAllImageDownloadFails = true
                self.filterdHotelData(tagList: self.viewModel.selectedTags)
                self.manageHeaderView()
                self.manageBottomRateView()
                self.hotelTableView.reloadData()
            }
        }
    }
    
}
