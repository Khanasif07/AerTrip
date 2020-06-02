//
//  PassengerSelection+TableDelegate.swift
//  Aertrip
//
//  Created by Apple  on 07.05.20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import Foundation

extension PassengersSelectionVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 6
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard GuestDetailsVM.shared.guests.count != 0 else {return 0}
        if indexPath.section == 0{
            if indexPath.row == 0{
                var firstRowHeight:CGFloat = 0
                var secondRowHeight:CGFloat = 0
                var thirdRowHeight:CGFloat = 0
                for i in 0..<GuestDetailsVM.shared.guests[indexPath.section].count {
                    switch i{
                    case 0,1,2,3:
                        firstRowHeight = (firstRowHeight == 136 || (!(GuestDetailsVM.shared.guests[indexPath.section][i].firstName.isEmpty) && !(GuestDetailsVM.shared.guests[indexPath.section][i].lastName.isEmpty))) ? 136 : 119
                    case 4,5,6,7:
                        secondRowHeight = (secondRowHeight == 136 || (!(GuestDetailsVM.shared.guests[indexPath.section][i].firstName.isEmpty) && !(GuestDetailsVM.shared.guests[indexPath.section][i].lastName.isEmpty))) ? 136 : 119
                    case 8,9,10,11:
                        thirdRowHeight = (thirdRowHeight == 136 || (!(GuestDetailsVM.shared.guests[indexPath.section][i].firstName.isEmpty) && !(GuestDetailsVM.shared.guests[indexPath.section][i].lastName.isEmpty))) ? 136 : 119
                    default: break;
                    }
                    
                }
                
                return (firstRowHeight + secondRowHeight + thirdRowHeight)
            }else{
                return 35
            }
            
        }else{
            
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
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            return self.getCellForFirstSection(with: indexPath)
        case 1:
            return getCellForSecondSection(with: indexPath)
        default:
            return UITableViewCell()
        }
        
    }
    
    
    func getCellForFirstSection(with indexPath: IndexPath)-> UITableViewCell{
        
        switch indexPath.row {
        case 0:
            guard let cell = self.passengerTableview.dequeueReusableCell(withIdentifier: "cell") as? PassengerGridCell else {return UITableViewCell()}
            cell.totalPassenger = self.viewModel.totalPassengerCount
            cell.configData(forIndexPath: indexPath, passengers: self.viewModel.passengerList)
            cell.journeyType = self.viewModel.journeyType
            cell.delegate = self
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
            guard let cell = self.passengerTableview.dequeueReusableCell(withIdentifier: "CommunicarionCell") as? CommunicationTextCell else {return UITableViewCell()}
            cell.setupForTitlte()
            return cell
        case 1:
            guard let cell = self.passengerTableview.dequeueReusableCell(withIdentifier: "FlightContactCell") as? FlightContactCell else {return UITableViewCell()}
            cell.vc = self
            cell.mobile = self.viewModel.mobile
            cell.isdCode = self.viewModel.isdCode
            cell.delegate = self
            return cell
        case 2:
            guard let cell = self.passengerTableview.dequeueReusableCell(withIdentifier: "FlightEmailFieldCell") as? FlightEmailFieldCell else {return UITableViewCell()}
            cell.configureCell(with: self.viewModel.email, isLoggedIn:self.viewModel.isLogin)
            return cell
        case 3:
            guard let cell = self.passengerTableview.dequeueReusableCell(withIdentifier: "CommunicarionCell") as? CommunicationTextCell else {return UITableViewCell()}
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
        vc.viewModel.currentIndex = indexPath.row
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
extension PassengersSelectionVC: FlightContactCellDelegate, FlightEmailTextFieldCellDelegate{
    
    func textFieldText(_ textField:UITextField){
        self.viewModel.mobile = textField.text ?? ""
    }
    
    func setIsdCode(_ countryDate:PKCountryModel,_ sender: UIButton){
        self.viewModel.isdCode = countryDate.ISOCode
    }
    
    func textEditableTableViewCellTextFieldText(_ indexPath: IndexPath, _ text: String){
        self.viewModel.email = text
    }
    
}
