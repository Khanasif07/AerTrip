//
//  FlightDomesticMultiLegResultVC+Animation.swift
//  AERTRIP
//
//  Created by Admin on 25/09/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation


extension FlightDomesticMultiLegResultVC {
    
    
//    func animateButton() {
//        self.animateFloatingButtonOnListView()
//    }
    
        func manageFloatingView(isHidden: Bool) {
             self.pinnedFlightOptionView.isHidden = isHidden
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
        
//        var yOfset : CGFloat = 0
        
        
        UIView.animate(withDuration: AppConstants.kAnimationDuration) {
            if self.viewModel.isFewSeatsLeft {
               self.pinedswitchOptionsBackViewBottom.constant = 100 + self.view.safeAreaInsets.bottom
            } else{
//                yOfset = 0
                self.pinedswitchOptionsBackViewBottom.constant = 51 + self.view.safeAreaInsets.bottom
            }
            self.view.layoutIfNeeded()

        }
        

           DispatchQueue.main.async {
               let newFrame = CGRect(x: 0.0, y: isHidden ? 400 : 0, width: self.pinnedFlightOptionView.width, height: self.pinnedFlightOptionView.height)
                        
            printDebug("manageSwitchContainer....\(isHidden)...\(newFrame)")
            
            UIView.animate(withDuration: AppConstants.kAnimationDuration, animations: { [weak self] in
                   
                   guard let sSelf = self else { return }
                   
                   sSelf.pinnedFlightOptionView.frame = newFrame
               
                   sSelf.view.layoutIfNeeded()
                   
                   }, completion: { [weak self](isDone) in
                       
                        guard let sSelf = self else { return }
                       
                       if isHidden {
                           sSelf.pinnedFlightOptionView.isHidden = true
                       }
                    
               })
            
           }
        
        printDebug("pinnedFlightsOptionsView.isHidden...\(pinnedFlightOptionView.isHidden)")
        
           if isHidden, shouldOff {
               //if switch is hidden then it must be off, otherwise it should be as it is.
            self.hidePinnedButtons()
//               showBluredHeaderViewCompleted()
           }
           
       }
    

    
    func setPinedSwitchState(isOn : Bool){
            switchView.isOn = isOn
        }
    
}
