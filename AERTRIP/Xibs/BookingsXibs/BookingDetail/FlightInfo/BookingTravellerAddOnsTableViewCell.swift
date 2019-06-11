//
//  BookingTravellerAddOnsTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 11/06/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class BookingTravellerAddOnsTableViewCell: UITableViewCell {
    // MARK: - IBOutlet
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var travellerCollectionView: UICollectionView!
    @IBOutlet var travellerAddonsCollectionView: UICollectionView!
    
    var paxDetails: [Pax] = [] {
        didSet {
            self.reloadList()
        }
    }
    
    private var selectedIndex: Int = 0 {
        didSet {
            self.reloadList()
        }
    }
    
    private var detailsToShow: JSONDictionary = [:] {
        didSet {
            self.detailsTitle = Array(detailsToShow.keys)
            self.detailsTitle.sort { $0 < $1}
        }
    }
    private var detailsTitle: [String] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.titleLabel.font = AppFonts.SemiBold.withSize(16.0)
        self.titleLabel.text = "Travellers & Add-ons"
        self.registerXib()
    }
    
    private func registerXib() {
        self.travellerCollectionView.registerCell(nibName: BookingTravellerCollectionViewCell.reusableIdentifier)
        self.travellerCollectionView.dataSource = self
        self.travellerCollectionView.delegate = self

        self.travellerAddonsCollectionView.registerCell(nibName: BookingTravellerAddOnsCollectionViewCell.reusableIdentifier)
        self.travellerAddonsCollectionView.dataSource = self
        self.travellerAddonsCollectionView.delegate = self
    }
    
    private func reloadList() {
        
        if self.paxDetails.count > self.selectedIndex {
            self.detailsToShow = self.paxDetails[self.selectedIndex].detailsToShow
        }
        else {
            self.detailsToShow = [:]
        }
        self.travellerCollectionView.reloadData()
        self.travellerAddonsCollectionView.reloadData()
    }
}

// MARK: - UICollectionViewData Source and UICollectionViewDelegate methods

extension BookingTravellerAddOnsTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView === travellerCollectionView {
            //list
            return self.paxDetails.count
        }
        else {
            //details
            return self.detailsTitle.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView === travellerCollectionView {
            //list
            return UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
        }
        else {
            //details
            return UIEdgeInsets.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView === travellerCollectionView {
            //list
            let newW: CGFloat = ((collectionView.width - 32.0) / 4.5)
            return  CGSize(width: newW, height: collectionView.height)
        }
        else {
            //details
            return  CGSize(width: collectionView.width, height: 60.0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView === travellerCollectionView {
            //list
            return self.getCellForList(indexPath: indexPath)
        }
        else {
            //details
            return self.getCellForDetails(indexPath: indexPath)
        }
    }
    
    func getCellForList(indexPath: IndexPath) -> UICollectionViewCell{
        guard let cell = self.travellerCollectionView.dequeueReusableCell(withReuseIdentifier: BookingTravellerCollectionViewCell.reusableIdentifier, for: indexPath) as? BookingTravellerCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.paxData = self.paxDetails[indexPath.item]
        
        return cell
    }
    
    func getCellForDetails(indexPath: IndexPath) -> UICollectionViewCell{
        guard let cell = self.travellerAddonsCollectionView.dequeueReusableCell(withReuseIdentifier: BookingTravellerAddOnsCollectionViewCell.reusableIdentifier, for: indexPath) as? BookingTravellerAddOnsCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let title = detailsTitle[indexPath.item]
        cell.configure(title: title, detail: (self.detailsToShow[title] as? String) ?? LocalizedString.na.localized)
        
        return cell
    }
}
