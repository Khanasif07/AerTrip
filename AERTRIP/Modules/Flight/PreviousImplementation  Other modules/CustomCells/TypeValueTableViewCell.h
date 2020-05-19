//
//  TypeValueTableViewCell.h
//  Aertrip
//
//  Created by Kakshil Shah on 5/15/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TypeValueHandler

@optional
- (void)valueDeleteAction:(NSIndexPath *)indexPath currentTableView:(UITableView *)tableview;
- (void)changedValueType:(NSIndexPath *)indexPath type:(NSString *)type currentTableView:(UITableView *)tableview;;
- (void)changedValue:(NSIndexPath *)indexPath value:(NSString *)value currentTableView:(UITableView *)tableview;

@end

@interface TypeValueTableViewCell : UITableViewCell <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *typeTextField;
@property (weak, nonatomic) IBOutlet UIImageView *downArrowImageView;
@property (weak, nonatomic) IBOutlet UITextField *valueTextField;
@property (weak, nonatomic) IBOutlet UIView *typeLineView;
@property (weak, nonatomic) IBOutlet UIView *valueLineView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;



@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,strong) NSArray *typeArray;
@property (weak, nonatomic) id<TypeValueHandler> delegate;
@property (nonatomic,strong) UITableView *currentTableView;

- (void)addPickerView;
- (void)setupTextField;

@end
