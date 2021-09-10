//
//  AirportSearch.m
//  Aertrip
//
//  Created by Kakshil Shah on 7/14/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import "AirportSearch.h"

#define kcategory @"category"
#define kiata @"iata"
#define kairport @"airport"
#define kcity @"city"
#define kcountry @"country"
#define kcountryCode @"countryCode"
#define klatitude @"latitude"
#define klongitude @"longitude"
#define krank @"rank"
#define ktimezone @"timezone"
#define ktimezoneShortName @"timezoneShortName"
#define ktimezoneOffset @"timezoneOffset"
#define ktimezoneDisplay @"timezoneDisplay"
#define kdistance @"distance"
#define kdistanceLabel  @"distanceLabel"



@implementation AirportSearch
- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_category forKey:kcategory];
    [encoder encodeObject:_iata forKey:kiata];
    [encoder encodeObject:_airport forKey:kairport];
    [encoder encodeObject:_city forKey:kcity];
    [encoder encodeObject:_country forKey:kcountry];
    [encoder encodeObject:_countryCode forKey:kcountryCode];
    [encoder encodeObject:_latitude forKey:klatitude];
    [encoder encodeObject:_longitude forKey:klongitude];
    [encoder encodeObject:_rank forKey:krank];
    [encoder encodeObject:_timezone forKey:ktimezone];
    [encoder encodeObject:_timezoneShortName forKey:ktimezoneShortName];
    [encoder encodeObject:_timezoneOffset forKey:ktimezoneOffset];
    [encoder encodeObject:_timezoneDisplay forKey:ktimezoneDisplay];
    [encoder encodeInteger:_distance forKey:kdistance];
    [encoder encodeObject:_distanceLabel forKey:kdistanceLabel];

    
}

- (id)initWithCoder:(NSCoder *)decoder {
    
     if ((self = [super init])) {
         _category = [decoder decodeObjectForKey:kcategory];
         _iata = [decoder decodeObjectForKey:kiata];
         _airport = [decoder decodeObjectForKey:kairport];
         _city = [decoder decodeObjectForKey:kcity];
         _country = [decoder decodeObjectForKey:kcountry];
         _countryCode = [decoder decodeObjectForKey:kcountryCode];
         _latitude = [decoder decodeObjectForKey:klatitude];
         _longitude = [decoder decodeObjectForKey:klongitude];
         _rank = [decoder decodeObjectForKey:krank];
         _timezone = [decoder decodeObjectForKey:ktimezone];
         _timezoneShortName = [decoder decodeObjectForKey:ktimezoneShortName];
         _timezoneOffset = [decoder decodeObjectForKey:ktimezoneOffset];
         _timezoneDisplay = [decoder decodeObjectForKey:ktimezoneDisplay];
         _distance = [decoder  decodeIntegerForKey:kdistance];
         _distanceLabel = [decoder decodeObjectForKey:kdistanceLabel];
     }
    return self;
}
@end
