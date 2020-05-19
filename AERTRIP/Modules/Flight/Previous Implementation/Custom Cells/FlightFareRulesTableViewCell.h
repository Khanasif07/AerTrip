//
//  FlightFareRulesTableViewCell.h
//  Aertrip
//
//  Created by Kakshil Shah on 8/9/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlightFareRulesTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *cancellationLabel;
@property (weak, nonatomic) IBOutlet UILabel *rescheduleLabel;


@property (weak, nonatomic) IBOutlet UILabel *cancellationAirlineFeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *rescheduleAirlineFeeLabel;

@property (weak, nonatomic) IBOutlet UILabel *cancellationAerTripFeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *rescheduleAerTripFeeLabel;
@end
