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

class HotelsGroupExpendedVC: BaseVC {
    
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
    weak var delegate: HotelsGroupExpendedVCDelegate?
    
    //MARK:- Properties
    //MARK:- Public
    
    //MARK:- Private
    private var itemsCount: Int = 10
    
    private var openCardsRect: [CGRect] = []
    private var closedCardsRect: [CGRect] = []
    private var cardViews: [UIView] = []
    let viewModel = HotelsGroupExtendedVM()
    private var selectedIndexPath: IndexPath?
    
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
    
    //MARK:- Methods
    //MARK:- Private
    private func initialSetups() {
        headerThumbView.layer.cornerRadius = headerThumbView.height / 2.0
        headerThumbView.layer.masksToBounds = true
        
        self.collectionView.register(UINib(nibName: "HotelCardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HotelCardCollectionViewCell")
        
        self.collectionView.isHidden = true
        
        delay(seconds: 0.2) { [weak self] in
            self?.saveCardsRact(forCards: 3)
            self?.collectionView.isHidden = false
            self?.animateCardsToShow()
        }
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
       AppFlowManager.default.presentHotelDetailsVCOverExpendCard(self,hotelInfo: self.viewModel.samePlaceHotels[indexPath.item], sourceView: self.view, sid: self.viewModel.sid, hotelSearchRequest: self.viewModel.hotelSearchRequest){
           self.statusBarColor = AppColors.themeWhite
           self.selectedIndexPath = indexPath
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
    self.delegate?.saveButtonActionFromLocalStorage(forHotel: forHotel)
    
                if let indexPath = self.collectionView.indexPath(forItem: sender) {
               self.viewModel.samePlaceHotels[indexPath.item].fav =  self.viewModel.samePlaceHotels[indexPath.item].fav == "0" ? "1" : "0"
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
