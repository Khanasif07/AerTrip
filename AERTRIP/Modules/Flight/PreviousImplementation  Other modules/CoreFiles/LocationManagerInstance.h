//
//  LocationManagerInstance.h
//  Skedule
//
//  Created by Kakshil Shah on 28/05/15.
//  Copyright (c) 2015 BazingaLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface LocationManagerInstance : NSObject<CLLocationManagerDelegate>
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,strong) NSString  *latitude;
@property (nonatomic,strong) NSString  *longitude;
-(CLLocation *)lastLocation;
+ (id)sharedManager;
@end

