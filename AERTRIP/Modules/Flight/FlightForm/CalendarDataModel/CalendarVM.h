//
//  CustomCalendarVM.h
//  Aertrip
//
//  Created by Hrishikesh Devhare on 26/12/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CalendarDataHandler.h"

NS_ASSUME_NONNULL_BEGIN

@interface CalendarVM : NSObject
@property (assign, nonatomic) BOOL isStartDateSelection;
@property (strong, nonatomic, nullable) NSDate *date1;
@property (strong, nonatomic, nullable ) NSDate *date2;
@property (assign, nonatomic) BOOL isHotelCalendar;
@property (assign, nonatomic) BOOL isReturn;
@property (assign, nonatomic) BOOL isMultiCity;
@property (assign, nonatomic) BOOL isFromHotelBulkBooking;
@property (assign, nonatomic) BOOL isFromFlightBulkBooking;
@property (weak, nonatomic) id<CalendarDataHandler> delegate;


-(void)onDoneButtonTapped;
-(void)tryToSelectMoreThan30Night;
@end

NS_ASSUME_NONNULL_END
