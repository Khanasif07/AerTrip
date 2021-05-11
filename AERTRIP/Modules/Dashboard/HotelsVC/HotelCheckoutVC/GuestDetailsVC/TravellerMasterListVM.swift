//
//  TravellerMasterListVM.swift
//  AERTRIP
//
//  Created by Admin on 10/05/21.
//  Copyright © 2021 Pramod Kumar. All rights reserved.
//

import Foundation

class TravellerMasterListVM{
    
    var selectedTraveller: [TravellerModel] = []
    var tableDataArray: [[TravellerModel]] = []
    var selfTraveller = TravellerModel()
    var tableSectionArray = [String]()
    
    
    func createDataSource(with travellers: [TravellerModel] = GuestDetailsVM.shared.travellerList){
        
        tableSectionArray = []
        tableDataArray = []
        
        var sortedList = travellers
        if UserInfo.loggedInUser?.generalPref?.sortOrder == "LF" {
            sortedList = sortedList.sorted(by: {$0.lastFirstName < $1.lastFirstName})
        }else{
            sortedList = sortedList.sorted(by: {$0.firstLastName < $1.firstLastName})
        }
        if let index = sortedList.firstIndex(where: {$0.group.lowercased() == "me"}){
            selfTraveller = sortedList[index]
            sortedList.remove(at: index)
        }
        if UserInfo.loggedInUser?.generalPref?.categorizeByGroup ?? false {
            let dict = Dictionary(grouping: sortedList, by: {$0.group})
            let labels = UserInfo.loggedInUser?.generalPref?.labels ?? []
            
            for label in labels{
                if let travellers = dict[label]{
                    tableSectionArray.append(label)
                    tableDataArray.append(travellers)
                }
            }
        } else {
            if UserInfo.loggedInUser?.generalPref?.sortOrder == "LF" {
                let dict = Dictionary(grouping: sortedList, by: {String($0.lastFirstName.first ?? "#")})
                let keys = Array(dict.keys).sorted()
                var nonAlphaKaysValue = [TravellerModel]()
                let alphabetArray:[String] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".map{String($0)}
                for key in keys{
                    if let value = dict[key]{
                        if alphabetArray.contains(key){
                            tableSectionArray.append(key)
                            tableDataArray.append(value)
                        }else{
                            nonAlphaKaysValue.append(contentsOf: value)
                        }
                        
                    }
                }
                if nonAlphaKaysValue.count != 0{
                    tableSectionArray.append("#")
                    tableDataArray.append(nonAlphaKaysValue)
                }
                
                
            } else {
                let dict = Dictionary(grouping: sortedList, by: {String($0.firstLastName.first ?? "#")})
                let keys = Array(dict.keys).sorted()
                var nonAlphaKaysValue = [TravellerModel]()
                let alphabetArray:[String] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".map{String($0)}
                for key in keys{
                    if let value = dict[key]{
                        if alphabetArray.contains(key){
                            tableSectionArray.append(key)
                            tableDataArray.append(value)
                        }else{
                            nonAlphaKaysValue.append(contentsOf: value)
                        }
                    }
                }
                if nonAlphaKaysValue.count != 0{
                    tableSectionArray.append("#")
                    tableDataArray.append(nonAlphaKaysValue)
                }
            }
        }
        //Insert current user on top top
        tableSectionArray.insert("", at: 0)
        tableDataArray.insert([selfTraveller], at: 0)
    }
    
    
}
