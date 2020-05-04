//
//  BookingTravellerAddOnsTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 11/06/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol TravellerAddOnsCellHeightDelegate:NSObjectProtocol{
    func needToUpdateHeight(at index:IndexPath)
}

class BookingTravellerAddOnsTableViewCell: UITableViewCell {
    // MARK: - IBOutlet
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var travellerCollectionView: UICollectionView!
    @IBOutlet weak var travellerAddonsCollectionView: UICollectionView!
    @IBOutlet weak var listCollectionHeightConstaint: NSLayoutConstraint!
    
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
    
    var flightDetail: FlightDetail? 
    
    private var detailsToShow: JSONDictionary = [:] {
        didSet {
            self.detailsTitle = Array(detailsToShow.keys)
            for title in self.detailsTitle{
                if (self.detailsToShow[title] as? String ?? "").isEmpty || (self.detailsToShow[title] as? String ?? "") == "-"{
                    if isFrequentFlyer(text: title) {
                        // do nothing
                    }else {
                    self.detailsTitle.remove(object: title)
                    }
                }
            }
            self.detailsTitle.sort { $0 < $1}
        }
    }
    private var detailsTitle: [String] = []
    weak var heightDelegate:TravellerAddOnsCellHeightDelegate?
    var parentIndexPath:IndexPath = [0,0]
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.titleLabel.font = AppFonts.SemiBold.withSize(16.0)
        self.titleLabel.text = "Travellers & Add-ons"
        self.registerXib()
        self.travellerAddonsCollectionView.isScrollEnabled = false
    }
    
    private func registerXib() {
        self.travellerCollectionView.registerCell(nibName: BookingTravellerCollectionViewCell.reusableIdentifier)
        self.travellerCollectionView.dataSource = self
        self.travellerCollectionView.delegate = self

        self.travellerAddonsCollectionView.registerCell(nibName: BookingTravellerAddOnsCollectionViewCell.reusableIdentifier)
        self.travellerAddonsCollectionView.registerCell(nibName: BookingFequentFlyerCollectionViewCell.reusableIdentifier)
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
        var height = 0.0
        var isFirstFF = true
        var ffCounter = 0
        self.detailsTitle.forEach { (value) in
            if isFrequentFlyer(text: value) {
                height += (isFirstFF ? 74 : 44)
                isFirstFF = false
                ffCounter += 1
            } else {
                height += 60
            }
        }
        if ffCounter > 1 {
            height += 16
        }
        self.listCollectionHeightConstaint.constant = CGFloat(height)//CGFloat(self.detailsTitle.count * 60)
        self.travellerCollectionView.reloadData()
        self.travellerAddonsCollectionView.reloadData()
    }
    
    private func isFirstFrequentFlyer(text:String) -> Bool {
        return text.lowercased().contains("8Frequent Flyer".lowercased())
    }
    
    private func isFrequentFlyer(text:String) -> Bool {
        return text.lowercased().contains("Frequent Flyer".lowercased())
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
            return UIEdgeInsets(top: 0.0, left: 12.0, bottom: 0.0, right: 16.0)
        }
        else {
            //details
            return UIEdgeInsets.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView === travellerCollectionView {
            //list
            let newW: CGFloat = 83//((collectionView.width - 32.0) / 3.5)
            return  CGSize(width: newW, height: 120)
        }
        else {
            //details
            
            if isFrequentFlyer(text: detailsTitle[indexPath.item]) {
                let isFirstFF = isFirstFrequentFlyer(text: detailsTitle[indexPath.item])
                return  CGSize(width: collectionView.width, height: isFirstFF ? 74.0 : 44)
            }
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
            
            if isFrequentFlyer(text: detailsTitle[indexPath.item]) {
                return self.getCellForFrequentFlyer(indexPath: indexPath)
            } else {
                return self.getCellForDetails(indexPath: indexPath)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView === travellerCollectionView {
            //list
            self.selectedIndex = indexPath.item
            self.heightDelegate?.needToUpdateHeight(at: self.parentIndexPath)
        }
        else {
            //details
        }
    }
    
    func getCellForList(indexPath: IndexPath) -> UICollectionViewCell{
        guard let cell = self.travellerCollectionView.dequeueReusableCell(withReuseIdentifier: BookingTravellerCollectionViewCell.reusableIdentifier, for: indexPath) as? BookingTravellerCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.paxData = self.paxDetails[indexPath.item]
        cell.isPaxSelected = (self.selectedIndex == indexPath.item)
        cell.reduceLeadingAndTrailing()
        return cell
    }
    
    func getCellForDetails(indexPath: IndexPath) -> UICollectionViewCell{
        guard let cell = self.travellerAddonsCollectionView.dequeueReusableCell(withReuseIdentifier: BookingTravellerAddOnsCollectionViewCell.reusableIdentifier, for: indexPath) as? BookingTravellerAddOnsCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        var title = detailsTitle[indexPath.item]
        let detail = (self.detailsToShow[title] as? String) ?? LocalizedString.na.localized
        title.removeFirst()
        cell.configure(title: title, detail: detail)
        
        return cell
    }
    
    func getCellForFrequentFlyer(indexPath: IndexPath) -> UICollectionViewCell{
        guard let cell = self.travellerAddonsCollectionView.dequeueReusableCell(withReuseIdentifier: BookingFequentFlyerCollectionViewCell.reusableIdentifier, for: indexPath) as? BookingFequentFlyerCollectionViewCell else {
            return UICollectionViewCell()
        }
        let title = detailsTitle[indexPath.item]
        if let detail = self.detailsToShow[title] as? FF {
            cell.frequentFlyer = detail
        }
        cell.showFrequentFlyerView = isFirstFrequentFlyer(text: title)
        if let code = self.flightDetail?.carrierCode, !code.isEmpty {
            let imageUrl = AppGlobals.shared.getAirlineCodeImageUrl(code: code)
            cell.airlineIconView.setImageWithUrl(imageUrl, placeholder: AppPlaceholderImage.default, showIndicator: true)
        }
        return cell
    }
    
    
}
