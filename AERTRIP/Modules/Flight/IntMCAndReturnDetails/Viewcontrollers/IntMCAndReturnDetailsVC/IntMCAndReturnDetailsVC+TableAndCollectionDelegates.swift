//
//  InternationalReturnAndMulticityVC+TableAndCollectionDelegates.swift
//  Aertrip
//
//  Created by Apple  on 17.04.20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import Foundation
import UIKit

//MARK:- Colletionview delegate, dataSource and flowLayoutDelegate
extension IntMCAndReturnDetailsVC: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numberOfLegs
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IntHeaderCollectionCell", for: indexPath) as? IntHeaderCollectionCell {
            cell.setUI(self.viewModel.headerArray[indexPath.row])
            if ( indexPath.row == (self.viewModel.headerArray.count - 1)) {
                cell.veticalSeparator.isHidden = true
            }
            else {
                cell.veticalSeparator.isHidden = false
            }
            cell.title.font = AppFonts.SemiBold.withSize(18.0)
            return cell
        }
        return UICollectionViewCell()
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var size = UIScreen.size
        size.height = 50
        
        if self.viewModel.numberOfLegs > 2 {
            
            if indexPath.row == 1 {
                size.width = size.width * 0.4
            }else {
                size.width = size.width * 0.5
            }
        }
        else {
            size.width = size.width * 0.5
        }
        return size
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let visibleRect = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50)
        
        guard let theAttributes = collectionView.layoutAttributesForItem(at: indexPath) else { return }
        var cellFrameInSuperview = collectionView.convert(theAttributes.frame, to: self.view)
        cellFrameInSuperview.origin.y = 0.0
        
        // if tapped cell is completely visible , return
        if visibleRect.contains(cellFrameInSuperview) {
            return
        }
        else {
            let width = baseScrollView.frame.size.width / 2.0
            let offset : CGFloat
            if cellFrameInSuperview.origin.x < 0 {
                // cell is located at left side of screen
                offset = CGFloat(indexPath.row ) * width
                
            }else {
                // cell is located at right side of screen
                offset = CGFloat(indexPath.row - 1) * width
            }
            let yOffset:CGFloat = (self.headerCollectionViewTop.constant == 0.0) ? 44 : 0.0
            baseScrollView.setContentOffset(CGPoint(x: offset, y: yOffset), animated: true)
        }
    }
}

