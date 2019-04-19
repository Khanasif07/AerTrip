//
//  AertripCalendarViewController.m
//  Aertrip
//
//  Created by Kakshil Shah on 6/29/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//


#import "AertripCalendarViewController.h"

#import "DIYCalendarCell.h"
#import <FSCalendar/FSCalendar.h>
#import <AertripCalendarDataModel/CalendarDataModel.h>
#import <CoreText/CoreText.h>

@interface AertripCalendarViewController () <FSCalendarDelegate, FSCalendarDataSource>

@property (weak, nonatomic) IBOutlet FSCalendar *customCalenderView;
@property (strong, nonatomic) NSCalendar *gregorian;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSDate *minimumDate;
@property (strong, nonatomic) NSDate *maximumDate;
@property (assign, nonatomic) CGFloat primaryDuration;
@property (strong , nonatomic) NSMutableArray * selectedDates;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@end

@implementation AertripCalendarViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setModalPresentationStyle:UIModalPresentationOverFullScreen];
    [self setModalPresentationCapturesStatusBarAppearance:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupInitials];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configureInitialBottomViewPosition];


}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self animateBottomViewIn];
    [self showDatesSelection];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(UIColor*)ONE_FIVE_THREE_COLOR {
    return  [UIColor  colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
}


-(UIColor*)AertripColor
{
    return  [UIColor  colorWithRed:0/255.0 green:204/255.0 blue:153/255.0 alpha:1.0];
}



- (NSString *)dayOfDate:(NSDate *)date {
    if (date != nil) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:date];
        
        NSInteger weekday = [components weekday];
        NSString *weekdayName = [dateFormatter weekdaySymbols][weekday - 1];
        return weekdayName;
    }
    return @"";
    
    
}

//
- (void)setupInitials {
    
    self.primaryDuration = 0.4;
    [self loadFont:@"SourceSansPro-Regular"];
    [self loadFont:@"SourceSansPro-SemiBold"];
    [self setupCalender];
    [self setupTopViewWrapper];
    [self SwitchTapOfSingleLegTypeJourney];
    
    [self applyShadowToDoneView];
    [self makeTopCornersRounded:self.bottomView withRadius:10.0];
    
    self.doneButton.userInteractionEnabled = YES;
    

}

    
    - (void) loadFont:(NSString*)fontName {
        NSString *fontPath = [[NSBundle mainBundle] pathForResource:fontName ofType:@"ttf"];
        NSData *inData = [NSData dataWithContentsOfFile:fontPath];
        CFErrorRef error;
        CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)inData);
        CGFontRef font = CGFontCreateWithDataProvider(provider);
        if (! CTFontManagerRegisterGraphicsFont(font, &error)) {
            CFStringRef errorDescription = CFErrorCopyDescription(error);
            NSLog(@"Failed to load font: %@", errorDescription);
            CFRelease(errorDescription);
        }
    }

- (void)makeTopCornersRounded:(UIView *)view withRadius:(double)radius{
    if (@available(iOS 11.0, *)) {
        view.layer.cornerRadius = radius;
        [view.layer setMaskedCorners:kCALayerMaxXMinYCorner | kCALayerMinXMinYCorner];
    } else {
        // Fallback on earlier versions
    }
}


- (NSString *)dateFormatedFromDate:(NSDate *)date
{
    if (date != nil) {
        NSDateFormatter *inputDateFormatter = [[NSDateFormatter alloc] init];
        [inputDateFormatter setDateFormat:@"dd MMM"];
        NSString *dateString = [inputDateFormatter stringFromDate:date];
        return dateString;
    }else {
        return @"";
    }
    
    
}

- (void)setupTopViewForSingleJourney {
    self.topViewHeightConstraint.constant = 93;
    self.TopSpaceConstraint.constant = 93;
    self.startDateLabel.text = @"Onwards";
    self.cancelButton.hidden = !self.viewModel.isReturn;
    
    if (self.viewModel.date2) {
        self.endDateLabel.text = @"Return";
        self.cancelButton.hidden = NO;
    }
    else {
        self.endDateLabel.text = @"Add Return?";
        self.cancelButton.hidden = YES;
    }
    [self setupCheckInDateView];
    [self setupCheckOutDateView];
}


-(void)updateMulticityCalendarWithIndex:(NSInteger)index{

    NSDate * previouslySelectedDate = [self getMinimumDateFor:index];
    if (previouslySelectedDate != nil ){
        self.minimumDate = previouslySelectedDate;
    }
   

    [self createSelectedDatesArray:index];

    NSString * key = [NSString stringWithFormat:@"%ld",(long)index];

    NSString * dateInStringFormat = [self.multicityViewModel.travelDatesDictionary objectForKey:key];
    NSDate * date = [self.dateFormatter dateFromString:dateInStringFormat];
    if (date != nil ) {
        [self performDateSelectionForMultiCity:date];
    }

    [self configureVisibleCells];
    
}

