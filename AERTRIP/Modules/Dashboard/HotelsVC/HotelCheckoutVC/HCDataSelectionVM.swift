//
//  HCDataSelectionVM.swift
//  AERTRIP
//
//  Created by Admin on 12/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HCDataSelectionVM {
    
    //MARK:- Properties
    //MARK:- Public
    static let shared = HCDataSelectionVM()
    
    // Save Hotel Form Data
  
    var hotelFormData : HotelFormPreviosSearchData = HotelFormPreviosSearchData()
    var selectedIndexPath: IndexPath = IndexPath()
   
    //GuestModalArray for travellers
    var guests : [[GuestModal]] = [[]]
    
    
     private init() {}
    
  
    
    //MARK:- Private
    
    
    //MARK:- Methods
    //MARK:- Private
    
    
    //MARK:- Public
}
