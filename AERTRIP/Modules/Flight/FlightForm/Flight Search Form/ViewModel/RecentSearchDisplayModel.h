//
//  RecentModel.h
//  Aertrip
//
//  Created by Hrishikesh Devhare on 14/01/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RecentSearchDisplayModel : NSObject

@property (strong , nonatomic) NSString * searchTime;
@property (strong , nonatomic) NSString * travelType;
@property (strong , nonatomic) NSAttributedString * TravelPlan;
@property (strong , nonatomic) NSString * flightClass;
@property (strong , nonatomic) NSString * travelDate;
@property (strong , nonatomic) NSString * paxCount;
@property (strong , nonatomic) NSDictionary * quary;



-(instancetype)initWithDictionary:(NSDictionary*)dictionary;
@end

NS_ASSUME_NONNULL_END
