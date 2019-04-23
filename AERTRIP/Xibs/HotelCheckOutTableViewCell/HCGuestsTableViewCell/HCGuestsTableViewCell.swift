//
//  HCGuestsTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 25/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol HCGuestsTableViewCellDelegate: class {
    func emailItineraryButtonAction(_ sender: UIButton , indexPath: IndexPath)
}

class HCGuestsTableViewCell: UITableViewCell {
    
    //Mark:- Variables
    //================
    internal var travellers = [TravellersList]()
    internal var delegate: HCGuestsTableViewCellDelegate?
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var guestLabel: UILabel!
    @IBOutlet weak var emailItineraryButton: UIButton!
    @IBOutlet weak var guestsCollectionView: UICollectionView! {
        didSet {
            self.guestsCollectionView.delegate = self
            self.guestsCollectionView.dataSource = self
            self.guestsCollectionView.contentInset = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 0.0)
        }
    }
    @IBOutlet weak var dividerView: ATDividerView!
    
    //Mark:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
    }
    
    //Mark:- Functions
    //================
    ///Config UI
    private func configUI() {
        //Font
        self.guestLabel.font = AppFonts.SemiBold.withSize(16.0)
        self.emailItineraryButton.titleLabel?.font = AppFonts.Regular.withSize(14.0)
        //Text
        self.guestLabel.text = LocalizedString.Guests.localized
        self.emailItineraryButton.setTitle(LocalizedString.EmailItinerary.localized, for: .normal)
        //Color
        self.guestLabel.textColor = AppColors.themeBlack
        self.emailItineraryButton.setTitleColor(AppColors.themeGreen, for: .normal)
        self.guestsCollectionView.registerCell(nibName: HCGuestsDetailsCollectionViewCell.reusableIdentifier)
    }
    
    ///Email Itinerary Button Action
    @IBAction func emailItineraryButtonAction(_ sender: UIButton) {
        if let tableView = self.superview as? UITableView, let indexPath = tableView.indexPath(forItem: sender) {        self.delegate?.emailItineraryButtonAction(sender, indexPath: indexPath)
        }
    }
}

//Mark:- UICollectionView Delegate DataSource DelegateFlowLayout
//==============================================================
extension HCGuestsTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.travellers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HCGuestsDetailsCollectionViewCell.reusableIdentifier, for: indexPath) as? HCGuestsDetailsCollectionViewCell else { return UICollectionViewCell() }
//        self.travellers[indexPath.item]
        let name = self.travellers[indexPath.item].pax_type == "child" ? "\(self.travellers[indexPath.item].first_name) \(self.travellers[indexPath.item].middle_name) \(self.travellers[indexPath.item].last_name) (\(self.travellers[indexPath.item].age))"  : "\(self.travellers[indexPath.item].first_name) \(self.travellers[indexPath.item].middle_name) \(self.travellers[indexPath.item].last_name)"
        cell.configCell(name: name, firstName: self.travellers[indexPath.item].first_name , lastName: self.travellers[indexPath.item].last_name , imageUrl: self.travellers[indexPath.item].profile_image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: 75.0, height: 108.0)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }

}
