//
//  CustomCalerdarVMForMulticity.h
//  Aertrip
//
//  Created by Hrishikesh Devhare on 19/01/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CalendarDataHandler.h"

NS_ASSUME_NONNULL_BEGIN

@interface MulticityCalendarVM : NSObject
@property (nonatomic,strong,) NSDictionary *travelDatesDictionary;
@property (weak, nonatomic) id<CalendarDataHandler> delegate;
@property (assign , nonatomic) NSUInteger currentIndex;
-(void)onDoneButtonTapped;
-(NSInteger)cityCount;
@end

NS_ASSUME_NONNULL_END
