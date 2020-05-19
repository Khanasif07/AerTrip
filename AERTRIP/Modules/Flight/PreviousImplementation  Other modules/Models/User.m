//
//  User.m
//  Aertrip
//
//  Created by Kakshil Shah on 04/05/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import "User.h"

@implementation User

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.userID = [decoder decodeObjectForKey:@"userID"];
    self.name = [decoder decodeObjectForKey:@"name"];
    self.mobile = [decoder decodeObjectForKey:@"mobile"];
    self.profileImage = [decoder decodeObjectForKey:@"profileImage"];
    self.email = [decoder decodeObjectForKey:@"email"];
    self.hotelsMaxStarRating = [decoder decodeObjectForKey:@"hotelsMaxStarRating"];
    self.hotelsMinStarRating = [decoder decodeObjectForKey:@"hotelsMinStarRating"];


    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.userID forKey:@"userID"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.mobile forKey:@"mobile"];
    [encoder encodeObject:self.profileImage forKey:@"profileImage"];
    [encoder encodeObject:self.email forKey:@"email"];
    [encoder encodeObject:self.hotelsMaxStarRating forKey:@"hotelsMaxStarRating"];
    [encoder encodeObject:self.hotelsMinStarRating forKey:@"hotelsMinStarRating"];
}
@end
