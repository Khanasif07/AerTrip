//
//  FlightBulkBookingViewController.m
//  Aertrip
//
//  Created by Kakshil Shah on 8/23/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import "FlightBulkBookingViewController.h"
#import "FlightFormViewControllerHeader.h"
#import <CoreLocation/CoreLocation.h>

@interface FlightBulkBookingViewController () <CalendarDataHandler, AddFlightPassengerHandler, AddFlightClassHandler, AirportSelctionHandler,MultiCityFlightCellHandler , CLLocationManagerDelegate, UITableViewDelegate , UITableViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet HMSegmentedControl *flightSegmentedControl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *multiCityView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *multiCityViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UITableView *multiCityTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *multiCityTableViewHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fromToViewHeightConstraint;

@property (weak, nonatomic) IBOutlet UIStackView *fromStackView;
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromSubTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromLabelTop;

@property (weak, nonatomic) IBOutlet UIView *FromToView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fromValueHeight;

@property (weak, nonatomic) IBOutlet UIStackView *toStackView;
@property (weak, nonatomic) IBOutlet UILabel *toLabel;
@property (weak, nonatomic) IBOutlet UILabel *toValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *toSubTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *toLabelTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toValueHeight;

@property (weak, nonatomic) IBOutlet UIButton *switcherButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *onwardReturnViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *onwardsLabel;
@property (weak, nonatomic) IBOutlet UILabel *onwardsValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *onwardsSubTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *returnLabel;
@property (weak, nonatomic) IBOutlet UILabel *returnValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *returnSubTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *returnButton;

@property (weak, nonatomic) IBOutlet UIView *passengerAdultCountView;
@property (weak, nonatomic) IBOutlet UIView *passengerChildrenCountView;
@property (weak, nonatomic) IBOutlet UIView *passengerInfantCountView;

@property (weak, nonatomic) IBOutlet UILabel *passengerAdultCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *passengerChildrenCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *passengerInfantCountLabel;

@property (weak, nonatomic) IBOutlet UIImageView *flightClassTypeImageView;
@property (weak, nonatomic) IBOutlet UILabel *flightClassTypeLabel;


@property (weak, nonatomic) IBOutlet UILabel *myDatesSelectionLabel;
@property ( assign , nonatomic) NSInteger datesSelection;
@property (weak, nonatomic) IBOutlet UITextField *specialRequestValueTextField;
@property (weak, nonatomic) IBOutlet UITextField *preferredFlightValueTextField;


//
@property (weak, nonatomic) IBOutlet UIView *submitButtonOuterView;
@property (weak, nonatomic) IBOutlet ATButton *submitButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *buttonActivityIndicator;

//
@property (weak, nonatomic) IBOutlet UIImageView *backingImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backingImageLeadingInset;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backingImageBottomInset;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backingImageTrailingInset;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backingImageTopInset;

//
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraintMainView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;



@property (strong , nonatomic) CLLocationManager * locationManager;

@property (assign, nonatomic) CGFloat primaryDuration;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *submitButtonWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *submitWidth;


@property (strong, nonatomic) TravellerCount* travellerCount;


@property (strong, nonatomic) NSMutableArray *segmentTitleSectionArray;
@property (strong, nonatomic) NSArray *myDatesArray;


@property (strong, nonatomic) NSIndexPath *selectedMultiCityArrayIndex;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passangerCountViewTopConstraint;
@property (weak, nonatomic) IBOutlet UIButton *multicityRemoveButton;
@property (weak, nonatomic) IBOutlet UIImageView *multicityRemoveIcon;
@property (weak, nonatomic) IBOutlet UILabel *multicityRemoveLabel;
@property (weak, nonatomic) IBOutlet UIButton *multicityAddButton;
@property (weak, nonatomic) IBOutlet UILabel *ReturnLabelCenter;

@property (weak, nonatomic) IBOutlet UIImageView *multicityAddFlightIcon;
@property (weak, nonatomic) IBOutlet UILabel *multicityAddFlightTitle;

@property (assign) BOOL isReturn;
@property (assign) BOOL isMultiCity;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passengerLineViewHeight;


@end

@implementation FlightBulkBookingViewController

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.4;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;
CGFloat animatedDistance;

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setModalPresentationCapturesStatusBarAppearance:YES];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupFlightSection];
    [self handleLoginState];
    self.submitButton.layer.masksToBounds = NO;
    [self.submitButton configureCommonGreenButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

-(void) handleLoginState{
    if ([self exists:[self userID]]) {
        
        [self.submitButton setTitle:@"Submit" forState:UIControlStateNormal];
        self.submitButtonWidth.constant = 150.0;
        self.submitWidth.constant = 150;
        [self.submitButtonOuterView.superview layoutIfNeeded];
        [self setCustomButtonViewEnabled:self.submitButton withOuterView:self.submitButtonOuterView];

    }else{
        
        [self.submitButton setTitle:@"Login and Submit" forState:UIControlStateNormal];
        self.submitButtonWidth.constant = 202;
        self.submitWidth.constant = 202;
        [self.submitButtonOuterView.superview layoutIfNeeded];
        [self setCustomButtonViewEnabled:self.submitButton withOuterView:self.submitButtonOuterView];

    }
}

//MARK:- FLIGHTS IMPLEMENTAION
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)setupFlightSection {
    _preferredFlightValueTextField.delegate = self;
    _specialRequestValueTextField.delegate = self;
    
    self.primaryDuration = 0.4;
    [self makeTopCornersRounded:self.bottomView withRadius:10.0];
    self.myDatesArray = @[@"Flexible", @"Fixed"];
    
    if ( self.formDataModel.onwardsDate == nil){
        self.formDataModel.onwardsDate = [NSDate date];
    }
    [self setupMyDatesPickerView];

   [self setupSubmitButton];
    if ( self.formDataModel.fromFlightArray == nil){
        self.formDataModel.fromFlightArray = [[NSMutableArray alloc] init];
    }

    if ( self.formDataModel.toFlightArray == nil){
        self.formDataModel.toFlightArray = [[NSMutableArray alloc] init];
    }
    self.segmentTitleSectionArray = [@[@"Oneway", @"Return", @"Multi-City"] mutableCopy];
    [self setupFromAndToView];
    [self setupOnwardsReturnView];
    
    self.travellerCount = [[TravellerCount alloc]init];
    self.travellerCount.flightAdultCount = 10;
    self.travellerCount.flightChildrenCount = 0;
    self.travellerCount.flightInfantCount = 0;
    [self setupPassenger];
    
    
    if( self.formDataModel.flightClass == nil){
        FlightClass *flightClassOne = [FlightClass new];
        flightClassOne.imageName = @"";
        flightClassOne.name = @"Economy";
        flightClassOne.type = ECONOMY_FLIGHT_TYPE;
        self.formDataModel.flightClass = flightClassOne;
        
    }
    [self setupFlightClassType];
    
    self.isMultiCity = NO;
    self.isReturn = NO;
    
    [self adjustAsPerTopBar];
    
    if ( self.formDataModel.multiCityArray == nil) {
        self.formDataModel.multiCityArray = [[NSMutableArray alloc] init];
    }
    [self setupMultiCityTableView];
    [self setupSegmentControl];
    [self setupFlightViewsHeights];
    [self setSwipeGesture];
}


-(void)setSwipeGesture{
    
    UISwipeGestureRecognizer * swipeGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeToDismiss)];
    self.view.userInteractionEnabled = YES;
    swipeGesture.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeGesture];
    
}


