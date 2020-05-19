//
//  FlightPreferencesTableViewCell.m
//  Aertrip
//
//  Created by Kakshil Shah on 5/17/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import "FlightPreferencesTableViewCell.h"

@implementation FlightPreferencesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setupTextField {
    self.frequentFlyerNumberTextField.delegate = self;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([newString length] > 0){
        self.frequentFlier.ffNumber = newString;
    }
    return true;
}
- (void)addPickerView {
    self.seatPickerView = [[UIPickerView alloc] init];
    self.seatPickerView.delegate = self;
    self.seatPickerView.dataSource = self;
    self.seatPreferenceTextField.inputView = self.seatPickerView;
    
    self.mealPickerView = [[UIPickerView alloc] init];
    self.mealPickerView.delegate = self;
    self.mealPickerView.dataSource = self;
    self.mealPreferenceTextField.inputView = self.mealPickerView;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == self.seatPickerView) {
       return self.seatTypeArray.count;
    } else if (pickerView == self.mealPickerView){
       return self.mealTypeArray.count;
    }
    return 0;

}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView == self.seatPickerView) {
        KeyValueData *seatKeyValue = [self.seatTypeArray objectAtIndex:row];
         [self.seatPreferenceTextField setText:seatKeyValue.value];
    } else if (pickerView == self.mealPickerView){
        KeyValueData *mealKeyValue = [self.mealTypeArray objectAtIndex:row];
         [self.mealPreferenceTextField setText:mealKeyValue.value];
    }

    
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView == self.seatPickerView) {
        KeyValueData *seatKeyValue = [self.seatTypeArray objectAtIndex:row];
        return seatKeyValue.value;

    } else if (pickerView ==self.mealPickerView){
        KeyValueData *mealKeyValue = [self.mealTypeArray objectAtIndex:row];
        return mealKeyValue.value;
    }
    return @"";
}

- (IBAction)selectFrequentFlyerAction:(id)sender {
    [self.delegate openFrequentFlyerController:self.indexPath value:self.frequentFlier];
}
- (IBAction)deleteAction:(id)sender {
    [self.delegate flyerDeleteAction:self.indexPath];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
