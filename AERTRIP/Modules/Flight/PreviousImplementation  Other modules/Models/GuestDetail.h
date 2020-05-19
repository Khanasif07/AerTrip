//
//  GuestDetail.h
//  Aertrip
//
//  Created by Kakshil Shah on 7/23/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GuestDetail : NSObject
@property (nonatomic,strong) NSString *noNameString;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *firstName;
@property (nonatomic,strong) NSString *lastName;
@property (nonatomic,strong) NSString *profileImage;
@property (nonatomic,strong) NSString *guestType;
@property (nonatomic,strong) NSString *age;
@property (nonatomic,strong) NSArray *frequentFlyerPreferenceArray;
@property (nonatomic,strong) NSString *mealPreference;
@property (nonatomic,strong) NSString *mealPreferenceKey;
@property (nonatomic,strong) NSString *seatPreference;
@property (nonatomic,strong) NSString *seatPreferenceKey;
@property (nonatomic,strong) NSString *dateOfBirth;
@property (nonatomic,strong) NSString *nationality;
@property (nonatomic,strong) NSString *passportNumber;
@property (nonatomic,strong) NSString *passportExpiryDate;
@property (nonatomic,strong) NSString *countryCode;

@end
