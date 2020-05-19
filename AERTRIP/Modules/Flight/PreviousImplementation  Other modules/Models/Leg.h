//
//  Leg.h
//  Aertrip
//
//  Created by Kakshil Shah on 08/08/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Leg : NSObject
@property (nonatomic,strong) NSArray *airlinesArray; //al -> Airline code -> Airline details
@property (nonatomic,strong) NSArray *allAirportsCodes; //ap
@property (nonatomic,strong) NSArray *airlineCodesArray; //al

@property (nonatomic,strong) NSString *arrivalDate; //ad
@property (nonatomic,strong) NSString *arrivalTime; //at


@property (nonatomic,strong) NSString *departureDate; //dd
@property (nonatomic,strong) NSString *departureTime; //dt

@property (nonatomic,strong) NSArray *allFlights; //flights -> Parse flight
@property (nonatomic,strong) NSString *totalTime; //tt


@end
