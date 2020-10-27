//
//  PassengerSelection+TableDelegate.swift
//  Aertrip
//
//  Created by Apple  on 07.05.20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import Foundation
import PhoneNumberKit

extension PassengersSelectionVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.isTravelSefetyRequired ? 3 : 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 6
        case 2:
            return 2
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard GuestDetailsVM.shared.guests.count != 0 else {return 0}
        if indexPath.section == 0{
            if indexPath.row == 0{

                let passengerCount = GuestDetailsVM.shared.guests[indexPath.section].count
                var cellHeight: CGFloat = 0.0
                if passengerCount % 4 == 0{
                    cellHeight = CGFloat(passengerCount / 4) * 119
                }else{
                    cellHeight = CGFloat((passengerCount / 4) + 1) * 119
                }
                var indexWithDetails = [Int]()
                for (index, value) in GuestDetailsVM.shared.guests[indexPath.section].enumerated(){
                    if (!(value.firstName.isEmpty) && !(value.lastName.isEmpty)){
                        indexWithDetails.append(index)
                    }
                }
                indexWithDetails = Array(Set(indexWithDetails.map{$0/4}))
                cellHeight += CGFloat(indexWithDetails.count * 17)
                return cellHeight//(firstRowHeight + secondRowHeight + thirdRowHeight)
            }else{
                return 35
            }
            
        }else if indexPath.section == 1{
            
            switch indexPath.row {
            case 0:
                return 42
            case 1:
                return 60.0
            case 2:
                return 61.0
            case 3:
                return 50
            case 4:
                return UITableView.automaticDimension
            default:
                return 35
            }
        }else{
            switch indexPath.row {
            case 0:
                return 44
            default:
                return 35
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            return self.getCellForFirstSection(with: indexPath)
        case 1:
            return getCellForSecondSection(with: indexPath)
        case 2:
            return getCellForThirdSection(with: indexPath)
        default:
            return UITableViewCell()
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath.section == 2) && (indexPath.row == 0){
            AppFlowManager.default.showURLOnATWebView(URL(string: "https://beta.aertrip.com/")!, screenTitle: "Travel Safety Guidlines")
        }
        
//        if indexPath.row == 0 {
//            printDebug("0")
////            AppToast.default.hideToast(self, animated: false)
//            AppToast.default.showToastMessage(message: "didSelectRowAt 0")
//
//        }else{
//            printDebug("1")
//        AppToast.default.showToastMessage(message: "didSelectRowAt 1")
//
//        }
        
    }
    
    
    func getCellForFirstSection(with indexPath: IndexPath)-> UITableViewCell{
        
        switch indexPath.row {
        case 0:
            guard let cell = self.passengerTableview.dequeueReusableCell(withIdentifier: "cell") as? PassengerGridCell else {return UITableViewCell()}
            cell.totalPassenger = self.viewModel.totalPassengerCount
            cell.configData(forIndexPath: indexPath)
            cell.journeyType = self.viewModel.journeyType
            cell.delegate = self
            cell.lastJourneyDate = self.viewModel.itineraryData.itinerary.searchParams.lastJourneyDate
            cell.isAllPaxInfoRequired = self.viewModel.itineraryData.itinerary.isAllPaxInfoRequired
            cell.minMNS = self.viewModel.manimumContactLimit
            cell.maxMNS = self.viewModel.maximumContactLimit
            return cell
        case 1:
            guard let cell = self.passengerTableview.dequeueReusableCell(withIdentifier: "FlightEmptyCell") as? FlightEmptyCell else {return UITableViewCell()}
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    
    func getCellForSecondSection(with indexPath: IndexPath)-> UITableViewCell{
        
        switch indexPath.row {
        case 0:
            guard let cell = self.passengerTableview.dequeueReusableCell(withIdentifier: "CommunicationTextCell") as? CommunicationTextCell else {return UITableViewCell()}
            cell.setupForTitlte()
            return cell
        case 1:
            guard let cell = self.passengerTableview.dequeueReusableCell(withIdentifier: "FlightContactCell") as? FlightContactCell else {return UITableViewCell()}
            cell.vc = self
            cell.mobile = self.viewModel.mobile
            cell.isdCode = self.viewModel.isdCode
            cell.delegate = self
            cell.setupData()
            return cell
        case 2:
            guard let cell = self.passengerTableview.dequeueReusableCell(withIdentifier: "FlightEmailFieldCell") as? FlightEmailFieldCell else {return UITableViewCell()}
            cell.configureCell(with: self.viewModel.email, isLoggedIn:self.viewModel.isLogin)
            cell.delegate = self
            return cell
        case 3:
            guard let cell = self.passengerTableview.dequeueReusableCell(withIdentifier: "CommunicationTextCell") as? CommunicationTextCell else {return UITableViewCell()}
            cell.setupForCommunicationMsg()
            return cell
        case 4:
            guard let cell = self.passengerTableview.dequeueReusableCell(withIdentifier: "UseGSTINCell") as? UseGSTINCell else {return UITableViewCell()}
            cell.delegate = self
            cell.gstModel = self.viewModel.selectedGST
            cell.gstSwitch.isOn = viewModel.isSwitchOn
//            if self.viewModel.isLogin{
//                if viewModel.isSwitchOn{
//                    cell.setupForSelectGST()
//                }
//            }else{
                if viewModel.isSwitchOn{
                    cell.setupForNewGST()
                }
//            }
            return cell
        case 5:
            guard let cell = self.passengerTableview.dequeueReusableCell(withIdentifier: "FlightEmptyCell") as? FlightEmptyCell else {return UITableViewCell()}
            cell.bottomDividerView.isHidden = !(self.viewModel.isTravelSefetyRequired)
            cell.backgroundColor = AppColors.themeGray04
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    
    func getCellForThirdSection(with indexPath: IndexPath)-> UITableViewCell{
        switch indexPath.row {
        case 0:
            guard let cell = self.passengerTableview.dequeueReusableCell(withIdentifier: "TravellSefetyCell") as? TravellSefetyCell else {return UITableViewCell()}
            return cell
        case 1:
            guard let cell = self.passengerTableview.dequeueReusableCell(withIdentifier: "FlightEmptyCell") as? FlightEmptyCell else {return UITableViewCell()}
            cell.bottomDividerView.isHidden = true
            cell.backgroundColor = AppColors.themeGray04
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension PassengersSelectionVC: PassengerGridSelectionDelegate{
    
    func didSelected(at indexPath: IndexPath){
        let vc = PassengerDetailsVC.instantiate(fromAppStoryboard: .PassengersSelection)
        vc.viewModel.journeyType = self.viewModel.journeyType
        vc.delegate = self
        vc.viewModel.isAllPaxInfoRequired = self.viewModel.itineraryData.itinerary.isAllPaxInfoRequired
        vc.viewModel.currentIndex = indexPath.row
        vc.viewModel.lastJourneyDate = self.viewModel.itineraryData.itinerary.searchParams.lastJourneyDate
        vc.viewModel.journeyEndDate = self.viewModel.itineraryData.itinerary.journeyEndDate
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
extension PassengersSelectionVC: FlightContactCellDelegate, FlightEmailTextFieldCellDelegate{
    
    func textFieldText(_ textField: PhoneNumberTextField){
        self.viewModel.mobile = textField.nationalNumber
    }
    
    func setIsdCode(_ countryDate:PKCountryModel){
        self.viewModel.isdCode = countryDate.ISOCode
        self.viewModel.manimumContactLimit = countryDate.minNSN
        self.viewModel.maximumContactLimit = countryDate.maxNSN
        
    }
    
    func textEditableTableViewCellTextFieldText(_ indexPath: IndexPath, _ text: String){
        self.viewModel.email = text
    }
    
}
