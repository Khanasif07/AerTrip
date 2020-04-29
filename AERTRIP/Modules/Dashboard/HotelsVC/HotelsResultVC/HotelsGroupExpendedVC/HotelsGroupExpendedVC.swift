//
//  HotelsGroupExpendedVC.swift
//  AERTRIP
//
//  Created by Admin on 26/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol HotelsGroupExpendedVCDelegate: class {
    func saveButtonActionFromLocalStorage(forHotel : HotelSearched)
}

class HotelsGroupExpendedVC: StatusBarAnimatableViewController {
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerThumbView: UIView!
    @IBOutlet weak var collectionView: ATCollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    @IBOutlet weak var headerViewTopConstraint: NSLayoutConstraint!
    weak var delegate: HotelsGroupExpendedVCDelegate?
    
    //MARK:- Properties
    internal var transition: CardTransition?
    override var statusBarAnimatableConfig: StatusBarAnimatableConfig{
        return StatusBarAnimatableConfig(prefersHidden: false, animation: .slide)
    }
    //MARK:- Public
    
    //MARK:- Private
    private var itemsCount: Int = 10
    
    private var openCardsRect: [CGRect] = []
    private var closedCardsRect: [CGRect] = []
    private var cardViews: [UIView] = []
    let viewModel = HotelsGroupExtendedVM()
    private var selectedIndexPath: IndexPath?
    var sheetView: PKBottomSheet?
    var viewTranslation = CGPoint(x: 0, y: 0)
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initialSetups()
    }
    
    override func bindViewModel() {
        //self.viewModel.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.statusBarColor = AppColors.clear
    }
    
    //MARK:- Methods
    //MARK:- Private
    private func initialSetups() {
        headerThumbView.layer.cornerRadius = headerThumbView.height / 2.0
        headerThumbView.layer.masksToBounds = true
        self.view.backgroundColor = UIColor.clear
        headerView.roundCorners(corners: [.topLeft,.topRight], radius: 10)
        if #available(iOS 13.0, *) {} else {
            headerViewTopConstraint.constant = AppFlowManager.default.safeAreaInsets.top + 8
            let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
            swipeGesture.delegate = self
            self.view.addGestureRecognizer(swipeGesture)
        }
        
        self.collectionView.register(UINib(nibName: "HotelCardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HotelCardCollectionViewCell")
        
        self.collectionView.isHidden = false//true
        
//        delay(seconds: 0.2) { [weak self] in
//            self?.saveCardsRact(forCards: 3)
//            self?.collectionView.isHidden = false
//            self?.animateCardsToShow()
//        }
    }
    
    private func saveCardsRact(forCards: Int) {
        let spaceFromBottom: CGFloat = 20.0
        let cardTail: CGFloat = 15.0
        let cardHeight: CGFloat = 205.0
        let spaceFromLeading: CGFloat = 20.0
        for idx in 0..<min(forCards, self.collectionView.subviews.count) {
            self.openCardsRect.append(self.collectionView.subviews[idx].frame)
            let newY = self.collectionView.height - (cardHeight + (cardTail * CGFloat(forCards - (idx + 1))) + spaceFromBottom)
            let newX = spaceFromLeading * CGFloat(idx)
            self.collectionView.subviews[idx].frame = CGRect(x: newX, y: newY, width: self.collectionView.width - (newX * 2.0), height: cardHeight)
            self.closedCardsRect.append(self.collectionView.subviews[idx].frame)
            self.cardViews.append(self.collectionView.subviews[idx])
            self.collectionView.sendSubviewToBack(self.collectionView.subviews[idx])
        }
    }
    
    private func animateCardsToShow() {
        for (idx, card) in self.cardViews.enumerated() {
            UIView.animate(withDuration: 0.5) { [weak self] in
                guard let sSelf = self else {return}
                card.frame = sSelf.openCardsRect[idx]
            }
        }
    }
    
    func animateCardsToClose() {
        for (idx, card) in self.cardViews.enumerated() {
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let sSelf = self else {return}
                card.frame = sSelf.closedCardsRect[idx]
                sSelf.collectionView.sendSubviewToBack(card)
            }
        }
    }
    
    //MARK:- Public
    
    //MARK:- Action
    
    override func dataChanged(_ note: Notification) {
        if let _ = note.object as? HotelDetailsVC {
            //fav updated from hotel details
            printDebug("fav updated from hotel details")
            if let indexPath = selectedIndexPath {
                self.viewModel.samePlaceHotels[indexPath.item].fav =  self.viewModel.samePlaceHotels[indexPath.item].fav == "0" ? "1" : "0"
                self.delegate?.saveButtonActionFromLocalStorage(forHotel: self.viewModel.samePlaceHotels[indexPath.item])
                self.collectionView.reloadData()
            }
        }
        
    }
}


