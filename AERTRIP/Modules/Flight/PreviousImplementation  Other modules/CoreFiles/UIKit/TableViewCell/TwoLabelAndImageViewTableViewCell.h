//
//  TwoLabelAndImageViewTableViewCell.h
//  Mazkara
//
//  Created by Kakshil Shah on 6/27/17.
//  Copyright © 2017 BazingaLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwoLabelAndImageViewTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
@property (weak, nonatomic) IBOutlet UILabel *subLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coreImageView;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end
