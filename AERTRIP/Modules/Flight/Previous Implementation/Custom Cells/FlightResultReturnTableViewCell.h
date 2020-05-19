//
//  FlightResultReturnTableViewCell.h
//  Aertrip
//
//  Created by Kakshil Shah on 8/30/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlightResultReturnTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *innerView;


@property (weak, nonatomic) IBOutlet UILabel *oldPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;


@property (weak, nonatomic) IBOutlet UIImageView *carrierFirstImageView;
@property (weak, nonatomic) IBOutlet UIImageView *carrierSecondImageView;

@property (weak, nonatomic) IBOutlet UIImageView *carrierThirdImageView;

@property (weak, nonatomic) IBOutlet UIView *carrierFirstView;
@property (weak, nonatomic) IBOutlet UIView *carrierSecondView;
@property (weak, nonatomic) IBOutlet UIView *carrierThirdView;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *carrierViewArray;

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *carrierImageViewArray;

@property (weak, nonatomic) IBOutlet UIView *moreCarrierOverView;
@property (weak, nonatomic) IBOutlet UILabel *moreCarrierCountLabel;




@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *toLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeRequiredLabel;

@property (weak, nonatomic) IBOutlet UIView *stopsView;
@property (weak, nonatomic) IBOutlet UIView *noStopsView;
@property (weak, nonatomic) IBOutlet UILabel *stopsLabel;




@property (weak, nonatomic) IBOutlet UIImageView *firstSampleImage;
@property (weak, nonatomic) IBOutlet UIImageView *secondSampleImage;
@property (weak, nonatomic) IBOutlet UIImageView *thirdSampleImage;
@property (weak, nonatomic) IBOutlet UIImageView *fourthSampleImage;

@property (weak, nonatomic) IBOutlet UIView *rightVerticalLineView;

@property (weak, nonatomic) IBOutlet UIView *leftVerticalLineView;


@end
