//
//  HotelResultVC+UICollectionView.swift
//  AERTRIP
//
//  Created by Admin on 31/01/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

class FilterCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetup()
    }
    
    private func initialSetup() {
        titleLabel.font = AppFonts.Regular.withSize(16)
        titleLabel.textColor = AppColors.themeTextColor
    }
}


extension HotelResultVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.filterArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = self.viewModel.filterArray[indexPath.item]
        let font = AppFonts.Regular.withSize(16.0)
        let width = text.widthOfString(usingFont: font) + 26// temporary
        return CGSize(width: width, height: collectionView.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCollectionViewCell", for: indexPath) as? FilterCollectionViewCell else { fatalError("FilterCollectionViewCell not found")}
        cell.titleLabel.text = self.viewModel.filterArray[indexPath.item]
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        AppFlowManager.default.showFilterVC(self, index: indexPath.item)
    }
    
}
