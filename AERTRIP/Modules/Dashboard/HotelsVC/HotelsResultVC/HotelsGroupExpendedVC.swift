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
    private var itemsCount: Int = 0
    
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
        
        collectionView.collectionViewLayout = MyFlowLayout()
        
        delay(seconds: 0.3) {
            self.reload()
        }

    }
    
    func reload() {
        self.collectionView.performBatchUpdates({
            for idx in 0..<3 {
                self.collectionView.insertItems(at: [IndexPath(item: idx, section: 0)])
                self.itemsCount += 1
            }
        }, completion: { (isDone) in
            //            self.collectionView.reloadData()
        })
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


class MyFlowLayout: UICollectionViewFlowLayout {
    var insertingIndexPaths = [IndexPath]()
    
    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)
        
        insertingIndexPaths.removeAll()
        
        for update in updateItems {
            if let indexPath = update.indexPathAfterUpdate {
                insertingIndexPaths.append(indexPath)
            }
        }
    }
    
    override func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()
        
        insertingIndexPaths.removeAll()
    }
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath)
        
        //if insertingIndexPaths.contains(itemIndexPath) {
        attributes?.alpha = 0.0
        //    attributes?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        attributes?.transform = CGAffineTransform(translationX: 0, y: 500.0)
        
        print(attributes)
        //}
        
        return attributes
    }
}
