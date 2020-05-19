//
//  SimpleLabelTableViewCell.h
//  Mazkara
//
//  Created by Kakshil Shah on 12/04/16.
//  Copyright © 2016 BazingaLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleLabelTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@end
