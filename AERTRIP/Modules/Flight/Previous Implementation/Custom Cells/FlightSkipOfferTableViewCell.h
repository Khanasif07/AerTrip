//
//  FlightSkipOfferTableViewCell.h
//  Aertrip
//
//  Created by Kakshil Shah on 9/6/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlightSkipOfferTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *travellerCountLabel;
@property (weak, nonatomic) IBOutlet UIView *autoSelectView;
@property (weak, nonatomic) IBOutlet UILabel *autoSelectLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *autoSelectViewHeightConstraint;

@end