//MARK:- TableView delegate dataSource
extension  IntMCAndReturnDetailsVC : UITableViewDataSource , UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let index = tableView.tag - 1000
            return self.viewModel.results[index].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let index = tableView.tag - 1000
        if let cell = tableView.dequeueReusableCell(withIdentifier: "InternationalReturnDetailsCell") as? InternationalReturnDetailsCell{
            cell.selectionStyle = .none
            cell.currentJourney = self.viewModel.results[index][indexPath.row]
            setPropertiesToCellAt(index:index, indexPath, cell: cell, tableView)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (indexPath.row == 0) ? 91.5 : 92
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        animateJourneyCompactView(for: tableView)
        setTotalFare()
        if self.viewModel.numberOfLegs == 2{
            updateSeleted(indexPath: indexPath, table: tableView)
        }else{
            enableDisableForMulticity(indexPath: indexPath, table: tableView)
        }
        setTableViewHeaderAfterSelection(tableView: tableView)
    }
    
    
    
    func updateSeleted(indexPath: IndexPath, table: UITableView) {
        let index = table.tag - 1000
        if index < (self.viewModel.numberOfLegs - 1) {
            _ = self.getSelectedJourneyForAllLegs()
            if viewModel.numberOfLegs == 2{
                self.viewModel.updateCellOnSelection(index: index, journey: self.viewModel.results[index][indexPath.row])
            }else{
                self.viewModel.updateSelectionForMuticity(index: index, journey: self.viewModel.results[index][indexPath.row])
            }
            
            let newTag = table.tag + 1
            let upIndex = index + 1
            let newTable = self.baseScrollView.viewWithTag(newTag) as? UITableView ?? UITableView()
            newTable.reloadData()
            table.reloadData()
            if upIndex < self.viewModel.selectedJourney.count{
                
                let currentResuls = self.viewModel.results[upIndex]
                let currentJourney = self.viewModel.selectedJourney[upIndex]
                var newSelectedIndex = 0
                if (self.findFirstFor(currentJourney, from: currentResuls, legIndex: upIndex)?.legsWithDetail.first?.isDisabled ?? false){
                    let currentIndx = self.findFirstIndexFor(currentJourney, from: currentResuls, legIndex: upIndex) ?? 0
                    
                    if let indx = self.findFirstIndexFor(false, from: Array(currentResuls[currentIndx..<currentResuls.count])){
                        let newIndexPath = IndexPath(row: (currentIndx + indx), section: 0)
                        newSelectedIndex = (currentIndx + indx)
                        newTable.selectRow(at: newIndexPath, animated: true, scrollPosition: .bottom)
                    }else{
                        let newIndex = self.findFirstIndexFor(false, from: currentResuls) ?? 0
                        newSelectedIndex = newIndex
                        let newIndexPath = IndexPath(row: newIndex, section: 0)
                        newTable.selectRow(at: newIndexPath, animated: true, scrollPosition: .bottom)
                    }
                    
                }else{
                    if let newIndex =  self.findFirstIndexFor(currentJourney, from: currentResuls, legIndex: upIndex){
                        newSelectedIndex = newIndex
                        let newIndexPath = IndexPath(row: newIndex, section: 0)
                        newTable.selectRow(at: newIndexPath, animated: true, scrollPosition: .bottom)
                    }
                }
                self.viewModel.checkForMessageWith(self.viewModel.results[upIndex][newSelectedIndex], at: upIndex)
            }
            table.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
            self.setTotalFare()
            setTableViewHeaderAfterSelection(tableView: newTable)
            self.updateSelectedPreviousController()
            
        }else{
            
            self.viewModel.checkForMessageWith(self.viewModel.results[index][indexPath.row], at: index)
            self.updateSelectedPreviousController()
        }
        
    }
    
    func enableDisableForMulticity(indexPath: IndexPath, table: UITableView){
        let index = table.tag - 1000
        var counter = 1
        for i in index..<self.viewModel.numberOfLegs{
            if i == index{
                self.updateSeleted(indexPath: indexPath, table: table)
            }else{
                let upIndex = index + counter
                counter += 1
                if let newTable = self.baseScrollView.viewWithTag(1000 + upIndex) as? UITableView,(upIndex < self.viewModel.selectedJourney.count - 1),
                    let newIndex = self.findFirstIndexFor(self.viewModel.selectedJourney[upIndex], from: self.viewModel.results[upIndex], legIndex: upIndex){
                    let newIndexPath = IndexPath(row: newIndex, section: 0)
                    self.updateSeleted(indexPath: newIndexPath, table: newTable)
                }
            }
        }
    }
    
    func findFirstIndexFor(_ journey:IntJourney, from data: IntResultArray, legIndex: Int)->Int?{
        return (data.firstIndex(where:{$0.leg.contains(journey.leg[legIndex])}))
    }
    
    func findFirstFor(_ journey:IntJourney, from data: IntResultArray, legIndex: Int)-> IntJourney?{
        return (data.first(where:{$0.leg.contains(journey.leg[legIndex])}))
    }
    
    func findFirstIndexFor(_ disabled:Bool, from data: IntResultArray)->Int?{
        return data.firstIndex(where:{$0.legsWithDetail.first?.isDisabled == disabled})
    }
    func findFirstFor(_ disabled:Bool, from data: IntResultArray)->IntJourney?{
        return data.first(where:{$0.legsWithDetail.first?.isDisabled == disabled})
    }
    
    private func updateSelectedPreviousController(){
        var legs = [String]()
        for i in 0..<self.viewModel.selectedJourney.count{
            legs.insert(self.viewModel.selectedJourney[i].leg[i], at: i)
        }
        if let journey = self.viewModel.internationalDataArray?.first(where: {$0.leg == legs}){
            onJourneySelect?(journey.id)
            self.viewModel.selectedCompleteJourney = journey
        }
        
    }
    
    
    //MARK:- Configure table cell according to their result.
    fileprivate func setPropertiesToCellAt( index: Int, _ indexPath: IndexPath,  cell: InternationalReturnDetailsCell, _ tableView: UITableView) {
        let arrayForDisplay = self.viewModel.results[index]
        guard (arrayForDisplay.count) > indexPath.row else {  return }
        /*if*/ let journey = arrayForDisplay[indexPath.row] //{
            cell.showDetailsFrom(journey:  journey)
        if let logoArray = journey.legsWithDetail.first?.airlineLogoArray {
                
                switch logoArray.count {
                case 1 :
                    cell.iconTwo.isHidden = true
                    cell.iconThree.isHidden = true
                    setImageto(tableView: tableView, imageView: cell.iconOne, url:logoArray[0] , index:  indexPath.row)
                case 2 :
                    cell.iconThree.isHidden = true
                    setImageto(tableView: tableView, imageView: cell.iconOne, url:logoArray[0] , index:  indexPath.row)
                    setImageto(tableView: tableView, imageView: cell.iconTwo, url:logoArray[1] , index:  indexPath.row)
                    
                case 3 :
                    setImageto(tableView: tableView, imageView: cell.iconOne, url:logoArray[0] , index:  indexPath.row)
                    setImageto(tableView: tableView, imageView: cell.iconTwo, url:logoArray[1] , index:  indexPath.row)
                    setImageto(tableView: tableView, imageView: cell.iconThree, url:logoArray[2] , index:  indexPath.row)
                default:
                    break
                }
            }
    }
    
    func setImageto(tableView: UITableView,  imageView : UIImageView , url : String , index : Int ) {
        if let image = tableView.resourceFor(urlPath: url , forView: index) {
            let resizedImage = image.resizeImage(24.0, opaque: false)
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage.roundedRectImageFromImage(image: resizedImage, imageSize: CGSize(width: 24.0, height: 24.0), cornerRadius: 2.0)
        }
    }
}
