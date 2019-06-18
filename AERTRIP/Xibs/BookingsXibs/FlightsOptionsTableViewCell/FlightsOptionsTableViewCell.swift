//
//  FlightsOptionsTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 31/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol FlightsOptionsTableViewCellDelegate: class {
    func addToCalender()
    func addToAppleWallet()
    func openWebCheckin()
    func openDirections()
    func openCallDetail()

}

class FlightsOptionsTableViewCell: UITableViewCell {

    //MARK:- Variables
    //MARK:===========
    weak var delegate: FlightsOptionsTableViewCellDelegate?
    private let optionImages: [UIImage] = [#imageLiteral(resourceName: "webCheckin"),#imageLiteral(resourceName: "directions"),#imageLiteral(resourceName: "call")]
    private let optionNames: [String] = [LocalizedString.WebCheckin.localized , LocalizedString.Directions.localized , LocalizedString.Call.localized]
    
    //MARK:- IBOutlets
    //MARK:===========
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var flightsOptionCollectionView: UICollectionView! {
        didSet {
            self.flightsOptionCollectionView.contentInset = UIEdgeInsets(top: 0.0, left: 1.0, bottom: 0.0, right: 1.0)
        }
    }
    @IBOutlet weak var addToCalenderBtnOutlet: UIButton!
    @IBOutlet weak var addToAppleWallet: UIButton!
    
    
    //MARK:- LifeCycle
    //MARK:===========
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureUI()
    }
    
    //MARK:- Functions
    //MARK:===========
    private func configureUI() {
        self.flightsOptionCollectionView.delegate = self
        self.flightsOptionCollectionView.dataSource = self
        self.flightsOptionCollectionView.registerCell(nibName: FlightsOptionCollectionViewCell.reusableIdentifier)
        self.addToCalenderBtnOutlet.layer.cornerRadius = 10.0
        self.addToCalenderBtnOutlet.layer.masksToBounds = true
        self.addToAppleWallet.layer.cornerRadius = 10.0
        self.addToAppleWallet.layer.masksToBounds = true
        
        self.addToAppleWallet.imageView?.size = CGSize(width: 30.0, height: 22.0)
        self.addToAppleWallet.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: -20.0, bottom: 0.0, right: 0.0)
        self.addToAppleWallet.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 16, bottom: 0.0, right: 0.0)
        
        self.addToCalenderBtnOutlet.imageView?.size = CGSize(width: 24.0, height: 24.0)
        self.addToCalenderBtnOutlet.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: 18.0, bottom: 0.0, right: 0.0)
        self.addToCalenderBtnOutlet.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 40.0, bottom: 0.0, right: 0.0)

    }
    
    internal func configureCell() {
        
    }
    
    //MARK:- IBActions
    //MARK:===========
    @IBAction func addToCalenderBtnAction(_ sender: UIButton) {
        self.delegate?.addToCalender()
    }
    
    @IBAction func addToAppleWalletBtnAction(_ sender: UIButton) {
        self.delegate?.addToAppleWallet()
    }
}

//MARK:- Extensions
//MARK:============
extension FlightsOptionsTableViewCell: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        printDebug(<#T##obj: T##T#>)
        return self.optionImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FlightsOptionCollectionViewCell.reusableIdentifier, for: indexPath) as? FlightsOptionCollectionViewCell else { return UICollectionViewCell() }
        cell.configureCell(optionImage: self.optionImages[indexPath.item], optionName: self.optionNames[indexPath.item], isLastCell: (indexPath.row == 2))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.item {
        case 0:
            delegate?.openWebCheckin()
        case 1:
            delegate?.openDirections()
        case 2:
            delegate?.openCallDetail()
        default:
            return
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 125.0, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }

}
