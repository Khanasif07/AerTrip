//
//  SpecialAccountDetailsVC+Delegate.swift
//  AERTRIP
//
//  Created by Admin on 06/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

extension SpecialAccountDetailsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        switch self.currentUserType {
        case .statement: return 4
        case .topup: return 3
        case .billwise: return 4
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch self.currentUserType {
        case .statement:
            
            return [0.0, 10.0, 10.0, 35.0][section]
            
        case .topup:
            
            return [0.0, 10.0, 35.0][section]
            
        case .billwise:
            
            return [0.0, 10.0, 10.0, 35.0][section]
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTableViewCell.reusableIdentifier) as? EmptyTableViewCell else {
            return nil
        }
        
        cell.contentView.backgroundColor = AppColors.screensBackground.color
        
        return cell.contentView
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.currentUserType {
        case .statement:
            
            return [self.viewModel.statementSummery.count, self.viewModel.creditSummery.count, 1, self.viewModel.otherAction.count][section]
            
        case .topup:
            
            return [self.viewModel.topUpSummery.count, 1, self.viewModel.otherAction.count][section]
            
        case .billwise:
            
            return [self.viewModel.bilWiseSummery.count, self.viewModel.creditSummery.count, 1, self.viewModel.otherAction.count][section]
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch self.currentUserType {
        case .statement:
            
            switch indexPath.section {
            //statement summery
            case 0: return self.viewModel.statementSummery[indexPath.row].height
            
            //credit summery
            case 1: return self.viewModel.creditSummery[indexPath.row].height
                
            //deposit cell
            case 2: return self.viewModel.depositCellHeight
                
            //other action
            case 3: return self.viewModel.otherAction[indexPath.row].height

            default: return 0
            }
            
        case .topup:
            
            switch indexPath.section {
            //topup summery
            case 0: return self.viewModel.topUpSummery[indexPath.row].height
                
            //deposit cell
            case 1: return self.viewModel.depositCellHeight
                
            //other action
            case 2: return self.viewModel.otherAction[indexPath.row].height
                
            default: return 0
            }
            
        case .billwise:
            
            switch indexPath.section {
            //bilwise summery
            case 0: return self.viewModel.bilWiseSummery[indexPath.row].height
                
            //credit summery
            case 1: return self.viewModel.creditSummery[indexPath.row].height
                
            //deposit cell
            case 2: return self.viewModel.depositCellHeight
                
            //other action
            case 3: return self.viewModel.otherAction[indexPath.row].height
                
            default: return 0
            }
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.currentUserType {
        case .statement:
            
            switch indexPath.section {
            //statement summery
            case 0:
                //return getSummeryCell(withData: self.viewModel.statementSummery[indexPath.row])
                let cell = getSummeryCell(withData: self.viewModel.statementSummery[indexPath.row], isForOther: false, isFirstCell: indexPath.row == 0) as! AccountSummeryCell
                
                if indexPath.row == 1 {
                //    cell.stackViewTop.constant = -4.0
                }
//                else if let sym = self.viewModel.statementSummery[indexPath.row].symbol, sym == "=" {
//                    cell.stackViewTop.constant = 2.0
//                }
                
                return cell
                
            //credit summery
            case 1:
                return getSummeryCell(withData: self.viewModel.creditSummery[indexPath.row], isForOther: false, isFirstCell: false)
                
            //deposit cell
            case 2:
                
                var amount = UserInfo.loggedInUser?.accountData?.statements?.beforeAmountDue?.amount ?? 0.0
                if amount < 0 {
                    amount = 0.0
                }
                
                var dateStr = ""
                if let date = UserInfo.loggedInUser?.accountData?.statements?.beforeAmountDue?.dates.first {
                    let str = date.toString(dateFormat: "EE, dd MMM YYYY")
                    if !str.isEmpty {
                        dateStr = "Before \(str)"
                    }
                }
                
                return getDepositCell(amount: amount, dateStr: dateStr)
                
            //other action
            case 3:
                return getSummeryCell(withData: self.viewModel.otherAction[indexPath.row], isForOther: true, isFirstCell: false)
                
            default:
                return UITableViewCell()
            }
            
        case .topup:
            
            switch indexPath.section {
            //topup summery
            case 0:
                let cell = getSummeryCell(withData: self.viewModel.topUpSummery[indexPath.row], isForOther: false, isFirstCell: indexPath.row == 0) as! AccountSummeryCell
                
                if indexPath.row == 1 {
              //      cell.stackViewTop.constant = -4.0
                }
                else if let sym = self.viewModel.topUpSummery[indexPath.row].symbol, sym == "=" {
              //      cell.stackViewTop.constant = 4.0
                }
                
                return cell
                
            //deposit cell
            case 1:
                
                var amount = UserInfo.loggedInUser?.accountData?.topup?.beforeAmountDue?.amount ?? 0.0
                if amount < 0 {
                    amount = 0.0
                }
                var dateStr = ""
                if let date = UserInfo.loggedInUser?.accountData?.topup?.beforeAmountDue?.dates.first {
                    let str = date.toString(dateFormat: "EE, dd MMM YYYY")
                    if !str.isEmpty {
                        dateStr = "Before \(str)"
                    }
                }
                
                return getDepositCell(amount: amount, dateStr: dateStr)
        
            //other action
            case 2:
                return getSummeryCell(withData: self.viewModel.otherAction[indexPath.row], isForOther: true, isFirstCell: false)
                
            default:
                return UITableViewCell()
            }
            
        case .billwise:
            
            switch indexPath.section {
            //bilwise summery
            case 0:
                let cell = getSummeryCell(withData: self.viewModel.bilWiseSummery[indexPath.row], isForOther: false, isFirstCell: indexPath.row == 0) as! AccountSummeryCell
                
                if indexPath.row == 1 {
               //     cell.stackViewTop.constant = -4.0
                }
                
                return cell
                
            //credit summery
            case 1:
                return getSummeryCell(withData: self.viewModel.creditSummery[indexPath.row], isForOther: false, isFirstCell: false)
                
            //deposit cell
            case 2:
                
                var amount = UserInfo.loggedInUser?.accountData?.billwise?.totalOutstanding ?? 0.0
                if amount < 0 {
                    amount = 0.0
                }
                return getDepositCell(amount: amount, dateStr: "")
                
            //other action
            case 3:
                return getSummeryCell(withData: self.viewModel.otherAction[indexPath.row], isForOther: true, isFirstCell: false)
                
            default:
                return UITableViewCell()
            }
            
        default:
            return UITableViewCell()
        }
    }
    
    func getSummeryCell(withData: SpecialAccountEvent, isForOther:Bool, isFirstCell: Bool) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AccountSummeryCell.reusableIdentifier) as? AccountSummeryCell else {
            return UITableViewCell()
        }
        
