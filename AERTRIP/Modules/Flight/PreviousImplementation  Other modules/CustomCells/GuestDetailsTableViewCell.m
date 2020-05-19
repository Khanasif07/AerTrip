//
//  GuestDetailsTableViewCell.m
//  Aertrip
//
//  Created by Kakshil Shah on 7/24/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import "GuestDetailsTableViewCell.h"

@implementation GuestDetailsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setupTextField {
    self.firstNameTextField.delegate = self;
    self.lastNameTextField.delegate = self;

}

- (void)addPickerView {
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    self.titleTextField.inputView = pickerView;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([newString length] > 0){
        //call delegate
        if (textField == self.firstNameTextField) {
            self.guestDetail.firstName = newString;
        }else if (textField == self.lastNameTextField) {
            self.guestDetail.lastName = newString;
        }
    }
    SkyFloatingLabelTextField *floatingTextField = (SkyFloatingLabelTextField *)textField;
    floatingTextField.errorMessage = @"";
    return YES;

}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.typeArray count];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSString *value = [self.typeArray objectAtIndex:row];
    [self.titleTextField setText:value];
    self.guestDetail.title = value;
//    [self.delegate changedValue:@"" atIndex:self.indexPath];
    
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.typeArray objectAtIndex:row];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
