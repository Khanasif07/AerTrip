//
//  FlightObjectResults.h
//  Aertrip
//
//  Created by Kakshil Shah on 8/7/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlightResultAlMaster.h"
@interface FlightResultsDict : NSObject
@property (nonatomic,strong) NSString *cityap;
@property (nonatomic,strong) NSArray *taxesKeyValueArray;
@property (nonatomic,strong) NSArray *aldetKeyValueArray;
@property (nonatomic,strong) NSString *rsid;
@property (nonatomic,strong) NSArray *flightResultAlMasterArray;

@property (nonatomic,strong) NSString *jCount;
@property (nonatomic,strong) NSArray *jArray;
@property (nonatomic,strong) NSArray *fArray;
@property (nonatomic,strong) NSDictionary *apdetDict;


@end
