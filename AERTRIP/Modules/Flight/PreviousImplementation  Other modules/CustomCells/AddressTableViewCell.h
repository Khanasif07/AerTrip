//
//  AddressTableViewCell.h
//  Aertrip
//
//  Created by Kakshil Shah on 5/16/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Address.h"
//@import CTKFlagPhoneNumber;


@protocol AddressHandler
@optional
- (void)addressDeleteAction:(NSIndexPath *)indexPath;
- (void)changedAddressValue:(NSIndexPath *)indexPath value:(Address *)address;
@end

@interface AddressTableViewCell : UITableViewCell <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *typeTextField;
@property (weak, nonatomic) IBOutlet UIImageView *typeDropDownArrowImageView;
@property (weak, nonatomic) IBOutlet UITextField *line1TextField;
@property (weak, nonatomic) IBOutlet UITextField *line2TextField;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UITextField *postCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *countryStateTextField;
@property (weak, nonatomic) IBOutlet UITextField *countryTextField;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;


@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,strong) NSArray *typeArray;
@property (weak, nonatomic) id<AddressHandler> delegate;
@property (nonatomic,assign) NSString *countryCode;
//@property (nonatomic,strong) CountryPicker *countryPickerView;
@property (nonatomic,assign) NSString *addressID;

- (void)addPickerView;
- (void)setupTextField;

@end