- (void)createSelectedDatesArray:(NSInteger)index {
    self.selectedDates = [[NSMutableArray alloc]init];
    
    NSString * currentIndexKey = [NSString stringWithFormat:@"%ld",(long)index];
    
    for ( int i = 0 ; i < self.multicityViewModel.cityCount; i++)
        
    {
        NSString * key = [NSString stringWithFormat:@"%ld",(long)i];
        
        NSString * dateInStringFormat = [self.multicityViewModel.travelDatesDictionary objectForKey:key];
        NSDate * date = [self.dateFormatter dateFromString:dateInStringFormat];
        if (date != nil ) {
            
            if ([key compare:currentIndexKey] == NSOrderedSame ) {
                continue;
            }
            else {
                [self.selectedDates addObject:date];
            }
        }        
    }
}


-(NSDate*)getMinimumDateFor:(NSInteger)index
{
    NSDate *previousSelectedDate = NSDate.date;
    
    if (index == 0 ) {
        previousSelectedDate = NSDate.date;
    }
    else {
        
        
        for ( int i = 0 ; i < [self.multicityViewModel cityCount]; i++)
            
        {
            NSString * key = [NSString stringWithFormat:@"%ld",(long)i];
            NSUInteger currentIndex = [key integerValue];
            
            if(currentIndex < index) {
                
                NSString * dateInStringFormat = [self.multicityViewModel.travelDatesDictionary objectForKey:key];
                NSDate * date = [self.dateFormatter dateFromString:dateInStringFormat];
                if (date != nil ) {
                    previousSelectedDate = date;
                }
            }
        }
    }
    
    return previousSelectedDate;
}

-(void)selectTapAtIndex:(NSUInteger)index{
    

    for (UIView *tapView  in self.TapStackView.subviews) {
        
        UILabel * dateLabelOne = [tapView viewWithTag:101];
        dateLabelOne.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:18.0];
        dateLabelOne.textColor = [self ONE_FIVE_THREE_COLOR];
        
        UILabel * dateLabelTwo = [tapView viewWithTag:102];
        dateLabelTwo.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:12.0];
        dateLabelTwo.textColor = [self ONE_FIVE_THREE_COLOR];
    }
    
    UIView * selectedIndexView = [self.TapStackView viewWithTag:( 50 + index)];
    
    UILabel * dateLabelOne = [selectedIndexView viewWithTag:101];
    dateLabelOne.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:18.0];
    dateLabelOne.textColor = [self AertripColor];
    
    UILabel * dateLabelTwo = [selectedIndexView viewWithTag:102];
    dateLabelTwo.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:12.0];
    dateLabelTwo.textColor = [self AertripColor];
    
    [self setSubTitleForTabAtIndex:index];
}


-(void)setSubTitleForTabAtIndex:(NSUInteger)index {
    
    UIView * selectedIndexView = [self.TapStackView viewWithTag:( 50 + index)];
    UILabel * dateLabelOne = [selectedIndexView viewWithTag:101];
    UILabel * dateLabelTwo = [selectedIndexView viewWithTag:102];
    
    NSString * dateString = [self getDateForIndex:index];
    
    if (dateString.length > 0) {
        dateLabelTwo.text = dateString;
        
        if( dateLabelTwo.hidden)  {
        
            dateLabelTwo.hidden = NO;
             dateLabelTwo.alpha = 0.0;
            [UIView animateWithDuration:0.3 animations:^{
                dateLabelTwo.alpha = 1.0;
                dateLabelOne.frame = CGRectMake(0, 9 , dateLabelOne.frame.size.width, 23);
            } completion:^(BOOL finished) {
               
            }
             ];
        }
    }
    else {
        dateLabelTwo.text = dateString;
        
        [UIView animateWithDuration:0.3 animations:^{
           
            dateLabelOne.frame = CGRectMake(0, 0 , dateLabelOne.frame.size.width, 62);
            dateLabelTwo.alpha = 0.0;
        } completion:^(BOOL finished) {
            dateLabelTwo.hidden = YES;
        }];
        
    }
}

