//
//  AirlineSearchModel.h
//  Aertrip
//
//  Created by Hrishikesh Devhare on 12/01/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AirportSearch.h"

NS_ASSUME_NONNULL_BEGIN

@interface AirlineSearchModel : NSObject
@property (strong , nonatomic) AirportSearch * origin;
@property (strong , nonatomic) AirportSearch * destination;

-(instancetype)initWithDictionary:(NSDictionary*)dictionary;
-(NSString*)leftString;
-(NSString*)rightString;
@end

NS_ASSUME_NONNULL_END
