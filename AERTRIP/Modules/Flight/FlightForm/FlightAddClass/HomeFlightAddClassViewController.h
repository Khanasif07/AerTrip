//
//  HomeFlightAddClassViewController.h
//  Aertrip
//
//  Created by Kakshil Shah on 7/11/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "AERTRIP-Swift.h"

@class FirebaseEventLogs;

@protocol AddFlightClassHandler
@optional
- (void)addFlightClassAction:(FlightClass *)flightClass ;


@end

@interface HomeFlightAddClassViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UIView *dimmerLayer;
@property (weak, nonatomic) IBOutlet UIImageView *backingImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewBottomConstraint;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *doneView;
@property (weak, nonatomic) IBOutlet UITableView *classTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *classTableViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;

@property (weak, nonatomic) id<AddFlightClassHandler> flightClassSelectiondelegate;
@property (strong, nonatomic) FlightClass *flightClass;

@end
