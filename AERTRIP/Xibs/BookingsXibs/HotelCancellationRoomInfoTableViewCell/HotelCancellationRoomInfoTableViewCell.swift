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
    internal var chargesData:  [(chargeName: String, chargeAmount: String, convertedAmount: NSAttributedString?)] = []
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
    @IBOutlet weak var rightArrowImageView: UIImageView!
    @IBOutlet weak var topDividerView: ATDividerView!
    @IBOutlet weak var bottomDividerView: ATDividerView!
    @IBOutlet weak var topDividerViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomDividerViewLeadingConstraint: NSLayoutConstraint!

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
        self.rightArrowImageView.image = #imageLiteral(resourceName: "rightArrow")
        
        self.rightArrowImageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2) //make the arrow to down
    }
    
    internal func configureCell(roomNumber: String, roomDetails: RoomDetailModel, isRoomSelected: Bool, isExpanded: Bool, currencyRate: CurrencyConversionRate?) {

        self.roomNumberLabel.text = roomNumber
        self.roomNameLabel.text = roomDetails.roomType
        //self.guestNamesLabel.text = roomDetails.guest.map { $0.fullName }.joined(separator: ", ")
        
        var nameArray  = [String]()
        roomDetails.guest.forEach { (guest) in
            var name = guest.name
            if !guest.dob.isEmpty {
                name += AppGlobals.shared.getAgeLastString(dob: guest.dob, formatter: Date.DateFormat.yyyy_MM_dd.rawValue)
            }
            nameArray.append(name)
        }
        self.guestNamesLabel.text = nameArray.joined(separator: ", ")
        if isRoomSelected {
            self.selectRoomButtonOutlet.setImage(#imageLiteral(resourceName: "CheckedGreenRadioButton"), for: .normal)
        } else {
            self.selectRoomButtonOutlet.setImage(#imageLiteral(resourceName: "UncheckedGreenRadioButton"), for: .normal)
        }
        self.topDividerView.isHidden = isExpanded
        self.bottomDividerView.isHidden = !isExpanded
        
        self.rightArrowImageView.transform = isExpanded ? CGAffineTransform(rotationAngle: -(CGFloat.pi/2)) : CGAffineTransform(rotationAngle: CGFloat.pi/2)
        
        self.setChargeData(roomDetails: roomDetails, currencyRate: currencyRate)
    }
    
    private func setChargeData(roomDetails: RoomDetailModel, currencyRate: CurrencyConversionRate?) {
        
        if let currency = currencyRate{
            self.chargesData = [
                (chargeName: LocalizedString.ConfirmationNo.localized, chargeAmount: roomDetails.voucher.isEmpty ? "-" : roomDetails.voucher, convertedAmount: nil),
                
                (chargeName: LocalizedString.SaleAmount.localized, chargeAmount: roomDetails.amountPaid.amountInDelimeterWithSymbol, convertedAmount: roomDetails.amountPaid.convertAmount(with: currency, using: AppFonts.Regular.withSize(16))),
                
                (chargeName: LocalizedString.CancellationCharges.localized, chargeAmount: roomDetails.cancellationCharges.amountInDelimeterWithSymbol, convertedAmount: roomDetails.cancellationCharges.convertCancellationAmount(with: currency, using: AppFonts.Regular.withSize(16))),
                
                (chargeName: LocalizedString.NetRefund.localized, chargeAmount: roomDetails.netRefund.amountInDelimeterWithSymbol, convertedAmount: roomDetails.netRefund.convertAmount(with: currency, using: AppFonts.Regular.withSize(16)))
            ]
        }else{
            self.chargesData = [
                (chargeName: LocalizedString.ConfirmationNo.localized, chargeAmount: roomDetails.voucher.isEmpty ? "-" : roomDetails.voucher, convertedAmount: nil),
                (chargeName: LocalizedString.SaleAmount.localized, chargeAmount: roomDetails.amountPaid.amountInDelimeterWithSymbol, convertedAmount: nil),
                (chargeName: LocalizedString.CancellationCharges.localized, chargeAmount: roomDetails.cancellationCharges.amountInDelimeterWithSymbol, convertedAmount: nil),
                (chargeName: LocalizedString.NetRefund.localized, chargeAmount: roomDetails.netRefund.amountInDelimeterWithSymbol, convertedAmount: nil)
            ]
        }
        self.chargesCollectionView.reloadData()
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
        cell.configureCell(chargeName: self.chargesData[indexPath.row].chargeName, chargeAmount: self.chargesData[indexPath.row].chargeAmount, convvertedAmount: self.chargesData[indexPath.row].convertedAmount)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 23.75)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
