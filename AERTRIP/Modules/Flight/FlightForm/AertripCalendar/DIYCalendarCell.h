//
//  DIYCalendarCell.h
//  FSCalendar
//
//  Created by dingwenchao on 02/11/2016.
//  Copyright © 2016 Wenchao Ding. All rights reserved.
//

#import <FSCalendar/FSCalendar.h>

typedef NS_ENUM(NSUInteger, SelectionType) {
    SelectionTypeNone,
    SelectionTypeSingle,
    SelectionTypeLeftBorder,
    SelectionTypeMiddle,
    SelectionTypeRightBorder,
    SelectionTypeMulticity
};


@interface DIYCalendarCell : FSCalendarCell

@property (weak, nonatomic) UIImageView *circleImageView;
@property (weak, nonatomic) CAShapeLayer *selectionLayer;
@property (weak, nonatomic) CAShapeLayer *shadowLayer;
@property (weak, nonatomic) CAShapeLayer *previousTapSelectionLayer;
@property (assign, nonatomic) SelectionType selectionType;

@end