        cell.event = withData
        if isForOther{
            cell.mainStackHeight.constant = 42
        }else{
            cell.mainStackHeight.constant = 35
        }
        cell.topDividerView.isHidden = !isFirstCell
        return cell
    }
    
    func getDepositCell(amount: Double, dateStr: String) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AccountDepositCell.reusableIdentifier) as? AccountDepositCell else {
            return UITableViewCell()
        }
        
        cell.configure(amount: amount, dateStr: dateStr)
        self.depositButton = cell.depositButton
        cell.depositButton.addTarget(self, action: #selector(self.depositButtonAction(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch self.currentUserType {
        case .statement:
            if (indexPath.section == 3) {
                switch indexPath.row {
                case 0:
                    AppFlowManager.default.moveToAccountDetailsVC(usingFor: .accountLadger, forDetails: self.viewModel.accountLadger, forVoucherTypes: self.viewModel.accVouchers)
                    
                case 1:
                    
                    AppFlowManager.default.moveToAccountOutstandingLadgerVC(data: self.viewModel.outstandingLadger)
                    
                case 2:
                    AppFlowManager.default.moveToPeriodicStatementVC(periodicEvents: self.viewModel.periodicEvents)
                    
                default:
                    printDebug("no need to implement")
                }
            }

        case .topup:
            if (indexPath.section == 2) {
                switch indexPath.row {
                case 0:
                    AppFlowManager.default.moveToAccountDetailsVC(usingFor: .accountLadger, forDetails: self.viewModel.accountLadger, forVoucherTypes: self.viewModel.accVouchers)
                    
                case 1:
                    AppFlowManager.default.moveToAccountOutstandingLadgerVC(data: self.viewModel.outstandingLadger)
                    
                default:
                    printDebug("no need to implement")
                }
            }

        case .billwise:
            if (indexPath.section == 3) {
                switch indexPath.row {
                case 0:
                    AppFlowManager.default.moveToAccountDetailsVC(usingFor: .accountLadger, forDetails: self.viewModel.accountLadger, forVoucherTypes: self.viewModel.accVouchers)
                    
                case 1:
                    AppFlowManager.default.moveToAccountOutstandingLadgerVC(data: self.viewModel.outstandingLadger)
                    
                default:
                    printDebug("no need to implement")
                }
            }
            
        default:
            printDebug("No need to implement")
        }
    }
}


