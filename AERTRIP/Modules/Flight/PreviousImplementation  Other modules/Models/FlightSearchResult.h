//
//  FlightSearchResult.h
//  Aertrip
//
//  Created by Kakshil Shah on 8/7/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlightSearchResult : NSObject
@property (nonatomic,strong) NSString *sid;
@property (nonatomic,strong) NSString *completed;
@property (nonatomic,strong) NSArray *flightArray;

@end
