//
//  DopDownData.m
//  Aertrip
//
//  Created by Kakshil Shah on 5/17/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import "DropDownData.h"

@implementation DropDownData
- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.emailTypeArray = [decoder decodeObjectForKey:@"emailTypeArray"];
    self.mobileTypeArray = [decoder decodeObjectForKey:@"mobileTypeArray"];
    self.socialTypeArray = [decoder decodeObjectForKey:@"socialTypeArray"];
    self.addressTypeArray = [decoder decodeObjectForKey:@"addressTypeArray"];
    self.salutationTypeArray = [decoder decodeObjectForKey:@"salutationTypeArray"];
    
    
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.emailTypeArray forKey:@"emailTypeArray"];
    [encoder encodeObject:self.mobileTypeArray forKey:@"mobileTypeArray"];
    [encoder encodeObject:self.socialTypeArray forKey:@"socialTypeArray"];
    [encoder encodeObject:self.addressTypeArray forKey:@"addressTypeArray"];
    [encoder encodeObject:self.salutationTypeArray forKey:@"salutationTypeArray"];

}
@end
