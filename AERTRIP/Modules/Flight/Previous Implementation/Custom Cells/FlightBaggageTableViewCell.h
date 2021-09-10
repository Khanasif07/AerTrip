//
//  FlightBaggageTableViewCell.h
//  Aertrip
//
//  Created by Kakshil Shah on 8/8/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlightBaggageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *coreImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *adultLabel;
@property (weak, nonatomic) IBOutlet UILabel *childLabel;
@property (weak, nonatomic) IBOutlet UILabel *infantLabel;

@property (weak, nonatomic) IBOutlet UILabel *adultCheckInLabel;
@property (weak, nonatomic) IBOutlet UILabel *childCheckInLabel;
@property (weak, nonatomic) IBOutlet UILabel *infantCheckInLabel;

@property (weak, nonatomic) IBOutlet UILabel *adultCabinLabel;
@property (weak, nonatomic) IBOutlet UILabel *childCabinLabel;
@property (weak, nonatomic) IBOutlet UILabel *infantCabinLabel;

@property (weak, nonatomic) IBOutlet UIView *layoverView;
@property (weak, nonatomic) IBOutlet UILabel *layoverLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoverViewHeightConstraint;

@end
