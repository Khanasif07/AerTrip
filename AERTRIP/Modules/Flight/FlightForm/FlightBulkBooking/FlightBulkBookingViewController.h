//
//  FlightBulkBookingViewController.h
//  Aertrip
//
//  Created by Kakshil Shah on 8/23/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import <HMSegmentedControl/HMSegmentedControl.h>
#import "FlightFormDataModel.h"

@protocol BulkBookingFormHandler
- (void)updateWithViewModel:(FlightFormDataModel*)viewModel;
@end


@interface FlightBulkBookingViewController : BaseViewController 
@property (strong, nonatomic) FlightFormDataModel * formDataModel;
@property (weak, nonatomic) id<BulkBookingFormHandler> BulkBookingFormDelegate;
@end