-(void)swipeToDismiss{
    [self cancelAction:nil];
}

- (void)setupSegmentControl {
    if (self.segmentTitleSectionArray.count == 0) self.segmentTitleSectionArray = [@[@"Oneway"] mutableCopy];
    
    [self.flightSegmentedControl setSectionTitles:self.segmentTitleSectionArray];
    self.flightSegmentedControl.backgroundColor = [UIColor clearColor];
    self.flightSegmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.flightSegmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
    
    self.flightSegmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    self.flightSegmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    self.flightSegmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.flightSegmentedControl.selectionIndicatorHeight = 2;
    self.flightSegmentedControl.verticalDividerEnabled = NO;
    self.flightSegmentedControl.selectionIndicatorColor = [self getAppColor];
    
    self.flightSegmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor FIVE_ONE_COLOR], NSFontAttributeName:[UIFont fontWithName:@"SourceSansPro-Regular" size:16]};
    
    self.flightSegmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor FIVE_ONE_COLOR], NSFontAttributeName:[UIFont fontWithName:@"SourceSansPro-Semibold" size:16]};
    
    self.flightSegmentedControl.borderType = HMSegmentedControlBorderTypeNone;
    self.flightSegmentedControl.selectedSegmentIndex = self.formDataModel.flightSearchType;
    //  [self setupSwipe];
}

- (IBAction)segmentChanged:(id)sender {
    self.formDataModel.flightSearchType = (FlightSearchType)self.flightSegmentedControl.selectedSegmentIndex; //used for swipe gesture too
    [self adjustAsPerTopBar];
    [self.BulkBookingFormDelegate updateWithViewModel:self.formDataModel];
    
    if(self.formDataModel.flightSearchType == MULTI_CITY){
        self.passengerLineViewHeight.constant = 0.48;
    }else{
        self.passengerLineViewHeight.constant = 0.5;
    }
}
- (void) adjustAsPerTopBar {
    
    if (self.formDataModel.flightSearchType == SINGLE_JOURNEY) {
        self.isMultiCity = NO;
        self.isReturn = NO;
    }else if (self.formDataModel.flightSearchType == RETURN_JOURNEY) {
        self.isMultiCity = NO;
        self.isReturn = YES;
    }else if(self.formDataModel.flightSearchType == MULTI_CITY)  {
        self.isMultiCity = YES;
        self.isReturn = NO;
    }
    [self setupFlightViewsHeights];
}

- (void)setupFlightViewsHeights {
    if (self.isMultiCity) {
        self.fromToViewHeightConstraint.constant = 0.0;
        self.onwardReturnViewHeightConstraint.constant = 0.0;
        [self setupMultiCityView];
        self.multiCityViewHeightConstraint.constant = 2000.0;
        self.multiCityTableViewHeightConstraint.constant = self.formDataModel.multiCityArray.count * 80.0;
        self.passangerCountViewTopConstraint.constant = self.multiCityTableViewHeightConstraint.constant + 95.0;
        [self.view layoutIfNeeded];
        [self reloadMultiCityTableView];
        
    }else {
        self.fromToViewHeightConstraint.constant = 101.5;
        self.onwardReturnViewHeightConstraint.constant = 101.5;
        self.multiCityViewHeightConstraint.constant = 0.0;
        self.passangerCountViewTopConstraint.constant = 250.5;
        [self setupOnwardsReturnView];
        
    }
}


-(void) setupFromLabel:(NSArray*)fromFlightArray
{
    if (fromFlightArray.count  > 0) {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.fromLabelTop.alpha = 1.0;
            self.fromLabel.alpha = 0.0;
        }];
        
        self.fromValueLabel.hidden = NO;
        self.fromValueLabel.text = [self flightFromText];
        
        
        AirportSearch *airportSearch = fromFlightArray[0];
        
        NSInteger count = fromFlightArray.count;
        switch (count) {
            case 1:
                self.fromSubTitleLabel.hidden = NO;
                [self.fromValueLabel setFont:[UIFont fontWithName:@"SourceSansPro-Semibold" size:26.0]];
                self.fromSubTitleLabel.text = airportSearch.city;
                self.fromValueHeight.constant = 33.0;
                break;
            case 2 :
                [self.fromValueLabel setFont:[UIFont fontWithName:@"SourceSansPro-Semibold" size:20.0]];
                self.fromSubTitleLabel.hidden = YES;
                self.fromValueHeight.constant = 52.0;
                break;
            case 3 :
                [self.fromValueLabel setFont:[UIFont fontWithName:@"SourceSansPro-Semibold" size:20.0]];
                self.fromSubTitleLabel.hidden = YES;
                self.fromValueHeight.constant = 52.0;
                break;
            default:
                break;
        }
    }else {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.fromLabelTop.alpha = 0.0;
            self.fromLabel.alpha = 1.0;
        }];
        
        self.fromSubTitleLabel.hidden = YES;
        self.fromValueLabel.hidden = YES;
    }
}

-(void)setupToLabel:(NSArray*)toFlightArray  {
    if (toFlightArray.count > 0) {
        self.toValueLabel.hidden = NO;
        [UIView animateWithDuration:0.4 animations:^{

            self.toLabel.alpha = 0.0;
            self.toLabelTop.alpha = 1.0;
        }];


        self.toValueLabel.text = [self flightToText];

        AirportSearch *airportSearch = toFlightArray[0];

        NSInteger count = toFlightArray.count;
        switch (count) {
            case 1:
                self.toValueHeight.constant = 33.0;
                self.toSubTitleLabel.hidden = NO;
                self.toSubTitleLabel.text = airportSearch.city;
                [self.toValueLabel setFont:[UIFont fontWithName:@"SourceSansPro-Semibold" size:26.0]];
                break;
            case 2 :
                self.toValueHeight.constant = 52.0;
                self.toSubTitleLabel.hidden = YES;
                [self.toValueLabel setFont:[UIFont fontWithName:@"SourceSansPro-Semibold" size:20.0]];
                break;
            case 3 :
                self.toValueHeight.constant = 52.0;
                self.toSubTitleLabel.hidden = YES;
                [self.toValueLabel setFont:[UIFont fontWithName:@"SourceSansPro-Semibold" size:20.0]];
                break;
            default:
                break;
        }

    }else {
        [UIView animateWithDuration:0.4 animations:^{

            self.toLabel.alpha = 1.0;
            self.toLabelTop.alpha = 0.0;

        }];

        self.toSubTitleLabel.hidden = YES;
        self.toValueLabel.hidden = YES;
    }
}

-(NSString*)flightFromText{
    return [self generateCSVFromSelectionArray:self.formDataModel.fromFlightArray forDisplay:YES];
}

-(NSString*)flightToText {
    return [self generateCSVFromSelectionArray:self.formDataModel.toFlightArray forDisplay:YES];
}


- (void)setupFromAndToView {
    
    
    [self setupFromLabel:self.formDataModel.fromFlightArray];
    [self setupToLabel: self.formDataModel.toFlightArray];
    
    if ( self.formDataModel.fromFlightArray.count == 0 && self.formDataModel.toFlightArray.count == 0) {
        self.switcherButton.enabled = NO;
    }else {
        self.switcherButton.enabled = YES;
    }
    

}

