//
//  FlightDomesticMultiLegResultVC+CollectionViewDelegates.swift
//  AERTRIP
//
//  Created by Appinventiv on 27/08/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation



//MARK:- Header CollectionView Method
extension FlightDomesticMultiLegResultVC : UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numberOfLegs
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeaderCollectionView", for: indexPath) as? FlightSectorHeaderCell {
            cell.setUI( headerArray[indexPath.row])
            if ( indexPath.row == (headerArray.count - 1)) {
                cell.veticalSeparator.isHidden = true
            }
            else {
                cell.veticalSeparator.isHidden = false
            }
            return cell
        }
        return UICollectionViewCell()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var size = UIScreen.main.bounds.size
        size.height = 50
        
        if self.viewModel.numberOfLegs > 2 {
            
            if indexPath.row == 1 {
                size.width = size.width * 0.4
            }else {
                size.width = size.width * 0.5
            }
        }
        else {
            size.width = size.width * 0.5
        }
        return size
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        

        collectionView.reloadData()
        
        let visibleRect = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50)
        

        guard let theAttributes = collectionView.layoutAttributesForItem(at: indexPath) else { return }
        var cellFrameInSuperview = collectionView.convert(theAttributes.frame, to: self.view)
        cellFrameInSuperview.origin.y = 0.0
        
        // if tapped cell is completely visible , return
        if visibleRect.contains(cellFrameInSuperview) {
            return
        }
        else {
            let width = baseScrollView.frame.size.width / 2.0
            let offset : CGFloat
            if cellFrameInSuperview.origin.x < 0 {
                // cell is located at left side of screen
                offset = CGFloat(indexPath.row ) * width
                
            }else {
                // cell is located at right side of screen
                offset = CGFloat(indexPath.row - 1) * width
            }
            baseScrollView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
        }
        
    }
}
