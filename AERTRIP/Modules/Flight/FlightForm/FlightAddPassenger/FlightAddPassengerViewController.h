//
//  FlightAddPassengerViewController.h
//  Aertrip
//
//  Created by Kakshil Shah on 7/11/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "Aertrip-Swift.h"

@class FirebaseEventLogs;

@protocol AddFlightPassengerHandler
@optional -(void)addFlightPassengerAction:(TravellerCount*)travellerCount;

@end


@interface FlightAddPassengerViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIView *dimmerLayer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewBottomConstraint;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *doneView;
@property (weak, nonatomic) IBOutlet UIButton *adultButton;
@property (weak, nonatomic) IBOutlet UIButton *childButton;
@property (weak, nonatomic) IBOutlet UIButton *infantButton;

@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *warningViewHeightConstraint;
@property (weak, nonatomic) id<AddFlightPassengerHandler> delegate;
@property (strong, nonatomic) TravellerCount* travellerCount;
@property ( assign, nonatomic) BOOL isForBulking;
@property ( assign, nonatomic) BOOL isToastVisible;

@end
