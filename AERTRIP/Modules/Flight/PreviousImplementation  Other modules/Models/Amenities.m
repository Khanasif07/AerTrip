//
//  Amenities.m
//  Aertrip
//
//  Created by Kakshil Shah on 7/17/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import "Amenities.h"

@implementation Amenities
- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.mainArray = [decoder decodeObjectForKey:@"mainArray"];
    self.basicArray = [decoder decodeObjectForKey:@"basicArray"];
    
    return self;
    
    
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:self.mainArray forKey:@"mainArray"];
    [encoder encodeObject:self.basicArray forKey:@"basicArray"];

}
@end
