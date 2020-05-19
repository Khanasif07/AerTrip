//
//  KeyValueData.m
//  Aertrip
//
//  Created by Kakshil Shah on 5/18/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import "KeyValueData.h"

@implementation KeyValueData
- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.key = [decoder decodeObjectForKey:@"key"];
    self.value = [decoder decodeObjectForKey:@"value"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.key forKey:@"key"];
    [encoder encodeObject:self.value forKey:@"value"];
    
}
@end
