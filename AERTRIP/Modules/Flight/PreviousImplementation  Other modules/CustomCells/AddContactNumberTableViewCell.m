//
//  AddContactNumberTableViewCell.m
//  Aertrip
//
//  Created by Kakshil Shah on 5/16/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import "AddContactNumberTableViewCell.h"

@implementation AddContactNumberTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



- (void)setupTextField {
    self.contactNumberTextField.delegate = self;

}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([newString length] > 0){
        [self.delegate changedContactNumber:self.indexPath value:newString];
    }
    return true;
}




- (void)addPickerView {
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    self.contactNumberTypeTextField.inputView = pickerView;
    
    self.countryCodeTextField.delegate = self;
    self.countryPickerView = [[CountryPicker alloc] init];
//    self.countryPickerView.countryPickerDelegate = self;
//    self.countryPickerView.showPhoneNumbers = YES;
//    self.countryPickerView.selectedLocale = [NSLocale currentLocale];
    self.countryCodeTextField.inputView = self.countryPickerView;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.contactNumberTypeArray count];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSString *value = [self.contactNumberTypeArray objectAtIndex:row];
    [self.contactNumberTypeTextField setText:value];
    [self.delegate changedContactNumberType:self.indexPath value:value];
    
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.contactNumberTypeArray objectAtIndex:row];
    
}

-(void)countryPhoneCodePicker:(CountryPicker *)picker didSelectCountryWithName:(NSString *)name countryCode:(NSString *)countryCode phoneCode:(NSString *)phoneCode flag:(UIImage *)flag {
    self.countryCodeTextField.text = phoneCode;
    self.countryImageView.image = flag;
    [self.delegate changedContactNumberCountryCode:self.indexPath countryCode:phoneCode flag:flag];
   
}








- (IBAction)deleteAction:(id)sender {
    [self.delegate contactNumberDeleteAction:self.indexPath];
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
