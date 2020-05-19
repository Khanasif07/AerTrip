//
//  FlightInternationalMultiLegResultVC+FooterView.swift
//  Aertrip
//
//  Created by Appinventiv on 25/04/20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import Foundation
import UIKit

//MARK:- Tableview Footer View

extension IntMCAndReturnVC {
    
    func showFooterView() {
        
        if viewModel.resultTableState == .showPinnedFlights {
            resultsTableView.tableFooterView = nil
            return
        }
        
        if viewModel.resultTableState == .showExpensiveFlights {
            setExpandedStateFooter()
        }
        else {
            setGroupedFooterView()
        }
    }
    
    
    func setGroupedFooterView() {
        
        if viewModel.results.aboveScoreCount == 0 {
            resultsTableView.tableFooterView = nil
            return
        }
        
        var numberOfView = 0
        
        switch  viewModel.results.aboveScoreCount {
        case 1:
            numberOfView = 1
        case 2 :
            numberOfView = 2
        default:
            numberOfView = 3
        }
        
        let height = 44.0 + 35.0 + CGFloat(numberOfView - 1) * 16.0
        let footerViewRect =  CGRect(x: 0, y: 0, width: resultsTableView.frame.width, height: height)
        let groupedFooterView = UIView(frame:footerViewRect)
        groupedFooterView.isUserInteractionEnabled = true
        
        let  tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnGroupedFooterView(_:)))
        tapGesture.numberOfTapsRequired = 1
        groupedFooterView.addGestureRecognizer(tapGesture)
        
        for count in 1...numberOfView {
            let baseView = createRepeatedFooterBaseView()
            baseView.frame = CGRect(x: (8 * count) ,y: (10 + 6 * count) ,width: (Int(groupedFooterView.frame.width) - (16 * count))  ,height:44)
            groupedFooterView.addSubview(baseView)
            groupedFooterView.sendSubviewToBack(baseView)
        }
        
        let titleLabel = UILabel(frame: CGRect(x:8,y: 16 ,width:groupedFooterView.frame.width - 16  ,height:44))
        titleLabel.textColor = UIColor.AertripColor
        titleLabel.font = UIFont(name: "SourceSansPro-Regular", size: 18.0)
        titleLabel.textAlignment = .center
        
        let count = viewModel.results.aboveScoreCount
        
        if count == 1 {
            titleLabel.text  = "Show 1 longer or more expensive flight"
        }else {
            titleLabel.text  = "Show " + String(count) + " longer or more expensive flights"
        }
        
        groupedFooterView.addSubview(titleLabel)
        
        if let footerView = resultsTableView.tableFooterView {
            
            for subview in footerView.subviews {
                subview.removeFromSuperview()
            }
            
            footerView.frame = footerViewRect
            footerView.addSubview(groupedFooterView)
        }
        else {
            let footerView = UIView(frame : footerViewRect)
            footerView.addSubview(groupedFooterView)
            resultsTableView.tableFooterView = footerView
        }
    }
    
    @objc func tappedOnGroupedFooterView(_ sender : UITapGestureRecognizer) {
            
            UIView.animate(withDuration: 0.3, animations: {
                self.resultsTableView.tableFooterView?.transform = CGAffineTransform(translationX: 0, y: 200)
            }) { (success) in
                self.viewModel.resultTableState = .showExpensiveFlights
                //            self.results.sort = self.sortOrder
                self.viewModel.results.excludeExpensiveFlights = false
                
                DispatchQueue.global(qos: .default).async {
//                    let groupedArray = self.viewModel.getInternationalDisplayArray(results: self.viewModel.results.sortedArray)
//                    self.viewModel.results.journeyArray = groupedArray
                    self.sortedArray = Array(self.viewModel.results.sortedArray)
                    self.applySorting(sortOrder: self.viewModel.sortOrder, isConditionReverced: self.viewModel.isConditionReverced, legIndex: self.viewModel.prevLegIndex, completion: {
                        DispatchQueue.main.async {
                            self.setExpandedStateFooter()
                            self.resultsTableView.reloadData()
                            self.resultsTableView.tableFooterView?.transform = CGAffineTransform.identity
                        }
                    })
                }
        }
    }
    
    func createRepeatedFooterBaseView() -> UIView {
        let baseView = UIView(frame: CGRect(x: 0 , y: 0, width: resultsTableView.frame.width, height: 44))
        baseView.backgroundColor = .white
        baseView.layer.cornerRadius = 5.0
        baseView.layer.shadowColor = UIColor.black.cgColor
        baseView.layer.shadowOpacity = 0.1
        baseView.layer.shadowRadius = 8.0
        baseView.layer.shadowOffset = CGSize(width: 0, height: 2)
        return baseView
    }
    
    func setExpandedStateFooter() {
        let footerViewRect = CGRect(x: 0, y: 0, width: resultsTableView.frame.width, height: 95)
        let expandedFooterView = UIView(frame: footerViewRect)
        expandedFooterView.isUserInteractionEnabled = true
        
        let  tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnExpandedFooterView(_:)))
        tapGesture.numberOfTapsRequired = 1
        expandedFooterView.addGestureRecognizer(tapGesture)
        
        let baseView = createRepeatedFooterBaseView()
        baseView.frame = CGRect(x: 8,y: 16 ,width:expandedFooterView.frame.width - 16  ,height:44)
        
        expandedFooterView.addSubview(baseView)
        
        let titleLabel = UILabel(frame: CGRect(x:8,y: 16 ,width:expandedFooterView.frame.width - 16  ,height:44))
        titleLabel.textColor = UIColor.AertripColor
        titleLabel.font = UIFont(name: "SourceSansPro-Regular", size: 18)
        titleLabel.textAlignment = .center
        let count = viewModel.results.aboveScoreCount
        titleLabel.text  = "Hide " + String(count) + " longer or more expensive flights"
        expandedFooterView.addSubview(titleLabel)
        
        if let footerView = resultsTableView.tableFooterView {
            
            for subview in footerView.subviews {
                subview.removeFromSuperview()
            }
            
            footerView.frame = footerViewRect
            footerView.addSubview(expandedFooterView)
        }
        else {
            
            let footerView = UIView(frame : footerViewRect)
            footerView.addSubview(expandedFooterView)
            resultsTableView.tableFooterView = footerView
        }
        
        resultsTableView.tableFooterView = expandedFooterView
        
    }
    
    @objc func tapOnExpandedFooterView(_ sender: UITapGestureRecognizer) {
            
            var tempAllArray = self.viewModel.results.allJourneys
            var indexPathsToBedeleted : [IndexPath] = []
            let suggestedArrayCount = self.viewModel.results.suggestedJourneyArray.count
            
            for (index, _) in tempAllArray.reversed().enumerated() {
                if index >= suggestedArrayCount{
                    tempAllArray.removeLast()
                    indexPathsToBedeleted.append(IndexPath(row: index, section: 0))
                }
            }
            
            self.viewModel.results.allJourneys = tempAllArray
            self.resultsTableView.deleteRows(at: indexPathsToBedeleted, with: UITableView.RowAnimation.fade)
            
        self.viewModel.resultTableState = .showRegularResults
            self.viewModel.results.excludeExpensiveFlights = false
            
            DispatchQueue.global(qos: .background).async {
//                let groupedArray =  self.viewModel.getInternationalDisplayArray(results: self.viewModel.results.sortedArray)
//                self.viewModel.results.journeyArray = groupedArray
                self.sortedArray = Array(self.viewModel.results.sortedArray)
                self.applySorting(sortOrder: self.viewModel.sortOrder, isConditionReverced: self.viewModel.isConditionReverced, legIndex: self.viewModel.prevLegIndex, completion: {
                    DispatchQueue.main.async {
                        self.setGroupedFooterView()
                        self.showBluredHeaderViewCompleted()
                        self.resultsTableView.reloadSections([0], with: .none)
                    }
                })
            }
    }
    
    func showBluredHeaderViewCompleted() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseInOut], animations: {
                if let blurEffectView = self.navigationController?.view.viewWithTag(500) {
                    var rect = blurEffectView.frame
                    rect.origin.y = 0
                    blurEffectView.frame = rect
                }
            }) { (success) in
                self.resultsTableView.reloadData()
            }
        }
    }
}
