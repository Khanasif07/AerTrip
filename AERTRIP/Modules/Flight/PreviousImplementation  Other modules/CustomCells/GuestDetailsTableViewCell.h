//
//  GuestDetailsTableViewCell.h
//  Aertrip
//
//  Created by Kakshil Shah on 7/24/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AERTRIP-Swift.h"
#import "GuestDetail.h"
@protocol GuestDetailsCellHandler

@optional
- (void)changedTitleType:(NSString *)type atIndex:(NSIndexPath *)indexPath;
- (void)changedValue:(GuestDetail *)value atIndex:(NSIndexPath *)indexPath;

@end




@interface GuestDetailsTableViewCell : UITableViewCell <UITextFieldDelegate ,UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
@property (weak, nonatomic) IBOutlet SkyFloatingLabelTextField *titleTextField;
@property (weak, nonatomic) IBOutlet SkyFloatingLabelTextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet SkyFloatingLabelTextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UIView *titleLineView;
@property (weak, nonatomic) IBOutlet UIView *firstNameLineView;
@property (weak, nonatomic) IBOutlet UIView *lastNameLineView;

@property (nonatomic,strong) NSIndexPath *indexPath;
@property (weak, nonatomic) id<GuestDetailsCellHandler> delegate;
@property (nonatomic,strong) NSArray *typeArray;
@property (nonatomic,strong) GuestDetail *guestDetail;


- (void)addPickerView;
- (void)setupTextField;


@end
