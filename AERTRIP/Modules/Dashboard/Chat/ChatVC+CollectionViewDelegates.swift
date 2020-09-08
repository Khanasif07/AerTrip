//
//  ChatVC+CollectionViewDelegates.swift
//  AERTRIP
//
//  Created by Appinventiv on 24/03/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

extension ChatVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.chatVm.recentSearchesData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SuggestionsCell", for: indexPath) as? SuggestionsCell else {
                fatalError("SuggestionsCell not found")
        }
        cell.populateData(data: self.chatVm.recentSearchesData[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let object = self.chatVm.recentSearchesData[indexPath.item]
        if object.type == .hotel {
            let width = object.getTextWidth(73)
            let textWidth = width + 86
            let cellWidth = textWidth > 275 ? 275 : textWidth
            printDebug("width: \(width)")
            printDebug("textWidth: \(textWidth)")
            printDebug("cellWidth: \(cellWidth)")
            return CGSize(width: cellWidth , height: 73)
        } else {
            var cellWidth: CGFloat = 275
            if let flight = object.flight {
                let width = flight.travelPlan.width(withConstrainedHeight: 73)
                let textWidth = width + 78
                cellWidth = textWidth > 275 ? 275 : textWidth
            }
            return CGSize(width: cellWidth, height: 73)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let object = self.chatVm.recentSearchesData[indexPath.item]
        if object.type == .hotel {
            var hotelData = HotelFormPreviosSearchData()
            for roomData in object.room ?? [] {
                if roomData.isPresent {
                    if let adultCounts = roomData.adultCounts.toInt {
                        hotelData.adultsCount.append(adultCounts)
                    }
                    var childrenArray: [Int] = []
                    childrenArray.removeAll()
                    var childrenCounter = 0
                    for child in roomData.child {
                        if child.isPresent {
                            childrenArray.append(child.childAge)
                            childrenCounter += 1
                        }
                    }
                    hotelData.childrenAge.append(childrenArray)
                    hotelData.childrenCounts.append(childrenCounter)
                }
            }
            hotelData.ratingCount = object.filter?.stars ?? []
            
            hotelData.checkInDate = Date.getDateFromString(stringDate: object.checkInDate, currentFormat: "E, dd MMM yy", requiredFormat: "yyyy-MM-dd") ?? ""
            hotelData.checkOutDate = Date.getDateFromString(stringDate: object.checkOutDate, currentFormat: "E, dd MMM yy", requiredFormat: "yyyy-MM-dd") ?? ""
            hotelData.destId = object.dest_id
            hotelData.destType = object.dest_type
            hotelData.destName = object.dest_name
            hotelData.cityName = object.dest_name.components(separatedBy: ",").first ?? ""
            var splittedStringArray = object.dest_name.components(separatedBy: ",")
            splittedStringArray.removeFirst()
            let stateName = splittedStringArray.joined(separator: ",")
            hotelData.stateName = stateName
            printDebug("searching again for \(object.dest_name)")
            hotelData.lat = object.lat
            hotelData.lng = object.lng
            hotelData.isHotelNearMeSelected = false
            HotelsSearchVM.hotelFormData = hotelData
            AppFlowManager.default.showHotelResult = true
            AppFlowManager.default.goToDashboard(toBeSelect: .hotels)
        } else {
            if let flight = object.flight {
                printDebug("flight.quary: \(flight.quary)")
                FlightWhatNextData.shared.isSettingForWhatNext = true
                FlightWhatNextData.shared.recentSearch = flight.quary as NSDictionary
                AppFlowManager.default.goToDashboard(toBeSelect: .flight)
            }
        }
    }
    
    
}
