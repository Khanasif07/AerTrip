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
    var onDismissCompletion: (() -> ())?
    
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
        doneButton.titleLabel?.textColor = AppColors.themeDarkGreen
    }
    
    override func setupTexts() {
        super.setupTexts()
//        self.doneButton.setTitle(LocalizedString.Cancel.localized, for: UIControl.State.normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        transformViewToOriginalState()
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        performDoneBtnAction()
    }
}

extension SelectPassengerVC {
    
    func setUpSubView(){
        self.doneButton.roundedCorners(cornerRadius: 13)
        self.popUpBackView.roundedCorners(cornerRadius: 13)
        self.selectPassengersVM.getAllowedPassengerForParticularAdon()
        self.configureCollectionView()
        self.setupForView()
        self.transparentBackView.backgroundColor = UIColor.clear
        self.transparentBackView.transform = CGAffineTransform(translationX: 0, y: transparentBackView.height)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
        self.doneButton.setTitle(LocalizedString.Done.localized, for: .normal)
        addDismissGesture()
    }
    
    private func transformViewToOriginalState() {
        UIView.animate(withDuration: 0.3, animations: {
            self.transparentBackView.transform = CGAffineTransform.identity
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        })
    }
    
    private func performDoneBtnAction(_ animationDuration: TimeInterval = 0.3) {
        //        self.selectPassengersVM.contactsComplition(self.selectPassengersVM.selectedContacts)
        
        UIView.animate(withDuration: animationDuration, animations: {
            self.transparentBackView.transform = CGAffineTransform(translationX: 0, y: self.transparentBackView.height)
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
        }) { (success) in
            self.dismiss(animated: false, completion: {
                self.onDismissCompletion?()
            })
        }
        
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
            let attString = NSMutableAttributedString(string: "\(selectPassengersVM.selectedSeatData.columnData.seatNumber)  •  ", attributes: [.font: AppFonts.SemiBold.withSize(18), .foregroundColor: AppColors.themeBlack])
            attString.append((Double(selectPassengersVM.selectedSeatData.columnData.amount)).getConvertedAmount(using: AppFonts.SemiBold.withSize(18)))
            titleLabel.attributedText = attString
//            titleLabel.text = selectPassengersVM.selectedSeatData.columnData.seatNumber + "  •  ₹ \(selectPassengersVM.selectedSeatData.columnData.amount.formattedWithCommaSeparator)"
            legsLabel.text = selectPassengersVM.selectedSeatData.columnData.getCharactericstic()
            legsLabel.textColor = AppColors.themeGray40
            legsLabel.font = AppFonts.Regular.withSize(14)
            headerDetailsStackBottom.constant = 21
            selectPassengersVM.initalPassengerForSeat = selectPassengersVM.selectedSeatData.columnData.passenger
            
        case .meals:
            self.selectPassengersLabel.text = LocalizedString.Select_Passengers_To_Assign_This_Meal.localized
            
            let attString = NSMutableAttributedString(string: "\( self.selectPassengersVM.adonsData.ssrName?.name ?? "")  •  ", attributes: [.font: AppFonts.SemiBold.withSize(18), .foregroundColor: AppColors.themeBlack])
            attString.append((Double(self.selectPassengersVM.adonsData.price)).getConvertedAmount(using: AppFonts.SemiBold.withSize(18)))
            titleLabel.attributedText = attString
            
//            self.titleLabel.text = "\( self.selectPassengersVM.adonsData.ssrName?.name ?? "")  •  ₹ \(self.selectPassengersVM.adonsData.price.commaSeprated)"
            self.legsLabel.text = self.selectPassengersVM.currentFlightName
      
        case .baggage:
            self.selectPassengersLabel.text = LocalizedString.Select_Passengers_To_Assign_This_Meal.localized
            
            let attString = NSMutableAttributedString(string: "\( self.selectPassengersVM.adonsData.ssrName?.name ?? "")  •  ", attributes: [.font: AppFonts.SemiBold.withSize(18), .foregroundColor: AppColors.themeBlack])
            attString.append((Double(self.selectPassengersVM.adonsData.price)).getConvertedAmount(using: AppFonts.SemiBold.withSize(18)))
            titleLabel.attributedText = attString
            
            
//            self.titleLabel.text = "\( self.selectPassengersVM.adonsData.ssrName?.name ?? "")  •  ₹ \(self.selectPassengersVM.adonsData.price.commaSeprated)"
            self.legsLabel.text = self.selectPassengersVM.currentFlightName

        case .others:
            self.selectPassengersLabel.text = LocalizedString.Select_Passengers.localized
            
            
            let attString = NSMutableAttributedString(string: "\( self.selectPassengersVM.adonsData.ssrName?.name ?? "")  •  ", attributes: [.font: AppFonts.SemiBold.withSize(18), .foregroundColor: AppColors.themeBlack])
            attString.append((Double(self.selectPassengersVM.adonsData.price)).getConvertedAmount(using: AppFonts.SemiBold.withSize(18)))
            titleLabel.attributedText = attString
            
//            self.titleLabel.text = "\( self.selectPassengersVM.adonsData.ssrName?.name ?? "")  •  ₹ \(self.selectPassengersVM.adonsData.price.commaSeprated)"
        self.legsLabel.text = self.selectPassengersVM.currentFlightName

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
    }
    
