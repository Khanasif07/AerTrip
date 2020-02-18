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
}

class HotelDetailsVC: StatusBarAnimatableViewController {
    
    //Mark:- Variables
    //================
    private(set) var viewModel = HotelDetailsVM()
    internal var completion: (() -> Void)? = nil
    internal weak var imagesCollectionView: UICollectionView?
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
//    internal var oldScrollPosition: CGPoint = .zero
    internal var didsmissOnScrollPosition: CGFloat = 200.0
    var stickyView: HotelFilterResultFooterView?
//    var tableFooterView: HotelFilterResultFooterView?
    weak var delegate : HotelDetailsVCDelegate?
    var onCloseHandler: (() -> Void)? = nil
    // manage wheter to hide with animate or note
    var isHideWithAnimation: Bool = true
    
    //------------------------ Golu Change --------------------
    var interactiveStartingPoint: CGPoint?
    var dismissalAnimator: UIViewPropertyAnimator?
    var backImage:UIImage? = UIImage()
    var isAddingChild = false
    var draggingDownToDismiss = false
    
    final class DismissalPanGesture: UIPanGestureRecognizer {}
    final class DismissalScreenEdgePanGesture: UIScreenEdgePanGestureRecognizer {}
    
    fileprivate lazy var dismissalPanGesture: DismissalPanGesture = {
        let pan = DismissalPanGesture()
        pan.maximumNumberOfTouches = 1
        return pan
    }()
    
    fileprivate lazy var dismissalScreenEdgePanGesture: DismissalScreenEdgePanGesture = {
        let pan = DismissalScreenEdgePanGesture()
        pan.edges = .left
        return pan
    }()
    
    @IBOutlet weak var heightOfHeader: NSLayoutConstraint!
    
    //------------------------ End --------------------
    
    @IBOutlet weak var footerViewHeightConstraint: NSLayoutConstraint!
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var headerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var hotelTableView: UITableView! {
        didSet {
            hotelTableView.delegate = self
            hotelTableView.dataSource = self
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
            self.smallLineView.alpha = 0
        }
    }
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var stickyBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainView: UIView!
    
    var startPanPoint: CGPoint = .zero
    var animator = UIViewPropertyAnimator()

