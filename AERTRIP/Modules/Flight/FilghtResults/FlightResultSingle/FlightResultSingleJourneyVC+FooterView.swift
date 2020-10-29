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
            } else {
                setGroupedFooterView()
            }
        }
        
        func setGroupedFooterView() {
            if viewModel.results.aboveHumanScoreCount == 0 || viewModel.resultTableState == .showPinnedFlights {
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
            
            let titleLabel = UILabel(frame: CGRect(x:8,y: 8 ,width:groupedFooterView.frame.width - 16  ,height:44))
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
           expandFlights()
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
     
            let titleLabel = UILabel(frame: CGRect(x:8,y: 8 ,width:expandedFooterView.frame.width - 16  ,height:44))
            titleLabel.textColor = UIColor.AertripColor
            titleLabel.font = UIFont(name: "SourceSansPro-Regular", size: 18)
            titleLabel.textAlignment = .center
            let count = viewModel.results.aboveHumanScoreCount

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
//            baseView.layer.cornerRadius = 5.0
//            baseView.layer.shadowColor = UIColor.black.cgColor
//            baseView.layer.shadowOpacity = 0.1
//            baseView.layer.shadowRadius = 8.0
//            baseView.layer.shadowOffset = CGSize(width: 0, height: 2)
            baseView.addShadow(cornerRadius: 5.0, maskedCorners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], color: AppColors.appShadowColor, offset: CGSize(width: 0, height: 2), opacity: 0.1, shadowRadius: 8.0)
            return baseView
        }
        
        
    @objc func tapOnExpandedFooterView(_ sender: UITapGestureRecognizer) {
        collapseFlights()
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
