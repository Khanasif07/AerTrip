//
//  TypeValueTableViewCell.m
//  Aertrip
//
//  Created by Kakshil Shah on 5/15/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import "TypeValueTableViewCell.h"

@implementation TypeValueTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   // [self addPickerView];
}
- (void)setupTextField {
    self.valueTextField.delegate = self;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([newString length] > 0){
        [self.delegate changedValue:self.indexPath value:newString currentTableView:self.currentTableView];
    }
    return true;
}

- (void)addPickerView {
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    self.typeTextField.inputView = pickerView;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
        return [self.typeArray count];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSString *value = [self.typeArray objectAtIndex:row];
    [self.typeTextField setText:value];
    [self.delegate changedValueType:self.indexPath type:value currentTableView:self.currentTableView];
    
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.typeArray objectAtIndex:row];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)deleteAction:(id)sender {
    [self.delegate valueDeleteAction:self.indexPath currentTableView:self.currentTableView];
}

@end
