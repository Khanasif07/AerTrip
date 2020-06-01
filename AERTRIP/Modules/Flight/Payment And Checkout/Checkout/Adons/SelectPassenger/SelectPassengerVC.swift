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
    @IBOutlet weak var legsLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var popUpBackView: UIView!
    
    let selectPassengersVM = SelectPassengersVM()
    
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
     self.doneButton.setTitle(self.selectPassengersVM.selectedContacts.isEmpty ? LocalizedString.Cancel.localized : LocalizedString.Done.localized, for: UIControl.State.normal)
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        self.selectPassengersVM.contactsComplition(self.selectPassengersVM.selectedContacts)
        dismiss(animated: true, completion: nil)
    }
    
}

extension SelectPassengerVC {
    
    func setUpSubView(){
        self.doneButton.roundedCorners(cornerRadius: 13)
        self.popUpBackView.roundedCorners(cornerRadius: 13)
        configureCollectionView()
    }
    
    func configureCollectionView(){
        self.passengerCollectionView.register(UINib(nibName: "selectPassengerCell", bundle: nil), forCellWithReuseIdentifier: "selectPassengerCell")
        self.passengerCollectionView.isScrollEnabled = true
        self.passengerCollectionView.bounces = true
        self.passengerCollectionView.delegate = self
        self.passengerCollectionView.dataSource = self
        self.passengerCollectionView.reloadData()
    }
    
}

extension SelectPassengerVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GuestDetailsVM.shared.guests.first?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectPassengerCell", for: indexPath) as? selectPassengerCell else { fatalError("selectPassengerCell not found") }
        if let firstGuestArray = GuestDetailsVM.shared.guests.first{
            cell.populateData(data: firstGuestArray[indexPath.item])
            cell.selectionImageView.isHidden = !self.selectPassengersVM.selectedContacts.contains(firstGuestArray[indexPath.item])
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: collectionView.frame.height - 32)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let allContacts = GuestDetailsVM.shared.guests.first else { return }
        
        if let index = self.selectPassengersVM.selectedContacts.firstIndex(where: { (cont) -> Bool in
            cont.id == allContacts[indexPath.item].id
        }){
            self.selectPassengersVM.selectedContacts.remove(at: index)
        }else{
        self.selectPassengersVM.selectedContacts.append(allContacts[indexPath.item])
        }
        
        collectionView.reloadItems(at: [IndexPath(item: indexPath.item, section: 0)])
        self.doneButton.setTitle(self.selectPassengersVM.selectedIndex.isEmpty ? LocalizedString.Cancel.localized : LocalizedString.Done.localized, for: UIControl.State.normal)
    }
    
}

