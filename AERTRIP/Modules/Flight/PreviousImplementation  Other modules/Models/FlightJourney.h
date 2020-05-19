//
//  FlightJourney.h
//  Aertrip
//
//  Created by Kakshil Shah on 08/08/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Fare.h"

@interface FlightJourney : NSObject
@property (nonatomic,strong) NSString *totalFare; //farepr
@property (nonatomic,strong) NSString *FareTypeName; //FareTypeName
@property (nonatomic,strong) NSString *arrivalDate; //ad
@property (nonatomic,strong) NSString *arrivalTime; //at
@property (nonatomic,strong) NSString *cabinClass; //cabin_class
@property (nonatomic,strong) NSString *changeOfPlaneTitle; //copt
@property (nonatomic,strong) NSArray *airlineCodesArray; //al

@property (nonatomic,strong) NSString *departureDate; //dd
@property (nonatomic,strong) NSString *departureTime; //dt

@property (nonatomic,strong) NSArray *allAirportsCodes; //ap
@property (nonatomic,strong) NSString *primaryKey; //fk
@property (nonatomic,strong) NSString *fewSeatsRemaining; //fsr
@property (nonatomic,strong) NSString *longLayover; //llow
@property (nonatomic,strong) NSString *overnightFlight; //ovgtf
@property (nonatomic,strong) NSString *redEye; //red
@property (nonatomic,strong) NSString *refundable; //rfd
@property (nonatomic,strong) NSString *reschedulable; //rsc
@property (nonatomic,strong) NSArray *totalTime; //tt



@property (nonatomic,strong) Fare *airlineFare; //fare -> Fare
@property (nonatomic,strong) NSArray *airlinesArray; //al -> Airline code -> Airline details
@property (nonatomic,strong) NSArray *allLegs; //leg
@property (nonatomic,strong) NSArray *airportsArray; //al -> Airline code -> Airline details


@end
