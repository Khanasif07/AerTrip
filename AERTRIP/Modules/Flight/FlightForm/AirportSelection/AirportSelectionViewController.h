//
//  AirportSelectionViewController.h
//  Aertrip
//
//  Created by Kakshil Shah on 7/11/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewController.h"
#import "AirportSelctionHandler.h"
#import "AERTRIP-Swift.h"
#import "AirportSelctionHandler.h"

@interface AirportSelectionViewController : BaseViewController

@property (strong, nonatomic) AirportSelectionVM * viewModel;

@end