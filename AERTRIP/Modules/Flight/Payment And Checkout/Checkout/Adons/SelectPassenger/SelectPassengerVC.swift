//
//  SelectPassengerVC.swift
//  AERTRIP
//
//  Created by Appinventiv on 28/05/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class SelectPassengerVC : BaseVC {
    
    @IBOutlet weak var transparentBackView: UIView!
    @IBOutlet weak var passengerCollectionView: UICollectionView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var selectPassengersLabel: UILabel!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var legsLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var popUpBackView: UIView!
    
    @IBOutlet weak var headerDetailsStackBottom: NSLayoutConstraint!
    
    let selectPassengersVM = SelectPassengersVM()
    
    var updatedFlightData: ((SeatMapModel.SeatMapFlight) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpSubView()
    }
    
    override func setupFonts() {
        super.setupFonts()
        selectPassengersLabel.font = AppFonts.Regular.withSize(14)
        titleLabel.font = AppFonts.SemiBold.withSize(18)
        legsLabel.font = AppFonts.SemiBold.withSize(14)
        doneButton.titleLabel?.font = AppFonts.SemiBold.withSize(20)
    }
    
    override func setupColors() {
        super.setupColors()
        self.selectPassengersLabel.textColor = AppColors.themeGray40
        self.legsLabel.textColor = AppColors.themeGray60
        doneButton.titleLabel?.textColor = AppColors.themeGreen
    }
    
    override func setupTexts() {
        super.setupTexts()
        self.doneButton.setTitle(LocalizedString.Cancel.localized, for: UIControl.State.normal)
        
//     self.doneButton.setTitle(self.selectPassengersVM.selectedContacts.isEmpty ? LocalizedString.Cancel.localized : LocalizedString.Done.localized, for: UIControl.State.normal)
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        self.selectPassengersVM.contactsComplition(self.selectPassengersVM.selectedContacts)
        dismiss(animated: true, completion: nil)
    }
    
}

extension SelectPassengerVC {
    
    func setUpSubView(){
//        let tap = UITapGestureRecognizer(target: self, action: #selector(backViewTapped))
//        transparentBackView.addGestureRecognizer(tap)
        self.doneButton.roundedCorners(cornerRadius: 13)
        self.popUpBackView.roundedCorners(cornerRadius: 13)
        self.selectPassengersVM.getAllowedPassengerForParticularAdon()
        configureCollectionView()
        setupForView()
    }
    
    @objc func backViewTapped(){
        dismiss(animated: true, completion: nil)
    }
    
    func configureCollectionView(){
        self.passengerCollectionView.register(UINib(nibName: "SelectPassengerCell", bundle: nil), forCellWithReuseIdentifier: "SelectPassengerCell")
        self.passengerCollectionView.isScrollEnabled = true
        self.passengerCollectionView.bounces = true
        self.passengerCollectionView.delegate = self
        self.passengerCollectionView.dataSource = self
        self.passengerCollectionView.reloadData()
    }
    
    func setupForView() {
        
        switch self.selectPassengersVM.setupFor {
      
        case .seatSelection:
            selectPassengersLabel.isHidden = true
            emptyView.isHidden = true
            titleLabel.text = selectPassengersVM.selectedSeatData.columnData.seatNumber + " • ₹\(selectPassengersVM.selectedSeatData.columnData.amount)"
            legsLabel.text = selectPassengersVM.selectedSeatData.columnData.getCharactericstic()
            legsLabel.textColor = AppColors.themeGray40
            legsLabel.font = AppFonts.Regular.withSize(14)
            headerDetailsStackBottom.constant = 21
            selectPassengersVM.initalPassengerForSeat = selectPassengersVM.selectedSeatData.columnData.passenger
            
        case .meals:
            self.selectPassengersLabel.text = LocalizedString.Select_Passengers_To_Assign_This_Meal.localized
            self.titleLabel.text = "\( self.selectPassengersVM.adonsData.ssrName?.name ?? "") • ₹ \(self.selectPassengersVM.adonsData.price)"
      
        case .baggage:
            self.selectPassengersLabel.text = LocalizedString.Select_Passengers_To_Assign_This_Meal.localized
            self.titleLabel.text = "\( self.selectPassengersVM.adonsData.ssrName?.name ?? "") • ₹ \(self.selectPassengersVM.adonsData.price)"
            
        case .others:
            self.selectPassengersLabel.text = LocalizedString.Select_Passengers.localized
            self.titleLabel.text = self.selectPassengersVM.adonsData.ssrName?.name
        
        }
    }
}

