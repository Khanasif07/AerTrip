//
//  FlightResultSingleJourneyVC+FooterView.swift
//  AERTRIP
//
//  Created by Appinventiv on 31/07/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

extension FlightResultSingleJourneyVC {
    
     //MARK:- Tableview Footer View
        
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
            if viewModel.results.aboveHumanScoreCount == 0 {
                resultsTableView.tableFooterView = nil
                return
            }
            
            var numberOfView = 0
            
            switch  viewModel.results.aboveHumanScoreCount {
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
//            groupedFooterView.backgroundColor = UIColor.yellow
            let  tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnGroupedFooterView(_:)))
            tapGesture.numberOfTapsRequired = 1
            groupedFooterView.addGestureRecognizer(tapGesture)
            
            for count in 1...numberOfView {
                let baseView = createRepeatedFooterBaseView()
                
                baseView.frame = CGRect(x: (8 * count) ,y: (10 + 6 * count) - 8 ,width: (Int(groupedFooterView.frame.width) - (16 * count))  ,height:44)
                groupedFooterView.addSubview(baseView)
                groupedFooterView.sendSubviewToBack(baseView)
            }
            
            let titleLabel = UILabel(frame: CGRect(x:8,y: 16 ,width:groupedFooterView.frame.width - 16  ,height:44))
            titleLabel.textColor = UIColor.AertripColor
            titleLabel.font = UIFont(name: "SourceSansPro-Regular", size: 18.0)
            titleLabel.textAlignment = .center
            
            let count = viewModel.results.aboveHumanScoreCount
            if count == 1 {
                titleLabel.text  = "Show 1 longer or expensive flight"
            }else {
                titleLabel.text  = "Show " + String(count) + " longer or expensive flights"
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
                        self.viewModel.results.excludeExpensiveFlights = false
                        DispatchQueue.global(qos: .default).async {

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
        
        func setExpandedStateFooter() {
            
            let footerViewRect = CGRect(x: 0, y: 0, width: resultsTableView.frame.width, height: 95)
            let expandedFooterView = UIView(frame: footerViewRect)
//            expandedFooterView.backgroundColor = UIColor.yellow

            expandedFooterView.isUserInteractionEnabled = true
            
            let  tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnExpandedFooterView(_:)))
            tapGesture.numberOfTapsRequired = 1
            expandedFooterView.addGestureRecognizer(tapGesture)
            

            let baseView = createRepeatedFooterBaseView()
            baseView.frame = CGRect(x: 8,y: 8 ,width:expandedFooterView.frame.width - 16  ,height:44)

            expandedFooterView.addSubview(baseView)
     
            let titleLabel = UILabel(frame: CGRect(x:8,y: 16 ,width:expandedFooterView.frame.width - 16  ,height:44))
            titleLabel.textColor = UIColor.AertripColor
            titleLabel.font = UIFont(name: "SourceSansPro-Regular", size: 18)
            titleLabel.textAlignment = .center
            let count = viewModel.results.aboveHumanScoreCount
            
//            if count == 0 {
//                resultsTableView.tableFooterView = nil
//                return
//            }
//
            
            titleLabel.text  = "Hide " + String(count) + " longer or expensive flights"
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
        
    //MARK:- Target  methods
     func showBluredHeaderViewCompleted() {
        DispatchQueue.main.async {
            
            UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseInOut], animations: {
                
                if let blurEffectView = self.navigationController?.view.viewWithTag(500) {
                    var rect = blurEffectView.frame
                    rect.origin.y = 0
                    blurEffectView.frame = rect
                }
            } ,completion: nil)
        }
    }
    
}
