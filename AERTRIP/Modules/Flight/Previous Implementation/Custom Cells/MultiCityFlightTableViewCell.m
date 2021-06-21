//
//  MultiCityFlightTableViewCell.m
//  Aertrip
//
//  Created by Kakshil Shah on 8/24/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import "MultiCityFlightTableViewCell.h"
#import "AirportSearch.h"
#import "AERTRIP-Swift.h"

@interface MultiCityFlightTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromSubTitleLabel;


@property (weak, nonatomic) IBOutlet UILabel *toLabel;
@property (weak, nonatomic) IBOutlet UILabel *toValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *toSubTitleLabel;


@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateSubTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *SwapButton;
@property (weak, nonatomic) IBOutlet UIView *fromToView;
@property (weak, nonatomic) IBOutlet UIStackView *dateStackView;
@property (weak, nonatomic) IBOutlet UIView *fromToContainerView;
@property (weak, nonatomic) IBOutlet UIView *slideCenterView;

@end


@implementation MultiCityFlightTableViewCell 
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setupFromAndToView {
    
    AirportSearch * origin = self.flightLegRow.origin;

    if (origin != nil ) {
        self.fromValueLabel.hidden = NO;
        self.fromValueLabel.text = origin.iata;
        self.fromSubTitleLabel.hidden = NO;
        self.fromSubTitleLabel.text = origin.city;
        
        self.fromLabel.hidden = YES;
    }else {
        self.fromSubTitleLabel.hidden = YES;
        self.fromValueLabel.hidden = YES;
        self.fromLabel.hidden = NO;
        
    }
    
    AirportSearch * destination = self.flightLegRow.destination;
    if (destination != nil) {
        self.toValueLabel.hidden = NO;
        self.toLabel.hidden = YES;
        self.toValueLabel.text = destination.iata;
        
        AirportSearch *airportSearch = destination;
        self.toSubTitleLabel.hidden = NO;
        self.toSubTitleLabel.text = airportSearch.city;
        
    }else {
        self.toLabel.hidden = NO;
        self.toSubTitleLabel.hidden = YES;
        self.toValueLabel.hidden = YES;
    }
    
    
    if (origin == nil && destination == nil) {
        self.SwapButton.enabled = NO;
    }
    else {
        self.SwapButton.enabled = YES;
    }
    
}
- (void)setupDateView {
   
    NSDate *date = self.flightLegRow.travelDate;

    if (date != nil) {
        self.dateLabel.hidden = YES;
        self.dateValueLabel.hidden = NO;
        self.dateSubTitleLabel.hidden = NO;
        
        self.dateValueLabel.text = [self dateFormatedFromDate:date];
        self.dateSubTitleLabel.text = [self dayOfDate:date];
        
        
    }else {
        [self changeLabelFont:self.dateLabel isSmall:NO];
        self.dateValueLabel.hidden = YES;
        self.dateSubTitleLabel.hidden = YES;
    }
}

- (void)changeLabelFont:(UILabel *)label isSmall:(BOOL)isSmall {
    if (isSmall) {
        [label setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:16.0]];
    }else {
        [label setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:20.0]];
        
    }
}

- (NSString *)dateFormatedFromDate:(NSDate *)date
{
    NSDateFormatter *inputDateFormatter = [[NSDateFormatter alloc] init];
    [inputDateFormatter setDateFormat:@"dd MMM"];
    NSString *dateString = [inputDateFormatter stringFromDate:date];
    return dateString;
    
}
- (NSString *)dayOfDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:date];
    
    NSInteger weekday = [components weekday];
    NSString *weekdayName = [dateFormatter shortWeekdaySymbols][weekday - 1];
    return weekdayName;
    
}


-(void) setColorForFromView{
    self.fromToView.backgroundColor = UIColor.themeBlack26;
    self.fromToContainerView.backgroundColor = UIColor.themeBlack26;
    self.slideCenterView.backgroundColor = UIColor.themeBlack26;
    self.dateStackView.backgroundColor = UIColor.themeBlack26;
}

- (IBAction)fromAction:(id)sender {
    [self.delegate openAirportSelectionControllerFor:YES indexPath:self.indexPath];
}

- (IBAction)toAction:(id)sender {
    [self.delegate openAirportSelectionControllerFor:NO indexPath:self.indexPath];
}

