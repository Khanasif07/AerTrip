//
//  FlightPreferencesTableViewCell.h
//  Aertrip
//
//  Created by Kakshil Shah on 5/17/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FrequentFlier.h"
#import "KeyValueData.h"

@protocol FrequentFlyerHandler
@optional
- (void)flyerDeleteAction:(NSIndexPath *)indexPath;
- (void)changedFrequentFlyerValue:(NSIndexPath *)indexPath value:(FrequentFlier *)frequentFlier;
- (void)openFrequentFlyerController:(NSIndexPath *)indexPath value:(FrequentFlier *)frequentFlier;;

@end



@interface FlightPreferencesTableViewCell : UITableViewCell <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *seatPreferenceTextField;
@property (weak, nonatomic) IBOutlet UITextField *mealPreferenceTextField;
@property (weak, nonatomic) IBOutlet UIImageView *frequentFlyerImageView;
@property (weak, nonatomic) IBOutlet UITextField *frequentFlyerNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *frequentFlyerNumberTextField;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;


@property (nonatomic,strong) NSIndexPath *indexPath;
@property (weak, nonatomic) id<FrequentFlyerHandler> delegate;
@property (strong, nonatomic) FrequentFlier *frequentFlier;
@property (nonatomic,strong) NSArray *seatTypeArray;
@property (nonatomic,strong) NSArray *mealTypeArray;
@property (nonatomic,strong) UIPickerView *seatPickerView;
@property (nonatomic,strong) UIPickerView *mealPickerView;
- (void)addPickerView;
- (void)setupTextField;


@end
