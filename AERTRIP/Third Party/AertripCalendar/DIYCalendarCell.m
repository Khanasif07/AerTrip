//
//  DIYCalendarCell.m
//  FSCalendar
//
//  Created by dingwenchao on 02/11/2016.
//  Copyright © 2016 Wenchao Ding. All rights reserved.
//

#import "DIYCalendarCell.h"
#import "FSCalendarExtensions.h"


@implementation DIYCalendarCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CAShapeLayer *selectionLayer = [[CAShapeLayer alloc] init];
        selectionLayer.fillColor = [UIColor colorWithRed:0/255.0 green:204/255.0 blue:153/255.0 alpha:1.0].CGColor;
//        CAShapeLayer * shadow = [[CAShapeLayer alloc] init];
//        self.shadowLayer = shadow;
//        self.shadowLayer.frame = self.bounds;
        
        selectionLayer.actions = @{@"hidden":[NSNull null]};
        [self.contentView.layer insertSublayer:selectionLayer below:self.titleLabel.layer];
        [self.contentView.layer insertSublayer:self.shadowLayer below:selectionLayer];
        self.selectionLayer = selectionLayer;
        self.shapeLayer.hidden = YES;
        
        CAShapeLayer *previousTapSelectionLayer = [[CAShapeLayer alloc] init];
        previousTapSelectionLayer.fillColor = [UIColor colorWithRed:236/255.0 green:253/255.0 blue:244/255.0 alpha:1].CGColor;
        previousTapSelectionLayer.borderColor = [UIColor colorWithRed:0/255.0 green:204/255.0 blue:153/255.0 alpha:1].CGColor;
        previousTapSelectionLayer.borderWidth = 0.5;
        previousTapSelectionLayer.cornerRadius = 10.0;
        previousTapSelectionLayer.actions = @{@"hidden":[NSNull null]};
        [self.contentView.layer insertSublayer:previousTapSelectionLayer below:self.titleLabel.layer];
        self.previousTapSelectionLayer = previousTapSelectionLayer;
        self.previousTapSelectionLayer.hidden = YES;

        

        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
     self.titleLabel.frame = self.contentView.bounds;
    float constantMinus = 10.0;
    float radius = 10.0;

    self.selectionLayer.frame = CGRectMake(0.0, constantMinus, self.bounds.size.width, self.bounds.size.height - constantMinus * 2);
    if (self.selectionType == SelectionTypeMiddle) {

        self.selectionLayer.path = [UIBezierPath bezierPathWithRect:self.selectionLayer.bounds].CGPath;
        self.shadowLayer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"MiddleShadow"].CGImage);
        self.shadowLayer.frame = CGRectMake(0, 6, 53.5, 74);

    } else if (self.selectionType == SelectionTypeLeftBorder) {
        self.selectionLayer.frame = CGRectMake(2.0, constantMinus, self.bounds.size.width - 2, self.bounds.size.height - constantMinus * 2);
        self.selectionLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.selectionLayer.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadii:CGSizeMake(radius, radius)].CGPath;
        self.shadowLayer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"LeftShadow"].CGImage);
        self.shadowLayer.frame = CGRectMake(-5, 6, 60, 74);

    } else if (self.selectionType == SelectionTypeRightBorder) {
        self.selectionLayer.frame = CGRectMake(0.0, constantMinus, self.bounds.size.width - 2, self.bounds.size.height - constantMinus * 2);
        self.selectionLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.selectionLayer.bounds byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight cornerRadii:CGSizeMake( radius, radius)].CGPath;
        self.shadowLayer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"RightShadow"].CGImage);
        self.shadowLayer.frame = CGRectMake(0, 6, 60, 74);

        
    } else if (self.selectionType == SelectionTypeSingle) {
        self.selectionLayer.frame = CGRectMake(2.0, constantMinus, self.bounds.size.width - 4, self.bounds.size.height - constantMinus * 2);

        self.selectionLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.selectionLayer.bounds cornerRadius:radius].CGPath;
        self.shadowLayer.frame = CGRectMake(-7, 6, 68, 74);
        self.shadowLayer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"FullShadow"].CGImage);
        
    }
    
    self.previousTapSelectionLayer.frame = CGRectMake(2.0, constantMinus, self.bounds.size.width - 4, self.bounds.size.height - constantMinus * 2);
    CGPathRef path = [UIBezierPath bezierPathWithRoundedRect:self.previousTapSelectionLayer.bounds cornerRadius:radius].CGPath;
    self.previousTapSelectionLayer.path = path;


    
}



- (void)setSelectionType:(SelectionType)selectionType
{
    if (_selectionType != selectionType) {
        _selectionType = selectionType;
        [self setNeedsLayout];
    }
}

@end
