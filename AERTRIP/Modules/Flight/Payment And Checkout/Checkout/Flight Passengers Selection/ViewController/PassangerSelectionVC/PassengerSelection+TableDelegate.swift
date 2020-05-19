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
        
        if indexPath.section == 0{
            if indexPath.row == 0{
                let isEmptyText = true//after selection cusromer manage space for last name
                let height = isEmptyText ? 119 : 136
                if (self.viewModel.totalPassengerCount)%4 == 0{
                    let count = ((self.viewModel.totalPassengerCount)/4 == 0) ? 1 : (self.viewModel.totalPassengerCount)/4
                    return CGFloat(height * count)
                }else{
                    return CGFloat(height * ((self.viewModel.totalPassengerCount)/4 + 1))
                }
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
            return cell
        case 2:
            guard let cell = self.passengerTableview.dequeueReusableCell(withIdentifier: "FlightEmailFieldCell") as? FlightEmailFieldCell else {return UITableViewCell()}
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
            if self.viewModel.isLogin{
                if viewModel.isSwitchOn{
                    cell.setupForSelectGST()
                }
            }else{
                if viewModel.isSwitchOn{
                    cell.setupForNewGST()
                }
            }
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
        vc.viewModel.passengerList = self.viewModel.passengerList
        vc.viewModel.currentIndex = indexPath.row
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
