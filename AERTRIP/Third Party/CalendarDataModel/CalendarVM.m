//
//  CustomCalendarVM.m
//  Aertrip
//
//  Created by Hrishikesh Devhare on 26/12/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import "CalendarVM.h"

@implementation CalendarVM


-(void)onDoneButtonTapped 
{
    if (self.isHotelCalendar)
        [self.delegate selectedDatesFromCalendar:self.date1 endDate:self.date2 isHotelCalendar:self.isHotelCalendar isReturn:self.isReturn];
    else
        [self.delegate selectedDatesFromCalendar:self.date1 endDate:self.date2  isReturn:self.isReturn];

}
@end
