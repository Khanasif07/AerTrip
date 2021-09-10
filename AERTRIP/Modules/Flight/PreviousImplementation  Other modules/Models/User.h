//
//  User.h
//  Aertrip
//
//  Created by Kakshil Shah on 04/05/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject<NSCoding>
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *mobile;
@property (nonatomic,strong) NSString *userID;
@property (nonatomic,strong) NSString *profileImage;
@property (nonatomic,strong) NSString *email;
@property (nonatomic,strong) NSString *location;
@property (nonatomic,strong) NSString *membershipNumber;
@property (nonatomic,strong) NSString *panNumber;
@property (nonatomic,strong) NSString *aadharNumber;
@property (nonatomic,strong) NSString *salutation;


//Hotels
@property (nonatomic,strong) NSString *hotelsMaxStarRating;
@property (nonatomic,strong) NSString *hotelsMinStarRating;




@end