- (IBAction)InvertAirportSelection:(UIButton*)sender {
    [self performAirportSwap];
    
    [UIView animateWithDuration:0.2 animations:^{
        if (CGAffineTransformEqualToTransform(sender.transform, CGAffineTransformIdentity)) {
            sender.transform = CGAffineTransformMakeRotation(M_PI * 0.999);
        } else {
            sender.transform = CGAffineTransformIdentity;
        }
    }];
}

- (void)performAirportSwap {
    
//        [self performAnimationForPlaceholderLabels];
    [self performAirportSwapAnimationForSubTitle];
    [self performAnimationForValueLabels];
    [self airportSwapOnModelView];
    [self cancelAction:@"AirportSwap"];
}


- (void)airportSwapOnModelView {
    NSMutableArray * tempArray = self.formDataModel.fromFlightArray;
    self.formDataModel.fromFlightArray = self.formDataModel.toFlightArray;
    self.formDataModel.toFlightArray = tempArray;
    
    self.fromValueLabel.hidden = YES;
    self.toValueLabel.hidden = YES;
    [self setupFromAndToView];
}

- (void)performAirportSwapAnimationForSubTitle {
    
    if ( self.toSubTitleLabel.isHidden && self.fromSubTitleLabel.isHidden ) {
        return;
    }
    
    UILabel * leftLabel = self.fromSubTitleLabel;
    UILabel * rightLabel = self.toSubTitleLabel;
    
    [self swipPositionOfLabels:leftLabel rightLabel:rightLabel];
}


- (void)performAnimationForValueLabels {
    
    UILabel * leftLabel = self.fromValueLabel;
    UILabel * rightLabel = self.toValueLabel;
    
    [self swipPositionOfLabels:leftLabel rightLabel:rightLabel];
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


- (void)swipPositionOfLabels:(UILabel *)leftLabel rightLabel:(UILabel *)rightLabel {
    UILabel * originAnimationLabel =  [self deepLabelCopy:leftLabel];
    UILabel * destinationAnimationLabel =  [self deepLabelCopy:rightLabel];
    
    
    UIColor * previousColor = leftLabel.textColor;
    
    leftLabel.textColor = [UIColor clearColor];
    rightLabel.textColor = [UIColor clearColor];
    
    [self.FromToView addSubview:originAnimationLabel];
    [self.FromToView addSubview:destinationAnimationLabel];
    
    
    CGRect leftLabelTargetFrame = rightLabel.frame;
    CGRect rightLabelTargetFrame = leftLabel.frame;
    
    if (leftLabel.frame.size.height > leftLabelTargetFrame.size.height){
        leftLabelTargetFrame.size.height = leftLabel.frame.size.height;
    }
    
    if (rightLabel.frame.size.height > rightLabelTargetFrame.size.height){
        rightLabelTargetFrame.size.height = rightLabel.frame.size.height;
    }
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        originAnimationLabel.frame = leftLabelTargetFrame;
        destinationAnimationLabel.frame = rightLabelTargetFrame;
        
    } completion:^(BOOL finished) {
        
        [originAnimationLabel removeFromSuperview];
        [destinationAnimationLabel removeFromSuperview];
        
        leftLabel.textColor = previousColor;
        rightLabel.textColor = previousColor;
        
    }];
}

- (NSString *)generateCSVFromSelectionArray:(NSArray *)array  forDisplay:(BOOL)forDisplay{
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    for (AirportSearch *airportSearch in array) {
        [resultArray addObject:airportSearch.iata];
    }
    return [self generateCVSStringFromArray:resultArray forDisplay:forDisplay];
}


-(NSString *) generateCVSStringFromArray:(NSArray *)array forDisplay:(BOOL)forDisplay
{
    if (!array) {
        return @"";
    }
    if (array.count == 0) {
        return @"";
    }
    
    if (array.count == 1 ) {
        return [array firstObject];
    }
    
    NSString *outputString = @"";
    for (int i = 0; i<array.count; i++) {
        outputString = [outputString stringByAppendingString:array[i]];
        if (i != array.count - 1) {
            outputString = [outputString stringByAppendingString:@", "];
        }
        if (i == array.count - 2 && forDisplay) {
            outputString = [outputString stringByAppendingString:@"\n"];
        }
    }
    
    return outputString;
}

- (void)setupOnwardsReturnView {
    if (self.formDataModel.onwardsDate != nil) {
        [self changeLabelFont:self.onwardsLabel isSmall:YES];
        
        self.onwardsValueLabel.hidden = NO;
        self.onwardsSubTitleLabel.hidden = NO;
        
        self.onwardsValueLabel.text = [self dateFormatedFromDate:self.formDataModel.onwardsDate];
        self.onwardsSubTitleLabel.text = [self dayOfDate:self.formDataModel.onwardsDate];
        
        
    }else {
        [self changeLabelFont:self.onwardsLabel isSmall:NO];
        self.onwardsValueLabel.hidden = YES;
        self.onwardsSubTitleLabel.hidden = YES;
    }
    if (self.isReturn) {
        [self.ReturnLabelCenter setTextColor:[ UIColor ONE_FIVE_THREE_COLOR] ];
        if (self.formDataModel.returnDate != nil) {
            
            self.returnValueLabel.hidden = NO;
            self.returnSubTitleLabel.hidden = NO;
            self.returnLabel.hidden = NO;
            self.ReturnLabelCenter.hidden = YES;
            self.returnValueLabel.text = [self dateFormatedFromDate:self.formDataModel.returnDate];
            self.returnSubTitleLabel.text = [self dayOfDate:self.formDataModel.returnDate];
            
        }else {
            self.returnValueLabel.hidden = YES;
            self.returnLabel.hidden = YES;
            self.returnSubTitleLabel.hidden = YES;
            self.ReturnLabelCenter.hidden = NO;

        }
    }else {

        [self.ReturnLabelCenter setTextColor:[UIColor TWO_THREE_ZERO_COLOR]];
        self.returnValueLabel.hidden = YES;
        self.returnSubTitleLabel.hidden = YES;
        self.returnLabel.hidden = YES;
        self.ReturnLabelCenter.hidden = NO;
    }
    
}

- (void)setupPassenger {
    
    if (self.travellerCount.flightAdultCount > 0) {
        self.passengerAdultCountView.hidden = NO;
        NSUInteger adultCount = (long)self.travellerCount.flightAdultCount;
        
        if ( adultCount == 101){
            self.passengerAdultCountLabel.text = @"100+";
        }else {
            self.passengerAdultCountLabel.text = [NSString stringWithFormat:@"%ld",(long)self.travellerCount.flightAdultCount];
        }
        
    }else {
        self.passengerAdultCountView.hidden = YES;
    }
    if (self.travellerCount.flightChildrenCount > 0) {
        self.passengerChildrenCountView.hidden = NO;
        
        NSUInteger childrenCount = (long)self.travellerCount.flightChildrenCount;
        if (childrenCount == 101) {
            self.passengerChildrenCountLabel.text = @"100+";
        }
        else {
            self.passengerChildrenCountLabel.text = [NSString stringWithFormat:@"%ld",(long)self.travellerCount.flightChildrenCount];
        }
    }else {
        self.passengerChildrenCountView.hidden = YES;
    }
    if ( self.travellerCount.flightInfantCount > 0) {
        self.passengerInfantCountView.hidden = NO;
        
        NSUInteger infantCount = (long)self.travellerCount.flightInfantCount;
        if (infantCount == 101) {
            self.passengerInfantCountLabel.text = @"100+";
        }
        else {
            self.passengerInfantCountLabel.text = [NSString stringWithFormat:@"%ld",self.travellerCount.flightInfantCount];
        }
    }else {
        self.passengerInfantCountView.hidden = YES;
    }
}

