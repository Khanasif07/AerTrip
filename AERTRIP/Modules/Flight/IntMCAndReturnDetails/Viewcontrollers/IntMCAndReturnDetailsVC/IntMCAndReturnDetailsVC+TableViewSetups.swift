//
//  InternationalReturnAndMulticityVC+TableViewSetups.swift
//  Aertrip
//
//  Created by Apple  on 17.04.20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import Foundation
import UIKit

extension IntMCAndReturnDetailsVC{
    
    func getVisibleAreaRectFor(tableView : UITableView) -> CGRect {
        
        let xCoordinate = tableView.frame.origin.x
        let yCoordinate = self.headerCollectionViewTop.constant + self.headerCollection.frame.height
        let width = tableView.bounds.size.width
        let bottomInset = self.view.safeAreaInsets.bottom
        //FIXME :- magical no
        let height = UIScreen.height - yCoordinate - bottomInset - 50 - self.statusBarHeight
        let visibleRect = CGRect(x: xCoordinate, y: yCoordinate, width: width, height: height)
        return visibleRect
    }
    
    func animateJourneyCompactView(for tableView : UITableView) {
        
        guard let selectedRowIndex = tableView.indexPathForSelectedRow else { return }
        let visibleRect = getVisibleAreaRectFor(tableView: tableView)
        let xCoordinate = tableView.frame.origin.x
        
        var selectedRowRect = tableView.rectForRow(at: selectedRowIndex)
        selectedRowRect.origin.y = selectedRowRect.origin.y - tableView.contentOffset.y
        selectedRowRect.origin.x = xCoordinate
        if visibleRect.contains(selectedRowRect) {
            let index = tableView.tag - 1000
            hideHeaderCellAt(index: index)
        }
        else {
            showHeaderCellAt(indexPath: selectedRowIndex , tableView: tableView)
        }
        setTableViewHeaderFor(tableView: tableView)
    }
    
    
    func showHeaderCellAt(indexPath : IndexPath, tableView : UITableView) {
        
        let index = tableView.tag - 1000
        let headerView = self.viewModel.journeyHeaderViewArray[index]
        
        if headerView.isHidden {
            headerView.isHidden = false
            
            let width = UIScreen.width / 2.0
            
            let arrayForDisplay = self.viewModel.results[index]
            let journey = arrayForDisplay[indexPath.row]
            headerView.setValuesFrom(journey: journey)
            
            let headerJourneyRect  = CGRect(x: (width * CGFloat(index)), y: (-journeyCompactViewHeight) , width: width - 1 , height: journeyCompactViewHeight)
            headerView.frame = headerJourneyRect
            
            
            UIView.animate(withDuration: 0.4) {
                var rect = headerView.frame
                var yCoordinate = max(self.headerCollectionViewTop.constant +  self.headerCollection.frame.size.height , self.headerCollection.frame.size.height )
                if self.baseScrollView.contentOffset.y == 44.0 {
                    yCoordinate = yCoordinate + 44.0
                }
                rect.origin.y = yCoordinate
                rect.size.height = self.journeyCompactViewHeight
                headerView.frame = rect
            }
        }
    }
    
    func hideHeaderCellAt(index : Int) {
        
        let headerView = self.viewModel.journeyHeaderViewArray[index]
        
        if headerView.isHidden {
            return
        }
        
        if !headerView.isHidden {
            UIView.animate(withDuration: 0.4, animations: {
                
                var frame = headerView.frame
                frame.origin.y =  (-self.headerCollectionViewTop.constant - self.journeyCompactViewHeight)
                headerView.frame = frame
                
            }) { (completed) in
                headerView.isHidden = true
            }
        }
    }
    
    
    //MARK:- Setting TableView Header after showing/hiding journey compact view to avoid overlapping of first cell
    
    func setTableViewHeaderFor(tableView  : UITableView) {
        guard tableView.contentSize.height > tableView.frame.height else {return}
        let width = tableView.bounds.size.width
        let index = tableView.tag - 1000
        let headerView = self.viewModel.journeyHeaderViewArray[index]
        
        let height : CGFloat
        if headerView.isHidden {
            height = 94.0
        }
        else {
            height = 136.0
        }
        
        let rect = CGRect(x: 0, y: 0, width: width, height: height )
        let tableHeaderView = UIView(frame: rect)
        tableView.tableHeaderView = tableHeaderView
    }
    
    
    func setTableViewHeaderAfterSelection(tableView  : UITableView) {
        
        let visibleRect = self.getVisibleAreaRectFor(tableView: tableView)
        let xCoordinate = tableView.frame.origin.x
        let zerothRowIndex = IndexPath(item: 0, section: 0)
        var zerothRowRect = tableView.rectForRow(at: zerothRowIndex)
        zerothRowRect.origin.x = xCoordinate
        let width = tableView.bounds.size.width
        
        let isFirstCellVisible : Bool
        if visibleRect.contains(zerothRowRect) {
            isFirstCellVisible = true
        }
        else {
            isFirstCellVisible = false
        }
        let index = tableView.tag - 1000
        let headerView = self.viewModel.journeyHeaderViewArray[index]
        var height : CGFloat = 136.0
        if isFirstCellVisible {
            
            if headerView.isHidden {
                height = 94.0
            }
            else {
                height = 136.0
            }
        }
        
        if let selectedIndex =  tableView.indexPathForSelectedRow
        {
            
            if selectedIndex.row <= 4 {
                height = 94.0
            }
        }
        
        let rect = CGRect(x: 0.0, y: 0.0, width: width, height: height )
        let tableHeaderView = UIView(frame: rect)
        tableView.tableHeaderView = tableHeaderView
    }
    
}
