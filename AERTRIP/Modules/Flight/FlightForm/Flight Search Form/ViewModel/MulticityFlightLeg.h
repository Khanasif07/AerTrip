//
//  MulticityFlightLeg.h
//  Aertrip
//
//  Created by Hrishikesh Devhare on 18/01/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AirportSearch.h"


NS_ASSUME_NONNULL_BEGIN

@interface MulticityFlightLeg : NSObject
@property (strong, nonatomic, nullable )AirportSearch *origin;
@property (strong, nonatomic , nullable )AirportSearch *destination;
@property (strong , nonatomic) NSDate* travelDate;
@end

NS_ASSUME_NONNULL_END
