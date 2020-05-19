//
//  FlightFilter.h
//  Aertrip
//
//  Created by Kakshil Shah on 9/21/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlightFilter : NSObject

@property (strong,nonatomic) NSMutableArray *apiSelectedArray;
@property (strong,nonatomic) NSMutableArray *qualitySelectedArray;
@property (strong,nonatomic) NSMutableArray *airlinesSelectedArray;
@property (assign, nonatomic) BOOL isRefundableFare;
@property (strong,nonatomic) NSString *stopSelected;
@property (strong,nonatomic) NSDictionary *sortSelected;
@property (strong,nonatomic) NSMutableArray *airportDepartureSelectedArray;
@property (strong,nonatomic) NSMutableArray *airportArrivalSelectedArray;
@property (strong,nonatomic) NSMutableArray *airportLayoverSelectedArray;


@property (strong,nonatomic) NSString *priceRangeLow;
@property (strong,nonatomic) NSString *priceRangeHigh;

@property (strong,nonatomic) NSString *tripDurationRangeLow;
@property (strong,nonatomic) NSString *tripDurationRangeHigh;

@property (strong,nonatomic) NSString *layoverDurationRangeLow;
@property (strong,nonatomic) NSString *layoverDurationRangeHigh;

@property (strong,nonatomic) NSString *departureTimeRangeLow;
@property (strong,nonatomic) NSString *departureTimeRangeHigh;

@property (strong,nonatomic) NSString *arrivalTimeRangeLow;
@property (strong,nonatomic) NSString *arrivalTimeRangeHigh;


@end
