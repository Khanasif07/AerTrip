//
//  CurrencyOptionCell.swift
//  AERTRIP
//
//  Created by apple on 25/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class CurrencyOptionCell: UITableViewCell {
    // MARK: - IB Outlets
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var infoLabel: UILabel!
    
    // MARK: - Properties
    
    let currency: [String] = ["USD", "INR", "SGD", "EUR"]
    let currenyValue = "AED 1 = $ 19.40" // Default value for testing
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setUpText()
        self.setUpFont()
        self.setUpTextColor()
        self.doInitialSetup()
        self.registerXib()
    }
    
    private func doInitialSetup() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.reloadData()
    }
    
    private func setUpText() {
        self.titleLabel.text = LocalizedString.CurrencyOptions.localized
        self.infoLabel.text = LocalizedString.CheckOutCurrencyOptionInfoMessage.localized
    }
    
    private func setUpFont() {
        self.titleLabel.font = AppFonts.Regular.withSize(16.0)
        self.infoLabel.font = AppFonts.Regular.withSize(14.0)
    }
    
    private func setUpTextColor() {
        self.titleLabel.textColor = AppColors.themeBlack
        self.infoLabel.textColor = AppColors.themeGray60
    }
    
    private func registerXib() {
        self.collectionView.registerCell(nibName: CurrenyCollectionViewCell.reusableIdentifier)
    }
}

// MARK: - UICollectionViewDataSource and Delegate methods

extension CurrencyOptionCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.currency.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: CurrenyCollectionViewCell.reusableIdentifier, for: indexPath) as? CurrenyCollectionViewCell else {
            printDebug("CurrenyCollectionViewCell not found")
            return UICollectionViewCell()
        }
        cell.currencyNameLabel.text = self.currency[indexPath.row]
        cell.currencyConversionValueLabel.text = currenyValue
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = self.collectionView.cellForItem(at: indexPath) as? CurrenyCollectionViewCell {
            cell.setSelectedState()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = self.collectionView.cellForItem(at: indexPath) as? CurrenyCollectionViewCell {
            cell.setDeselectedState()
        }
    }
}
