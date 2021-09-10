//
//  CustomCalendarHandler.h
//  Aertrip
//
//  Created by Hrishikesh Devhare on 26/12/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#ifndef CalendarDataHandler_h
#define CalendarDataHandler_h


#endif /* CalendarDataHandler_h */


@protocol CalendarDataHandler
@optional - (void)selectedDatesFromCalendar:(NSDate *)startDate endDate:(NSDate *)endDate isHotelCalendar:(BOOL)isHotelCalendar isReturn:(BOOL)isReturn;
@optional - (void)selectedDatesFromCalendar:(NSDate *)startDate endDate:(NSDate *)endDate  isReturn:(BOOL)isReturn;
@optional -(void)MulticityDateSelectionWithDictionary:(NSDictionary*)dictionary reloadUI:(BOOL)reloadUI;
@optional -(void)TryToSelectMoreThan30Night;
@end

