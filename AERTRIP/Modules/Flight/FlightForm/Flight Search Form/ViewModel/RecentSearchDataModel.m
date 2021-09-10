//
//  RecentSearchDataModel.m
//  Aertrip
//
//  Created by  hrishikesh on 30/04/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

#import "RecentSearchDataModel.h"
#import "Network.h"

@implementation RecentSearchDataModel


-(void)handleDictionaryForFlightSearch:(NSArray*)recentSearchArray
{
    [self.recentSearchArray removeAllObjects];
    [self.recentSearchArray addObjectsFromArray:recentSearchArray];
    [self.delegate updateRecentSearch];
}


- (NSString *)dateFormattedForAPIRequest:(NSDate*)date {
    NSString *depart = @"";
    NSDateFormatter *inputDateFormatter = [[NSDateFormatter alloc] init];
    [inputDateFormatter setDateFormat:@"dd-MM-yyyy"];
    depart = [inputDateFormatter stringFromDate:self.onwardsDate];
    return depart;
}
@end