-(void)prepareTopTapViewForMulticityJourney{
    
    
    NSUInteger count = [self.multicityViewModel cityCount];
    for ( int i = 0 ; i < count; i++) {
        

        CGFloat width = self.view.frame.size.width/count;
        UIView * tapView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 62)];

        tapView.tag = ( i + 50);
        
        
        UILabel * dateLabelOne = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 62)];
        [dateLabelOne.widthAnchor constraintEqualToConstant:width].active = YES;
        
        dateLabelOne.backgroundColor = [UIColor clearColor];
        dateLabelOne.textAlignment =  NSTextAlignmentCenter;
        dateLabelOne.tag = 101;
        
        NSString * title = [NSString stringWithFormat:@"%d",(i + 1) ];
        dateLabelOne.text = title;
        dateLabelOne.textColor = [self ONE_FIVE_THREE_COLOR];
        dateLabelOne.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:18];
        [tapView addSubview:dateLabelOne];

        
        UILabel * dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 36, width, 15)];
        dateLabel.backgroundColor = [UIColor clearColor];
        dateLabel.textAlignment =  NSTextAlignmentCenter;
        dateLabel.tag = 102;
        

        dateLabel.textColor = [self ONE_FIVE_THREE_COLOR];
        dateLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:12];

        NSString * dateString = [self getDateForIndex:i];
        if (dateString.length > 0) {
            dateLabel.text = dateString;
            dateLabel.hidden = NO;
            dateLabelOne.frame = CGRectMake(0, 9, width, 23);
        }
        else {
            dateLabel.text = dateString;
            dateLabel.hidden = YES;
            dateLabelOne.frame = CGRectMake(0, 0 , width, 62);

        }

        [tapView addSubview:dateLabel];
        
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnSelectedTab:)];
        [tapView addGestureRecognizer:tapGesture];
        [self.TapStackView addArrangedSubview:tapView];


    }
    
    
    self.multicitySelectionTabWidth.constant = self.view.frame.size.width/count;
    [self.bottomView layoutIfNeeded];
    [self setMulticitySelectionBackground];
}

-(void)setMulticitySelectionBackground{
    
    
    [UIView animateWithDuration:0.4 animations:^{
        NSUInteger count = [self.multicityViewModel cityCount];
        
        CGFloat width = self.TapStackView.frame.size.width/count;
        self.multicitySelectionLeading.constant = self.multicityViewModel.currentIndex * width;
        [self.bottomView layoutIfNeeded];
    }];
    
}

- (void)selectMulticityTapAt:(NSUInteger)index {
    self.multicityViewModel.currentIndex = index;
    [self selectTapAtIndex:index ];
    [self updateMulticityCalendarWithIndex:index];
    [self setMulticitySelectionBackground];
}

-(void)tapOnSelectedTab:(UITapGestureRecognizer*)tapGesture {
  
    NSUInteger index = tapGesture.view.tag;
    
    index =  ( index - 50 );
    [self selectMulticityTapAt:index];

}


-(NSString*)getDateForIndex:(NSUInteger)index
{   NSString * formattedDateString = @"";
    
    NSString * key = [NSString stringWithFormat:@"%ld",(long)index];
    NSString *dateInStringFormat = [self.multicityViewModel.travelDatesDictionary objectForKey:key];

    if ( dateInStringFormat.length > 0) {
        
        NSDate * dateObj = [self.dateFormatter dateFromString:dateInStringFormat];
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"dd MMM"];
        formattedDateString = [dateFormatter stringFromDate:dateObj];
    }
    else {
        formattedDateString = dateInStringFormat;
    }
    
    return formattedDateString;
}


- (void)setupTopViewWrapper {
    
    if( self.multicityViewModel != nil) {
        self.topViewHeightConstraint.constant = 0;
        self.TopSpaceConstraint.constant = 62;
        self.TapStackView.hidden = NO;
        
        [self prepareTopTapViewForMulticityJourney];
        [self selectTapAtIndex:self.multicityViewModel.currentIndex];
        [self updateMulticityCalendarWithIndex:self.multicityViewModel.currentIndex];
        
        return;
    }
    
    
    if (self.viewModel.isHotelCalendar) {
        self.cancelButton.hidden = YES;
        self.startDateLabel.text = @"Check-in";
        self.endDateLabel.text = @"Check-out";

    }else {
            [self setupTopViewForSingleJourney];
    }
}
- (void)applyShadowToDoneView {
    
    self.doneOutterView.clipsToBounds = NO;
    self.doneOutterView.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.05].CGColor;
    self.doneOutterView.layer.shadowOpacity = 1.0;
    self.doneOutterView.layer.shadowRadius = 10.0;
    self.doneOutterView.layer.shadowOffset = CGSizeMake(0.0, -6.0);
    
}