extension SelectPassengerVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.selectPassengersVM.allowedPassengers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectPassengerCell", for: indexPath) as? SelectPassengerCell else { fatalError("SelectPassengerCell not found") }
       
        if let firstGuestArray = GuestDetailsVM.shared.guests.first{
            if selectPassengersVM.setupFor == .seatSelection {
                cell.setupCellFor(firstGuestArray[indexPath.item], selectPassengersVM.selectedSeatData, selectPassengersVM.seatDataArr)
            }else{
                
                cell.populateData(data: self.selectPassengersVM.allowedPassengers[indexPath.item])
                cell.selectionImageView.isHidden = !self.selectPassengersVM.selectedContacts.contains(self.selectPassengersVM.allowedPassengers[indexPath.item])
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if selectPassengersVM.setupFor == .seatSelection {
           return CGSize(width: 80, height: collectionView.frame.height)
        }
        return CGSize(width: 80, height: collectionView.frame.height - 32)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectPassengersVM.setupFor == .seatSelection {
            didSelectForSeatSelection(indexPath, collectionView)
        } else {
          didSelect(indexPath, collectionView)
        }
    }

    private func didSelectForSeatSelection(_ indexPath: IndexPath,_ collectionView: UICollectionView) {
        
        guard let allContacts = GuestDetailsVM.shared.guests.first, allContacts.indices.contains(indexPath.item) else { return }
        
        let passenger = allContacts[indexPath.item]
        
        if selectPassengersVM.selectedSeatData.columnData.passenger?.id == passenger.id {
            selectPassengersVM.selectedSeatData.columnData.passenger = nil
            selectPassengersVM.resetFlightData(nil)
        } else {
            selectPassengersVM.selectedSeatData.columnData.passenger = passenger
            selectPassengersVM.resetFlightData(passenger)
            
        }
        updatedFlightData?(selectPassengersVM.flightData)
        collectionView.reloadData()
        doneButton.setTitle(LocalizedString.Done.localized, for: .normal)
        //        let isPassengerModified = selectPassengersVM.seatModel.columnData.passenger?.id != selectPassengersVM.initalPassengerForSeat?.id
        //        doneButton.setTitle(isPassengerModified ? LocalizedString.Done.localized : LocalizedString.Cancel.localized, for: .normal)
    }
    
    private func didSelect(_ indexPath: IndexPath,_ collectionView: UICollectionView) {
        
//        guard let allContacts = GuestDetailsVM.shared.guests.first else { return }
        
        if let index = self.selectPassengersVM.selectedContacts.firstIndex(where: { (cont) -> Bool in
            cont.id == self.selectPassengersVM.allowedPassengers[indexPath.item].id
        }){
            if self.selectPassengersVM.freeMeal {
                AppToast.default.showToastMessage(message: LocalizedString.Passenger_Cannot_Be_Deselected_For_Meal.localized)
                return }
            self.doneButton.setTitle(LocalizedString.Done.localized, for: UIControl.State.normal)

            self.selectPassengersVM.selectedContacts.remove(at: index)
        }else{
            self.doneButton.setTitle(LocalizedString.Done.localized, for: UIControl.State.normal)
            self.selectPassengersVM.selectedContacts.append(self.selectPassengersVM.allowedPassengers[indexPath.item])
        }
        
        collectionView.reloadItems(at: [IndexPath(item: indexPath.item, section: 0)])
    }
    
}

