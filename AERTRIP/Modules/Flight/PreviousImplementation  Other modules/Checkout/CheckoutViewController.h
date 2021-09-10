//
//  CheckoutViewController.h
//  Aertrip
//
//  Created by Kakshil Shah on 7/24/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface CheckoutViewController : BaseViewController


@property (weak, nonatomic) IBOutlet UILabel *applyCouponLabel;
@property (weak, nonatomic) IBOutlet UIImageView *couponNextArrowImageView;
@property (weak, nonatomic) IBOutlet UIButton *removeCouponButton;
@property (weak, nonatomic) IBOutlet UIButton *couponNextButton;


@property (weak, nonatomic) IBOutlet UILabel *aerTripBalanceValueLabel;
@property (weak, nonatomic) IBOutlet UISwitch *aertripWalletSwitchButton;


@property (weak, nonatomic) IBOutlet UIView *baseFareView;
@property (weak, nonatomic) IBOutlet UILabel *baseFareLabel;
@property (weak, nonatomic) IBOutlet UILabel *baseFareValueLabel;


@property (weak, nonatomic) IBOutlet UIView *taxesView;
@property (weak, nonatomic) IBOutlet UILabel *taxesLabel;
@property (weak, nonatomic) IBOutlet UILabel *taxesValueLabel;


@property (weak, nonatomic) IBOutlet UIView *discountView;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountValueLabel;


@property (weak, nonatomic) IBOutlet UIView *aertripWalletView;
@property (weak, nonatomic) IBOutlet UILabel *aertripWalletLabel;
@property (weak, nonatomic) IBOutlet UILabel *aertripWalletValueLabel;


@property (weak, nonatomic) IBOutlet UILabel *totalPayableValueLabel;

@property (weak, nonatomic) IBOutlet UIView *fareBreakupBottomInstructionView;
@property (weak, nonatomic) IBOutlet UILabel *fareBrkupInstructionLabel;
@property (weak, nonatomic) IBOutlet UILabel *netIffectiveFareLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fareBrkupInstructionHeightConstraint;


@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;



@property (strong, nonatomic) NSMutableArray *sectionArray;


@property (strong, nonatomic) NSMutableArray *selectedPreferencesArray;
@property (strong, nonatomic) NSString *airLineNameString;
@property (strong, nonatomic) NSString *specialRequestString;

@property (strong, nonatomic) NSString *itenaryID;
@property (strong, nonatomic) NSString *mobile;
@property (strong, nonatomic) BookFlightObject *bookFlightObject;

@property (strong, nonatomic) NSString *bookingType;

@property ( nonatomic) BOOL isFlight;


@end