- (void)setupCalender {
    self.gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"yyyy-MM-dd";
    self.minimumDate = NSDate.date;
    
    self.selectedDates = [[NSMutableArray alloc]init];
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.year = 1;
    dayComponent.day = -1;
    
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    NSDate *maximumDate = [theCalendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0];
    self.maximumDate = maximumDate;

    
    [self.customCalenderView setScrollDirection:FSCalendarScrollDirectionVertical];
    self.customCalenderView.dataSource = self;
    self.customCalenderView.delegate = self;
    
    self.customCalenderView.pagingEnabled = NO; // important to scroll down
    
    
    if ( self.viewModel != nil){
        self.customCalenderView.allowsMultipleSelection = YES;
    }
    if ( self.multicityViewModel != nil) {
       self.customCalenderView.allowsMultipleSelection = NO;
    }
    self.customCalenderView.firstWeekday = 1;
    self.customCalenderView.placeholderType = FSCalendarPlaceholderTypeNone;    //date cell placeholder make empty
    [self.customCalenderView registerClass:[DIYCalendarCell class] forCellReuseIdentifier:@"cell"];

    UIPanGestureRecognizer *scopeGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.customCalenderView  action:@selector(handleScopeGesture:)];
    [self.customCalenderView  addGestureRecognizer:scopeGesture];
    
    //HEADER
    self.customCalenderView.appearance.headerTitleColor = [UIColor blackColor];
    self.customCalenderView.appearance.headerTitleFont = [UIFont fontWithName:@"SourceSansPro-Semibold" size:20.0];
    self.customCalenderView.headerHeight = 60.0;
    self.customCalenderView.weekdayHeight = 0;              //hide weekday section

    
    // HeaderView
//    FSCalendarHeaderView * headerView = [[FSCalendarHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
//    self.customCalenderView.calendarHeaderView = headerView;
    
    
    //date cell
    self.customCalenderView.rowHeight = 70.0;
    self.customCalenderView.appearance.titleDefaultColor = [UIColor blackColor];
    self.customCalenderView.appearance.titleFont = [UIFont fontWithName:@"SourceSansPro-Regular" size:20.0];
    self.customCalenderView.swipeToChooseGesture.enabled = YES;
    self.customCalenderView.today = nil;

    //COLOR SETUP
}


- (void)setupNightCount {
    if (self.viewModel.isHotelCalendar) {
        if (self.viewModel.date1 != nil && self.viewModel.date2 != nil) {
            self.nightView.hidden = NO;
            NSInteger count = [self getNumberOfNightsInRange:self.viewModel.date1 endDate:self.viewModel.date2];
            NSInteger nightCount = count;
            if (nightCount > 1) {
                self.nightCountLabel.text = [NSString stringWithFormat:@"%ld Nights", (long)nightCount];
            }else {
                self.nightCountLabel.text = [NSString stringWithFormat:@"%ld Night", (long)nightCount];
            }
        }else {
            self.nightView.hidden = YES;
        }
    }else {
        self.nightView.hidden = YES;

    }
    
}


- (NSInteger)getNumberOfNightsInRange:(NSDate *)startDate endDate:(NSDate *)endDate {
    if (startDate == nil || endDate == nil)
        return NSNotFound;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *startDateString = [dateFormatter stringFromDate:startDate];
    startDate = [dateFormatter dateFromString:startDateString];
    
    
    NSString *endDateString = [dateFormatter stringFromDate:endDate];
    endDate = [dateFormatter dateFromString:endDateString];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    
    NSInteger startDay = [calendar ordinalityOfUnit:NSCalendarUnitDay
                                             inUnit:NSCalendarUnitEra
                                            forDate:startDate];
    
    NSInteger endDay = [calendar ordinalityOfUnit:NSCalendarUnitDay
                                           inUnit:NSCalendarUnitEra
                                          forDate:endDate];
    
    if (startDay == NSNotFound)
        return startDay;
    
    if (endDay == NSNotFound)
        return endDay;
    
    return endDay - startDay;
    
    
}

//MARK:- Target Action methods



- (IBAction)doneAction:(id)sender {
    
    if (self.multicityViewModel != nil ) {
        [self.multicityViewModel onDoneButtonTapped];
    }
    else if ( self.viewModel != nil){
        [self.viewModel onDoneButtonTapped];
    }
    [self animateBottomViewOut];
}
- (IBAction)cancelAction:(id)sender {
    self.endDateLabel.text = @"Add Return?";
    self.viewModel.isStartDateSelection = YES;
    self.viewModel.isReturn = NO;
    
    if(self.viewModel.date1 != nil && self.viewModel.date2 != nil) {
        [self deSelectDatesInRange:self.viewModel.date1 endDate:self.viewModel.date2];
    }
    
    if (self.viewModel.date2 != nil) {
        [self.customCalenderView deselectDate:self.viewModel.date2];
    }
    
    self.viewModel.date2 = nil;
    [self setupCheckOutDateView];
    [self showDatesSelection];
    [self SwitchTapOfSingleLegTypeJourney];

}

