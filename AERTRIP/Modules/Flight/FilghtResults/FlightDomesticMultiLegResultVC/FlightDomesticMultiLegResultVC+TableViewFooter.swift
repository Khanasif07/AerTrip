//
//  file+FooterExtension.swift
//  Aertrip
//
//  Created by  hrishikesh on 26/12/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit


extension FlightDomesticMultiLegResultVC {
    
    func showFooterViewAt(index : Int) {
        
        if viewModel.resultsTableStates[index] == .showExpensiveFlights {
            setExpandedStateFooterAt(index: index)
        }
        else {
            setGroupedFooterViewAt(index: index)
        }
    }
    
    func setGroupedFooterViewAt(index : Int) {
        
        let aboveHumanScoreCount = self.viewModel.results[index].aboveHumanScoreCount
        
        if let tableView = baseScrollView.viewWithTag( 1000 + index) as? UITableView {
            
            if aboveHumanScoreCount == 0 {
                tableView.tableFooterView = nil
                return
            }
            
            var numberOfView = 0
            
            switch  aboveHumanScoreCount {
            case 1:
                numberOfView = 1
            case 2 :
                numberOfView = 2
            default:
                numberOfView = 3
            }
            
            let height = 44.0 + 35.0 + CGFloat(numberOfView - 1) * 16.0
            
            let groupedFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: height))
            groupedFooterView.isUserInteractionEnabled = true
            groupedFooterView.tag = index
            let  tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnGroupedFooterView(_:)))
            tapGesture.numberOfTapsRequired = 1
            groupedFooterView.addGestureRecognizer(tapGesture)
            
            for count in 1...numberOfView {
                
                let baseView = createRepeatedFooterBaseView(for: tableView)
                baseView.frame = CGRect(x: (8 * count) ,y: (10 + 6 * count) ,width: (Int(groupedFooterView.frame.width) - (16 * count))  ,height:60)
                groupedFooterView.addSubview(baseView)
                groupedFooterView.sendSubviewToBack(baseView)
            }
            
            let titleLabel = UILabel(frame: CGRect(x:8,y: 16 ,width:groupedFooterView.frame.width - 16  ,height:60))
            titleLabel.textColor = UIColor.AertripColor
            titleLabel.numberOfLines = 0
