//
//  TravellerPreference.h
//  Aertrip
//
//  Created by Kakshil Shah on 6/8/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TravellerPreference : NSObject
@property (nonatomic,strong) NSString *displayName;
@property (nonatomic,strong) NSString *preferenceID;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSString *value;


@end