- (void)setupFlightClassType {
    [self.flightClassTypeImageView setImage:[UIImage imageNamed:[self getImageNameForFlightClass:self.formDataModel.flightClass]]];
    self.flightClassTypeLabel.text = self.formDataModel.flightClass.name;
    
    if ([self.formDataModel.flightClass.type isEqualToString:PREMIUM_FLIGHT_TYPE]) {
        self.flightClassTypeLabel.text = @"Premium";
    }
}

- (NSString *)getImageNameForFlightClass:(FlightClass *)flightClass {
    
    if ([flightClass.type isEqualToString:ECONOMY_FLIGHT_TYPE]) {
        return @"EconomyClassBlack";
    }else if ([flightClass.type isEqualToString:BUSINESS_FLIGHT_TYPE]) {
        return @"BusinessClassBlack";
        
    }else if ([flightClass.type isEqualToString:PREMIUM_FLIGHT_TYPE]) {
        return @"PreEconomyClassBlack";
        
    }else if ([flightClass.type isEqualToString:FIRST_FLIGHT_TYPE]) {
        return @"FirstClassBlack";
        
    }
    return @"";
}

- (void)setupSubmitButton {
    
    [self hideFlightLoaderIndicator];
    [self setCustomButtonViewEnabled:self.submitButton withOuterView:self.submitButtonOuterView];
//    [self.submitButton addTarget:self action:@selector(flightSearchButtonPressed) forControlEvents:UIControlEventTouchDown];
//    [self.submitButton addTarget:self action:@selector(flightSearchButtonReleased) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
}

- (void)flightSearchButtonPressed {
    [self customButtonViewPressed:self.submitButtonOuterView];
    
}
- (void)flightSearchButtonReleased {
    [self customButtonViewReleased:self.submitButtonOuterView];
    
}
- (void)hideFlightLoaderIndicator {
    
    [self.buttonActivityIndicator stopAnimating];
    [self.buttonActivityIndicator setHidden:YES];
    [self.submitButton setTitle:@"Submit" forState:UIControlStateNormal];
    self.view.userInteractionEnabled = YES;
    
}
- (void)showFlightLoaderIndicator {
    self.view.userInteractionEnabled = NO;
    [self.buttonActivityIndicator startAnimating];
    [self.buttonActivityIndicator setHidden:NO];
    [self.submitButton setTitle:@"" forState:UIControlStateNormal];
}
- (void)selectedDatesFromCalendar:(NSDate *)startDate endDate:(NSDate *)endDate  isReturn:(BOOL)isReturn {
    if (self.isMultiCity) {
        NSMutableDictionary *dictionary = [self.formDataModel.multiCityArray objectAtIndex:self.selectedMultiCityArrayIndex.row];
        NSString *dateString = [self getStringFromNSDate:startDate];
        [dictionary setObject:dateString forKey:@"date"];
        [self reloadMultiCityTableView];
    }else {
        self.formDataModel.onwardsDate = startDate;
        if (isReturn) {
            self.flightSegmentedControl.selectedSegmentIndex = 1;
            self.isReturn = YES;
            //change segment index
            self.formDataModel.returnDate = endDate;
        }else {
            self.flightSegmentedControl.selectedSegmentIndex = 0;
            self.isReturn = NO;
            
        }
        [self setupOnwardsReturnView];

    }
}

-(BOOL)isValidFlightSearch
{
    BOOL isValidSearch = NO;
    
    if (self.isMultiCity) {
        isValidSearch = [self validateMultiCityJourney];
    }
    else {
        isValidSearch =  [self validateSingleLegJourney];
    }
    
    return isValidSearch;
}

-(BOOL)validateSingleLegJourney
{
    if (self.formDataModel.fromFlightArray.count == 0) {
        [AertripToastView toastInView:self.view withText:@"Please select an origin airport"];
        [self shakeAnimation:FromLabel];
        return NO;
    }
    
    if (self.formDataModel.toFlightArray.count == 0) {
        [AertripToastView toastInView:self.view withText:@"Please select a valid destination"];
        [self shakeAnimation:ToLabel];
        return NO;
    }
    NSString *from = [self generateCSVFromSelectionArray:self.formDataModel.fromFlightArray forDisplay:NO];
    NSString *to = [self generateCSVFromSelectionArray:self.formDataModel.toFlightArray forDisplay:NO];
    if ([from isEqualToString:to]) {
        [AertripToastView toastInView:self.view withText:@"Origin and destination cannot be same"];
        [self shakeAnimation:ToLabel];
        return NO;
        
    }
    
    if (![self exists:[self formateDateForAPI:self.formDataModel.onwardsDate]]) {
        [AertripToastView toastInView:self.view withText:@"Please select a departure date"];
        [self shakeAnimation:DepartureDateLabel];
        return NO;
    }
    if (self.isReturn) {
        if (![self exists:[self formateDateForAPI:self.formDataModel.returnDate]]) {
            [AertripToastView toastInView:self.view withText:@"Please select a return date"];
            [self shakeAnimation:ArrivalDateLabel];
            return NO;
        }
    }
    return YES;
}

-(void)showErrorMessage:(NSString*)errorMessage{
    [AertripToastView toastInView:self.view withText:errorMessage];
}

- (void)shakeAnimation:(PlaceholderLabels)label atIndex:(NSIndexPath*)indexPath
{
    MultiCityFlightTableViewCell * cell = [self.multiCityTableView cellForRowAtIndexPath:indexPath];
    [cell shakeAnimation:label];
    [cell setupFromAndToView];
    
}

-(void)shakeAnimation:(PlaceholderLabels)label
{
    switch (label) {
        case FromLabel :
            [self.fromLabel nudgeAnimation];
            break;
        case ToLabel :
            [self.toLabel nudgeAnimation];
            break;
        case DepartureDateLabel:
            [self.onwardsLabel nudgeAnimation];
            break;
        case ArrivalDateLabel :
            [self.returnLabel nudgeAnimation];
            break;
        default:
            break;
    }

}

-(BOOL)validateMultiCityJourney {
    
    
    for (int i = 0 ; i  < self.formDataModel.multiCityArray.count ; i++ ){
        
        MulticityFlightLeg * flightLeg = [self.formDataModel.multiCityArray objectAtIndex:i];
        
        NSString * origin = flightLeg.origin.iata;
        
        if ( origin == nil) {
            [self showErrorMessage:@"Please select an origin airport"];
            NSIndexPath * index = [NSIndexPath indexPathForRow:i inSection:0];
            [self shakeAnimation:MulticityFromLabel atIndex:index];
            return NO;
        }
        NSString * destination = flightLeg.destination.iata;
        
        if ( destination == nil) {
            [self  showErrorMessage:@"Please select a destination airport"];
            NSIndexPath * index = [NSIndexPath indexPathForRow:i inSection:0];
            [self shakeAnimation:MulticityToLabel atIndex:index];
            
            return  NO;
        }
        NSDate * date = flightLeg.travelDate;
        
        if ( date == nil) {
            [self showErrorMessage:@"Please select a departure date"];
            NSIndexPath * index = [NSIndexPath indexPathForRow:i inSection:0];
            [self shakeAnimation:MulticityDateLabel atIndex:index];
            return NO;
        }
    }
    return YES;
}


