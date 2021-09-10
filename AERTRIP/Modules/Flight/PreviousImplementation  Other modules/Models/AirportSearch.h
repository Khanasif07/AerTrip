//
//  AirportSearch.h
//  Aertrip
//
//  Created by Kakshil Shah on 7/14/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AirportSearch : NSObject  <NSCoding>
@property (nonatomic,strong) NSString *category;
@property (nonatomic,strong) NSString *iata;
@property (nonatomic,strong) NSString *airport;
@property (nonatomic,strong) NSString *city;
@property (nonatomic,strong) NSString *country;
@property (nonatomic,strong) NSString *countryCode;
@property (nonatomic,strong) NSString *latitude;
@property (nonatomic,strong) NSString *longitude;
@property (nonatomic,strong) NSString *rank;
@property (nonatomic,strong) NSString *timezone;
@property (nonatomic,strong) NSString *timezoneShortName;
@property (nonatomic,strong) NSString *timezoneOffset;
@property (nonatomic,strong) NSString *timezoneDisplay;
@property (nonatomic,strong) NSString *label;
@property (nonatomic,strong) NSString *value;
@property (nonatomic,assign) NSUInteger distance;
@property (nonatomic,strong) NSString *distanceLabel;
@end
