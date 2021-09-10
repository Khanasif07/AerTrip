//
//  RefundPopupViewController.h
//  Aertrip
//
//  Created by Kakshil Shah on 9/12/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@protocol RefundPopupHandler
@optional
- (void)confirmRefundAction;
@end


@interface RefundPopupViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *refundAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymentModeDescriptionLabel;

//@property (weak, nonatomic) id<RefundPopupHandler> delegate;

@end
