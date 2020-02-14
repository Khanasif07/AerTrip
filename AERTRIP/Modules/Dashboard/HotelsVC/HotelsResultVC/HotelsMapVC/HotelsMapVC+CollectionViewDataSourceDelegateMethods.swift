//
//  HotelResultVC+CollectionViewDataSourceDelegateMethods.swift
//  AERTRIP
//
//  Created by apple on 18/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

extension HotelsMapVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.hotelsMapCV.isHidden = self.viewModel.collectionViewLocArr.count == 0
        return self.viewModel.collectionViewLocArr.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard  self.viewModel.collectionViewLocArr.indices.contains(indexPath.item),let hData = self.viewModel.collectionViewList[self.viewModel.collectionViewLocArr[indexPath.item]] as? [HotelSearched] else {
            return UICollectionViewCell()
        }
        printDebug("***************************Hotel Detail \(indexPath.item) **********************")
        printDebug("Hotel data is \(hData)")
        if hData.count > 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HotelGroupCardCollectionViewCell.reusableIdentifier, for: indexPath) as? HotelGroupCardCollectionViewCell else {
                fatalError("HotelGroupCardCollectionViewCell not found")
            }
            
            cell.hotelListData = hData.first
            cell.delegate = self
            cell.shouldShowMultiPhotos = false
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HotelCardCollectionViewCell.reusableIdentifier, for: indexPath) as? HotelCardCollectionViewCell else {
                fatalError("HotelCardCollectionViewCell not found")
            }
            cell.hotelListData = hData.first
            cell.delegate = self
            cell.shouldShowMultiPhotos = false
            cell.updateConstraintForHotelResultMap()
            return cell
        }
        
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let _ = collectionView.cellForItem(at: indexPath) as? HotelGroupCardCollectionViewCell {
            self.expandGroup((self.viewModel.collectionViewList[self.viewModel.collectionViewLocArr[indexPath.row]] as? [HotelSearched]) ?? [])
        }
        else if let cell = collectionView.cellForItem(at: indexPath) as? HotelCardCollectionViewCell, let data = cell.hotelListData {
             //--------------------------- Golu Change ---------------------
            self.selectedIndexPath = indexPath
//            AppFlowManager.default.presentHotelDetailsVC(self,hotelInfo: data, sourceView: cell.contentView, sid: self.viewModel.sid, hotelSearchRequest: self.viewModel.hotelSearchRequest)
            
            presentController(cell: cell, hotelInfo: data, sid: self.viewModel.sid, hotelSearchRequest: self.viewModel.hotelSearchRequest)
        }
         //--------------------------- End ---------------------
//        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    }
    
    
     //--------------------------- Golu Change ---------------------
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
        self.present(nav, animated: true, completion: {
            cell.unfreezeAnimations()
        })
        
    }
    
}
