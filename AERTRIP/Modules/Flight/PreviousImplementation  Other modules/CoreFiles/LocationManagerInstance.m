//
//  LocationManagerInstance.m
//  Skedule
//
//  Created by Kakshil Shah on 28/05/15.
//  Copyright (c) 2015 BazingaLabs. All rights reserved.
//

#import "LocationManagerInstance.h"
#import "Constants.h"
@implementation LocationManagerInstance


+ (id)sharedManager {
    static LocationManagerInstance *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        self.locationManager.distanceFilter = 50.0f;
        self.locationManager.headingFilter = 5;
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        if (![defaults boolForKey:MANUAL_ZONE_SELECTED]) {
            
            if(NSClassFromString(@"UIPopoverController")) {
                [self.locationManager requestWhenInUseAuthorization];
            }
            [self.locationManager startUpdatingLocation];
        }
 
        
    }
    return self;
}



-(CLLocation *)lastLocation{
    if (self.locationManager) {
        if(self.locationManager.location){
           // [self storeLatLongInDefaults: self.locationManager.location];

            return self.locationManager.location;
        }
    }
    return nil;
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:ZONE_ACCESS_ERROR
     object:self];
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusDenied) {
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:LOCATION_DENIED
         object:self];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    CLLocation *crnLoc = [locations lastObject];
    self.latitude = [NSString stringWithFormat:@"%.8f",crnLoc.coordinate.latitude];
    self.longitude = [NSString stringWithFormat:@"%.8f",crnLoc.coordinate.longitude];
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    if (![defaults boolForKey:MANUAL_ZONE_SELECTED]) {
        
        if ([defaults stringForKey:LAT_KEY].length > 0) {
            float latitude1 =  [[defaults objectForKey:LAT_KEY] floatValue];
            float longitude1 = [[defaults objectForKey:LONG_KEY] floatValue];
            float latDifferance = latitude1 - [self.latitude floatValue];
            float longDifferance = longitude1 - [self.longitude floatValue];
            
            if ( fabsf(latDifferance) > 0.006 || fabsf(longDifferance) > 0.006) {
                [defaults setValue:self.latitude forKey:LAT_KEY];
                [defaults setValue:self.longitude forKey:LONG_KEY];
                [defaults synchronize];
                
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:LOCATION_NOTIFICATION
                 object:self];
                
            }
            
        }else {
            [defaults setValue:self.latitude forKey:LAT_KEY];
            [defaults setValue:self.longitude forKey:LONG_KEY];
            [defaults synchronize];
            
            [[NSNotificationCenter defaultCenter]
             postNotificationName:LOCATION_NOTIFICATION
             object:self];
            
        }
    }

    
}

- (void)storeLatLongInDefaults: (CLLocation *)crnLoc {
    
    self.latitude = [NSString stringWithFormat:@"%.8f",crnLoc.coordinate.latitude];
    self.longitude = [NSString stringWithFormat:@"%.8f",crnLoc.coordinate.longitude];
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    if (![defaults boolForKey:MANUAL_ZONE_SELECTED]) {
        
        if ([defaults stringForKey:LAT_KEY].length > 0) {
            float latitude1 =  [[defaults objectForKey:LAT_KEY] floatValue];
            float longitude1 = [[defaults objectForKey:LONG_KEY] floatValue];
            float latDifferance = latitude1 - [self.latitude floatValue];
            float longDifferance = longitude1 - [self.longitude floatValue];
            
            if ( fabsf(latDifferance) > 0.006 || fabsf(longDifferance) > 0.006) {
                [defaults setValue:self.latitude forKey:LAT_KEY];
                [defaults setValue:self.longitude forKey:LONG_KEY];
                [defaults synchronize];
            
            }
            
        }else {
            [defaults setValue:self.latitude forKey:LAT_KEY];
            [defaults setValue:self.longitude forKey:LONG_KEY];
            [defaults synchronize];
            
        }
    }

}

@end
