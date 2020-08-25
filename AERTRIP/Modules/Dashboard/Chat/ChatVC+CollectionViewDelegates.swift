//
//  ChatVC+CollectionViewDelegates.swift
//  AERTRIP
//
//  Created by Appinventiv on 24/03/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

extension ChatVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.chatVm.recentSearchesData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SuggestionsCell", for: indexPath) as? SuggestionsCell else {
                fatalError("SuggestionsCell not found")
        }
        cell.populateData(data: self.chatVm.recentSearchesData[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let object = self.chatVm.recentSearchesData[indexPath.item]
        if object.type == .hotel {
            let width = object.getTextWidth(73)
            let textWidth = width + 86
            let cellWidth = textWidth > 275 ? 275 : textWidth
            printDebug("width: \(width)")
            printDebug("textWidth: \(textWidth)")
            printDebug("cellWidth: \(cellWidth)")
            return CGSize(width: cellWidth , height: 73)
        } else {
            return CGSize(width: 164, height: 73)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
}
