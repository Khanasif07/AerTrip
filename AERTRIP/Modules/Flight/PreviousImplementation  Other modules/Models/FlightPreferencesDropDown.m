//
//  FlightPreferencesDropDown.m
//  Aertrip
//
//  Created by Kakshil Shah on 5/17/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import "FlightPreferencesDropDown.h"

@implementation FlightPreferencesDropDown
- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.seatTypeArray = [decoder decodeObjectForKey:@"seatTypeArray"];
    self.mealTypeArray = [decoder decodeObjectForKey:@"mealTypeArray"];
    
    
    
    
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.seatTypeArray forKey:@"seatTypeArray"];
    [encoder encodeObject:self.mealTypeArray forKey:@"mealTypeArray"];
    
}
@end
