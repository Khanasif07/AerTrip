#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "CalendarDataHandler.h"
#import "CalendarDataModel.h"
#import "CalendarVM.h"
#import "MulticityCalendarVM.h"

FOUNDATION_EXPORT double AertripCalendarDataModelVersionNumber;
FOUNDATION_EXPORT const unsigned char AertripCalendarDataModelVersionString[];

