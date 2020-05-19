//
//  HomeViewController.h
//  Aertrip
//
//  Created by Kakshil Shah on 23/04/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import "BaseViewController.h"

#import <HMSegmentedControl/HMSegmentedControl.h>
#import "FlightFormDataModel.h"

@interface FlightFormViewController : BaseViewController 
@property (strong , nonatomic) FlightFormDataModel* viewModel;
@property (nonatomic, assign) BOOL isInternationalJourney;
@end
