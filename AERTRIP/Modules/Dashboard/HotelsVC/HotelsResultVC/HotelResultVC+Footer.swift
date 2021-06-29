//
//  HotelResultVC+Footer.swift
//  AERTRIP
//
//  Created by Admin on 29/04/21.
//  Copyright © 2021 Pramod Kumar. All rights reserved.
//

import Foundation


extension HotelResultVC {
    

    func setGroupedFooterView() {

        
        var numberOfView = 3
        
        let height = 44.0 + 35.0 + CGFloat(numberOfView - 1) * 16.0
        let footerViewRect =  CGRect(x: 0, y: 0, width: tableViewVertical.frame.width, height: height)
        let groupedFooterView = UIView(frame:footerViewRect)
        groupedFooterView.isUserInteractionEnabled = true
//            groupedFooterView.backgroundColor = UIColor.yellow
        let  tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnGroupedFooterView(_:)))
        tapGesture.numberOfTapsRequired = 1
        groupedFooterView.addGestureRecognizer(tapGesture)
        
        let footerBackgroundColor = [AppColors.themeWhiteDashboard, AppColors.flightResultsFooterSecondaryColor, AppColors.flightResultsFooterThirdColor]
        
        for count in 1...numberOfView {
            var backgroundColor = AppColors.themeWhiteDashboard
            if let color = footerBackgroundColor[safe: count - 1]{
                backgroundColor = color
            }
            let baseView = createRepeatedFooterBaseView(backgroundColor: backgroundColor)
            
            baseView.frame = CGRect(x: (8 * count) ,y: (10 + 6 * count) - 8 ,width: (Int(groupedFooterView.frame.width) - (16 * count))  ,height:44)
            groupedFooterView.addSubview(baseView)
            groupedFooterView.sendSubviewToBack(baseView)
        }
        
        let titleLabel = UILabel(frame: CGRect(x:8,y: 8 ,width:groupedFooterView.frame.width - 16  ,height:44))
        titleLabel.textColor = UIColor.AertripColor
//            titleLabel.font = UIFont(name: "SourceSansPro-Regular", size: 18.0)
        titleLabel.font = AppFonts.Regular.withSize(18)
        titleLabel.textAlignment = .center
        
        titleLabel.text  = "Beyond 20 Km"


        groupedFooterView.addSubview(titleLabel)
        
        
        if let footerView = tableViewVertical.tableFooterView {
            
            for subview in footerView.subviews {
                subview.removeFromSuperview()
            }
            
            footerView.frame = footerViewRect
            footerView.addSubview(groupedFooterView)
        }
        else {
            let footerView = UIView(frame : footerViewRect)
            footerView.addSubview(groupedFooterView)
            tableViewVertical.tableFooterView = footerView
        }
    }
    
    
    @objc func tappedOnGroupedFooterView(_ sender : UITapGestureRecognizer) {

        UIView.animate(withDuration: 0.1) {
        
            self.tableViewVertical.tableFooterView?.transform = CGAffineTransform(translationX: 0, y: 200)
    
        } completion: { (success) in
            
            self.tableViewVertical.tableFooterView?.transform = CGAffineTransform.identity

            self.setExpandedStateFooter()
            
            self.viewModel.showBeyondTwenty = true
            
            self.doneButtonTapped()
        }
 
    }
    
    
    
    func setExpandedStateFooter() {
                
        let footerViewRect = CGRect(x: 0, y: 0, width: tableViewVertical.frame.width, height: 95)
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
//            titleLabel.font = UIFont(name: "SourceSansPro-Regular", size: 18)
        titleLabel.font = AppFonts.Regular.withSize(18)
        titleLabel.textAlignment = .center
       
        titleLabel.text  = "Less then 20 km"
        expandedFooterView.addSubview(titleLabel)
        
        
        if let footerView = tableViewVertical.tableFooterView {
            
            for subview in footerView.subviews {
                subview.removeFromSuperview()
            }
            
            footerView.frame = footerViewRect
            footerView.addSubview(expandedFooterView)
        }
        else {
            let footerView = UIView(frame : footerViewRect)
            footerView.addSubview(expandedFooterView)
            tableViewVertical.tableFooterView = footerView
        }
    }
    
    
    @objc func tapOnExpandedFooterView(_ sender: UITapGestureRecognizer) {
        
//        guard let sections = self.viewModel.fetchedResultsController.sections else {
//            printDebug("No sections in fetchedResultsController")
//            return
//        }
//
//        printDebug("sections....\(sections.count)")
//
//        tableViewVertical.deleteSections(IndexSet(integer: sections.count - 1), with: UITableView.RowAnimation.fade)
        
        UIView.animate(withDuration: 0.1) {
            
            self.tableViewVertical.tableFooterView?.transform = CGAffineTransform(translationX: 0, y: 1)

        } completion: { (success) in
            
            self.tableViewVertical.tableFooterView?.transform = CGAffineTransform.identity
           
            let yPoint = self.tableViewVertical.contentSize.height - (self.tableViewVertical.tableFooterView?.height ?? 0.0)
            
            self.tableViewVertical.setContentOffset(CGPoint(x: 0, y: yPoint), animated: false)
            
            self.setGroupedFooterView()
            self.viewModel.showBeyondTwenty = false
            self.doneButtonTapped()
            
        }

    }
    
    
    
    func createRepeatedFooterBaseView(backgroundColor: UIColor = AppColors.themeWhiteDashboard) -> UIView {// = 
        let baseView = UIView(frame: CGRect(x: 0 , y: 0, width: tableViewVertical.frame.width, height: 44))
        baseView.backgroundColor = backgroundColor
        let shadowProp = AppShadowProperties()
        baseView.addShadow(cornerRadius: shadowProp.cornerRadius/2, maskedCorners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], color: shadowProp.shadowColor, offset: shadowProp.offset, opacity: shadowProp.opecity, shadowRadius: shadowProp.shadowRadius)
        return baseView
    }
    
}
