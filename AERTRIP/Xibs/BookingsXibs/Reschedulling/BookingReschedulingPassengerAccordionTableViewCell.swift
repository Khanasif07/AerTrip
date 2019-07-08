//
//  BookingReschedulingPassengerAccordionTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 24/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol BookingReschedulingPassengerAccordionTableViewCellDelegate: class {
    func arrowButtonAccordionTapped(arrowButton: UIButton)
}

class BookingReschedulingPassengerAccordionTableViewCell: ATTableViewCell {
    // MARK: - IB Outlet
    
    @IBOutlet var headerView: UIView!
    @IBOutlet var passengerNameLabel: UILabel!
    @IBOutlet var arrowButton: UIButton!
    @IBOutlet var headerDividerView: ATDividerView!
    
    @IBOutlet var detailView: UIView!
    @IBOutlet var bottomDividerView: ATDividerView!
    
    @IBOutlet var selectedTravellerButton: UIButton!
    @IBOutlet var pnrTitleLabel: UILabel!
    @IBOutlet var pnrValueLabel: UILabel!
    @IBOutlet var saleAmountLabel: UILabel!
    @IBOutlet var saleValueLabel: UILabel!
    @IBOutlet var cancellationChargeLabel: UILabel!
    @IBOutlet var cancellationChargeValueLabel: UILabel!
    @IBOutlet var netRefundLabel: UILabel!
    @IBOutlet var netRefundValueLabel: UILabel!
    
    // MARK: - Properties
    
    open private(set) var expanded = false
    weak var delegate: BookingReschedulingPassengerAccordionTableViewCellDelegate?
    
    // MARK: - Override methods
    
    override func setupTexts() {
        self.pnrTitleLabel.text = LocalizedString.PNRNo.localized
        self.saleAmountLabel.text = LocalizedString.SaleAmount.localized
        self.cancellationChargeLabel.text = LocalizedString.CancellationCharges.localized
        self.netRefundLabel.text = LocalizedString.NetRefund.localized
    }
    
    override func setupFonts() {
        self.pnrTitleLabel.font = AppFonts.Regular.withSize(16.0)
        self.saleAmountLabel.font = AppFonts.Regular.withSize(16.0)
        self.cancellationChargeLabel.font = AppFonts.Regular.withSize(16.0)
        self.netRefundLabel.font = AppFonts.Regular.withSize(16.0)
        
        self.pnrValueLabel.font = AppFonts.Regular.withSize(16.0)
        self.saleValueLabel.font = AppFonts.Regular.withSize(16.0)
        self.cancellationChargeValueLabel.font = AppFonts.Regular.withSize(16.0)
        self.netRefundValueLabel.font = AppFonts.Regular.withSize(16.0)
    }
    
    override func setupColors() {
        self.pnrTitleLabel.textColor = AppColors.themeGray40
        self.saleAmountLabel.textColor = AppColors.themeGray40
        self.cancellationChargeLabel.textColor = AppColors.themeGray40
        self.netRefundLabel.textColor = AppColors.themeGray40
        
        self.pnrValueLabel.textColor = AppColors.themeGray40
        self.saleValueLabel.textColor = AppColors.themeGray40
        self.cancellationChargeValueLabel.textColor = AppColors.themeGray40
        self.netRefundValueLabel.textColor = AppColors.themeGray40
    }
    
    func setExpanded(_ expanded: Bool, animated: Bool) {
        self.expanded = expanded
        if animated {
            let alwaysOptions: UIView.AnimationOptions = []
            
            let expandedOptions: UIView.AnimationOptions = [.transitionFlipFromTop]
            let collapsedOptions: UIView.AnimationOptions = [.transitionFlipFromBottom]
            let options = expanded ? alwaysOptions.union(expandedOptions) : alwaysOptions.union(collapsedOptions)
            
            UIView.transition(with: detailView, duration: 0.3, options: options, animations: {
                self.toggleCell()
            }, completion: nil)
        } else {
            self.toggleCell()
        }
    }
    
    // MARK: Helpers
    
    private func toggleCell() {
        self.detailView.isHidden = !expanded
        self.arrowButton.setImage(#imageLiteral(resourceName: self.expanded ? "upArrowIconCheckout" : "downArrowCheckOut"), for: .normal)
    }
    
    func configureCell(passengerName: String, pnrNo: String, saleValue: String, cancellationCharge: String, refundValue: String) {
        self.passengerNameLabel.text = passengerName
        self.pnrValueLabel.text = pnrNo
        self.saleValueLabel.text = saleValue
        self.cancellationChargeValueLabel.text = cancellationCharge
        self.netRefundValueLabel.text = refundValue
    }
    
    @IBAction func arrowButtonTapped(_ sender: UIButton) {
        self.delegate?.arrowButtonAccordionTapped(arrowButton: sender)
    }
}