    private func didSelect(_ indexPath: IndexPath,_ collectionView: UICollectionView) {
        
        
        if let index = self.selectPassengersVM.selectedContacts.firstIndex(where: { (cont) -> Bool in
            cont.id == self.selectPassengersVM.allowedPassengers[indexPath.item].id
        }){
            self.doneButton.setTitle(LocalizedString.Done.localized, for: UIControl.State.normal)
            self.selectPassengersVM.selectedContacts.remove(at: index)
        }else{
            self.doneButton.setTitle(LocalizedString.Done.localized, for: UIControl.State.normal)
        self.selectPassengersVM.selectedContacts.append(self.selectPassengersVM.allowedPassengers[indexPath.item])
        }
        
        collectionView.reloadItems(at: [IndexPath(item: indexPath.item, section: 0)])
        self.selectPassengersVM.contactsComplition(self.selectPassengersVM.selectedContacts)

    }
    
}

// MARK: Popver dismiss animation
extension SelectPassengerVC {
    
    private func addDismissGesture() {
        let dismissGesture = UIPanGestureRecognizer(target: self, action: #selector(didPanViewToDismiss(_:)))
        view.addGestureRecognizer(dismissGesture)
    }
    
    @objc private func didPanViewToDismiss(_ sender: UIPanGestureRecognizer) {
        let yTranslation = sender.translation(in: view).y
                
        switch sender.state {
        case .ended:
            let popopverMaxHeight = view.height - popUpBackView.origin.y
            let yVelocity = sender.velocity(in: view).y
            if (yVelocity > 500) && (yTranslation > popopverMaxHeight/4) && (yTranslation < popopverMaxHeight) {
                performDoneBtnAction()
            } else if yTranslation >= popopverMaxHeight {
                performDoneBtnAction(0.0)
            } else {
                transformViewToOriginalState()
            }
        default:
            transformViewBy(yTranslation)
        }
    }
    
    private func transformViewBy(_ yTranslation: CGFloat) {
        guard yTranslation >= 0 else { return }
        transparentBackView.transform = CGAffineTransform(translationX: 0, y: yTranslation)
        let maxViewColorAlpha: CGFloat = 0.5,
        popopverMaxHeight = view.height - popUpBackView.origin.y
        
        let fractionForAlpha = maxViewColorAlpha - ((yTranslation/popopverMaxHeight) * maxViewColorAlpha)
        view.backgroundColor = UIColor.black.withAlphaComponent(fractionForAlpha)
    }
}
