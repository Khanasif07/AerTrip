//
//  Flight.h
//  Aertrip
//
//  Created by Kakshil Shah on 8/7/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Fare.h"
#import "Airline.h"
@interface Flight : NSObject


@property (nonatomic,strong) NSString *arrivalDate; //ad
@property (nonatomic,strong) NSString *arrivalTime; //at
@property (nonatomic,strong) NSString *arrivalTerminus; //atm
@property (nonatomic,strong) NSString *airlineCode; //atm
@property (nonatomic,strong) NSString *departureDate; //dd
@property (nonatomic,strong) NSString *departureTime; //dt
@property (nonatomic,strong) NSString *cabinClass; //cc
@property (nonatomic,strong) NSString *departureTerminus; //dtm
@property (nonatomic,strong) NSString *equipment; //eq
@property (nonatomic,strong) NSString *flightNumber; //fn
@property (nonatomic,strong) NSString *fromAirport; //fr
@property (nonatomic,strong) NSString *toAirport; //to
@property (nonatomic,strong) NSString *changeOfPlaneTitle; //copt
@property (nonatomic,strong) NSString *primaryKey; //fk
@property (nonatomic,strong) NSString *fewSeatsRemaining; //fsr
@property (nonatomic,strong) NSString *longLayover; //llow
@property (nonatomic,strong) NSString *overnightFlight; //ovgtf
@property (nonatomic,strong) NSString *redEye; //red
@property (nonatomic,strong) NSString *refundable; //rfd
@property (nonatomic,strong) NSString *reschedulable; //rsc
@property (nonatomic,strong) NSString *totalFare; //farepr
@property (nonatomic,strong) NSString *FareTypeName; //FareTypeName
@property (nonatomic,strong) NSString *time; //ft

@property (nonatomic,strong) NSArray *allAirportsCodes; //ap
@property (nonatomic,strong) Airline *airline; //al -> Airline code -> Airline details

@end
