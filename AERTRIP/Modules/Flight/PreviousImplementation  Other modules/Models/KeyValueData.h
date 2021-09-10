//
//  KeyValueData.h
//  Aertrip
//
//  Created by Kakshil Shah on 5/18/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyValueData : NSObject<NSCoding>
@property (nonatomic,strong) NSString *key;
@property (nonatomic,strong) NSString *value;

@end
