//
//  AddressTableViewCell.m
//  Aertrip
//
//  Created by Kakshil Shah on 5/16/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import "AddressTableViewCell.h"

@implementation AddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



- (void)setupTextField {
    
    self.typeTextField.delegate = self;
    self.line1TextField.delegate = self;
    self.line2TextField.delegate = self;
    self.cityTextField.delegate = self;
    self.postCodeTextField.delegate = self;
    self.countryStateTextField.delegate = self;
    self.countryTextField.delegate = self;

}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    Address *address = [Address new];
    address.type = self.typeTextField.text;
    address.line1 = self.line1TextField.text;
    address.line2 = self.line2TextField.text;
    address.city = self.cityTextField.text;
    address.postalCode = self.postCodeTextField.text;
    address.state = self.countryStateTextField.text;
    address.countryName = self.countryTextField.text;
    address.countryCode = self.countryCode;
    address.addressID = self.addressID;
    
    if ([newString length] > 0){
        if (textField == self.typeTextField) {
            address.type = newString;

        } else if (textField == self.line1TextField){
            address.line1 = newString;

        }else if (textField == self.line2TextField){
            address.line2 = newString;

        }else if (textField == self.cityTextField){
            address.city = newString;

        }else if (textField == self.postCodeTextField){
            address.postalCode = newString;

        }else if (textField == self.countryStateTextField){
            address.state = newString;

        }else if (textField == self.countryTextField){
            address.countryName = newString;

        }
        [self.delegate changedAddressValue:self.indexPath value:address];
    }
    return true;
}

- (void)addPickerView {
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    pickerView.dataSource = self;
    pickerView.delegate = self;
    pickerView.dataSource = self;
    self.typeTextField.inputView = pickerView;
    
    self.countryTextField.delegate = self;
//    self.countryPickerView = [[CountryPicker alloc] init];
//    self.countryPickerView.countryPickerDelegate = self;
//    self.countryPickerView.showPhoneNumbers = YES;
//    self.countryPickerView.selectedLocale = [NSLocale currentLocale];
//    self.countryTextField.inputView = self.countryPickerView;
    
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
    [self.delegate changedAddressValue:self.indexPath value:[self getAddressObjectWithCurrentValue]];

}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.typeArray objectAtIndex:row];
    
}


//- (void)countryPhoneCodePicker:(CountryPicker *)picker didSelectCountryWithName:(NSString *)name countryCode:(NSString *)countryCode phoneCode:(NSString *)phoneCode flag:(UIImage *)flag {
//   
//        [self.countryTextField setText:name];
//        self.countryCode = countryCode;
//        [self.delegate changedAddressValue:self.indexPath value:[self getAddressObjectWithCurrentValue]];
//    
//}

- (Address *)getAddressObjectWithCurrentValue {
    Address *address = [Address new];
    address.type = self.typeTextField.text;
    address.line1 = self.line1TextField.text;
    address.line2 = self.line2TextField.text;
    address.city = self.cityTextField.text;
    address.postalCode = self.postCodeTextField.text;
    address.state = self.countryStateTextField.text;
    address.countryName = self.countryTextField.text;
    address.countryCode = self.countryCode;
    address.addressID = self.addressID;

    return address;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (IBAction)deleteAction:(id)sender {
    [self.delegate addressDeleteAction:self.indexPath];
    
}





@end
