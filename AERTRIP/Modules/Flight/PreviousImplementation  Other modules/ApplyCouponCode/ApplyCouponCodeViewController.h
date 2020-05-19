//
//  ApplyCouponCodeViewController.h
//  Aertrip
//
//  Created by Kakshil Shah on 7/28/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface ApplyCouponCodeViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *couponTableView;
@property (weak, nonatomic) IBOutlet UIView *emptyView;


@end
