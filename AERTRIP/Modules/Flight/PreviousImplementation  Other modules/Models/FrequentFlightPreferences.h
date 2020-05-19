//
//  FrequentFlightPreferences.h
//  Aertrip
//
//  Created by Kakshil Shah on 5/17/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FrequentFlightPreferences : NSObject

@property (nonatomic,strong) NSString *mealType;
@property (nonatomic,strong) NSString *seatType;
@property (nonatomic,strong) NSString *mealPrefix;
@property (nonatomic,strong) NSString *seatPrefix;

@property (nonatomic,strong) NSString *flyerName;
@property (nonatomic,strong) NSString *flyerFlag;
@property (nonatomic,strong) NSString *flyerNumber;
@property (nonatomic,strong) NSString *flyerShortName;
@property (nonatomic,strong) NSString *flyerValue;

@end
