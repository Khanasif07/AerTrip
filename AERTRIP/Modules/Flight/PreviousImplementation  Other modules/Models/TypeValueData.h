//
//  EmailData.h
//  Aertrip
//
//  Created by Kakshil Shah on 5/15/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TypeValueData : NSObject

@property (nonatomic,strong) NSString *ID;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSString *isDefaultType;
@property (nonatomic,strong) NSString *value;
@property (nonatomic,strong) NSString *canDelete;
@property (nonatomic,strong) NSString *countryCode;
@property (nonatomic,strong) UIImage *countryFlag;





@end