extension HotelsGroupExpendedVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.samePlaceHotels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HotelCardCollectionViewCell", for: indexPath) as? HotelCardCollectionViewCell else {
            fatalError("HotelCardCollectionViewCell not found")
        }
        
        //        cell.hotelData = self.viewModel.hotels[indexPath.item]
        cell.hotelListData = self.viewModel.samePlaceHotels[indexPath.item]
        cell.saveButton.isSelected = self.viewModel.samePlaceHotels[indexPath.item].fav == "0" ? false : true
        //        cell.hotelNameLabel.text = "\(indexPath.item + 1)"
        //        cell.containerTopConstraint.constant = (indexPath.item == 0) ? 16.0 : 5.0
        //        cell.containerBottomConstraint.constant = 5.0
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = (indexPath.item == 0) ? 214.0 : 203.0
        return CGSize(width: UIDevice.screenWidth, height: CGFloat(height))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        AppFlowManager.default.presentHotelDetailsVCOverExpendCard(self,hotelInfo: self.viewModel.samePlaceHotels[indexPath.item], sourceView: self.view, sid: self.viewModel.sid, hotelSearchRequest: self.viewModel.hotelSearchRequest){[weak self] in
//            guard let self = self else {return}
////            self.statusBarColor = AppColors.themeWhite
//            self.selectedIndexPath = indexPath
//        }
        if let cell = collectionView.cellForItem(at: indexPath) as? HotelCardCollectionViewCell{
            self.selectedIndexPath = indexPath
            self.presentControllerDefault(cell: cell, hotelInfo: self.viewModel.samePlaceHotels[indexPath.item], sid: self.viewModel.sid, hotelSearchRequest: self.viewModel.hotelSearchRequest)
        }
    }
    
    
    func presentControllerDefault(cell:TransitionCellTypeDelegate, hotelInfo: HotelSearched, sid: String, hotelSearchRequest: HotelSearchRequestModel?){
        let vc = HotelDetailsVC.instantiate(fromAppStoryboard: .HotelResults)
        vc.viewModel.hotelInfo = hotelInfo
        vc.delegate = self
        vc.viewModel.hotelSearchRequest = hotelSearchRequest
        var img = cell.selfImage
        if cell.selfImage == nil{
            img = cell.viewScreenShot()
        }
        vc.backImage = img
        let nav = AppFlowManager.default.getNavigationController(forPresentVC: vc)
        self.present(nav, animated: true)
        
    }
    
    
    func presentController(cell:TransitionCellTypeDelegate, hotelInfo: HotelSearched, sid: String, hotelSearchRequest: HotelSearchRequestModel?){
        
        let vc = HotelDetailsVC.instantiate(fromAppStoryboard: .HotelResults)
        vc.viewModel.hotelInfo = hotelInfo
        vc.delegate = self
        vc.viewModel.hotelSearchRequest = hotelSearchRequest
        var img = cell.selfImage
        if cell.selfImage == nil{
           img = cell.viewScreenShot()
        }
        vc.backImage = img
        cell.freezeAnimations()
        let currentCellFrame = cell.layer.presentation()!.frame
        let cardFrame = cell.superview!.convert(currentCellFrame, to: nil)
        vc.modalPresentationStyle = .custom
        let frameWithoutTransform = { () -> CGRect in
            let center = cell.center
            let size = cell.bounds.size
            let r = CGRect(
                x: center.x - size.width / 2,
                y: center.y - size.height / 2,
                width: size.width,
                height: size.height
            )
            return cell.superview!.convert(r, to: nil)
        }()
        
        let params = CardTransition.Params(fromCardFrame: cardFrame, fromCardFrameWithoutTransform: frameWithoutTransform, fromCell: cell, img: img)
        self.transition = CardTransition(params: params)
        
        let nav = AppFlowManager.default.getNavigationController(forPresentVC: vc)//UINavigationController(rootViewController: vc)
        
        nav.transitioningDelegate = transition
        nav.modalPresentationCapturesStatusBarAppearance = true
        nav.modalPresentationStyle = .custom
        if let topVC = UIApplication.topViewController() {
            topVC .present(nav, animated: true, completion: {
                cell.unfreezeAnimations()
            })
        }
        
    }
    
    
}

// MARK: - HotelCardCollectionViewCellDelegate methods

extension HotelsGroupExpendedVC: HotelCardCollectionViewCellDelegate {
    func saveButtonAction(_ sender: UIButton, forHotel: HotelsModel) {
        printDebug("save button action ")
    }
    
    func saveButtonActionFromLocalStorage(_ sender: UIButton, forHotel: HotelSearched) {
        printDebug("save button action local storage ")
        guard AppGlobals.shared.isNetworkRechable(showMessage: true) else {return}
        self.delegate?.saveButtonActionFromLocalStorage(forHotel: forHotel)
        
        if let indexPath = self.collectionView.indexPath(forItem: sender) {
            if self.viewModel.isFromFavorite {
               self.viewModel.samePlaceHotels.remove(at: indexPath.item)
                if self.viewModel.samePlaceHotels.isEmpty {
                    sheetView?.dismiss(animated: true)
                    return
                }
            } else {
            //self.viewModel.samePlaceHotels[indexPath.item].fav =  self.viewModel.samePlaceHotels[indexPath.item].fav == "0" ? "1" : "0"
            }
            self.collectionView.reloadData()
        }
    }
    
    func pagingScrollEnable(_ indexPath: IndexPath, _ scrollView: UIScrollView) {
        printDebug("handle scrolling enabled")
    }
}


// MARK: - HotelDetailsVCDelegate

extension HotelsGroupExpendedVC: HotelDetailsVCDelegate {
    func hotelFavouriteUpdated() {
        print("favourite updated")
    }
}
extension HotelsGroupExpendedVC {
    
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
        
        guard let direction = sender.direction, direction.isVertical, direction == .down, self.collectionView.contentOffset.y <= 0
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
}
