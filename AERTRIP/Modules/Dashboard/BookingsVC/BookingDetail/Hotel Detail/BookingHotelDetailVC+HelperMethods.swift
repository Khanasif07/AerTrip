//
//  BookingHotelDetailVC+HelperMethods.swift
//  AERTRIP
//
//  Created by apple on 14/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation


extension BookingHotelDetailVC {
    
    
    func openMaps() {
        // setting source and destination latitute logitude same for now
        
        let buttons = AppGlobals.shared.getPKAlertButtons(forTitles: [LocalizedString.OpenInMaps.localized,LocalizedString.OpenInGoogleMaps.localized], colors: [AppColors.themeGreen,AppColors.themeGreen])
 
        
        _ = PKAlertController.default.presentActionSheet(nil, message: nil, sourceView: view, alertButtons: buttons, cancelButton: AppGlobals.shared.pKAlertCancelButton) { _, index in
            if index == 0 {
                AppGlobals.shared.openAppleMap(originLat: self.viewModel.hotelData.lat, originLong: self.viewModel.hotelData.long, destLat: self.viewModel.hotelData.lat, destLong: self.viewModel.hotelData.long)
            } else {
                AppGlobals.shared.openGoogleMaps(originLat: self.viewModel.hotelData.lat, originLong: self.viewModel.hotelData.long, destLat: self.viewModel.hotelData.long, destLong: self.viewModel.hotelData.long)
            }
        }
    }
    
    
    func getHeightForRowSecondSection(_ indexPath: IndexPath) -> CGFloat {
       
        return [60,60,60,UITableView.automaticDimension,180,UITableView.automaticDimension,UITableView.automaticDimension,UITableView.automaticDimension,UITableView.automaticDimension,UITableView.automaticDimension,UITableView.automaticDimension][indexPath.row]
    }
    
    func getHeightForRowFirstSection(_ indexPath: IndexPath) -> CGFloat {
         return [220.5,101,UITableView.automaticDimension,138][indexPath.row]
    }
    
}