//
//  AmenitiesMainType.m
//  Aertrip
//
//  Created by Kakshil Shah on 7/17/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import "AmenitiesMainType.h"

@implementation AmenitiesMainType
- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.name = [decoder decodeObjectForKey:@"name"];
    self.className = [decoder decodeObjectForKey:@"className"];
    self.available = [decoder decodeObjectForKey:@"available"];

    return self;
    
    
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.className forKey:@"className"];
    [encoder encodeObject:self.available forKey:@"available"];

}
@end
