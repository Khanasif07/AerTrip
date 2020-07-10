//
//  FlightPaymentVC+TableViewDelagateAndCells.swift
//  AERTRIP
//
//  Created by Apple  on 12.06.20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

//MARK:- Tableview delegate and datasource.
extension FlightPaymentVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.sectionTableCell.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch self.viewModel.sectionHeader[section]{
        case .CouponsAndWallet, .TotalPaybleAndTC: return nil
        case .Taxes:
            guard let headerView = self.checkOutTableView.dequeueReusableHeaderFooterView(withIdentifier: self.cellIdentifier) as? HotelFareSectionHeader else {
                return nil
            }
            headerView.tag = section
            headerView.delegate = self
            self.handleDiscountArrowAnimation(headerView)
            headerView.arrowButton.isUserInteractionEnabled = false
            headerView.grossFareTitleTopConstraint.constant = 0
            headerView.grossFareTitleLabel.text = "Base Fare"
            headerView.discountsTitleLabel.text = "Taxes and Fees"
            headerView.discountPriceLabel.text = "\(Double(self.viewModel.itinerary.details.fare.taxes.value).amountInDelimeterWithSymbol)"
            headerView.grossPriceLabel.text = "\(Double(self.viewModel.itinerary.details.fare.bf.value).amountInDelimeterWithSymbol)"
            return headerView
        case .Discount:
            guard let headerView = self.checkOutTableView.dequeueReusableHeaderFooterView(withIdentifier: self.cellIdentifier) as? HotelFareSectionHeader, !self.viewModel.discountData.isEmpty else {
                return nil
            }
            headerView.arrowButton.isUserInteractionEnabled = false
            headerView.grossFareTitleLabel.text = ""
            headerView.grossPriceLabel.text = ""
            headerView.tag = section
            headerView.delegate = self
            headerView.grossFareTitleTopConstraint.constant = 0
            self.handleDiscountArrowAnimation(headerView)
            headerView.discountsTitleLabel.text = "Discounts"
            headerView.discountPriceLabel.text = "\(Double(self.viewModel.itinerary.details.fare.discount?.value ?? 0).amountInDelimeterWithSymbol)"
            return headerView
        case .Addons:return self.getHeaderAddons(section)
        
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch self.viewModel.sectionHeader[section]{
        case .CouponsAndWallet, .TotalPaybleAndTC: return CGFloat.leastNonzeroMagnitude
        case .Taxes: return 53.0
        case .Discount: return !self.viewModel.discountData.isEmpty ? 27 : CGFloat.leastNonzeroMagnitude
        case .Addons: return self.viewModel.addonsData.isEmpty ? CGFloat.leastNonzeroMagnitude : 27
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.viewModel.sectionHeader[section]{
        case .Taxes: return  isTaxesAndFeeExpended ? self.viewModel.sectionTableCell[section].count : 0
        case .Discount: return (isCouponSectionExpanded && isCouponApplied) ? self.viewModel.sectionTableCell[section].count : 0
        case .Addons: return isAddonsExpended ? self.viewModel.sectionTableCell[section].count : 0
        default: return self.viewModel.sectionTableCell[section].count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch self.viewModel.sectionHeader[indexPath.section]{
        case .CouponsAndWallet: return self.getHeightOfRowForFirstSection(indexPath)
        case .Taxes,.Discount,.Addons: return  20
        case .TotalPaybleAndTC: return self.getHeightOfRowForThirdSection(indexPath)
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.viewModel.sectionHeader[indexPath.section] {
        case .CouponsAndWallet:return self.getCellForCouponAndWalletSection(indexPath)
        case .Taxes: return self.getCellForTaxesSection(indexPath)
        case.Discount: return self.getCellForDiscountSection(indexPath)
        case .Addons: return self.getCellAddonsSection(indexPath)
        case .TotalPaybleAndTC: return self.getCellForTotalPaybleAndTCSection(indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1, indexPath.section == 0 {
            self.moveToCouponVC(indexPath:indexPath)
//            AppFlowManager.default.presentFlightCouponCodeVC(itineraryId: self.viewModel.itinerary.id, vc: self, couponCode: self.viewModel.appliedCouponData.couponCode ?? "", product: .flights)
        }
    }
    
    func handleDiscountArrowAnimation(_ headerView: HotelFareSectionHeader) {
        let rotateTrans = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        switch self.viewModel.sectionHeader[headerView.tag]{
        case .Taxes:
            headerView.arrowButton.transform = (self.isTaxesAndFeeExpended) ? .identity : rotateTrans
        case .Discount:
            headerView.arrowButton.transform = (self.isCouponSectionExpanded) ? .identity : rotateTrans
        case .Addons:
            headerView.arrowButton.transform = (self.isAddonsExpended) ? .identity : rotateTrans
        default:break
        }
    }
    
    func moveToCouponVC(indexPath:IndexPath){
        self.viewModel.isApplyingCoupon = true
        self.view.isUserInteractionEnabled = false
        self.checkOutTableView.reloadRow(at: indexPath, with: .automatic)
        self.viewModel.getCouponsDetailsApi(){[weak self] (success, data, error) in
            guard let self = self else {return}
            self.viewModel.isApplyingCoupon = false
            self.view.isUserInteractionEnabled = true
            self.checkOutTableView.reloadRow(at: indexPath, with: .automatic)
            if success{
                let obj = HCCouponCodeVC.instantiate(fromAppStoryboard: .HotelCheckout)
                obj.flightDelegate = self
                obj.viewModel.itineraryId = self.viewModel.itinerary.id
                obj.viewModel.couponCode = self.viewModel.appliedCouponData.couponCode ?? ""
                obj.viewModel.product = .flights
                obj.viewModel.couponsData = data
                obj.modalPresentationStyle = .overFullScreen
                self.present(obj, animated: true)
            }else{
                AppGlobals.shared.showErrorOnToastView(withErrors: error, fromModule: .flights)
            }
            
        }
        
    }
    
}
//MARK:- Tableview cell,height,Headers
extension FlightPaymentVC{
    
    func getHeaderAddons(_ section:Int)-> UITableViewHeaderFooterView?{
        guard let headerView = self.checkOutTableView.dequeueReusableHeaderFooterView(withIdentifier: self.cellIdentifier) as? HotelFareSectionHeader, !self.viewModel.addonsData.isEmpty else {
            return nil
        }
        headerView.arrowButton.isUserInteractionEnabled = false
        headerView.grossFareTitleLabel.text = ""
        headerView.grossPriceLabel.text = ""
        headerView.tag = section
        headerView.delegate = self
        headerView.grossFareTitleTopConstraint.constant = 0
        self.handleDiscountArrowAnimation(headerView)
        headerView.discountsTitleLabel.text = "Addons"
        headerView.discountPriceLabel.text = "\(Double(self.viewModel.itinerary.details.fare.addons?.value ?? 0).amountInDelimeterWithSymbol)"
        return headerView
    }
    

    
    func getHeightOfRowForFirstSection(_ indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0, 2: // Empty Cell
            return 35.0
        case 4: // Empty Cell
            return (UserInfo.loggedInUser != nil && (self.getWalletAmount() > 0)) ? 35.0 : 0.0//(UserInfo.loggedInUser != nil) ? 35.0 : 0.0
        case 1: // Apply Coupon Cell
            return 44.0
        case 3: // Pay by Wallet Cell
            return (UserInfo.loggedInUser != nil && (self.getWalletAmount() > 0)) ? 75.0 : 0.0//(UserInfo.loggedInUser != nil) ? 75.0 : 0.0
            //        case 5: // Fare Detail Cell
        //            return 80.0
        default:
            return 44 // Default Height Cell
        }
    }
    
    func getHeightOfRowForThirdSection(_ indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0: // Convenince Fee Cell
            if self.isConvenienceFeeApplied {
                return 36.0
            } else {
                return 0.0
            }
            
        case 1: // Wallet amount Cell
            if self.isWallet {
                return 40.0
            } else {
                return 0.0
            }
        case 2: // total amount Cell
            return 46.0
            
        case 3: // Convenience Cell Message
//            if self.isConvenienceFeeApplied {
//                return 46.0
//            } else {
                return 0.0
//            }
        case 4: // Final amount message table view Cell
            if self.isCouponApplied {
                return 87.0
            } else {
                return 0
            }
        case 5: // term and privacy cell
            return 115.0
        default:
            return 44
        }
    }
}

extension FlightPaymentVC{
    
    func getCellForCouponAndWalletSection(_ indexPath: IndexPath) -> UITableViewCell {
        switch self.viewModel.sectionTableCell[indexPath.section][indexPath.row] {
        case .EmptyCell:
            guard let emptyCell = self.checkOutTableView.dequeueReusableCell(withIdentifier: EmptyTableViewCell.reusableIdentifier, for: indexPath) as? EmptyTableViewCell else {
                printDebug("Cell not found")
                return UITableViewCell()
            }
            emptyCell.clipsToBounds = true
            return emptyCell
        case .CouponCell:
            guard let applyCouponCell = self.checkOutTableView.dequeueReusableCell(withIdentifier: ApplyCouponTableViewCell.reusableIdentifier, for: indexPath) as? ApplyCouponTableViewCell else {
                printDebug("ApplyCouponTableViewCell not found")
                return UITableViewCell()
            }
            if self.isCouponApplied {
                if let discountBreakUp = self.viewModel.appliedCouponData.discountsBreakup {
                    let saveAmount = discountBreakUp.CACB + discountBreakUp.CPD
                    applyCouponCell.appliedCouponLabel.text = LocalizedString.Save.localized + " " + Double(saveAmount).amountInDelimeterWithSymbol
                    applyCouponCell.couponView.isHidden = false
                    applyCouponCell.couponLabel.text = LocalizedString.CouponApplied.localized + (self.viewModel.appliedCouponData.couponCode ?? "")
                }else{
                    applyCouponCell.appliedCouponLabel.text = LocalizedString.Save.localized
                    applyCouponCell.couponView.isHidden = false
                    applyCouponCell.couponLabel.text = LocalizedString.CouponApplied.localized
                }
            } else {
                applyCouponCell.couponView.isHidden = true
                applyCouponCell.couponLabel.text = LocalizedString.ApplyCoupon.localized
            }
            applyCouponCell.hideShowLoader(isHidden: !self.viewModel.isApplyingCoupon)
            applyCouponCell.delegate = self
            return applyCouponCell
        case .WalletCell:
            guard let walletCell = self.checkOutTableView.dequeueReusableCell(withIdentifier: WalletTableViewCell.reusableIdentifier, for: indexPath) as? WalletTableViewCell else {
                printDebug("WalletTableViewCell not found")
                return UITableViewCell()
            }
            walletCell.clipsToBounds = true
            walletCell.delegate = self
            walletCell.walletSwitch.isOn = isWallet
            walletCell.amountLabel.attributedText = self.getWalletAmount().amountInDelimeterWithSymbol.asStylizedPrice(using: AppFonts.SemiBold.withSize(16.0))
            return walletCell
        case .FareBreakupCell:
            
            guard let cell = self.checkOutTableView.dequeueReusableCell(withIdentifier: "FareBreakupCell") as? FareBreakupTableViewCell else {return UITableViewCell()}
            cell.selectionStyle = .none
            let noAdult = (self.viewModel.itinerary.searchParams.adult.toInt == 0)
            cell.adultCountDisplayView.isHidden = noAdult
            cell.adultCountDisplayViewWidth.constant = noAdult ? 0 : 25
            cell.adultCountLabel.text = noAdult ? "" : self.viewModel.itinerary.searchParams.adult
            let noChild = (self.viewModel.itinerary.searchParams.child.toInt == 0)
            cell.childrenCountDisplayView.isHidden = noChild
            cell.childrenCountDisplayViewWidth.constant = (noChild) ? 0 : 35
            cell.childrenCountLabel.text = (noChild) ? "" : self.viewModel.itinerary.searchParams.child
            let noInfant = (self.viewModel.itinerary.searchParams.infant.toInt == 0)
            cell.infantCountDisplayView.isHidden = noInfant
            cell.infantCountDisplayViewWidth.constant = noInfant ? 0 : 35
            cell.infantCountLabel.text = noInfant ? "" : self.viewModel.itinerary.searchParams.infant
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func getCellForTaxesSection(_ indexPath: IndexPath)->UITableViewCell{
        
        guard let cell = self.checkOutTableView.dequeueReusableCell(withIdentifier: DiscountCell.reusableIdentifier, for: indexPath) as? DiscountCell else { return UITableViewCell()}
        let title = self.viewModel.taxAndFeesData[indexPath.row].name
        let amount = Double(self.viewModel.taxAndFeesData[indexPath.row].value).amountInDelimeterWithSymbol.asStylizedPrice(using: AppFonts.Regular.withSize(14.0))
        cell.configureCellForInvoice(title: title, amount: amount)
        return cell
    }
    func getCellForDiscountSection(_ indexPath: IndexPath)->UITableViewCell{
        
        
        guard let cell = self.checkOutTableView.dequeueReusableCell(withIdentifier: DiscountCell.reusableIdentifier, for: indexPath) as? DiscountCell else { return UITableViewCell()}
        let title = self.viewModel.discountData[indexPath.row].name
        let amount = Double(self.viewModel.discountData[indexPath.row].value).amountInDelimeterWithSymbol.asStylizedPrice(using: AppFonts.Regular.withSize(14.0))
        cell.configureCellForInvoice(title: title, amount: amount)
        return cell
    }
    
    
    func getCellAddonsSection(_ indexPath: IndexPath)->UITableViewCell{
        
        guard let cell = self.checkOutTableView.dequeueReusableCell(withIdentifier: DiscountCell.reusableIdentifier, for: indexPath) as? DiscountCell else { return UITableViewCell()}
        let title = self.viewModel.addonsData[indexPath.row].name
        let amount = Double(self.viewModel.addonsData[indexPath.row].value).amountInDelimeterWithSymbol.asStylizedPrice(using: AppFonts.Regular.withSize(14.0))
        cell.configureCellForInvoice(title: title, amount: amount)
        return cell
    }
    
    func getCellForTotalPaybleAndTCSection(_ indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {

        case 0: // Convenience Fee Cell
            guard let convenieneCell = self.checkOutTableView.dequeueReusableCell(withIdentifier: WallletAmountCellTableViewCell.reusableIdentifier, for: indexPath) as? WallletAmountCellTableViewCell else {
                printDebug("WallletAmountCellTableViewCell not found")
                return UITableViewCell()
            }
            convenieneCell.walletAmountLabel.textColor = AppColors.themeBlack
            convenieneCell.aertripWalletTitleLabel.textColor = AppColors.themeBlack
            let amount = isWallet ? self.convenienceFeesWallet : self.convenienceRate
            if self.isConvenienceFeeApplied {
                convenieneCell.aertripWalletTitleLabel.text = LocalizedString.ConvenienceFee.localized
                convenieneCell.walletAmountLabel.attributedText = amount.amountInDelimeterWithSymbol.asStylizedPrice(using: AppFonts.Regular.withSize(16.0))
                return convenieneCell
            } else {
                convenieneCell.clipsToBounds = true
                return UITableViewCell()
            }
        case 1: // Aertip Wallet Cell
            
            guard let walletAmountCell = self.checkOutTableView.dequeueReusableCell(withIdentifier: WallletAmountCellTableViewCell.reusableIdentifier, for: indexPath) as? WallletAmountCellTableViewCell else {
                printDebug("WallletAmountCellTableViewCell not found")
                return UITableViewCell()
            }
            walletAmountCell.callForReuse()
            if self.isWallet {
                var amount = Double(self.viewModel.itinerary.details.farepr)
                var amountFromWallet: Double = 0.0
                if self.isCouponApplied, let discountBreakUp = self.viewModel.appliedCouponData.discountsBreakup {
                    amount -= discountBreakUp.CPD
                }
                if amount > self.getWalletAmount() {
                    amountFromWallet = self.getWalletAmount()
                } else {
                    amountFromWallet = amount
                }
                walletAmountCell.walletAmountLabel.text = "-" + abs(amountFromWallet).amountInDelimeterWithSymbol
                walletAmountCell.clipsToBounds = true
                return walletAmountCell
            } else {
                walletAmountCell.clipsToBounds = true
                return UITableViewCell()
            }
            
        case 2: // Total pay now Cell
            guard let totalPayableNowCell = self.checkOutTableView.dequeueReusableCell(withIdentifier: TotalPayableNowCell.reusableIdentifier, for: indexPath) as? TotalPayableNowCell else {
                printDebug("TotalPayableNowCell not found")
                return UITableViewCell()
            }
            totalPayableNowCell.totalPayableTextTopConstraint.constant = 12.0
            totalPayableNowCell.totalPayableTextBottomConstraint.constant = 12.0
            totalPayableNowCell.topDeviderView.isHidden = false
            totalPayableNowCell.bottomDeviderView.isHidden = !isCouponApplied
            totalPayableNowCell.totalPriceLabel.attributedText = self.getTotalPayableAmount().amountInDelimeterWithSymbol.asStylizedPrice(using: AppFonts.SemiBold.withSize(20.0))
            return totalPayableNowCell
        case 3: // Convenience Fee message Cell
            guard let conveninceCell = self.checkOutTableView.dequeueReusableCell(withIdentifier: ConvenienceFeeTableViewCell.reusableIdentifier, for: indexPath) as? ConvenienceFeeTableViewCell else {
                printDebug("ConvenienceFeeTableViewCell not found")
                return UITableViewCell()
            }
            let amount = self.isWallet ? self.convenienceFeesWallet : self.convenienceRate
            if self.isConvenienceFeeApplied {
                conveninceCell.convenienceFeeLabel.textColor = AppColors.themeBlack
                conveninceCell.convenienceFeeLabel.text = LocalizedString.convenienceFee1.localized + " \(amount.amountInDelimeterWithSymbol) " + LocalizedString.convenienceFee2.localized
                return conveninceCell
            } else {
                conveninceCell.clipsToBounds = true
                return UITableViewCell()
            }
            
        case 4: // Final Amount Message cell
            guard let finalAmountCell = self.checkOutTableView.dequeueReusableCell(withIdentifier: FinalAmountTableViewCell.reusableIdentifier, for: indexPath) as? FinalAmountTableViewCell else {
                printDebug("FinalAmountTableViewCell not found")
                return UITableViewCell()
            }
            if self.isCouponApplied {
                if let discountBreakUp = self.viewModel.appliedCouponData.discountsBreakup {
                    // Net Effective fare
                    let netAmount = self.viewModel.itinerary.details.fare.netEffectiveFare.value
                    let convinceFee = isWallet ? self.convenienceFeesWallet : self.convenienceRate
                    let effectiveFare = Double(netAmount) + convinceFee
                    finalAmountCell.payableWalletMessageLabel.text = Double(discountBreakUp.CACB).amountInDelimeterWithSymbol + LocalizedString.PayableWalletMessage.localized
                    
                    let ttl = effectiveFare.amountInDelimeterWithSymbol
                    let amount = ttl.asStylizedPrice(using: AppFonts.SemiBold.withSize(14.0))
                    let attributedTitle = NSMutableAttributedString(string: "\(LocalizedString.NetEffectiveFare.localized)", attributes: [.font: AppFonts.SemiBold.withSize(14)])
                    attributedTitle.append(amount)
                    
                    finalAmountCell.netEffectiveFareLabel.attributedText = attributedTitle//LocalizedString.NetEffectiveFare.localized + "\(effectiveFare.amountInDelimeterWithSymbol)"
                }
                finalAmountCell.clipsToBounds = true
                return finalAmountCell
            } else {
                finalAmountCell.clipsToBounds = true
                return UITableViewCell()
            }
            
        case 5: // Term and privacy Cell
            guard let termAndPrivacCell = self.checkOutTableView.dequeueReusableCell(withIdentifier: TermAndPrivacyTableViewCell.reusableIdentifier, for: indexPath) as? TermAndPrivacyTableViewCell else {
                return UITableViewCell()
            }
            return termAndPrivacCell
        default:
            return UITableViewCell()
        }
    }
    
}