- (IBAction)submitAction:(id)sender {
    
    if(![self isValidFlightSearch]) {
        return;
    }
    
    if ([self exists:[self userID]]) {
        
        [self performFlightSearch:[self buildDictionaryForFlightSearch]];

    }else{
        


    }
}

- (void)flightFromSource:(NSMutableArray *)fromArray toDestination:(NSMutableArray *)toArray airlineNum:(NSString *)airlineNum{
    if (self.isMultiCity) {
        [self setMulticityAirports:fromArray toArray:toArray atIndexPath:self.selectedMultiCityArrayIndex];

    }else {
    
        self.formDataModel.fromFlightArray = fromArray;
        self.formDataModel.toFlightArray = toArray;
        [self setupFromAndToView];
    }
    
    [self.BulkBookingFormDelegate updateWithViewModel:self.formDataModel];

}

- (void)setMulticityAirports:(NSMutableArray * _Nullable)fromArray toArray:(NSMutableArray * _Nullable)toArray atIndexPath:(NSIndexPath*)indexPath{
    
    self.selectedMultiCityArrayIndex = indexPath;
    MulticityFlightLeg * currentSelected = [self.formDataModel.multiCityArray objectAtIndex:indexPath.row];
    currentSelected.origin = [fromArray firstObject];
    currentSelected.destination = [toArray firstObject];
    
    [self.formDataModel.multiCityArray replaceObjectAtIndex:indexPath.row withObject:currentSelected];
    
    [self reloadMultiCityTableViewAtIndex:indexPath];
    
    NSUInteger nextIndex = self.selectedMultiCityArrayIndex.row + 1;
    if(nextIndex < self.formDataModel.multiCityArray.count) {
        
        MulticityFlightLeg * nextRow = [self.formDataModel.multiCityArray objectAtIndex:nextIndex];
        if ( nextRow.origin == nil) {
            nextRow.origin = [toArray firstObject];
            
            NSIndexPath * nextIndexPath = [NSIndexPath indexPathForRow:nextIndex inSection:indexPath.section];
            
            [self.formDataModel.multiCityArray replaceObjectAtIndex:nextIndexPath.row  withObject:nextRow];
            [self reloadMultiCityTableViewAtIndex:nextIndexPath];
            
        }
    }
    
    NSUInteger previousIndex = self.selectedMultiCityArrayIndex.row - 1 ;
    
    if(previousIndex != -1){
        
        MulticityFlightLeg * previousRow = [self.formDataModel.multiCityArray objectAtIndex:previousIndex];
        if ( previousRow.destination == nil){
            previousRow.destination = [fromArray firstObject];
            NSIndexPath * previousIndexPath = [NSIndexPath indexPathForRow:previousIndex inSection:indexPath.section];
            
            [self.formDataModel.multiCityArray replaceObjectAtIndex:previousIndexPath.row  withObject:previousRow];
            [self reloadMultiCityTableViewAtIndex:previousIndexPath];
        }
    }
}

- (void)reloadMultiCityTableViewAtIndex:(NSIndexPath*)indexPath {
    
    NSArray * indices = [NSArray arrayWithObject:indexPath];
    [self.multiCityTableView reloadRowsAtIndexPaths:indices withRowAnimation:UITableViewRowAnimationNone];
    
}


-(MulticityCalendarVM*)prepareVMForMulticityCalendar:(NSUInteger)currentIndex
{
    MulticityCalendarVM * newMulticityCalendarVM = [[MulticityCalendarVM alloc]init];
    newMulticityCalendarVM.currentIndex = currentIndex;
    newMulticityCalendarVM.delegate = self;
    
    NSMutableDictionary * travelDatesDictionary = [[NSMutableDictionary alloc]init];
    
    for (int i = 0 ; i < self.formDataModel.multiCityArray.count ; i++) {
        
        MulticityFlightLeg * currentFligtLeg = [self.formDataModel.multiCityArray objectAtIndex:i];
        NSString * key = [NSString stringWithFormat:@"%d",i];
        NSString * date = [self formateDateForAPI:currentFligtLeg.travelDate];
        
        [travelDatesDictionary setObject:date forKey:key];
    }
    newMulticityCalendarVM.travelDatesDictionary = travelDatesDictionary;
    
    return newMulticityCalendarVM;
    
}

//MARK:- NEWORK CALL

- (NSMutableDictionary *)buildDictionaryForFlightSearch {
    
    NSMutableDictionary *parametersDynamic = [[NSMutableDictionary alloc] init];
    
    [parametersDynamic setObject:[NSString stringWithFormat:@"%ld",(long)self.travellerCount.flightAdultCount] forKey:@"adt"];
    [parametersDynamic setObject:[NSString stringWithFormat:@"%ld",(long)self.travellerCount.flightChildrenCount] forKey:@"chd"];
    [parametersDynamic setObject:[NSString stringWithFormat:@"%ld",(long)self.travellerCount.flightInfantCount] forKey:@"inf"];
    NSString *tripType = @"single";
    if (self.isMultiCity) {
        tripType = @"multi";
    }else {
        if (self.isReturn) {
            tripType = @"return";
            NSString *returnString = @"";
            if (self.formDataModel.returnDate != nil) {
                NSDateFormatter *inputDateFormatter = [[NSDateFormatter alloc] init];
                [inputDateFormatter setDateFormat:@"yyyy-MM-dd"];
                returnString = [inputDateFormatter stringFromDate:self.formDataModel.returnDate];
            }
            [parametersDynamic setObject:returnString forKey:@"to_date"];
        }
    }
    [parametersDynamic setObject:tripType forKey:@"trip_type"];
    [parametersDynamic setObject:[self.formDataModel.flightClass.name capitalizedString] forKey:@"cabinclass"];
    [parametersDynamic setObject:[self parseString:self.preferredFlightValueTextField.text] forKey:@"preferred"];
    [parametersDynamic setObject:[self parseString:self.specialRequestValueTextField.text] forKey:@"special_request"];
    [parametersDynamic setObject:[NSString stringWithFormat:@"%lu",(unsigned long)self.datesSelection] forKey:@"dates_fixed"];
    [parametersDynamic setObject:@"0" forKey:@"direct_flight_only"];
    [parametersDynamic setObject:@"flight" forKey:@"pType"];


    NSString *depart = @"";
    if (self.formDataModel.onwardsDate != nil) {
        NSDateFormatter *inputDateFormatter = [[NSDateFormatter alloc] init];
        [inputDateFormatter setDateFormat:@"yyyy-MM-dd"];
        depart = [inputDateFormatter stringFromDate:self.formDataModel.onwardsDate];
    }
    
    [parametersDynamic setObject:depart forKey:@"from_date"];
    
    
    
    [parametersDynamic setObject:[self generateCSVFromSelectionArray:self.formDataModel.fromFlightArray forDisplay:NO] forKey:@"source"];
    [parametersDynamic setObject:[self generateCSVFromSelectionArray:self.formDataModel.toFlightArray forDisplay:NO]  forKey:@"destination"];
    
    
    
    
    
    return parametersDynamic;
}

- (void) performFlightSearch:(NSDictionary*)flightSearchParameters
{
    [self showFlightLoaderIndicator];
    [[Network sharedNetwork] callApi:BULK_BOOKING_INQUIRY_API parameters:flightSearchParameters loadFromCache:NO expires:YES success:^(NSDictionary *dataDictionary) {
        [self handleDictionary:dataDictionary];
        
    } failure:^(NSString *error, BOOL popup) {
        [AertripToastView toastInView:self.view withText:error];
        [self hideFlightLoaderIndicator];
    }];
}
    

