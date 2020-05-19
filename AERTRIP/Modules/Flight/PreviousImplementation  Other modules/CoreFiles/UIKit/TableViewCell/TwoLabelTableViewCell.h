//
//  TwoLabelTableViewCell.h
//  Mazkara
//
//  Created by Kakshil Shah on 17/05/16.
//  Copyright © 2016 BazingaLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwoLabelTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondaryLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end
