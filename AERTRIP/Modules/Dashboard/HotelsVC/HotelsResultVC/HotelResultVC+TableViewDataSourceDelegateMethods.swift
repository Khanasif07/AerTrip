//
//  HotelResultVC+TableViewDataSourceDelegateMethods.swift
//  AERTRIP
//
//  Created by apple on 18/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

// MARK: - Table view datasource and delegate methods

// MARK: -

extension HotelResultVC: UITableViewDataSource, UITableViewDelegate {
    func manageViewForSearchAndFilterMode() {
        
        let count = self.viewModel.fetchedResultsController.fetchedObjects?.count ?? 0
        if (self.viewModel.fetchRequestType == .FilterApplied), count <= 0 {
            //self.hotelSearchView.isHidden = false
            self.tableViewVertical.backgroundView = noHotelFoundOnFilterEmptyView
            self.noHotelFoundOnFilter()
            self.manageFloatingView(isHidden: true)
        }
        else if (self.viewModel.fetchRequestType == .Searching) {
            self.manageFloatingView(isHidden: true)
            self.hotelSearchView.isHidden = false
            self.hotelSearchTableView.backgroundView = self.noResultemptyView
            if !self.viewModel.searchedHotels.isEmpty {
                self.hotelSearchTableView.backgroundView?.isHidden = true
            }
            else {
                self.hotelSearchTableView.backgroundView?.isHidden = (self.viewModel.searchTextStr.isEmpty && self.viewModel.searchedHotels.isEmpty)
            }
            manageFloatingView(isHidden: true)
        }
        else if (self.viewModel.fetchRequestType == .normalInSearching) {
            self.viewModel.searchedHotels.removeAll()
            self.hotelSearchView.isHidden = false
            hotelSearchTableView.backgroundColor = AppColors.clear
            self.hotelSearchTableView.backgroundView?.isHidden = true
            manageFloatingView(isHidden: true)
        }
        else {
            self.dataFounOnFilter()
            self.hotelSearchView.isHidden = true
            self.tableViewVertical.backgroundView = nil
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        manageViewForSearchAndFilterMode()
        if tableView === hotelSearchTableView {
            searchBar.enablesReturnKeyAutomatically = self.viewModel.searchedHotels.count < 0
            return 1
        }
        else {
            return self.viewModel.fetchedResultsController.sections?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView === hotelSearchTableView {
            return self.viewModel.searchedHotels.count
        } else {
            guard let sections = self.viewModel.fetchedResultsController.sections else {
                printDebug("No sections in fetchedResultsController")
                return 0
            }
            let sectionInfo = sections[section]
        //    let dbData = fetchedResultsController.fetchedObjects ?? []//CoreDataManager.shared.fetchData("HotelSearched") ?? []
            // shimmer will be remain hidden in this case
            self.manageShimmer(isHidden: true)
            manageViewForSearchAndFilterMode()
            return sectionInfo.numberOfObjects
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView === hotelSearchTableView {
            return 0.0
        }
        else {
           return  section == 0 ?  0 :  53.0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView === hotelSearchTableView {
            return nil
        }
        else {
            guard let hView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HotelResultSectionHeader") as? HotelResultSectionHeader else {
                return nil
            }
            
            hView.titleLabel.text = self.getSectionTitle(forSection: section)
            hView.titleLabelWidthConstraint.constant = hView.titleLabel.intrinsicContentSize.width + 16
            return hView
        }
    }
    
    func getSectionTitle(forSection section: Int) -> String {
        guard let allSections = self.viewModel.fetchedResultsController.sections else {
            return ""
        }
        
        var finalText = "a" // for handling empty case
        if section >= (allSections.count - 1) {
            //it's a last section updated this
            
            let title = allSections[section].name
            if title.contains("to") {
                var titleArr = allSections[section].name.components(separatedBy: "to")
                titleArr[1] = " \(Int((self.viewModel.filterApplied.distanceRange < 1.0) ? 1.0 : self.viewModel.filterApplied.distanceRange))"
                
                finalText = titleArr.joined(separator: "to")
            }
            else {
                finalText = title
            }
        }
        else {
            //not a last section return as it is
            finalText = allSections[section].name
        }
        
        _ = finalText.removeFirst()
        if !finalText.isEmpty {
            finalText += " kms"
        }
        
        return finalText
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView === hotelSearchTableView {
            return 110.0
        } else {
            return 209.0
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView === hotelSearchTableView {
            return indexPath.row == 0 ? 115.0 : 110.0
        } else {
            return 209.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView === hotelSearchTableView {
            guard let cell = hotelSearchTableView.dequeueReusableCell(withIdentifier: self.hotelResultCellIdentifier, for: indexPath) as? HotelSearchTableViewCell else {
                printDebug("HotelSearchTableViewCell not found")
                return UITableViewCell()
            }
            cell.searchText = self.viewModel.searchTextStr
            cell.topDividerView.isHidden = indexPath.row == 0 ? false : true
            cell.topConstraintDividerView.constant = indexPath.row == 0 ? 5 : 0
            if self.viewModel.searchedHotels.count > 0 {
                cell.hotelData = self.viewModel.searchedHotels[indexPath.row]
            }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "HotelCardTableViewCell", for: indexPath) as? HotelCardTableViewCell else {
                fatalError("HotelCardTableViewCell not found")
            }
            
            let hData = viewModel.fetchedResultsController.object(at: indexPath)
            self.isAboveTwentyKm = hData.isHotelBeyondTwentyKm
            self.isFotterVisible = self.isAboveTwentyKm
            cell.hotelListData = hData
            cell.delegate = self
            cell.contentView.backgroundColor = AppColors.themeWhite
            if  let sections = self.viewModel.fetchedResultsController.sections {
                let sectionInfo = sections[indexPath.section]
                cell.isLastCellInSection =  indexPath.item ==  (sectionInfo.numberOfObjects - 1)
            } else {
                cell.isLastCellInSection = false
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        self.selectedIndexPath = indexPath
        if tableView === hotelSearchTableView {
            let hData = self.viewModel.searchedHotels[indexPath.row]
            if let cell = tableView.cellForRow(at: indexPath) as? HotelSearchTableViewCell {
//                AppFlowManager.default.presentHotelDetailsVC(self,hotelInfo: hData, sourceView: cell.contentView, sid: self.viewModel.sid, hotelSearchRequest: self.viewModel.hotelSearchRequest){
//                    self.statusBarColor = AppColors.themeWhite
//                }
                self.presentController(cell: cell, hotelInfo: hData, sid: self.viewModel.sid, hotelSearchRequest: self.viewModel.hotelSearchRequest)
                self.selectedIndexPath = indexPath
            }
        } else {
            let hData = viewModel.fetchedResultsController.object(at: indexPath)
            if let cell = tableView.cellForRow(at: indexPath) as? HotelCardTableViewCell {
                
                self.presentController(cell: cell, hotelInfo: hData, sid: self.viewModel.sid, hotelSearchRequest: self.viewModel.hotelSearchRequest)

            }
        }
    }
    
    //--------------------------- Golu Change ---------------------
    func presentController(cell:TransitionCellTypeDelegate, hotelInfo: HotelSearched, sid: String, hotelSearchRequest: HotelSearchRequestModel?){
        
        let vc = HotelDetailsVC.instantiate(fromAppStoryboard: .HotelResults)
        vc.viewModel.hotelInfo = hotelInfo
        vc.delegate = self
        vc.viewModel.hotelSearchRequest = hotelSearchRequest
        var img = cell.selfImage
        if cell.selfImage == nil{
            img = cell.viewScreenShot()
        }
        vc.backImage = img
        cell.freezeAnimations()
        let currentCellFrame = cell.layer.presentation()!.frame
        let cardFrame = cell.superview!.convert(currentCellFrame, to: nil)
        vc.modalPresentationStyle = .custom
        let frameWithoutTransform = { () -> CGRect in
            let center = cell.center
            let size = cell.bounds.size
            let r = CGRect(
                x: center.x - size.width / 2,
                y: center.y - size.height / 2,
                width: size.width,
                height: size.height
            )
            return cell.superview!.convert(r, to: nil)
        }()
        
        let params = CardTransition.Params(fromCardFrame: cardFrame, fromCardFrameWithoutTransform: frameWithoutTransform, fromCell: cell, img: img)
        self.transition = CardTransition(params: params)
        
        let nav = AppFlowManager.default.getNavigationController(forPresentVC: vc)
        nav.transitioningDelegate = transition
        nav.modalPresentationCapturesStatusBarAppearance = true
        nav.modalPresentationStyle = .custom
        self.present(nav, animated: true, completion: {
            cell.unfreezeAnimations()
        })
        
    }
}