- (void)handleDictionary:(NSDictionary *)dataDictionary {
//    HomeBulkHotelSubmitViewController *controller = (HomeBulkHotelSubmitViewController *)[self getControllerForModule:HOME_BULK_HOTEL_SUBMIT_CONTROLLER];
//    controller.delegate = self;
//    [self presentViewController:controller animated:NO completion:nil];
    [self removeActivityIndicator];
}
- (void)submitBulkRoomsDoneAction {
    [self animateBackingImageOut];
    [self animateBottomViewOut];
}
//MARK:- USER INTERACTIONS


- (IBAction)fromAction:(id)sender {
    AirportSelectionViewController *controller = (AirportSelectionViewController *)[self getControllerForModule:AIRPORT_SELECTION_CONTROLLER];
    
    AirportSelectionVM * fromToSelectionVM = [[AirportSelectionVM alloc]
                                                          initWithIsFrom:YES
                                                          delegateHandler:self
                                                          fromArray:self.formDataModel.fromFlightArray
                                                          toArray:self.formDataModel.toFlightArray
                                                          airportSelectionMode:AirportSelectionModeBulkBookingJourney];
    
    controller.viewModel = fromToSelectionVM;
    if (@available(iOS 13.0, *)) {
        [self presentViewController:controller animated:YES completion:nil];
    }
    else {
        [self presentViewController:controller animated:NO completion:nil];
    }
    
}
- (IBAction)toAction:(id)sender {
    AirportSelectionViewController *controller = (AirportSelectionViewController *)[self getControllerForModule:AIRPORT_SELECTION_CONTROLLER];
    
    AirportSelectionVM * fromToSelectionVM = [[AirportSelectionVM alloc]
                                                          initWithIsFrom:NO
                                                          delegateHandler:self
                                                          fromArray:self.formDataModel.fromFlightArray
                                                          toArray:self.formDataModel.toFlightArray
                                                          airportSelectionMode:AirportSelectionModeBulkBookingJourney];

    controller.viewModel = fromToSelectionVM;
    if (@available(iOS 13.0, *)) {
        [self presentViewController:controller animated:YES completion:nil];
    }
    else {
        [self presentViewController:controller animated:NO completion:nil];
    }

}

- (void)flightFromArray:(NSMutableArray *)fromArray toArray:(NSMutableArray *)toArray {
    if (self.isMultiCity) {
        NSMutableDictionary *dictionary = [self.formDataModel.multiCityArray objectAtIndex:self.selectedMultiCityArrayIndex.row];
        [dictionary setObject:fromArray forKey:@"fromArray"];
        [dictionary setObject:toArray forKey:@"toArray"];
        [self reloadMultiCityTableView];
    }else {
        self.formDataModel.fromFlightArray = fromArray;
        self.formDataModel.toFlightArray = toArray;
        [self setupFromAndToView];
    }
}

-(CalendarVM*)prepareForDateSelction:(BOOL)isStartDate
{
    CalendarVM * calendarVM = [[CalendarVM alloc] init];
    calendarVM.isStartDateSelection = isStartDate;
        calendarVM.date1 = self.formDataModel.onwardsDate;
        if (self.isReturn) {
            calendarVM.date2 = self.formDataModel.returnDate;
        }
        calendarVM.isHotelCalendar = NO;
        calendarVM.isReturn = self.isReturn;
        calendarVM.delegate = self;

    return  calendarVM ;
}
- (IBAction)onwardsAction:(id)sender {
    NSBundle * calendarBundle = [NSBundle bundleForClass:AertripCalendarViewController.class];
    UIStoryboard *storyboard = [UIStoryboard   storyboardWithName:@"AertripCalendar" bundle:calendarBundle];
    AertripCalendarViewController * controller = [storyboard instantiateViewControllerWithIdentifier:@"AertripCalendarViewController"];
    controller.viewModel = [self prepareForDateSelction:YES];
    
    if (@available(iOS 13.0, *)) {
        [self presentViewController:controller animated:YES completion:nil];
    }
    else {
        [self presentViewController:controller animated:NO completion:nil];
    }
}
- (IBAction)returnAction:(id)sender {
    
    if (self.flightSegmentedControl.selectedSegmentIndex == 1 ) {
        NSBundle * calendarBundle = [NSBundle bundleForClass:AertripCalendarViewController.class];
        UIStoryboard *storyboard = [UIStoryboard   storyboardWithName:@"AertripCalendar" bundle:calendarBundle];
        AertripCalendarViewController * controller = [storyboard instantiateViewControllerWithIdentifier:@"AertripCalendarViewController"];
        controller.viewModel = [self prepareForDateSelction:NO];
        
        if (@available(iOS 13.0, *)) {
            [self presentViewController:controller animated:YES completion:nil];
        }
        else {
            [self presentViewController:controller animated:NO completion:nil];
        }
    }
    else
    {
        self.flightSegmentedControl.selectedSegmentIndex = 1 ;
        [self segmentChanged:nil];
    }
}
- (IBAction)passengersAction:(id)sender {
    
    FlightAddPassengerViewController *controller = (FlightAddPassengerViewController *)[self getControllerForModule:FLIGHT_ADD_PASSENGER_CONTROLLER];
    controller.travellerCount = self.travellerCount;
    controller.delegate = self;
    controller.isForBulking = YES;
    [self presentViewController:controller animated:NO completion:nil];
    
    
}

- (void)addFlightPassengerAction:(TravellerCount*)travellerCount {
    self.travellerCount = travellerCount;
    [self setupPassenger];
}

- (IBAction)classAction:(id)sender {
    
    HomeFlightAddClassViewController *controller = (HomeFlightAddClassViewController *)[self getControllerForModule:HOME_FLIGHT_ADD_CLASS_CONTROLLER];
    controller.flightClassSelectiondelegate = self;
    controller.flightClass = self.formDataModel.flightClass;
    [self presentViewController:controller animated:NO completion:nil];
    
}

- (void)addFlightClassAction:(FlightClass *)flightClass {
    self.formDataModel.flightClass = flightClass;
    [self setupFlightClassType];
}