- (void)SwitchTapOfSingleLegTypeJourney {
    if (self.viewModel.isStartDateSelection) {

        [UIView animateWithDuration:0.2 animations:^{
            self.backgroudViewLeadingConstraint.constant = 0;
            [self.TopView layoutIfNeeded];
        }];
        
        [self.startDateLabel setFont:[UIFont fontWithName:@"SourceSansPro-Semibold" size:16.0]];
        [self.startDateLabel setTextColor:[self AertripColor]];
        [self.endDateLabel setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:18.0]];
        [self.endDateLabel setTextColor:[self ONE_FIVE_THREE_COLOR]];
    }else {
        self.endDateLabel.text = @"Return";
        self.viewModel.isReturn = YES;
        self.cancelButton.hidden = FALSE;

        [UIView animateWithDuration:0.2 animations:^{
            self.backgroudViewLeadingConstraint.constant = self.view.frame.size.width/2;
            [self.TopView layoutIfNeeded];
        }];
        
        [self.endDateLabel setFont:[UIFont fontWithName:@"SourceSansPro-Semibold" size:18.0]];
        [self.endDateLabel setTextColor:[self AertripColor]];
        [self.startDateLabel setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:16.0]];
        [self.startDateLabel setTextColor:[self ONE_FIVE_THREE_COLOR]];
    }
}

