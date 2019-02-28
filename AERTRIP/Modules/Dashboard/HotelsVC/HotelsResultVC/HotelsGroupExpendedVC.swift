//
//  HotelsGroupExpendedVC.swift
//  AERTRIP
//
//  Created by Admin on 26/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HotelsGroupExpendedVC: BaseVC {
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var headerThumbView: UIView!
    @IBOutlet weak var collectionView: ATCollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    
    //MARK:- Properties
    //MARK:- Public
    
    //MARK:- Private
    private var itemsCount: Int = 10
    private var openCardsRect: [CGRect] = []
    private var closedCardsRect: [CGRect] = []
    private var cardViews: [UIView] = []
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initialSetups()
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
}


extension HotelsGroupExpendedVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.itemsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HotelCardCollectionViewCell", for: indexPath) as? HotelCardCollectionViewCell else {
            fatalError("HotelCardCollectionViewCell not found")
        }
        
//        cell.hotelData = self.viewModel.hotels[indexPath.item]
        cell.hotelNameLabel.text = "\(indexPath.item + 1)"
        cell.containerTopConstraint.constant = (indexPath.item == 0) ? 16.0 : 5.0
        cell.containerBottomConstraint.constant = 5.0
//        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = (indexPath.item == 0) ? 214.0 : 203.0
        return CGSize(width: UIDevice.screenWidth, height: CGFloat(height))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
}

extension HotelsGroupExpendedVC: PKBottomSheetDelegate {
    func willHide(_ sheet: PKBottomSheet) {
        self.animateCardsToClose()
    }
}