- (IBAction)cancelAction:(id)sender {

    [self.BulkBookingFormDelegate updateWithViewModel:self.formDataModel];
    if(![sender  isEqual: @"AirportSwap"]){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

//MARK:- PICKER VIEW
- (void)setupMyDatesPickerView {
    
    [UIView transitionWithView:self.myDatesSelectionLabel
                    duration:0.25f
                     options:UIViewAnimationOptionTransitionCrossDissolve
                  animations:^{
    self.myDatesSelectionLabel.text = [self.myDatesArray objectAtIndex:self.datesSelection];
    
    } completion:nil];
        
}


-(IBAction)TapOnDateSelection:(id)sender
{
    
    if ( self.datesSelection == 0) {
        self.datesSelection = 1;
    }
    else {
        self.datesSelection = 0;
    }
    
    
    [UIView transitionWithView:self.myDatesSelectionLabel
                    duration:0.25f
                     options:UIViewAnimationOptionTransitionCrossDissolve
                  animations:^{

      self.myDatesSelectionLabel.text = [self.myDatesArray objectAtIndex:self.datesSelection];

    } completion:nil];
    
}


//MARK:- ANIMATIONS
- (void)configureInitialBottomViewPosition {
    self.topConstraintMainView.constant = (self.view.bounds.size.height);
}
- (void)configureBackingImageInPosition:(BOOL)presenting {
    
    double edgeInset = presenting ? 15.0: 0.0;
    double cornerRadius = presenting ? 10.0 : 0.0;
    self.backingImageLeadingInset.constant = edgeInset;
    self.backingImageTrailingInset.constant = edgeInset;
    double aspectRatio = self.backingImageView.frame.size.height / self.backingImageView.frame.size.width;
    self.backingImageTopInset.constant = edgeInset * aspectRatio;
    self.backingImageBottomInset.constant = edgeInset * aspectRatio;
    self.backingImageView.layer.cornerRadius = cornerRadius;
    
}

- (void)animateBackingImage:(BOOL)presenting {
    [UIView animateWithDuration:self.primaryDuration animations:^{
        [self configureBackingImageInPosition:presenting];
        [self.view layoutIfNeeded];
    }];
}
- (void)animateBackingImageIn {
    [self animateBackingImage:YES];
}

- (void)animateBackingImageOut {
    [self animateBackingImage:NO];
    
}

- (void)animateBottomViewIn {

}
- (void)animateBottomViewOut {

}
//MARK:- MULTICITY IMPLEMENTATION

- (void)setupMultiCityView {
    
    if(self.formDataModel.multiCityArray.count == 0) {
        
        [self setupNewMulticitySearch];
        return;
    }
    

    
    AirportSearch * firstOriginAirport = [self.formDataModel.fromFlightArray firstObject];
    AirportSearch * firstDestinationAirport = [self.formDataModel.toFlightArray firstObject];
    
    MulticityFlightLeg *firstLeg = [self.formDataModel.multiCityArray firstObject];
    
    BOOL airportSearchUpdated = NO;
    
    
    if([firstOriginAirport.iata compare:firstLeg.origin.iata] != NSOrderedSame) {
        airportSearchUpdated = YES;
    }
    if([firstDestinationAirport.iata compare:firstLeg.destination.iata] != NSOrderedSame) {
        airportSearchUpdated = YES;
    }
    
    if (airportSearchUpdated) {
        [self.formDataModel.multiCityArray removeAllObjects];
        [self setupNewMulticitySearch];
    }
    
}

-(void)removeLastLegFromJourney{
    
    [self.formDataModel.multiCityArray removeLastObject];
    
    
    NSInteger count = self.formDataModel.multiCityArray.count ;
    if( count > 2 ) {
        [self disableRemoveMulticityButton:NO];
    }
    else {
        [self disableRemoveMulticityButton:YES];
    }
    if ( count < 5){
        [self disableAddMulticityButton:NO];
    }
}

- (void)setupNewMulticitySearch {
    
    // Add two Arrays
    [self addFlightLegForMulticityJounrney];
    [self addFlightLegForMulticityJounrney];
    [self disableRemoveMulticityButton:YES];
    [self reloadMultiCityTableView];
}


-(void)disableRemoveMulticityButton:(BOOL)disable{
    
    if( disable) {
        
        self.multicityRemoveIcon.alpha = 0.20;
        self.multicityRemoveLabel.alpha = 0.20;
        self.multicityRemoveButton.enabled = NO;
    }
    else {
        self.multicityRemoveButton.enabled = YES;
        self.multicityRemoveIcon.alpha = 1.0;
        self.multicityRemoveLabel.alpha = 1.0;
    }
}


-(void)disableAddMulticityButton:(BOOL)disable{
    
    if( disable) {
        self.multicityAddButton.enabled = NO;
        self.multicityAddFlightIcon.alpha = 0.20;
        self.multicityAddFlightTitle.alpha = 0.20;
    }
    else {
        
        self.multicityAddButton.enabled = YES;
        self.multicityAddFlightTitle.alpha = 1.0;
        self.multicityAddFlightIcon.alpha = 1.0;
    }
}

-(void)addFlightLegForMulticityJounrney{
    
    
    MulticityFlightLeg* nextRowInMulticity = [self getNextRowForMulticity];
    [self.formDataModel.multiCityArray addObject:nextRowInMulticity];
    
    
    if(self.formDataModel.multiCityArray.count > 2){
        [self disableRemoveMulticityButton:NO];
    }else {
        [self disableRemoveMulticityButton:YES];
    }
    
    if( self.formDataModel.multiCityArray.count == 5 ) {
        [self disableAddMulticityButton:YES];
        
    }
}

- (void)setupMultiCityTableView {
    self.multiCityTableView.delegate = self;
    self.multiCityTableView.dataSource = self;
}

- (IBAction)removeMultiCityAction:(id)sender {
    if (self.formDataModel.multiCityArray.count > 0) {
        [self removeLastLegFromJourney];
        [self setupFlightViewsHeights];
    }
}
- (IBAction)addMultiCityAction:(id)sender {
    [self addFlightLegForMulticityJounrney];
    [self setupFlightViewsHeights];
    
}


- (NSMutableDictionary *)getDefaultMulticity {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *fromArray = [[NSMutableArray alloc] init];
    NSMutableArray *toArray = [[NSMutableArray alloc] init];
    [dictionary setObject:fromArray forKey:@"fromArray"];
    [dictionary setObject:toArray forKey:@"toArray"];
    NSString *date = @"";
    [dictionary setObject:date forKey:@"date"];
    
    
    return dictionary;
}
- (void)reloadMultiCityTableView {
    [self.multiCityTableView reloadData];
 
}



-(void)MulticityDateSelectionWithDictionary:(NSDictionary*)dictionary reloadUI:(BOOL)reloadUI{
    
    
    for ( NSString * key in [dictionary allKeys] ) {
        
        NSString *dateString = [dictionary objectForKey:key];
        NSUInteger index = [key integerValue];
        
        MulticityFlightLeg * flightLeg = [self.formDataModel.multiCityArray objectAtIndex:index];
        
        NSDateFormatter *inputDateFormatter = [[NSDateFormatter alloc] init];
        [inputDateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        NSDate * updatedDate = [inputDateFormatter dateFromString:dateString];
        flightLeg.travelDate = updatedDate;
        
        [self.formDataModel.multiCityArray replaceObjectAtIndex:index withObject:flightLeg];
    }
    
    if ( reloadUI ) {
        [self reloadMultiCityTableView];
    }
    
    [self.BulkBookingFormDelegate updateWithViewModel:self.formDataModel];

}
//MARK:- TABLEVIEW DELEGATES
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.formDataModel.multiCityArray.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"TypeValueCell";
    MultiCityFlightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *customCell = [[NSBundle mainBundle] loadNibNamed:@"MultiCityFlightTableViewCell" owner:self options:nil];
        cell = [customCell objectAtIndex:0];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.indexPath = indexPath;
    MulticityFlightLeg *flightLegRow = [self.formDataModel.multiCityArray objectAtIndex:indexPath.row];
    cell.flightLegRow = flightLegRow;
    [cell setupFromAndToView];
    [cell setupDateView];
    return cell;
}

//MARK:- MULTICITY CELL HANDLER DELEGATE
- (void)openAirportSelectionControllerFor:(BOOL)isFrom indexPath:(NSIndexPath *)indexPath {
    self.selectedMultiCityArrayIndex = indexPath;
    
    AirportSelectionViewController *controller = (AirportSelectionViewController *)[self getControllerForModule:AIRPORT_SELECTION_CONTROLLER];
    
    controller.viewModel = [self prepareForMultiCityAirportSelection:isFrom indexPath:indexPath];
   
    if (@available(iOS 13.0, *)) {
        [self presentViewController:controller animated:YES completion:nil];
    }
    else {
        [self presentViewController:controller animated:NO completion:nil];
    }
    
}


-(AirportSelectionVM*)prepareForMultiCityAirportSelection:(BOOL)isFrom indexPath:(NSIndexPath*)indexPath
{
    self.selectedMultiCityArrayIndex = indexPath;
    MulticityFlightLeg * currentLeg = [self.formDataModel.multiCityArray objectAtIndex:indexPath.row];
    
    NSMutableArray *fromFlightArray = [NSMutableArray array];
    if ( currentLeg.origin){
        [fromFlightArray addObject:currentLeg.origin];
    }
    
    NSMutableArray* toFlightArray =  [NSMutableArray array];
    if ( currentLeg.destination){
        [toFlightArray addObject:currentLeg.destination];
    }
    
    AirportSelectionVM * fromToSelectionVM = [[AirportSelectionVM alloc]
                                              initWithIsFrom:isFrom
                                              delegateHandler:self
                                              fromArray:fromFlightArray
                                              toArray:toFlightArray
                                              airportSelectionMode:AirportSelectionModeMultiCityJourney
                                              ];
    
    return fromToSelectionVM;
}

- (void)openCalenderDateForMulticity:(NSIndexPath *)indexPath {

    NSBundle * calendarBundle = [NSBundle bundleForClass:AertripCalendarViewController.class];
    UIStoryboard *storyboard = [UIStoryboard   storyboardWithName:@"AertripCalendar" bundle:calendarBundle];
    AertripCalendarViewController * controller = [storyboard instantiateViewControllerWithIdentifier:@"AertripCalendarViewController"];
    controller.multicityViewModel = [self prepareVMForMulticityCalendar:indexPath.row];
    
    if (@available(iOS 13.0, *)) {
        [self presentViewController:controller animated:YES completion:nil];
    }
    else {
        [self presentViewController:controller animated:NO completion:nil];
    }
    
}

//MARK:- COMMON METHODS

- (void)changeLabelFont:(UILabel *)label isSmall:(BOOL)isSmall {
    if (isSmall) {
        [label setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:16.0]];
    }else {
        [label setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:20.0]];
        
    }
    
    
}
- (NSString *)formateDateForAPI:(NSDate *) date {
    if (date == nil) {
        return @"";
    }
    NSDateFormatter *inputDateFormatter = [[NSDateFormatter alloc] init];
    [inputDateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [inputDateFormatter stringFromDate:date];
    return dateString;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//MARK: - Multicity Implemenatation

- (MulticityFlightLeg *)getNextRowForMulticity
{
    
    MulticityFlightLeg * newRow = [[MulticityFlightLeg alloc]init];
    
    NSUInteger count = self.formDataModel.multiCityArray.count;
    
    if (count == 0 && self.formDataModel.fromFlightArray.count > 0){
        
        AirportSearch * firstObject = [self.formDataModel.fromFlightArray firstObject];
        newRow.origin = firstObject;
    }
    else {
        
        MulticityFlightLeg * lastObject = [self.formDataModel.multiCityArray lastObject];
        newRow.origin = lastObject.destination;
    }
    
    if(count == 0 ) {
        AirportSearch * destination = [self.formDataModel.toFlightArray firstObject];
        newRow.destination = destination;
    }
    
    if( count == 0 ){
        newRow.travelDate = self.formDataModel.onwardsDate;
    }
    
    return newRow;
    
}


-(void)setupLocationService
{
    //     Requesting Permission to Use Location Services.
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
}



-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    [self defaultCityForForm];
    NSLog(@"Error: %@",error.description);
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currentLocation = [locations lastObject];
    [self.locationManager stopUpdatingLocation];
    [self performNearbyAirportsByLocation:currentLocation];
}


-(void)performNearbyAirportsByLocation:(CLLocation*)location
{
    [self.locationManager stopUpdatingLocation];
    
    NSString* latitudeLongituteString = [NSString stringWithFormat:@"?latitude=%.8f&longitude=%.8f",location.coordinate.latitude,location.coordinate.longitude];
    
    NSString * url = [NEARBY_AIRPORT_SEARCH_API stringByAppendingString:latitudeLongituteString];
    
    [[Network sharedNetwork] callGETApi:url parameters:nil loadFromCache:NO expires:YES success:^(NSDictionary *dataDictionary) {
        [self handleNearbyAirportByLocationResult:dataDictionary];
    } failure:^(NSString *error, BOOL popup) {
    }];
    
}

-(void)handleNearbyAirportByLocationResult:(NSDictionary*)responseDictionary
{
    NSArray * airports = [responseDictionary allValues];
    NSArray * Airports = [Parser parseAirportSearchArray:airports];
    
    NSArray * nearbyAirports = [Airports sortedArrayUsingComparator:^NSComparisonResult(AirportSearch *airportOne, AirportSearch *airportTwo){
        
        if (airportOne.distance < airportTwo.distance) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        
        if (airportOne.distance > airportTwo.distance) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        return NSOrderedSame;
    }];
    
    AirportSearch * nearestAirport = [nearbyAirports firstObject];
    
    if ( [self.formDataModel.fromFlightArray count] == 0) {
        [self.formDataModel.fromFlightArray removeAllObjects];
        [self.formDataModel.fromFlightArray addObject:nearestAirport];
    }
    [self setupFromAndToView];
    
}


-(void)defaultCityForForm
{
    
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"popularAirports" ofType:@"json"];
    
    NSError *error= NULL;
    NSData* data = [NSData dataWithContentsOfFile:filepath];
    NSArray * arrayFromFile = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    if (error == NULL)
    {
        NSArray * array = [Parser parseAirportSearchArray:arrayFromFile];
        AirportSearch * nearestAirport = [array firstObject];
        [self.formDataModel.fromFlightArray removeAllObjects];
        [self.formDataModel.fromFlightArray addObject:nearestAirport];
        [self setupFromAndToView];
    }
}


