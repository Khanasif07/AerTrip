//
//  file+FooterExtension.swift
//  Aertrip
//
//  Created by  hrishikesh on 26/12/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit


extension FlightDomesticMultiLegResultVC
{
    
    func showFooterViewAt(index : Int) {
        
        if resultsTableViewStates[index] == .showExpensiveFlights {
            setExpandedStateFooterAt(index: index)
        }
        else {
            setGroupedFooterViewAt(index: index)
        }
    }
    
    func setGroupedFooterViewAt(index : Int) {
        
        let aboveHumanScoreCount = results[index].aboveHumanScoreCount
        
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
            titleLabel.font = UIFont(name: "SourceSansPro-Regular", size: 14.0)
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
        
        if let index = sender.view?.tag {
            resultsTableViewStates[index] = .showExpensiveFlights
            self.results[index].sort = sortOrder
            self.results[index].excludeExpensiveFlights = false
            self.sortedJourneyArray[index] = Array(self.results[index].sortedArray)
            if let tableView = baseScrollView.viewWithTag( 1000 + index) as? UITableView {
                tableView.reloadData()
                
                let indexPath : IndexPath
                if (self.results[index].suggestedJourneyArray.count == 0 ) {
                    indexPath = IndexPath(row: 0, section: 1)
                    tableView.selectRow(at: indexPath , animated: false, scrollPosition: .none)
                    ShowFareBreakupView()
                }
                
            }
            setExpandedStateFooterAt(index: index)
        }
    }
    
    
    func setExpandedStateFooterAt(index: Int) {
        
        if let tableView = baseScrollView.viewWithTag( 1000 + index) as? UITableView {
        
        let aboveHumanScoreCount = results[index].aboveHumanScoreCount

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
        titleLabel.font = UIFont(name: "SourceSansPro-Regular", size: 14.0)
        titleLabel.textAlignment = .center
        titleLabel.text  = "Hide " + String(aboveHumanScoreCount) + " longer or expensive flights"
        expandedFooterView.addSubview(titleLabel)
        tableView.tableFooterView = expandedFooterView
            
        }
    }
    
    
    func createRepeatedFooterBaseView(for view : UIView) -> UIView {
        let baseView = UIView(frame: CGRect(x: 0 , y: 0, width: view.frame.width, height: 60))
        baseView.backgroundColor = .white
        baseView.layer.cornerRadius = 5.0
        baseView.layer.shadowColor = UIColor.black.cgColor
        baseView.layer.shadowOpacity = 0.1
        baseView.layer.shadowRadius = 8.0
        baseView.layer.shadowOffset = CGSize(width: 0, height: 2)

        return baseView
    }
    
    
    @objc func tapOnExpandedFooterView(_ sender: UITapGestureRecognizer) {
        
        if let index = sender.view?.tag {
            
            resultsTableViewStates[index] = .showRegularResults
            
            self.results[index].sort = sortOrder
            self.results[index].excludeExpensiveFlights = true
            self.sortedJourneyArray[index] = Array(self.results[index].sortedArray)

            if let tableView = baseScrollView.viewWithTag( 1000 + index) as? UITableView {
                
                if sortOrder == .Smart  {
                    tableView.deleteSections( IndexSet(integer: 1), with: .top)
                }
                else {
                    tableView.reloadData()
                }
                                
                if let bounds = tableView.tableFooterView?.bounds {
                    let rect = tableView.convert( bounds, from: tableView.tableFooterView)
                    tableView.scrollRectToVisible(rect, animated: true)
                }
            }
            setGroupedFooterViewAt(index: index)
        }
    }
}