//MARK:- Cell Classes
//MARK:-
class AccountSummeryCell: UITableViewCell {
    
    //MARK:- IBOutlet
    //MARK:-
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var dividerView: ATDividerView!
    @IBOutlet weak var dividerViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var dividerViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewTop: NSLayoutConstraint!
    @IBOutlet weak var amountLabelTraillingConstant: NSLayoutConstraint!
    @IBOutlet weak var amountStackView: UIStackView!
    @IBOutlet weak var dipositLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var mainStackHeight: NSLayoutConstraint!
    @IBOutlet weak var topDividerView: ATDividerView!
    
    //MARK:- Life Cycle
    //MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }
    
    var event: SpecialAccountEvent? {
        didSet {
            self.setupData()
        }
    }
    
    //MARK:- Properties
    //MARK:- Private
    private func resetAllSubViews() {
        titleLabel.isHidden = true
        symbolLabel.isHidden = true
        amountLabel.isHidden = true
        amountStackView.isHidden = true
        descLabel.isHidden = true
        dividerView.isHidden = true
        
        titleLabel.text = ""
        descLabel.text = ""
        symbolLabel.text = ""
        amountLabel.text = ""
        amountLabel.attributedText = nil
        
        dividerViewLeadingConstraint.constant = 16.0
        dividerViewTrailingConstraint.constant = 16.0
        amountLabelTraillingConstant.constant = 16.0
        
//        if let user = UserInfo.loggedInUser, (user.userCreditType == .topup) {
//            stackViewTop.constant = self.event!.isForTitle ? 4.0 : 0.0
//        }
    }
    
    //MARK:- Public
    
    
    //MARK:- Methods
    //MARK:- Private
    private func setupData() {
        guard let evnt = self.event else {
            self.resetAllSubViews()
            return
        }
        
        if evnt.isForTitle {
            self.configureHeader(title: evnt.title)
        }
        else if evnt.isNext {
            self.configureNext(title: evnt.title)
        }
        else if let sym = evnt.symbol, sym == "=" {
            self.configureGrandTotal(title: evnt.title, totalAmount: evnt.amount)
        }
        else {
            self.configure(detail: evnt.title, amount: evnt.amount, descp: evnt.description, symbol: evnt.symbol)
        }
    }
    
    //MARK:- Public
    private func configureHeader(title: String) {
        self.resetAllSubViews()
        amountStackView.isHidden = false
        self.titleLabel.isHidden = false
        self.titleLabel.font = AppFonts.Regular.withSize(14.0)
        self.titleLabel.textColor = AppColors.themeGray40
        self.titleLabel.text = title
    }
    
    private func configure(detail: String, amount: String, descp: String? = nil, symbol: String? = nil) {
        guard self.event != nil else {return}
        self.resetAllSubViews()
        amountStackView.isHidden = false
        self.dividerView.isHidden = !(self.event!.isDevider)
        self.dividerViewTrailingConstraint.constant = 16.0
        
        self.titleLabel.isHidden = false
        self.titleLabel.font = AppFonts.Regular.withSize(16.0)
        self.titleLabel.textColor = AppColors.themeBlack
        self.titleLabel.text = detail
        
        if let sym = symbol {
            self.symbolLabel.isHidden = false
            self.symbolLabel.font = AppFonts.SemiBold.withSize(20.0)
            self.symbolLabel.textColor = AppColors.themeBlack
            self.symbolLabel.text = sym
        }
        
        if let des = descp {
            self.descLabel.isHidden = false
            self.descLabel.font = AppFonts.Regular.withSize(14.0)
            self.descLabel.textColor = AppColors.themeGray40
            self.descLabel.text = des
        }
        
        self.amountLabel.isHidden = false
        self.amountLabel.font = AppFonts.Regular.withSize(16.0)
        self.amountLabel.textColor = AppColors.themeBlack
        self.amountLabel.attributedText = amount.asStylizedPrice(using: AppFonts.Regular.withSize(16.0))
    }
    
