//
//  LabelImageTableViewCell.h
//  Mazkara
//
//  Created by Kakshil Shah on 18/05/16.
//  Copyright © 2016 BazingaLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LabelImageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coreImageView;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end
