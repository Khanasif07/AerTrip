//
//  ContactMethod.h
//  Aertrip
//
//  Created by Kakshil Shah on 04/05/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactMethod : NSObject
@property (nonatomic,strong) NSString *label;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSString *value;
@property (nonatomic,strong) NSString *contactID;
@property (nonatomic,strong) NSString *ISD;
@property (nonatomic,strong) NSString *mobileFormatted;
@property (nonatomic,strong) NSString *sortOrder;
@end