-(void)swapMultiCityAirportsFor:(NSIndexPath*)indexPath{
    
    NSMutableArray * fromArray = [NSMutableArray array];
    NSMutableArray *toArray = [NSMutableArray array];
    
    MulticityFlightLeg * currentLeg = [self.formDataModel.multiCityArray objectAtIndex:indexPath.row];
    
    AirportSearch * origin = currentLeg.destination;
    if ( origin != nil ){
        [fromArray addObject:origin];
    }
    
    AirportSearch * destination = currentLeg.origin;
    if ( destination != nil) {
        [toArray addObject:destination];
    }
    
    [self setMulticityAirports:fromArray toArray:toArray atIndexPath:indexPath];
    
}


-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    [self.view endEditing:YES];
}

//MARK:- Textfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
     CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
     CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
     CGFloat numerator =  midline - viewRect.origin.y  - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
     CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)
     * viewRect.size.height;
     CGFloat heightFraction = numerator / denominator;
     if (heightFraction < 0.0)
     {
         heightFraction = 0.0;
     }
     else if (heightFraction > 1.0)
     {
         heightFraction = 1.0;
     }
     UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
     orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
         animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
    return YES;

}

- (BOOL) textFieldShouldEndEditing:(UITextField*)textField
{
     CGRect viewFrame = self.view.frame;
     viewFrame.origin.y += animatedDistance;
     [UIView beginAnimations:nil context:NULL];
     [UIView setAnimationBeginsFromCurrentState:YES];
     [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
     [self.view setFrame:viewFrame];
     [UIView commitAnimations];
    
    return YES;

}

@end
