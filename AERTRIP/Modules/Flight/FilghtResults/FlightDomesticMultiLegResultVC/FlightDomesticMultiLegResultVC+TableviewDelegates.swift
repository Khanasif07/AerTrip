//
//  FlightDomesticMultiLegResultVC+TableviewDelegates.swift
//  AERTRIP
//
//  Created by Appinventiv on 27/08/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

//MARK:- TableView Data source , Delegate Methods
extension  FlightDomesticMultiLegResultVC : UITableViewDataSource , UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           
           let index = tableView.tag - 1000
           
           let tableState = viewModel.resultsTableStates[index]
        
        printDebug("state...\(index)...\(tableState)")
        
           if tableState == .showTemplateResults{
               return 10
           } else if tableState == .showPinnedFlights {
            return self.viewModel.results[index].pinnedFlights.count
           } else if tableState == .showExpensiveFlights {
               return self.viewModel.results[index].allJourneys.count
           } else if tableState == .showRegularResults{
            return self.viewModel.results[index].suggestedJourneyArray.count
           } else{
               return 0
           }
           
       }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
           let index = tableView.tag - 1000
           let tableState = viewModel.resultsTableStates[index]
           
           if tableState == .showTemplateResults {
               if let cell = tableView.dequeueReusableCell(withIdentifier: "DomesticMultiLegTemplateCell") as? DomesticMultiLegTemplateCell{
                   cell.selectionStyle = .none
                   return cell
               }
           } else if tableState == .showNoResults{
                return UITableViewCell()
           } else {
               
               if let cell = tableView.dequeueReusableCell(withIdentifier: "DomesticMultiLegCell") as? DomesticMultiLegCell{
                   cell.selectionStyle = .none
                   setPropertiesToCellAt(index:index, indexPath, cell: cell, tableView)
                   
                   if #available(iOS 13, *) {
                    if cell.interactions.isEmpty{
                       let interaction = UIContextMenuInteraction(delegate: self)
                       cell.addInteraction(interaction)
                    }
                   }
                   return cell
               }
           }
           return UITableViewCell()
       }
       
       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 130.0
       }
       
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        tableView.isScrollEnabled = false
        baseScrollView.isScrollEnabled = false
        isNeedToUpdateLayout = false
        return indexPath
    }
    
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let tableIndex = tableView.tag - 1000
        
        printDebug(self.viewModel.results[tableIndex].suggestedJourneyArray[indexPath.row].fk)
        
        self.viewModel.shouldDisplayToast = true
        self.viewModel.setSelectedJourney(tableIndex: tableIndex, journeyIndex: indexPath.row)
           
           if flightSearchType == RETURN_JOURNEY { 
               checkForComboFares()
           }
           checkForOverlappingFlights(displayToast : false)
            showMessageForIncompatableFlights(tableIndex: tableIndex)
           setTotalFare()
//        tableView.reloadData()
//        animateJourneyCompactView(for: tableView)
        if let indexPath = tableView.indexPathsForVisibleRows{
            UIView.performWithoutAnimation {
                tableView.reloadRows(at: indexPath, with: .none)
            }
        }
        setTableViewHeaderAfterSelection(tableView: tableView)
        delay(seconds: 0.2) {
            tableView.isScrollEnabled = true
            self.baseScrollView.isScrollEnabled = true
            self.isNeedToUpdateLayout = true
        }
       }
    
    fileprivate func setPropertiesToCellAt( index: Int, _ indexPath: IndexPath,  cell: DomesticMultiLegCell, _ tableView: UITableView) {
         
//         let tableState = viewModel.resultsTableStates[index]
    
        var arrayForDisplay = self.viewModel.results[index].suggestedJourneyArray
         
        arrayForDisplay = self.viewModel.currentDataSource(tableIndex: index)
         
         if arrayForDisplay.count > 0 && indexPath.row < arrayForDisplay.count{
              
            let journey = arrayForDisplay[indexPath.row]
                 
            cell.showDetailsFrom(journey:  journey, selectedJourney: self.viewModel.results[index].selectedJourney)
               
            if let logoArray = journey.airlineLogoArray {
                     
                     switch logoArray.count {
                     case 1 :
                         cell.iconTwo.isHidden = true
                         cell.iconThree.isHidden = true
                         cell.iconOne.setImageWithUrl(logoArray[0], placeholder: UIImage(), showIndicator: false)

//                         setImageto(tableView: tableView, imageView: cell.iconOne, url:logoArray[0] , index:  indexPath.row)
                     case 2 :
                         cell.iconThree.isHidden = true
                        
                         cell.iconOne.setImageWithUrl(logoArray[0], placeholder: UIImage(), showIndicator: false)
                         cell.iconTwo.setImageWithUrl(logoArray[1], placeholder: UIImage(), showIndicator: false)

                         
//                         setImageto(tableView: tableView, imageView: cell.iconOne, url:logoArray[0] , index:  indexPath.row)
//                         setImageto(tableView: tableView, imageView: cell.iconTwo, url:logoArray[1] , index:  indexPath.row)
                         
                     case 3 :
                        
                        cell.iconOne.setImageWithUrl(logoArray[0], placeholder: UIImage(), showIndicator: false)
                        cell.iconTwo.setImageWithUrl(logoArray[1], placeholder: UIImage(), showIndicator: false)
                        cell.iconThree.setImageWithUrl(logoArray[2], placeholder: UIImage(), showIndicator: false)

                        
//
//                         setImageto(tableView: tableView, imageView: cell.iconOne, url:logoArray[0] , index:  indexPath.row)
//                         setImageto(tableView: tableView, imageView: cell.iconTwo, url:logoArray[1] , index:  indexPath.row)
//                         setImageto(tableView: tableView, imageView: cell.iconThree, url:logoArray[2] , index:  indexPath.row)
                     default:
                         break
                     }
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
    
     func setTotalFare() {
        if let selectedJourneys = self.viewModel.getSelectedJourneyForAllLegs() {
               if selectedJourneys.count == self.viewModel.numberOfLegs {
                   ShowFareBreakupView()
               }else{
                hideFareBreakupView()
               }
           } else {
               hideFareBreakupView()
           }
       }
    
}
