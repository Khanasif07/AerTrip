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
    
    @IBOutlet weak var navTitleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var bookingPolicyTableView: ATTableView!
    
    @IBOutlet weak var headerContainerView: UIView!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    // MARK: - Variables
    let viewModel = BookingCancellationPolicyVM()
    
    
    // MARK: - Override methods
    
    override func initialSetup() {
        self.bookingPolicyTableView.dataSource = self
        self.bookingPolicyTableView.delegate = self
        self.registerXib()
        if #available(iOS 13.0, *) {
            headerViewHeightConstraint.constant = 56
        }
        headerContainerView.backgroundColor = .clear
        self.view.backgroundColor = AppColors.themeWhite.withAlphaComponent(0.85)
        self.bookingPolicyTableView.contentInset = UIEdgeInsets(top: headerContainerView.height + 20, left: 0, bottom: 0, right: 0)
        self.bookingPolicyTableView.reloadData()

        if self.viewModel.vcUsingType == .bookingPolicy {
            self.viewModel.getBookingPolicy()
        }
    }
    
    override func setupFonts() {
        self.navTitleLabel.font = AppFonts.SemiBold.withSize(18.0)//AppFonts.SemiBold.withSize(22.0)
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
           self.bookingPolicyTableView.registerCell(nibName: FareRuleTableViewCell.reusableIdentifier)
    }
    
    // MARK: - IBAction
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    // MARK: - Helper Methods
    
    private func getCellForBookingPolicy(_ indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.bookingPolicyTableView.dequeueReusableCell(withIdentifier: "FareRuleTableViewCell", for: indexPath) as? FareRuleTableViewCell else {
            fatalError("FareRuleTableViewCell not found")
        }
        
        cell.configureCell(isForBookingPolicy: true,fareRules: self.viewModel.bookingPolicies, ruteString: "")

        
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
        
        return cell
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
            cancellationPolicy.configureCell(cancellationTimePeriod: "Cancellation not allowed", cancellationAmount: "", cancellationType: .nonRefundable)
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
            ///change done for  https://app.asana.com/0/1199093003059613/1199930068999723 as per discussion with Rahul Das Survase
            if "\(chargeData.fromStr)" == LocalizedString.dash.localized{
                cancellationPolicy.configureCell(cancellationTimePeriod: "Before \(chargeData.toStr)", cancellationAmount: chargeData.cancellationFee.delimiterWithSymbolTill2Places, cancellationType: .cancellationFee)
            } else if "\(chargeData.toStr)" == LocalizedString.dash.localized{
                cancellationPolicy.configureCell(cancellationTimePeriod: "\(chargeData.fromStr) or later", cancellationAmount: chargeData.cancellationFee.delimiterWithSymbolTill2Places, cancellationType: .cancellationFee)
            }else{
                cancellationPolicy.configureCell(cancellationTimePeriod: "\(chargeData.fromStr) \(LocalizedString.dash.localized) \(chargeData.toStr)", cancellationAmount: chargeData.cancellationFee.delimiterWithSymbolTill2Places, cancellationType: .cancellationFee)
            }
            
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.viewModel.vcUsingType == .bookingPolicy {
          return getCellForBookingPolicy(indexPath)
        } else  {
          return getCellForCancellationPolicy(indexPath)
        }
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
        delay(seconds: 0.2) {
            self.bookingPolicyTableView.reloadData()
        }
    }
    
    func getBookingPolicyFail() {
    }
}
