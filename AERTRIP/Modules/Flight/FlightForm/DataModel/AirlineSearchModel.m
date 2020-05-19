//
//  AirlineSearchModel.m
//  Aertrip
//
//  Created by Hrishikesh Devhare on 12/01/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

#import "AirlineSearchModel.h"
#import "Parser.h"

@implementation AirlineSearchModel

-(instancetype)initWithDictionary:(NSDictionary*)dictionary
{
     if ((self = [super init])) {

         NSDictionary * originDictionary = [dictionary objectForKey:@"origin"];
         self.origin =  [Parser parseAirportSearchDictionary:originDictionary];
        
         NSDictionary * destinationDictionary = [dictionary objectForKey:@"destination"];
         self.destination =  [Parser parseAirportSearchDictionary:destinationDictionary];
     }
        return self;
}

-(NSString*)leftString {
    
    return [NSString stringWithFormat:@"%@ → %@",self.origin.city,self.destination.city];
}
-(NSString*)rightString {
    return [NSString stringWithFormat:@"%@ → %@",self.origin.iata,self.destination.iata];
}
@end
