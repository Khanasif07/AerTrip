//
//  DopDownData.h
//  Aertrip
//
//  Created by Kakshil Shah on 5/17/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DropDownData : NSObject<NSCoding>
@property (nonatomic,strong) NSArray *emailTypeArray;
@property (nonatomic,strong) NSArray *mobileTypeArray;
@property (nonatomic,strong) NSArray *socialTypeArray;
@property (nonatomic,strong) NSArray *addressTypeArray;
@property (nonatomic,strong) NSArray *salutationTypeArray;

@end
