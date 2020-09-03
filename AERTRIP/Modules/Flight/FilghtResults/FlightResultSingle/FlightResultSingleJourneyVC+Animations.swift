//
//  FlightResultSingleJourneyVC+Animations.swift
//  AERTRIP
//
//  Created by Appinventiv on 17/08/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

extension FlightResultSingleJourneyVC {
    
    func expandFlights(){
        
        UIView.animate(withDuration: 0.3, animations: {
            self.resultsTableView.tableFooterView?.transform = CGAffineTransform(translationX: 0, y: 200)
        }) { (success) in
            
            self.viewModel.resultTableState = .showExpensiveFlights
            self.viewModel.results.excludeExpensiveFlights = false
            DispatchQueue.global(qos: .default).async {
                
//                self.sortedArray = Array(self.viewModel.results.sortedArray)
                
                self.applySorting(sortOrder: self.viewModel.sortOrder, isConditionReverced: self.viewModel.isConditionReverced, legIndex: 0, completion: {
                    DispatchQueue.main.async {
                        self.setExpandedStateFooter()
                        self.resultsTableView.reloadData()
                        self.resultsTableView.tableFooterView?.transform = CGAffineTransform.identity
                    }
                })
            }
        }
    }
    
    
    func collapseFlights(){
        
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
//                self.sortedArray = Array(self.viewModel.results.sortedArray)
                self.applySorting(sortOrder: self.viewModel.sortOrder, isConditionReverced: self.viewModel.isConditionReverced, legIndex: 0, completion: {
                    DispatchQueue.main.async {
                        self.setGroupedFooterView()
                        self.showBluredHeaderViewCompleted()
                        self.resultsTableView.reloadSections([0], with: .none)
                    }
                })
            }
        }
    
        func manageFloatingView(isHidden: Bool) {
             self.pinnedFlightsOptionsView.isHidden = isHidden
         }
        
        
        func showPinnedButtons(withAnimation: Bool = true) {
              if withAnimation {
                  self.unpinnedAllButton.alpha = 0.0
                  self.emailPinnedFlights.alpha = 0.0
                  self.sharePinnedFilghts.alpha = 0.0
                  UIView.animate(withDuration: TimeInterval(0.4), delay: 0, options: [.curveEaseOut, ], animations: { [weak self] in
                      self?.unpinnedAllButton.alpha = 1.0
                      self?.emailPinnedFlights.alpha = 1.0
                      self?.sharePinnedFilghts.alpha = 1.0
                      self?.unpinnedAllButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                      self?.emailPinnedFlights.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                      self?.sharePinnedFilghts.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                      self?.emailPinnedFlights.transform = CGAffineTransform(translationX: 26, y: 0)
                      self?.sharePinnedFilghts.transform = CGAffineTransform(translationX: 80, y: 0)
                      self?.unpinnedAllButton.transform = CGAffineTransform(translationX: 134, y: 0)
                      }, completion: nil)
                  
              } else {
                  self.unpinnedAllButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                  self.emailPinnedFlights.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                  self.sharePinnedFilghts.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                  self.emailPinnedFlights.transform = CGAffineTransform(translationX: 26, y: 0)
                  self.sharePinnedFilghts.transform = CGAffineTransform(translationX: 80, y: 0)
                  self.unpinnedAllButton.transform = CGAffineTransform(translationX: 134, y: 0)
              }
          }
          
          func hidePinnedButtons(withAnimation: Bool = false) {
              if withAnimation {
                  UIView.animate(withDuration: TimeInterval(0.4), delay: 0, options: .curveEaseOut, animations: { [weak self] in
                    
                      self?.unpinnedAllButton.transform = CGAffineTransform(translationX: 0, y: 0)
                      self?.emailPinnedFlights.transform = CGAffineTransform(translationX: 0, y: 0)
                      self?.sharePinnedFilghts.transform = CGAffineTransform(translationX: 0, y: 0)
                        self?.unpinnedAllButton.alpha = 0.0
                        self?.emailPinnedFlights.alpha = 0.0
                        self?.sharePinnedFilghts.alpha = 0.0
                      }, completion: { [weak self] (success) in
                          self?.unpinnedAllButton.isHidden = true
                          self?.emailPinnedFlights.isHidden = true
                          self?.sharePinnedFilghts.isHidden = true
                          self?.unpinnedAllButton.alpha = 1.0
                          self?.emailPinnedFlights.alpha = 1.0
                          self?.sharePinnedFilghts.alpha = 1.0
                  })
              } else {
                  self.unpinnedAllButton.transform = CGAffineTransform(translationX: 0, y: 0)
                  self.emailPinnedFlights.transform = CGAffineTransform(translationX: 0, y: 0)
                  self.sharePinnedFilghts.transform = CGAffineTransform(translationX: 0, y: 0)
                  self.unpinnedAllButton.isHidden = true
                  self.emailPinnedFlights.isHidden = true
                  self.sharePinnedFilghts.isHidden = true
              }
          }
          
          func animateButton() {
              self.showPinnedButtons()
          }
    
     func manageSwitchContainer(isHidden: Bool, shouldOff: Bool = true) {
          
         manageFloatingView(isHidden: isHidden)
           
           DispatchQueue.main.async {
               let newFrame = CGRect(x: 0.0, y: isHidden ? 100.0 : 0.0, width: self.pinnedFlightsOptionsView.width, height: self.pinnedFlightsOptionsView.height)
                        
            UIView.animate(withDuration: AppConstants.kAnimationDuration, animations: {[weak self] in
                   guard let sSelf = self else {return}
                   
                   sSelf.pinnedFlightsOptionsView.frame = newFrame
                   sSelf.view.layoutIfNeeded()
                   
                   }, completion: { [weak self](isDone) in
                       guard let sSelf = self else {return}
                       
                       if isHidden {
                           sSelf.pinnedFlightsOptionsView.isHidden = true
                       }
               })
           }
           
           if isHidden, shouldOff {
               //if switch is hidden then it must be off, otherwise it should be as it is.
            self.hidePinnedButtons()
              // tableViewVertical.setContentOffset(CGPoint(x: 0, y: -topContentSpace), animated: false)
               showBluredHeaderViewCompleted()
           }
           
       }
    
    func setPinedSwitchState(isOn : Bool){
         switchView.isOn = isOn
     }
    
}





