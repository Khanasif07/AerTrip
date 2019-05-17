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
        switch indexPath.row {
        case 0:
            noteCell.isForBookingPolicyCell = true
            noteCell.noteLabel.text = LocalizedString.SpecialCheckInInstructions.localized
            noteCell.configCell(notes: self.viewModel.speicalCheckinInstructiion)
            return noteCell
        case 1:
            noteCell.isForBookingPolicyCell = true
            noteCell.noteLabel.text = LocalizedString.CheckInInstructions.localized
            noteCell.configCell(notes: self.viewModel.checinInstruction)
            return noteCell
        case 2:
            noteCell.isForBookingPolicyCell = true
            noteCell.noteLabel.text = LocalizedString.BookingNote.localized
            noteCell.configCell(notes: self.viewModel.bookingNote)
            return noteCell
        default:
            return UITableViewCell()
        }
    }
    
    private func getCellForCancellationPolicy(_ indexPath: IndexPath) -> UITableViewCell {
        
        guard let cancellationPolicy = self.bookingPolicyTableView.dequeueReusableCell(withIdentifier: "CancellationPolicyTableViewCell") as? CancellationPolicyTableViewCell else {
            fatalError("CancellationPolicyTableViewCell not found")
        }
        
        switch indexPath.row {
        case 0:
            cancellationPolicy.configureCell(cancellationTimePeriod: "Before Tue, 06 Nov 2018 22:59", cancellationAmount: "", cancellationType: .freeCancellation)
            return cancellationPolicy
        case 1:
            cancellationPolicy.configureCell(cancellationTimePeriod: "Tue, 06 Nov 2018 23:00 to Tue, 06 Dec 2018 22:59", cancellationAmount: "₹ 10,000", cancellationType: .cancellationFree)
            return cancellationPolicy
        case 2:
            cancellationPolicy.configureCell(cancellationTimePeriod: "Tue, 06 Nov 2018 23:00 to Tue, 06 Dec 2018 22:59", cancellationAmount: "₹ 22,000", cancellationType: .cancellationFree)
            return cancellationPolicy
        case 3:
            cancellationPolicy.configureCell(cancellationTimePeriod: "Wed, 16 Dec 2018 23:00 or later", cancellationAmount: "", cancellationType: .nonRefundable)
            return cancellationPolicy
        default:
            return UITableViewCell()
        }
        
    }
}



// MARK: - UITableViewDataSource and UITableViewDelegate methods

extension BookingCancellationPolicyVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.viewModel.vcUsingType == .bookingPolicy {
            return 3
        } else {
            return 4
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
        if self.viewModel.vcUsingType == .cancellationPolicy {
            AppFlowManager.default.presentSelectTripVC(delegate: self)
        }
    }
    
}


// MARK: - Select Trip VC Delegate methods

extension BookingCancellationPolicyVC: SelectTripVCDelegate {
    func selectTripVC(sender: SelectTripVC, didSelect trip: TripModel, tripDetails: TripDetails?) {
        // 
    }
}
