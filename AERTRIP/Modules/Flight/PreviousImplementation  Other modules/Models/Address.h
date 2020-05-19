//
//  Address.h
//  Aertrip
//
//  Created by Kakshil Shah on 04/05/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Address : NSObject
@property (nonatomic,strong) NSString *line1;
@property (nonatomic,strong) NSString *line2;
@property (nonatomic,strong) NSString *line3;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSString *city;
@property (nonatomic,strong) NSString *countryCode;
@property (nonatomic,strong) NSString *countryName;
@property (nonatomic,strong) NSString *addressID;
@property (nonatomic,strong) NSString *userID;
@property (nonatomic,strong) NSString *postalCode;
@property (nonatomic,strong) NSString *state;




@end