    //Mark:- LifeCycle
    //================
    override func viewDidLoad() {
        //------------------------ Golu Change --------------------
        super.viewDidLoad()
        if self.isAddingChild{
            let panGes = UIPanGestureRecognizer(target: self, action: #selector(self.panHandler(_:)))
            panGes.delegate = self
            // self.view.addGestureRecognizer(panGes)
        }else{
            setPanGesture()
            
        }
        //------------------------ End --------------------
    }
    
    @objc func panHandler(_ sender: UIPanGestureRecognizer) {
        
        //        let translation = sender.translation(in: self.view)
        //
        //        if sender.state == .began {
        //            self.startPanPoint = translation
        //        }
        //        else if sender.state == .changed {
        //
        //            let moved = translation.y - self.startPanPoint.y
        //
        //            print(moved)
        //        }
        
        let progress = sender.translation(in: self.view).y / self.hotelTableView.height
        print(progress)
        switch sender.state {
        case .began:
            animator = UIViewPropertyAnimator(duration: 3, curve: .easeOut, animations: { [weak self] in
                guard let sSelf = self else {return}
                sSelf.imageView.frame = sSelf.sourceFrame
                sSelf.hotelTableView.alpha = 0.0
                //            sSelf.mainView.alpha = 0
                sSelf.hotelTableView.frame = sSelf.tableFrameHidden
            })
            animator.startAnimation()
            animator.pauseAnimation()

            animator.addCompletion { [weak self](position) in
                guard let sSelf = self else {return}
                print(position)
                sSelf.removeFromParentVC
                sSelf.headerView.isHidden = false
            }

        case .changed:
            animator.fractionComplete = progress
        case .ended:
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        default:
            ()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.statusBarStyle = .default
//        self.hotelTableView.reloadRow(at: IndexPath(row: 0, section: 0), with: .none)
        self.statusBarColor = AppColors.themeBlack.withAlphaComponent(0.4)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.statusBarColor = AppColors.clear
    }
    
    override func initialSetup() {
        self.viewModel.getHotelDistanceAndTimeInfo()
        self.configUI()
        self.registerNibs()
        self.footerViewSetUp()
       // self.permanentTagsForFilteration()
        self.getSavedFilter()
        self.completion = { [weak self] in
            self?.hotelTableView.reloadData()
            self?.viewModel.getHotelInfoApi()
        }
        if self.isAddingChild{
            self.viewModel.getHotelInfoApi()
        }
        self.smallLineView.backgroundColor = AppColors.themeWhite.withAlphaComponent(0.85)
        self.hotelTableView.bounces = true
        self.view.backgroundColor = .clear
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    //------------------------ Golu Change --------------------
    override var statusBarAnimatableConfig: StatusBarAnimatableConfig{
        return StatusBarAnimatableConfig(prefersHidden: true,
        animation: .slide)
    }
    //------------------------ End --------------------
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
        stV.hotelFeesLabel.text = (self.viewModel.hotelInfo?.price ?? 0.0).amountInDelimeterWithSymbol
        stV.noRoomsAvailable.isHidden = true
        stV.addSelectRoomTarget(target: self, action: #selector(selectRoomAction))
        return stV
    }
    
    @objc func selectRoomAction() {
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
            
//            if let tableFooterView = self.tableFooterView {
//                tableFooterView.containerView.backgroundColor = AppColors.noRoomsAvailableFooterColor
//                tableFooterView.containerView.addGredient(isVertical: false, cornerRadius: 0.0, colors: [AppColors.noRoomsAvailableFooterShadow, AppColors.noRoomsAvailableFooterColor])
//                tableFooterView.noRoomsAvailable.isHidden = false
//                tableFooterView.fromLabel.isHidden = true
//                tableFooterView.hotelFeesLabel.isHidden = true
//                tableFooterView.selectRoomLabel.isHidden = true
//            }
//            self.hotelTableView.tableFooterView?.isHidden = true
        } else {
//            self.hotelTableView.tableFooterView?.isHidden = false
            if let stickyView = self.stickyView {
                stickyView.containerView.backgroundColor = AppColors.themeGreen
                stickyView.containerView.addGredient(isVertical: false, cornerRadius: 0.0, colors: [AppColors.themeGreen, AppColors.shadowBlue])
                stickyView.noRoomsAvailable.isHidden = true
                stickyView.fromLabel.isHidden = false
                stickyView.hotelFeesLabel.isHidden = false
                stickyView.selectRoomLabel.isHidden = false
            }
            
//            if let tableFooterView = self.tableFooterView {
//                tableFooterView.containerView.backgroundColor = AppColors.themeGreen
//                tableFooterView.containerView.addGredient(isVertical: false, cornerRadius: 0.0, colors: [AppColors.themeGreen, AppColors.shadowBlue])
//                tableFooterView.noRoomsAvailable.isHidden = true
//                tableFooterView.fromLabel.isHidden = false
//                tableFooterView.hotelFeesLabel.isHidden = false
//                tableFooterView.selectRoomLabel.isHidden = false
//            }
        }
    }
    
    func show(onViewController: UIViewController, sourceView: UIView, animated: Bool) {
        self.isAddingChild = true
        self.parentVC = onViewController
        self.sourceView = sourceView
        onViewController.add(childViewController: self)
        self.setupBeforeAnimation()
        let newY = UIApplication.shared.statusBarFrame.height + 8.0
        self.headerTopConstraint.constant = 8.0
        let newImageFrame = CGRect(x: 0.0, y: newY, width: self.view.width, height: hotelImageHeight)
        let newTableFrame = CGRect(x: 0.0, y: newY, width: self.view.width, height: (self.view.height-(newY+AppFlowManager.default.safeAreaInsets.bottom)))
        
        self.footerView.isHidden = true
        self.headerView.isHidden = true
        
        func setValue() {
            self.imageView.frame = newImageFrame
            self.hotelTableView.frame = newTableFrame
            self.hotelTableView.alpha = 1.0
            self.mainView.backgroundColor = AppColors.themeBlack.withAlphaComponent(0.3)
            self.view.layoutIfNeeded()
        }
        
        func manageOnComplition() {
            self.imageView.isHidden = true
            self.footerView.isHidden = false
            self.headerView.isHidden = false
            self.smallLineView?.alpha = 1
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
        
//        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, animations: { [weak self] in
//            guard let sSelf = self else {return}
//            sSelf.imageView.frame = newImageFrame
//            sSelf.hotelTableView.frame = newTableFrame
//            sSelf.hotelTableView.alpha = 1.0
//            }, completion: { [weak self](isDone) in
//                guard let sSelf = self else {return}
//                sSelf.imageView.isHidden = true
//                sSelf.footerView.isHidden = false
//                sSelf.headerView.isHidden = false
//                sSelf.smallLineView?.alpha = 1
//        })
    }
    
    func hideOnScroll() {
        self.imageView.frame = CGRect(x: 0.0, y: didsmissOnScrollPosition, width: self.imageView.frame.size.width, height: self.imageView.frame.size.height)
        self.hide(animated: isHideWithAnimation)
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
        
//        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, animations: { [weak self] in
//            guard let sSelf = self else {return}
//            sSelf.imageView.frame = sSelf.sourceFrame
//            sSelf.hotelTableView.alpha = 0.0
////            sSelf.mainView.alpha = 0
//            sSelf.hotelTableView.frame = sSelf.tableFrameHidden
//            }, completion: { [weak self](isDone) in
//                guard let sSelf = self else {return}
//
//                sSelf.removeFromParentVC
//                sSelf.headerView.isHidden = false
//        })
    }
    
     func footerViewSetUp() {
        self.stickyView = getStickyFooter()
        if let stickyView = self.stickyView {
            stickyView.frame = self.footerView.bounds
            self.footerView.addSubview(stickyView)
        }
        
//        self.tableFooterView = getStickyFooter()
//        if let footerView = self.tableFooterView {
//            footerView.frame = self.footerView.bounds
////            self.hotelTableView.tableFooterView = footerView
//        }
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
        self.headerView.firstLeftButtonLeadingConst.constant = 4.5
        self.headerView.firstRightButton.addTarget(self, action: #selector(self.cancelButtonAction), for: .touchUpInside)
        self.headerView.leftButton.addTarget(self, action: #selector(self.fevButtonAction), for: .touchUpInside)
        // setting to make Close button pixel perfect
        self.headerView.firstRightButtonTrailingConstraint.constant = -3
        self.hotelTableView.roundTopCorners(cornerRadius: 10.0)
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
        
    internal func heightForRow(tableView: UITableView, indexPath: IndexPath) -> CGFloat {
        if !self.viewModel.hotelDetailsTableSectionData.isEmpty, self.viewModel.hotelDetailsTableSectionData[indexPath.section][indexPath.row] == .searchTagCell {
             return  UITableView.automaticDimension
        } else {
            if indexPath.section == 0, indexPath.row == 2 {
                if let hotelData = self.viewModel.hotelData {
                    let text = hotelData.address + "Maps    "
                    let size = text.sizeCount(withFont: AppFonts.Regular.withSize(18.0), bundingSize: CGSize(width: UIDevice.screenWidth - 32.0, height: 10000.0))
                    return size.height + 46.5
                        + 21.0  + 2.0//y of textview 46.5 + bottom space 14.0 + 7.0
                }
                else {
                    return (UIDevice.screenHeight - UIApplication.shared.statusBarFrame.height) - (211.0 + 126.5)
                }
            }
            else if indexPath.section == 0, indexPath.row == 3 {
                //overview cell
                if let hotelData = self.viewModel.hotelData {
                    
                    let textView = UITextView()
                    textView.frame.size = CGSize(width: UIDevice.screenWidth - 32.0, height: 100.0)
                    textView.font = AppFonts.Regular.withSize(18)
                    textView.text = hotelData.info
                    if textView.numberOfLines >= 3{
                        if let lineHeight = textView.font?.lineHeight{
                            return ((3 * lineHeight) + 70)
                        }
                    }else{
                    let text = hotelData.address + "Maps    "
                    let size = text.sizeCount(withFont: AppFonts.Regular.withSize(18.0), bundingSize: CGSize(width: UIDevice.screenWidth - 32.0, height: 10000.0))
                    return size.height + 46.5
                        + 21.0  + 2.0//y of textview 46.5 + bottom space 14.0 + 7.0
                    }
                }
                else {
                    return (UIDevice.screenHeight - UIApplication.shared.statusBarFrame.height) - (211.0 + 126.5)
                }
                let maxH = AppFonts.Regular.withSize(18.0).lineHeight * 3.0
            }
            if !self.viewModel.hotelDetailsTableSectionData.isEmpty, self.viewModel.hotelDetailsTableSectionData[indexPath.section][indexPath.row] == .ratesEmptyStateCell {
                return 550
            }
            else if  !self.viewModel.hotelDetailsTableSectionData.isEmpty, self.viewModel.hotelDetailsTableSectionData[indexPath.section][indexPath.row] == .paymentPolicyCell {
                return 0
                }
            else {
                 return UITableView.automaticDimension
            }
           
        }
        
    }
    
    internal func heightForHeaderView(tableView: UITableView, section: Int) -> CGFloat {
        return 0.0
    }
    
    internal func heightForFooterView(tableView: UITableView, section: Int) -> CGFloat {
        return 0.0
    }
    
    private func getFirstSectionData( hotelData: HotelDetails) -> [TableCellType] {
        var cellsArray: [TableCellType] = []
        cellsArray.append(.imageSlideCell)
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
            self.viewModel.ratesData = self.viewModel.filteredRates(rates: rates , roomMealData: self.viewModel.roomMealDataCopy, roomOtherData: self.viewModel.roomOtherDataCopy, roomCancellationData: self.viewModel.roomCancellationDataCopy)
            if self.viewModel.ratesData.isEmpty {
            self.viewModel.hotelDetailsTableSectionData.append([.ratesEmptyStateCell])
            } else {
                for singleRate in self.viewModel.ratesData {
                    self.viewModel.roomRates.append(singleRate.roomData)
                    self.viewModel.hotelDetailsTableSectionData.append(singleRate.tableViewRowCell)
                }
            }
        }
        
       self.hotelTableView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.manageFavIcon()
        }
    }
    
    //Mark:- IBOActions
    //=================
    @IBAction func cancelButtonAction (_ sender: UIButton) {
        //------------------------ Golu Change --------------------
        if self.isAddingChild{
            self.headerView.isHidden = true
            self.smallLineView.alpha = 0
            self.hide(animated: isHideWithAnimation)
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
            self.hide(animated: isHideWithAnimation)
            initialPanPoint = touchPoint
        }
    }
    
    func openMap() {
        guard let reqParams = self.viewModel.hotelSearchRequest?.requestParameters,let destParams = self.viewModel.hotelData else { return }
        AppGlobals.shared.redirectToMap(sourceView: view, originLat: reqParams.latitude, originLong: reqParams.longitude, destLat: destParams.lat, destLong: destParams.long)
    }
}


//------------------------ Golu Change --------------------
extension HotelDetailsVC{
    
    func setPanGesture(){
        hotelTableView.contentInsetAdjustmentBehavior = .never
        
        dismissalPanGesture.addTarget(self, action: #selector(handleDismissalPan(gesture:)))
        dismissalPanGesture.delegate = self
        
        dismissalScreenEdgePanGesture.addTarget(self, action: #selector(handleDismissalPan(gesture:)))
        dismissalScreenEdgePanGesture.delegate = self
        
        // Make drag down/scroll pan gesture waits til screen edge pan to fail first to begin
        dismissalPanGesture.require(toFail: dismissalScreenEdgePanGesture)
        hotelTableView.panGestureRecognizer.require(toFail: dismissalScreenEdgePanGesture)
        
        loadViewIfNeeded()
        view.addGestureRecognizer(dismissalPanGesture)
        view.addGestureRecognizer(dismissalScreenEdgePanGesture)
    }
       
       func didSuccessfullyDragDownToDismiss() {
           dismiss(animated: true)
           
       }
       func userWillCancelDissmissalByDraggingToTop(velocityY: CGFloat) {}
       
       func didCancelDismissalTransition() {
           // Clean up
           interactiveStartingPoint = nil
           dismissalAnimator = nil
           draggingDownToDismiss = false
        self.headerView.isHidden = false
        self.hotelTableView.showsVerticalScrollIndicator = true
//        self.view.setNeedsDisplay()
       }
       
       // This handles both screen edge and dragdown pan. As screen edge pan is a subclass of pan gesture, this input param works.
       @objc func handleDismissalPan(gesture: UIPanGestureRecognizer) {
           
           let isScreenEdgePan = gesture.isKind(of: DismissalScreenEdgePanGesture.self)
           let canStartDragDownToDismissPan = !isScreenEdgePan && !draggingDownToDismiss
           
           // Don't do anything when it's not in the drag down mode
           if canStartDragDownToDismissPan { return }
           
           let targetAnimatedView = gesture.view!
           let startingPoint: CGPoint
           
           if let p = interactiveStartingPoint {
               startingPoint = p
           } else {
               // Initial location
               startingPoint = gesture.location(in: nil)
               interactiveStartingPoint = startingPoint
           }
           
           let currentLocation = gesture.location(in: nil)
           let progress = isScreenEdgePan ? (gesture.translation(in: targetAnimatedView).x / 100) : (currentLocation.y - startingPoint.y) / 100
           let targetShrinkScale: CGFloat = 0.84
           let targetCornerRadius: CGFloat = GlobalConstants.cardCornerRadius
           
           func createInteractiveDismissalAnimatorIfNeeded() -> UIViewPropertyAnimator {
               if let animator = dismissalAnimator {
                   return animator
               } else {
                   let animator = UIViewPropertyAnimator(duration: 0, curve: .linear, animations: {
                       targetAnimatedView.transform = .init(scaleX: targetShrinkScale, y: targetShrinkScale)
                       targetAnimatedView.layer.cornerRadius = targetCornerRadius
                   })
                   animator.isReversed = false
                   animator.pauseAnimation()
                   animator.fractionComplete = progress
                   return animator
               }
           }
           
           switch gesture.state {
           case .began:
               dismissalAnimator = createInteractiveDismissalAnimatorIfNeeded()
               self.headerView.isHidden = true
               
           case .changed:
               dismissalAnimator = createInteractiveDismissalAnimatorIfNeeded()
               
               let actualProgress = progress
               let isDismissalSuccess = actualProgress >= 1.0
               
               dismissalAnimator!.fractionComplete = actualProgress
               self.headerView.isHidden = true
               if isDismissalSuccess {
                   dismissalAnimator!.stopAnimation(false)
                   dismissalAnimator!.addCompletion { [unowned self] (pos) in
                       switch pos {
                       case .end:
                           self.didSuccessfullyDragDownToDismiss()
                       default:
                           fatalError("Must finish dismissal at end!")
                       }
                   }
                   dismissalAnimator!.finishAnimation(at: .end)
               }
               
           case .ended, .cancelled:
               if dismissalAnimator == nil {
                   // Gesture's too quick that it doesn't have dismissalAnimator!
                   print("Too quick there's no animator!")
                   didCancelDismissalTransition()
                   return
               }

               dismissalAnimator!.pauseAnimation()
               dismissalAnimator!.isReversed = true
               
               // Disable gesture until reverse closing animation finishes.
               gesture.isEnabled = false
               dismissalAnimator!.addCompletion { [unowned self] (pos) in
                   self.didCancelDismissalTransition()
                   gesture.isEnabled = true
               }
               dismissalAnimator!.startAnimation()
           default:
               fatalError("Impossible gesture state? \(gesture.state.rawValue)")
           }
       }
}