- (IBAction)swapAction:(UIButton *)sender {
    
    [self performAnimationForPlaceHolderLabels];
    [self performAnimationForValueLabels];
    [self performAirportSwapAnimationForSubTitle];
    

    [UIView animateWithDuration:0.4 animations:^{
        if (CGAffineTransformEqualToTransform(sender.transform, CGAffineTransformIdentity)) {
            sender.transform = CGAffineTransformMakeRotation(M_PI * 0.999);
        } else {
            sender.transform = CGAffineTransformIdentity;
        }
        

    } completion:^(BOOL finished) {
        [self.delegate swapMultiCityAirportsFor:self.indexPath];

    }];
    
}


-(void)performAnimationForPlaceHolderLabels{
    
    
    if ( !self.fromLabel.isHidden) {
        
        [UIView animateWithDuration:0.3 animations:^{
            self.fromLabel.alpha = 0.0;
        }];
    }

    
    if ( !self.toLabel.isHidden) {
        
        [UIView animateWithDuration:0.3 animations:^{
            self.toLabel.alpha = 0.0;
        }];
    }
    

}

- (void)performAnimationForValueLabels {
    
    UILabel * leftLabel = self.fromValueLabel;
    UILabel * rightLabel = self.toValueLabel;
    
    [self swipPositionOfLabels:leftLabel rightLabel:rightLabel];
}



- (void)performAirportSwapAnimationForSubTitle {
    
    if ( self.toSubTitleLabel.isHidden && self.fromSubTitleLabel.isHidden ) {
        return;
    }
    
    UILabel * leftLabel = self.fromSubTitleLabel;
    UILabel * rightLabel = self.toSubTitleLabel;
    
    [self swipPositionOfLabels:leftLabel rightLabel:rightLabel];
}


- (void)swipPositionOfLabels:(UILabel *)leftLabel rightLabel:(UILabel *)rightLabel {
    UILabel * originAnimationLabel =  [self deepLabelCopy:leftLabel];
    UILabel * destinationAnimationLabel =  [self deepLabelCopy:rightLabel];
    
    
    UIColor * previousColor = leftLabel.textColor;
    
    leftLabel.textColor = [UIColor clearColor];
    rightLabel.textColor = [UIColor clearColor];
    
    [self.fromToView addSubview:originAnimationLabel];
    [self.fromToView addSubview:destinationAnimationLabel];
    
    
    CGRect leftLabelTargetFrame = rightLabel.frame;
    CGRect rightLabelTargetFrame = leftLabel.frame;
    
    if (leftLabel.frame.size.height > leftLabelTargetFrame.size.height){
        leftLabelTargetFrame.size.height = leftLabel.frame.size.height;
    }

    if (rightLabel.frame.size.height > rightLabelTargetFrame.size.height){
        rightLabelTargetFrame.size.height = rightLabel.frame.size.height;
    }
    
    
    [UIView animateWithDuration:0.4 animations:^{
        
        originAnimationLabel.frame = leftLabelTargetFrame;
        destinationAnimationLabel.frame = rightLabelTargetFrame;
        
    } completion:^(BOOL finished) {
        
        [originAnimationLabel removeFromSuperview];
        [destinationAnimationLabel removeFromSuperview];
        
        leftLabel.textColor = previousColor;
        rightLabel.textColor = previousColor;
        
     
        
    }];
}


- (UILabel *)deepLabelCopy:(UILabel *)label {
    UILabel *duplicateLabel = [[UILabel alloc] initWithFrame:label.frame];
    duplicateLabel.text = label.text;
    duplicateLabel.textColor = label.textColor;
    duplicateLabel.font = label.font;
    duplicateLabel.textAlignment = label.textAlignment;
    duplicateLabel.hidden = label.hidden;
    duplicateLabel.numberOfLines = label.numberOfLines;
    
    return duplicateLabel ;
}


- (IBAction)dateAction:(id)sender {
    
    [self.delegate openCalenderDateForMulticity:self.indexPath];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)shakeAnimation:(PlaceholderLabels)label
{
    
    UIView * view = nil ;
    
    switch (label) {
        case MulticityFromLabel:
            view = self.fromLabel;
            break;
        case MulticityToLabel:
            view = self.toLabel;
            break;
        case MulticityDateLabel:
            view = self.dateLabel;
            break;
        default:
            break;
    }
    
    [view nudgeAnimation];

}

@end