    private func configureGrandTotal(title: String, totalAmount: String) {
        self.resetAllSubViews()
        amountStackView.isHidden = false
        self.titleLabel.isHidden = false
        self.titleLabel.font = AppFonts.SemiBold.withSize(16.0)
        self.titleLabel.textColor = AppColors.themeBlack
        self.titleLabel.text = title
        
        self.symbolLabel.isHidden = false
        self.symbolLabel.font = AppFonts.SemiBold.withSize(20.0)
        self.symbolLabel.textColor = AppColors.themeBlack
        self.symbolLabel.text = "="
        
        self.amountLabel.isHidden = false
        self.amountLabel.font = AppFonts.SemiBold.withSize(16.0)
        self.amountLabel.textColor = AppColors.themeBlack
        self.amountLabel.attributedText = totalAmount.asStylizedPrice(using: AppFonts.Regular.withSize(16.0))
    }
    
    private func configureNext(title: String) {
        guard self.event != nil else {return}
        self.resetAllSubViews()
        amountStackView.isHidden = false
        self.dividerView.isHidden = false
        self.dividerViewTrailingConstraint.constant = 0.0
        if self.event!.isLastNext {
            self.dividerViewLeadingConstraint.constant = 0.0
        }
        
        self.titleLabel.isHidden = false
        self.titleLabel.font = AppFonts.Regular.withSize(18.0)
        self.titleLabel.textColor = AppColors.themeBlack
        self.titleLabel.text = title
        
        self.amountLabel.isHidden = false
        self.amountLabel.font = AppFonts.SemiBold.withSize(16.0)
        self.amountLabel.textColor = AppColors.themeBlack
        self.amountLabel.attributedText = AppGlobals.shared.getTextWithImage(startText: "", image: #imageLiteral(resourceName: "arrowNextScreen"), endText: "", font: AppFonts.SemiBold.withSize(16.0))
        
      //  self.stackViewTop.constant = 6.0
        self.amountLabelTraillingConstant.constant = 0.0
    }
}

class AccountDepositCell: UITableViewCell {
    
    //MARK:- IBOutlet
    //MARK:-
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var depositButton: ATButton!
    
    
    //MARK:- Life Cycle
    //MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.depositButton.layer.cornerRadius = self.depositButton.height / 2.0
    }
    
    //MARK:- Properties
    //MARK:- Private
    
    //MARK:- Public
    
    
    //MARK:- Methods
    //MARK:- Private
    func configure(amount: Double, dateStr: String) {
        
        self.titleLabel.font = AppFonts.Regular.withSize(14.0)
        self.titleLabel.textColor = AppColors.themeGray40
        self.titleLabel.text = "Total Amount Due"
        
        self.amountLabel.font = AppFonts.SemiBold.withSize(28.0)
        self.amountLabel.textColor = AppColors.themeBlack
        self.amountLabel.attributedText = amount.amountInDelimeterWithSymbol.asStylizedPrice(using: AppFonts.SemiBold.withSize(28.0))
        
        self.dateLabel.font = AppFonts.Regular.withSize(14.0)
        self.dateLabel.textColor = AppColors.themeRed
        self.dateLabel.text = dateStr
        
//        self.depositButton.titleLabel?.font = AppFonts.SemiBold.withSize(17.0)
        self.depositButton.setTitleFont(font: AppFonts.SemiBold.withSize(17.0), for: .normal)
        self.depositButton.setTitleFont(font: AppFonts.SemiBold.withSize(17.0), for: .highlighted)
        self.depositButton.setTitleFont(font: AppFonts.SemiBold.withSize(17.0), for: .selected)
        self.depositButton.setTitle("Deposit", for: .normal)
        self.depositButton.setTitle("Deposit", for: .selected)
        self.depositButton.shadowColor = AppColors.themeBlack
        self.depositButton.setTitleColor(AppColors.themeWhite, for: .normal)
        self.depositButton.setTitleColor(AppColors.themeWhite, for: .selected)
        self.depositButton.shadowColor = AppColors.themeBlack.withAlphaComponent(0.16)
        self.depositButton.layer.applySketchShadow(color: AppColors.themeBlack, alpha: 0.16, x: 0, y: 2, blur: 6, spread: 0)
    }
    
    //MARK:- Public
}
