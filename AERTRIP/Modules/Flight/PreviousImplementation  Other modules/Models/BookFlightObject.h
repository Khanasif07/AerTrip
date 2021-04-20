//
//  BookFlightObject.h
//  Aertrip
//
//  Created by Kakshil Shah on 8/11/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlightJourney.h"
#import "flightSearchType.h"

@class TravellerCount;

@interface BookFlightObject : NSObject


@property (nonatomic,strong) NSString *sid;
@property (nonatomic,strong) NSDictionary *displayGroups;
@property (nonatomic,strong) NSArray *vcodes;

@property (nonatomic,strong) FlightJourney *journey;
@property (nonatomic, strong) TravellerCount * travellerCount;
@property (assign, nonatomic) BOOL isReturn;
@property (assign, nonatomic) BOOL isMultyCity;
@property (assign) FlightSearchType flightSearchType;
@property (strong, nonatomic) NSDate *onwardDate;
@property (strong, nonatomic) NSDate *returnDate;

@property (strong, nonatomic) NSAttributedString * titleString;
@property (strong, nonatomic) NSString * subTitleString;
@property (assign , nonatomic) BOOL isDomestic;

@property (assign , nonatomic) NSInteger flightAdultCount;
@property (assign , nonatomic) NSInteger flightChildrenCount;
@property (assign , nonatomic) NSInteger flightInfantCount;

@property (nonatomic, strong) NSString * taxSort;
@property (nonatomic, strong) NSString * aerinSessionId;
@end



