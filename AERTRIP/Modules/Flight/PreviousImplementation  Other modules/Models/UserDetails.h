//
//  UserDetails.h
//  Aertrip
//
//  Created by Kakshil Shah on 04/05/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GeneralUserPreferences.h"
#import "Address.h"
#import "User.h"
#import "Traveller.h"
@interface UserDetails : NSObject
@property (nonatomic,strong) NSArray *addressArray;
@property (nonatomic,strong) GeneralUserPreferences *preferences;
@property (nonatomic,strong) Address *billingAddress;
@property (nonatomic,strong) User *user;
@property (nonatomic,strong) NSArray *linkedAccountsNames;
@property (nonatomic,strong) NSArray *travellersArray;
@property (nonatomic,strong) NSArray *hotelPreferencesArray;
@property (nonatomic,strong) Traveller *selfTraveller;

@end
