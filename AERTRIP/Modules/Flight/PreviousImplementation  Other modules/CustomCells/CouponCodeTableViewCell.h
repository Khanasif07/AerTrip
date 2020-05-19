//
//  CouponCodeTableViewCell.h
//  Aertrip
//
//  Created by Kakshil Shah on 7/28/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouponCodeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *optionImageView;
@property (weak, nonatomic) IBOutlet UILabel *codeValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *saveValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponDiscriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;



@end
