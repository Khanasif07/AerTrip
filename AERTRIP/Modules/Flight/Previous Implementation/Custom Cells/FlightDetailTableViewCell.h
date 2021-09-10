//
//  FlightDetailTableViewCell.h
//  Aertrip
//
//  Created by Kakshil Shah on 8/8/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlightDetailTableViewCell : UITableViewCell


//TOP VIEW
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *operatedByLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberAndClassLabel;
@property (weak, nonatomic) IBOutlet UILabel *onTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coreImageView;


// LEFT FROM VIEW

@property (weak, nonatomic) IBOutlet UILabel *fromTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromAirportNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromCityLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromTerminalLabel;






// RIGHT TO VIEW


@property (weak, nonatomic) IBOutlet UILabel *toTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *toLabel;
@property (weak, nonatomic) IBOutlet UILabel *toDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *toAirportNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *toCityLabel;
@property (weak, nonatomic) IBOutlet UILabel *toTerminalLabel;


//CENTER VIEW
@property (weak, nonatomic) IBOutlet UIImageView *nightImageView;
@property (weak, nonatomic) IBOutlet UILabel *hourTravelledLabel;
@property (weak, nonatomic) IBOutlet UILabel *centerSubLabel;


//LAYOVER VIEW
@property (weak, nonatomic) IBOutlet UIView *layoverView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoverHeightConstraint;



@end
