//
//  Traveller.h
//  Aertrip
//
//  Created by Kakshil Shah on 04/05/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContactMethod.h"

@interface Traveller : NSObject
@property (nonatomic,strong) NSArray *addressArray;
@property (nonatomic,strong) NSArray *contactMethodArrayMobile;
@property (nonatomic,strong) NSArray *contactMethodArraySocial;
@property (nonatomic,strong) NSArray *contactMethodArrayEmail;
@property (nonatomic,strong) NSArray *frequentFlyerArray;



@property (nonatomic,strong) NSArray *hotelPreferencesArray;
@property (nonatomic,strong) NSArray *preferenceArray;

@property (nonatomic,strong) NSString *company;
@property (nonatomic,strong) NSString *countryID;
@property (nonatomic,strong) NSString *department;
@property (nonatomic,strong) NSString *doa;
@property (nonatomic,strong) NSString *dob;
@property (nonatomic,strong) NSString *employeeID;
@property (nonatomic,strong) NSString *firstName;
@property (nonatomic,strong) NSString *gender;
@property (nonatomic,strong) NSString *googleID;
@property (nonatomic,strong) NSString *homeCity;

@property (nonatomic,strong) NSString *travellerID;
@property (nonatomic,strong) NSString *jobTitle;
@property (nonatomic,strong) NSString *label;
@property (nonatomic,strong) NSString *lastName;
@property (nonatomic,strong) NSString *middleName;
@property (nonatomic,strong) NSString *notes;
@property (nonatomic,strong) NSString *profileImageURL;
@property (nonatomic,strong) NSString *passportCountry;
@property (nonatomic,strong) NSString *passportCountryName;
@property (nonatomic,strong) NSString *passportExpiryDate;
@property (nonatomic,strong) NSString *passportImage;
@property (nonatomic,strong) NSString *passportIssueDate;
@property (nonatomic,strong) NSString *passportNumber;
@property (nonatomic,strong) NSString *salutation;

@end
