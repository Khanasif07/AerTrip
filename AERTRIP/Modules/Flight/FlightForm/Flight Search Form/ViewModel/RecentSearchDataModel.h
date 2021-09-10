//
//  RecentSearchDataModel.h
//  Aertrip
//
//  Created by  hrishikesh on 30/04/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RecentSearchDelegate
-(void)updateRecentSearch;
@end

@interface RecentSearchDataModel : NSObject

@property (strong, nonatomic) NSDate *onwardsDate;
@property (strong, nonatomic) NSMutableArray *recentSearchArray;
@property (weak, nonatomic) id <RecentSearchDelegate > delegate ;
-(void)handleDictionaryForFlightSearch:(NSArray*)recentSearchArray;
@end

NS_ASSUME_NONNULL_END
