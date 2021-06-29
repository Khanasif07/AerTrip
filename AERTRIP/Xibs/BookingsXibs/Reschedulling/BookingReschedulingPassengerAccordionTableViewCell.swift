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
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var passengerNameLabel: UILabel!
    @IBOutlet weak var arrowButton: UIButton!
    @IBOutlet weak var headerDividerView: ATDividerView!
    
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var bottomDividerView: ATDividerView!
    
    @IBOutlet weak var selectedTravellerButton: UIButton!
    @IBOutlet weak var requestInProcessLbl: UILabel!
    @IBOutlet weak var pnrStackView: UIStackView!
    @IBOutlet weak var pnrTitleLabel: UILabel!
    @IBOutlet weak var pnrValueLabel: UILabel!
    @IBOutlet weak var saleAmntStackView: UIStackView!
    @IBOutlet weak var saleAmountLabel: UILabel!
    @IBOutlet weak var saleValueLabel: UILabel!
    @IBOutlet weak var cancellationChargeStackView: UIStackView!
    @IBOutlet weak var cancellationChargeLabel: UILabel!
    @IBOutlet weak var cancellationChargeValueLabel: UILabel!
    @IBOutlet weak var netRefundStackView: UIStackView!
    @IBOutlet weak var netRefundLabel: UILabel!
    @IBOutlet weak var netRefundValueLabel: UILabel!
    
    // MARK: - Properties
    
    open private(set) var expanded = false
    weak var delegate: BookingReschedulingPassengerAccordionTableViewCellDelegate?
    
    // MARK: - Override methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.passengerNameLabel.attributedText = nil
    }
    
    override func setupTexts() {
        requestInProcessLbl.text = LocalizedString.requestInProcess.localized
        self.pnrTitleLabel.text = LocalizedString.PNRNo.localized
        self.saleAmountLabel.text = LocalizedString.SaleAmount.localized
        self.cancellationChargeLabel.text = LocalizedString.CancellationCharges.localized
        self.netRefundLabel.text = LocalizedString.NetRefund.localized
    }
    
    override func setupFonts() {
        requestInProcessLbl.font = AppFonts.Regular.withSize(16.0)
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
        requestInProcessLbl.textColor = AppColors.themeRed
        self.pnrTitleLabel.textColor = AppColors.themeGray153
        self.saleAmountLabel.textColor = AppColors.themeGray153
        self.cancellationChargeLabel.textColor = AppColors.themeGray153
        self.netRefundLabel.textColor = AppColors.themeGray153
        
        self.pnrValueLabel.textColor = AppColors.themeGray153
        self.saleValueLabel.textColor = AppColors.themeGray153
        self.cancellationChargeValueLabel.textColor = AppColors.themeGray153
        self.netRefundValueLabel.textColor = AppColors.themeGray153
        self.passengerNameLabel.textColor = AppColors.themeBlack
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
        self.arrowButton.setImage(self.expanded ? AppImages.upArrowIconCheckout : AppImages.downArrowCheckOut, for: .normal)
    }
    
    func configureCell(passengerName: String, pnrNo: String, saleValue: String, cancellationCharge: String, refundValue: String, age: String) {
        //self.passengerNameLabel.text = passengerName
        self.pnrValueLabel.text = pnrNo
        self.saleValueLabel.text = saleValue
        self.cancellationChargeValueLabel.text = cancellationCharge
        self.netRefundValueLabel.text = refundValue
        self.passengerNameLabel.appendFixedText(text: passengerName, fixedText: age)
        if !age.isEmpty {
            self.passengerNameLabel.AttributedFontColorForText(text: age, textColor: AppColors.themeGray153)
        }
    }
    
    func setColorForRescheduling(){
        [self.contentView, self.containerView, self.detailView, self.headerView].forEach{ view in
            view?.backgroundColor = AppColors.themeBlack26
            
        }
    }
    
    func togglePaxDetails(hidden: Bool) {
        requestInProcessLbl.isHidden = !hidden
        pnrStackView.isHidden = hidden
        saleAmntStackView.isHidden = hidden
        cancellationChargeStackView.isHidden = hidden
        netRefundStackView.isHidden = true
        selectedTravellerButton.isHidden = hidden
    }
    
    @IBAction func arrowButtonTapped(_ sender: UIButton) {
        self.delegate?.arrowButtonAccordionTapped(arrowButton: sender)
    }
}
