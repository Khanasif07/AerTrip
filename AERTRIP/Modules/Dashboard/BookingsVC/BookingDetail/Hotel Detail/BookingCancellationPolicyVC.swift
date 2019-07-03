//
//  BookingCancellationPolicyVC.swift
//  AERTRIP
//
//  Created by apple on 15/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class BookingCancellationPolicyVC: BaseVC {
    
    // MARK: - IBOutlet
    
    @IBOutlet var navTitleLabel: UILabel!
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var bookingPolicyTableView: ATTableView!
    
    // MARK: - Variables
    let viewModel = BookingCancellationPolicyVM()
    
    
    // MARK: - Override methods
    
    override func initialSetup() {
        self.bookingPolicyTableView.dataSource = self
        self.bookingPolicyTableView.delegate = self
        self.registerXib()
        self.bookingPolicyTableView.reloadData()
        
        if self.viewModel.vcUsingType == .bookingPolicy {
            self.viewModel.getBookingPolicy()
        }
    }
    
    override func setupFonts() {
        self.navTitleLabel.font = AppFonts.SemiBold.withSize(22.0)
    }
    
    override func setupTexts() {
        self.navTitleLabel.text = self.viewModel.vcUsingType == .bookingPolicy ? LocalizedString.BookingPolicy.localized : LocalizedString.CancellationPolicy.localized
    }
    
    override func setupColors() {
        self.navTitleLabel.textColor = AppColors.themeBlack
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    private func registerXib() {
        self.bookingPolicyTableView.registerCell(nibName: CancellationPolicyTableViewCell.reusableIdentifier)
         self.bookingPolicyTableView.registerCell(nibName: FareInfoNoteTableViewCell.reusableIdentifier)
    }
    
    // MARK: - IBAction
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    // MARK: - Helper Methods
    
    private func getCellForBookingPolicy(_ indexPath: IndexPath) -> UITableViewCell {
        guard let noteCell = self.bookingPolicyTableView.dequeueReusableCell(withIdentifier: "FareInfoNoteTableViewCell") as? FareInfoNoteTableViewCell else {
            fatalError("FareInfoNoteTableViewCell not found")
        }
        
        noteCell.isForBookingPolicyCell = true
        noteCell.noteLabel.text = ""
        noteCell.configCell(note: self.viewModel.bookingPolicies)

        
//        switch indexPath.row {
//        case 0:
//            noteCell.isForBookingPolicyCell = true
//            noteCell.noteLabel.text = LocalizedString.SpecialCheckInInstructions.localized
//            noteCell.configCell(notes: self.viewModel.speicalCheckinInstructiion)
//            return noteCell
//        case 1:
//            noteCell.isForBookingPolicyCell = true
//            noteCell.noteLabel.text = LocalizedString.CheckInInstructions.localized
//            noteCell.configCell(notes: self.viewModel.checinInstruction)
//            return noteCell
//        case 2:
//            noteCell.isForBookingPolicyCell = true
//            noteCell.noteLabel.text = LocalizedString.BookingNote.localized
//            noteCell.configCell(notes: self.viewModel.bookingNote)
//            return noteCell
//        default:
//            return UITableViewCell()
//        }
        
        return noteCell
    }
    
    private func getNumberOfCellForCancellationPolicy() -> Int {
        guard let canc = self.viewModel.bookingDetail?.bookingDetail?.cancellation, !canc.charges.isEmpty else {
            return 1
        }
        
        return canc.charges.count
    }
    
    private func getCellForCancellationPolicy(_ indexPath: IndexPath) -> UITableViewCell {
        
        guard let cancellationPolicy = self.bookingPolicyTableView.dequeueReusableCell(withIdentifier: "CancellationPolicyTableViewCell") as? CancellationPolicyTableViewCell else {
            fatalError("CancellationPolicyTableViewCell not found")
        }
        
        guard let canc = self.viewModel.bookingDetail?.bookingDetail?.cancellation, !canc.charges.isEmpty else {
            cancellationPolicy.configureCell(cancellationTimePeriod: "cancellation not allowed.", cancellationAmount: "", cancellationType: .nonRefundable)
            return cancellationPolicy
        }
        
        let chargeData = canc.charges[indexPath.row]
        
        if chargeData.isFree {
            cancellationPolicy.configureCell(cancellationTimePeriod: "Before \(chargeData.toStr)", cancellationAmount: "", cancellationType: .freeCancellation)
        }
        else if !chargeData.isRefundable {
            cancellationPolicy.configureCell(cancellationTimePeriod: "\(chargeData.fromStr) or later", cancellationAmount: "", cancellationType: .nonRefundable)
        }
        else {
            cancellationPolicy.configureCell(cancellationTimePeriod: "\(chargeData.fromStr) to \(chargeData.toStr)", cancellationAmount: chargeData.cancellationFee.delimiterWithSymbolTill2Places, cancellationType: .cancellationFee)
        }
        
        return cancellationPolicy
    }
}



// MARK: - UITableViewDataSource and UITableViewDelegate methods

extension BookingCancellationPolicyVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.viewModel.vcUsingType == .bookingPolicy {
            return 1
        } else {
            return self.getNumberOfCellForCancellationPolicy()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.viewModel.vcUsingType == .bookingPolicy {
          return getCellForBookingPolicy(indexPath)
        } else  {
          return getCellForCancellationPolicy(indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Opening Select New Trip VC
//        if self.viewModel.vcUsingType == .cancellationPolicy {
//            AppFlowManager.default.presentSelectTripVC(delegate: self)
//        }
    }
    
}


// MARK: - Select Trip VC Delegate methods

extension BookingCancellationPolicyVC: SelectTripVCDelegate {
    func selectTripVC(sender: SelectTripVC, didSelect trip: TripModel, tripDetails: TripDetails?) {
        // 
    }
}


extension BookingCancellationPolicyVC: BookingCancellationPolicyVMDelegate {
    func willGetBookingPolicy(){
    }
    
    func getBookingPolicySuccess() {
        self.bookingPolicyTableView.reloadData()
    }
    
    func getBookingPolicyFail() {
    }
}
