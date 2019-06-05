//
//  HotelCancellationRoomInfoTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 05/06/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol HotelCancellationRoomInfoTableViewCellDelegate: class {
    func selectRoomForCancellation(for indexPath: IndexPath)
    func cellExpand(for indexPath: IndexPath)
}

class HotelCancellationRoomInfoTableViewCell: UITableViewCell {
    
    //MARK:- Variables
    //MARK:===========
    internal var chargesData:  [(chargeName: String, chargeAmount: String)] = [(chargeName: "Confirmation No.", chargeAmount: "201806-030787"), (chargeName: "Sale Amount", chargeAmount: "₹ 27,000"), (chargeName: "Cancellation Charges", chargeAmount: "₹ 27,000"), (chargeName: "Net Refund", chargeAmount: "₹ 27,000")]
    internal weak var delegate: HotelCancellationRoomInfoTableViewCellDelegate?
    
    //MARK:- IBOutlets
    //MARK:===========
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var selectRoomButtonOutlet: UIButton!
    @IBOutlet weak var roomNumberLabel: UILabel!
    @IBOutlet weak var roomNameLabel: UILabel!
    @IBOutlet weak var guestNamesLabel: UILabel!
    @IBOutlet weak var chargesCollectionView: UICollectionView!
    @IBOutlet weak var cellExpandButtonOutlet: UIButton!
    @IBOutlet weak var topDividerView: ATDividerView!
    @IBOutlet weak var bottomDividerView: ATDividerView!
    
    //MARK:- LifeCycle
    //MARK:===========
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureUI()
    }
    
    //MARK:- Functions
    //MARK:===========
    private func configureUI() {
        //Font
        self.roomNumberLabel.font = AppFonts.Regular.withSize(18.0)
        self.roomNameLabel.font = AppFonts.Regular.withSize(18.0)
        self.guestNamesLabel.font = AppFonts.Regular.withSize(16.0)
        
        //Color
        self.roomNumberLabel.textColor = AppColors.themeBlack
        self.roomNameLabel.textColor = AppColors.themeBlack
        self.guestNamesLabel.textColor = AppColors.themeGray40
        
        self.chargesCollectionView.registerCell(nibName: HotleCancellationChargesCollectionViewCell.reusableIdentifier)
        self.chargesCollectionView.delegate = self
        self.chargesCollectionView.dataSource = self
        
        self.topDividerView.isHidden = true
        self.bottomDividerView.isHidden = false
    }
    
    internal func configureCell(roomNumber: String , roomName: String, guestNames: [String], isRoomSelected: Bool, isExpanded: Bool) {
        self.roomNumberLabel.text = roomNumber
        self.roomNameLabel.text = roomName
        self.guestNamesLabel.text = guestNames.joined(separator: ", ")
        if isRoomSelected {
            self.selectRoomButtonOutlet.setImage(#imageLiteral(resourceName: "tick"), for: .normal)
        } else {
            self.selectRoomButtonOutlet.setImage(#imageLiteral(resourceName: "untick"), for: .normal)
        }
        self.topDividerView.isHidden = isExpanded
        self.bottomDividerView.isHidden = !isExpanded
    }
    
    //MARK:- IBActions
    //MARK:===========
    @IBAction func selectRoomButtonAction(_ sender: UIButton) {
        if let superVw = self.superview as? UITableView, let indexPath = superVw.indexPath(for: self), let safeDelegate = self.delegate {
            safeDelegate.selectRoomForCancellation(for: indexPath)
        }
    }
    
    @IBAction func cellExpandButtonAction(_ sender: UIButton) {
        if let superVw = self.superview as? UITableView, let indexPath = superVw.indexPath(for: self), let safeDelegate = self.delegate {
            safeDelegate.cellExpand(for: indexPath)
        }
    }
}

//MARK:- Extensions
//MARK:============
extension HotelCancellationRoomInfoTableViewCell: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.chargesData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HotleCancellationChargesCollectionViewCell.reusableIdentifier, for: indexPath) as? HotleCancellationChargesCollectionViewCell else { return UICollectionViewCell() }
        cell.configureCell(chargeName: self.chargesData[indexPath.row].chargeName, chargeAmount: self.chargesData[indexPath.row].chargeAmount)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 23.75)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.zero
    }
}
