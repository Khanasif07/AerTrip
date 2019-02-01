//
//  RoomGuestSelectionVM.swift
//  AERTRIP
//
//  Created by Admin on 21/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class RoomGuestSelectionVM {
    
    //MARK:- Properties
    //MARK:- Public
    var roomNumber: Int = 1
    var selectedAdults: Int = 1
    var selectedChilds: Int = 2
    let maxGuest: Int = 6
    var childrenAge: [Int] = [3, 10, 0, 0]
    
    var selectionString: String {
        var temp = ""
        if self.selectedAdults > 0 {
            temp = "\(self.selectedAdults) \((self.selectedAdults > 1) ? LocalizedString.Adults.localized : LocalizedString.Adult.localized)"
        }
        
        if self.selectedChilds > 0 {
            if !temp.isEmpty {
                temp += " \(LocalizedString.and.localized) "
            }
            temp += "\(self.selectedChilds) \((self.selectedChilds > 1) ? LocalizedString.Children.localized : LocalizedString.Child.localized)"
        }
        return temp
    }
    
    //MARK:- Methods
    //MARK:- Public
    
}