//MARK:- BOTTOM ANIMATIONS
- (void)configureInitialBottomViewPosition {
    self.topConstraintMainView.constant = (self.view.bounds.size.height);
}
- (void)animateBottomViewIn {
    [UIView animateWithDuration:self.primaryDuration delay:0 options: UIViewAnimationOptionCurveEaseInOut animations:^{
        self.dimmerLayer.alpha = 0.4;
        self.topConstraintMainView.constant = 0;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}
- (void)animateBottomViewOut {
    [UIView animateWithDuration:self.primaryDuration delay:0 options: UIViewAnimationOptionCurveEaseIn animations:^{
        self.dimmerLayer.alpha = 0.0;
          self.topConstraintMainView.constant = (self.view.bounds.size.height);
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}



#pragma mark - FSCalendarDataSource

- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar
{
    return self.minimumDate;
}

- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar
{
    return self.maximumDate;
}

- (FSCalendarCell *)calendar:(FSCalendar *)calendar cellForDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    DIYCalendarCell *cell = [calendar dequeueReusableCellWithIdentifier:@"cell" forDate:date atMonthPosition:monthPosition];
    return cell;
}
- (void)calendar:(FSCalendar *)calendar willDisplayCell:(FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition: (FSCalendarMonthPosition)monthPosition
{
    [self configureCell:cell forDate:date atMonthPosition:monthPosition];
}

#pragma mark - FSCalendarDelegate
- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    
    NSDate * previousDate = [self.minimumDate dateByAddingTimeInterval:-86400];
    NSTimeInterval timeInterval = [date timeIntervalSinceDate:previousDate];

    if(timeInterval > 0 )
    {
        return YES;
    }
    return NO;

}

- (BOOL)calendar:(FSCalendar *)calendar shouldDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    
    if (self.viewModel != nil ) {
        [self performDateSelectionForFlight:calendar date:date];
        return NO;
    }

    return YES;
}

- (void)performDateSelectionForHotel:(NSDate * _Nonnull)date {
    if (self.viewModel.date1 == nil) {
        self.viewModel.date1 = date;
        [self.customCalenderView selectDate:self.viewModel.date1];
        self.viewModel.isStartDateSelection = YES;
        
    }else {
        if (self.viewModel.date2 == nil ) {
            if (date > self.viewModel.date1) {
                self.viewModel.date2 = date;
                [self.customCalenderView selectDate:self.viewModel.date2];
                [self selectDatesInRange:self.viewModel.date1 endDate:self.viewModel.date2];
                self.viewModel.isStartDateSelection = NO;
            }else {
                [self.customCalenderView deselectDate:self.viewModel.date1];
                self.viewModel.date1 = date;
                [self.customCalenderView selectDate:self.viewModel.date1];
                self.viewModel.isStartDateSelection = YES;
            }
        }else {
            [self deSelectDatesInRange:self.viewModel.date1 endDate:self.viewModel.date2];
            [self.customCalenderView deselectDate:self.viewModel.date1];
            [self.customCalenderView deselectDate:self.viewModel.date2];
            
            self.viewModel.date1 = date;
            self.viewModel.date2 = nil;
            [self.customCalenderView selectDate:self.viewModel.date1];
            self.viewModel.isStartDateSelection = YES;
            
            
        }
    }
    [self setupCheckInDateView];
    [self setupCheckOutDateView];
    [self SwitchTapOfSingleLegTypeJourney];
    [self configureVisibleCells];
}



- (void)performDateSelectionForFlight:(FSCalendar * _Nonnull)calendar date:(NSDate * _Nonnull)date {
    
    
        if (self.viewModel.date1 != nil) {
            [self.customCalenderView deselectDate:self.viewModel.date1];
        }
        if (self.viewModel.date2 != nil) {
            [self.customCalenderView deselectDate:self.viewModel.date2];

        }
        if (self.viewModel.date1 != nil && self.viewModel.date2 != nil) {
            [self deSelectDatesInRange:self.viewModel.date1 endDate:self.viewModel.date2];

        }
    
    
    if (self.viewModel.isStartDateSelection) {

        
        //Trim selection  if new date is later to currently selected onwards date
        // e.g. if previously 14 is onwards date ( self.viewModel.date1 ) and new date is 17,
        // then trim selection for dates 14 to 16.
        if([self.viewModel.date1 compare:date] == NSOrderedAscending ) {
            [self deSelectDatesInRange:self.viewModel.date1 endDate:date];
        }
      
        self.viewModel.date1 = date;
        [self setupCheckInDateView];
        
        // if newly selected onwards date is greater than  return date
        // then remove previouly selected return date and trim previously selected date range
        if ([self.viewModel.date1 compare:self.viewModel.date2] == NSOrderedDescending) {

            self.viewModel.date2 = nil;
            [self setupCheckOutDateView];

        }
        
        [self showDatesSelection];
      
        if (self.viewModel.isReturn) {
            self.viewModel.isStartDateSelection = NO;
            [self SwitchTapOfSingleLegTypeJourney];
        }
    }
    else {
        
        //Removing previously selected dates if new date is prior to currently selected return date
        // e.g. if previously 25 is returned date ( self.viewModel.date2 ) and new date is 21,
        // then trim selection for dates 22 to 25.
        if([date compare:self.viewModel.date2] == NSOrderedAscending ) {
            [self deSelectDatesInRange:date endDate:self.viewModel.date2];
        }
        
        
        self.viewModel.date2 = date;
        [self setupCheckOutDateView];
        
        // if newly selected return date is prior to selected onwards date
        // then remove previouly selected onwards date and trim selected date range
        if ([self.viewModel.date1 compare:self.viewModel.date2] == NSOrderedDescending) {

            [self deSelectDatesInRange:self.viewModel.date2 endDate:self.viewModel.date1];
            self.viewModel.date1 = nil;
            [self setupCheckInDateView];
        }
        
        [self showDatesSelection];
            self.viewModel.isStartDateSelection = YES;
            [self SwitchTapOfSingleLegTypeJourney];

    }
}


- (void)removeSelectedDatesForLaterTabs:(NSDate*)currentSelectedDate
{
    for( NSInteger i = (self.multicityViewModel.currentIndex + 1 ) ; i <  [self.multicityViewModel cityCount] ; i++){
        NSString * key = [NSString stringWithFormat:@"%ld",(long)i];
        NSString *dateInStringFormat = [self.multicityViewModel.travelDatesDictionary objectForKey:key];
        NSDate * date = [self.dateFormatter dateFromString:dateInStringFormat];
        if (date != nil ) {
            
            NSTimeInterval timeInterval = [date timeIntervalSinceDate:currentSelectedDate];
            if ( timeInterval < 0 ) {

                [self.customCalenderView deselectDate:date];
                [self.multicityViewModel.travelDatesDictionary setValue:@"" forKey:key];
                [self setSubTitleForTabAtIndex:i];
            }
        }
    }
    
    [self createSelectedDatesArray:self.multicityViewModel.currentIndex];
}

-(void)performDateSelectionForMultiCity:(NSDate * _Nonnull)date{
    
    [self.customCalenderView selectDate:date];
    NSString * key = [NSString stringWithFormat:@"%ld",(long)self.multicityViewModel.currentIndex];
    NSString * dateString = [self.dateFormatter stringFromDate:date];
    [self.multicityViewModel.travelDatesDictionary setValue:dateString forKey:key];
    [self setSubTitleForTabAtIndex:self.multicityViewModel.currentIndex];
    [self configureVisibleCells];
}
    
-(void)showDatesSelection {
    
    if( self.viewModel.date1 && self.viewModel.date2) {
        [self selectRange];
    }
    else {
        [self selectOnlyDates];
    }
}


- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{

    if(self.viewModel !=  nil ) {
        
        if (self.viewModel.isHotelCalendar) {
            [self performDateSelectionForHotel:date];
        }else {
            [self performDateSelectionForFlight:calendar date:date];
        }
        return;
    }
 
    if ( self.multicityViewModel != nil) {
        [self performDateSelectionForMultiCity:date];
        [self removeSelectedDatesForLaterTabs:date];
        NSInteger cityCount = [self.multicityViewModel cityCount];
        if ( (self.multicityViewModel.currentIndex + 1) < cityCount){
            [self selectMulticityTapAt: (self.multicityViewModel.currentIndex + 1)];
        }
    }
    
     [self configureVisibleCells];
}
- (void)selectDatesInRange:(NSDate *)startDate endDate:(NSDate *)endDate {
   
    NSInteger numberOfNights = [self getNumberOfNightsInRange:startDate endDate:endDate];
    for (int i = 1 ; i <= numberOfNights-0; i++) {
        NSDateComponents *components = [[NSDateComponents alloc] init] ;
        [components setDay:i];
        NSDate *newDateNext = [self.gregorian dateByAddingComponents:components toDate:startDate options:0];
        [self.customCalenderView selectDate:newDateNext];
        
    }
}
- (void)deSelectDatesInRange:(NSDate *)startDate endDate:(NSDate *)endDate {
    
    NSInteger numberOfNights = [self getNumberOfNightsInRange:startDate endDate:endDate];

    for (int i = 1 ; i <= numberOfNights; i++) {
        NSDateComponents *components = [[NSDateComponents alloc] init] ;
        [components setDay:i];
        NSDate *newDateNext = [self.gregorian dateByAddingComponents:components toDate:startDate options:0];
        [self.customCalenderView deselectDate:newDateNext];
    }
}



- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar
{
    NSLog(@"did change page %@",[self.dateFormatter stringFromDate:calendar.currentPage]);
}

- (void)showSelectionLayer:(DIYCalendarCell *)diyCell selectionType:(SelectionType)selectionType {
    diyCell.selectionLayer.hidden = NO;
    diyCell.previousTapSelectionLayer.hidden = YES;
    diyCell.selectionType = selectionType;
}

- (void)configureCell:(__kindof FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    
    DIYCalendarCell *diyCell = (DIYCalendarCell *)cell;
    NSDate * previousDate = [self.minimumDate dateByAddingTimeInterval:-86400];
    
    NSTimeInterval timeInterval = [date timeIntervalSinceDate:previousDate];

    if(timeInterval > 0 )
    {
        cell.titleLabel.textColor = [UIColor blackColor];
    }
    else {
        cell.titleLabel.textColor = [UIColor colorWithRed:0.66 green:0.66 blue:0.66 alpha:1.0];
    }
    
    if( [date timeIntervalSinceDate:self.maximumDate] > 0 ){
        cell.titleLabel.textColor = [UIColor colorWithRed:0.66 green:0.66 blue:0.66 alpha:1.0];
    }
    
    // Custom today circle
    diyCell.circleImageView.hidden = [self.gregorian isDateInToday:date];
    // Configure selection layer
    if (monthPosition == FSCalendarMonthPositionCurrent) {
        // Configure selection layer
        
        
        SelectionType selectionType = SelectionTypeNone;

        if(self.multicityViewModel !=nil &&  [self.selectedDates containsObject:date]){
            selectionType = SelectionTypeMulticity;
        }
        
            if ([self.customCalenderView.selectedDates containsObject:date]) {
                NSDate *previousDate = [self.gregorian dateByAddingUnit:NSCalendarUnitDay value:-1 toDate:date options:0];
                NSDate *nextDate = [self.gregorian dateByAddingUnit:NSCalendarUnitDay value:1 toDate:date options:0];
                if ([self.customCalenderView.selectedDates containsObject:date]) {
                    if ([self.customCalenderView.selectedDates containsObject:previousDate] && [self.customCalenderView.selectedDates containsObject:nextDate]) {
                        selectionType = SelectionTypeMiddle;
                    } else if ([self.customCalenderView.selectedDates containsObject:previousDate] && [self.customCalenderView.selectedDates containsObject:date]) {
                        selectionType = SelectionTypeRightBorder;
                    } else if ([self.customCalenderView.selectedDates containsObject:nextDate]) {
                        selectionType = SelectionTypeLeftBorder;
                    } else {
                        selectionType = SelectionTypeSingle;
                    }
                }
            }
        

        if (selectionType == SelectionTypeNone) {
            diyCell.selectionLayer.hidden = YES;
            diyCell.previousTapSelectionLayer.hidden = YES;
            return;
        }
        
        if (selectionType == SelectionTypeMulticity){
            diyCell.selectionLayer.hidden = YES;
            diyCell.previousTapSelectionLayer.hidden = NO;
            diyCell.selectionType = selectionType;
        }
        
        if ( selectionType == SelectionTypeSingle) {
            cell.titleLabel.textColor = [UIColor whiteColor];
            [self showSelectionLayer:diyCell selectionType:selectionType];
        }
        
        if ( selectionType == SelectionTypeMiddle) {
            cell.titleLabel.textColor = [UIColor whiteColor];
            [self showSelectionLayer:diyCell selectionType:selectionType];
        }

        if ( selectionType == SelectionTypeRightBorder) {
            cell.titleLabel.textColor = [UIColor whiteColor];
            [self showSelectionLayer:diyCell selectionType:selectionType];
        }
        
        if ( selectionType == SelectionTypeLeftBorder) {
            cell.titleLabel.textColor = [UIColor whiteColor];
            [self showSelectionLayer:diyCell selectionType:selectionType];
        }
    } else {
        
        diyCell.selectionLayer.hidden = YES;
        diyCell.previousTapSelectionLayer.hidden = YES;
        
    }

}

//MARK:- CALENDER PRIVATE METHOD


- (void)configureVisibleCells
{
    [self.customCalenderView.visibleCells enumerateObjectsUsingBlock:^(__kindof FSCalendarCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDate *date = [self.customCalenderView dateForCell:obj];
        FSCalendarMonthPosition position = [self.customCalenderView monthPositionForCell:obj];
        [self configureCell:obj forDate:date atMonthPosition:position];
    }];
}




//MARK:- Single / Return Journey Methods

- (void)selectOnlyDates {
    
    
        if (self.viewModel.date1 != nil) {
            [self.customCalenderView selectDate:self.viewModel.date1];
        }
    
        if (self.viewModel.date2 != nil) {
            [self.customCalenderView selectDate:self.viewModel.date2];
        }

    [self configureVisibleCells];
    
    
}
- (void)selectRange {
    if (self.viewModel.date1 != nil && self.viewModel.date2 != nil) {
        [self.customCalenderView selectDate:self.viewModel.date1];
        [self.customCalenderView selectDate:self.viewModel.date2];
        [self selectDatesInRange:self.viewModel.date1 endDate:self.viewModel.date2];
        
        if (!self.viewModel.isReturn) {
            [self.customCalenderView selectDate:self.viewModel.date1];
        }
        
    }else if (self.viewModel.date1 != nil) {
        [self.customCalenderView selectDate:self.viewModel.date1];
    }else if (self.viewModel.date2 != nil) {
        [self.customCalenderView selectDate:self.viewModel.date2];
    }
    [self configureVisibleCells];
    
}



- (void)setupCheckInDateView {
    if(self.viewModel.date1 == nil) {
        self.startDateSubLabel.hidden = YES;
        self.startDateValueLabel.hidden = YES;
    }else {
        self.startDateSubLabel.hidden = NO;
        self.startDateValueLabel.hidden = NO;
        self.startDateValueLabel.text = [self dateFormatedFromDate:self.viewModel.date1];
        self.startDateSubLabel.text = [self dayOfDate:self.viewModel.date1];
    }
    [self setupNightCount];
    
    
    
}
- (void)setupCheckOutDateView {
    
    
    if(self.viewModel.date2 == nil) {
        self.endDateSubLabel.hidden = YES;
        self.endDateValueLabel.hidden = YES;
        
        self.cancelButton.hidden = YES;
    }else {
        self.endDateSubLabel.hidden = NO;
        self.endDateValueLabel.hidden = NO;
        self.endDateValueLabel.text = [self dateFormatedFromDate:self.viewModel.date2];
        self.endDateSubLabel.text = [self dayOfDate:self.viewModel.date2];
        self.cancelButton.hidden = NO;
    }
    [self setupNightCount];
    
    
}


- (IBAction)checkInButtonAction:(id)sender {
    
    
    [self showDatesSelection];
    self.viewModel.isStartDateSelection = YES;
    [self SwitchTapOfSingleLegTypeJourney];
}
- (IBAction)checkOutButtonAction:(id)sender {
    [self showDatesSelection];
    self.viewModel.isStartDateSelection = NO;
    self.viewModel.isReturn = YES ;
    [self SwitchTapOfSingleLegTypeJourney];
}

@end