//            titleLabel.font = UIFont(name: "SourceSansPro-Regular", size: 14.0)
            titleLabel.font = AppFonts.Regular.withSize(14)

            titleLabel.textAlignment = .center
            
            if aboveHumanScoreCount == 1 {
                titleLabel.text  = "Show 1 longer or expensive flight"
            }else {
                titleLabel.text  = "Show " + String(aboveHumanScoreCount) + " longer or expensive flights"
            }
            
            groupedFooterView.addSubview(titleLabel)
            tableView.tableFooterView = groupedFooterView
            
        }
    }
    
    @objc func tappedOnGroupedFooterView(_ sender : UITapGestureRecognizer) {
        
        guard let tableIndex = sender.view?.tag else { return }
        guard let tableView = baseScrollView.viewWithTag( 1000 + tableIndex) as? UITableView else { return }

        UIView.animate(withDuration: 0.1, animations: {
                   tableView.tableFooterView?.transform = CGAffineTransform(translationX: 0, y: 200)
               }) { (success) in
                
                self.viewModel.resultsTableStates[tableIndex] = .showExpensiveFlights
                self.viewModel.results[tableIndex].excludeExpensiveFlights = false
                
                DispatchQueue.global(qos: .default).async {

                    //apply sorting
                self.applySorting(sortOrder: self.viewModel.sortOrder, isConditionReverced: self.viewModel.isConditionReverced, legIndex: tableIndex, completion: {
                    DispatchQueue.main.async {
                        self.setExpandedStateFooterAt(index: tableIndex)
                        tableView.reloadData()
                        tableView.tableFooterView?.transform = CGAffineTransform.identity
                    }
                })
                    
                    FirebaseEventLogs.shared.logDomesticAndMulticityResults(with: FirebaseEventLogs.EventsTypeName.ShowLongerOrExpensiveFlights, value: self.viewModel.flightSearchParameters)
                    
            }
        }
    }
    
    
    func setExpandedStateFooterAt(index: Int) {
        
        if let tableView = baseScrollView.viewWithTag( 1000 + index) as? UITableView {
        
        let aboveHumanScoreCount = self.viewModel.results[index].aboveHumanScoreCount

            if aboveHumanScoreCount == 0 {
                tableView.tableFooterView = nil
                return
            }

        let expandedFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 96))
        expandedFooterView.isUserInteractionEnabled = true
        expandedFooterView.tag = index
            
        let  tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnExpandedFooterView(_:)))
        tapGesture.numberOfTapsRequired = 1
        expandedFooterView.addGestureRecognizer(tapGesture)

        let baseView = createRepeatedFooterBaseView(for: tableView)
        baseView.frame = CGRect(x: 8,y: 16 ,width:expandedFooterView.frame.width - 16  ,height:60)

        expandedFooterView.addSubview(baseView)

        let titleLabel = UILabel(frame: CGRect(x:8,y: 16 ,width:expandedFooterView.frame.width - 16  ,height:60))
        titleLabel.textColor = UIColor.AertripColor
        titleLabel.numberOfLines = 0
            titleLabel.font = AppFonts.Regular.withSize(14)
        titleLabel.textAlignment = .center
        titleLabel.text  = "Hide " + String(aboveHumanScoreCount) + " longer or expensive flights"
        expandedFooterView.addSubview(titleLabel)
        tableView.tableFooterView = expandedFooterView
            
        }
    }
    
    func createRepeatedFooterBaseView(for view : UIView) -> UIView {
        let baseView = UIView(frame: CGRect(x: 0 , y: 0, width: view.frame.width, height: 60))
        baseView.backgroundColor = .white
//        baseView.layer.cornerRadius = 5.0
//        baseView.layer.shadowColor = UIColor.black.cgColor
//        baseView.layer.shadowOpacity = 0.1
//        baseView.layer.shadowRadius = 8.0
//        baseView.layer.shadowOffset = CGSize(width: 0, height: 2)
//        baseView.addShadow(cornerRadius: 5.0, maskedCorners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], color: AppColors.appShadowColor, offset: CGSize(width: 0, height: 2), opacity: 0.1, shadowRadius: 8.0)
        let shadowProp = AppShadowProperties()
        baseView.addShadow(cornerRadius: shadowProp.cornerRadius/2, maskedCorners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], color: shadowProp.shadowColor, offset: shadowProp.offset, opacity: shadowProp.opecity, shadowRadius: shadowProp.shadowRadius)
        return baseView
    }
    
    
    @objc func tapOnExpandedFooterView(_ sender: UITapGestureRecognizer) {
        
        
        guard let tableIndex = sender.view?.tag else { return }
             guard let tableView = baseScrollView.viewWithTag( 1000 + tableIndex) as? UITableView else { return }
        
        var tempAllArray = self.viewModel.results[tableIndex].allJourneys
        var indexPathsToBedeleted : [IndexPath] = []
        let suggestedArrayCount = self.viewModel.results[tableIndex].suggestedJourneyArray.count
        
        for (index, _) in tempAllArray.reversed().enumerated() {
            if index >= suggestedArrayCount{
                tempAllArray.removeLast()
                indexPathsToBedeleted.append(IndexPath(row: index, section: 0))
            }
        }
        
          self.viewModel.results[tableIndex].allJourneys = tempAllArray
          tableView.deleteRows(at: indexPathsToBedeleted, with: UITableView.RowAnimation.fade)
            
            self.viewModel.resultsTableStates[tableIndex] = .showRegularResults
            self.viewModel.results[tableIndex].excludeExpensiveFlights = false
        
                    DispatchQueue.global(qos: .background).async {
                    self.applySorting(sortOrder: self.viewModel.sortOrder, isConditionReverced: self.viewModel.isConditionReverced, legIndex: tableIndex, completion: {
                            DispatchQueue.main.async {
                                self.viewModel.results[tableIndex].journeyArray = self.viewModel.results[tableIndex].journeyArray
                                self.setGroupedFooterViewAt(index: tableIndex)
//                                self.showBluredHeaderViewCompleted()
                                tableView.reloadSections([0], with: .none)
                       }
                })
                        
                        FirebaseEventLogs.shared.logDomesticAndMulticityResults(with: FirebaseEventLogs.EventsTypeName.HideLongerOrExpensiveFlights, value: self.viewModel.flightSearchParameters)

        }
    }
}
