//
//  HomeViewController.m
//  Aertrip
//
//  Created by Kakshil Shah on 23/04/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//
#import "FlightFormViewControllerHeader.h"
#import "AERTRIP-Swift.h"
@class SwiftObjCBridgingController;
@interface FlightFormViewController ()< AddFlightPassengerHandler, AddFlightClassHandler, MultiCityFlightCellHandler , FlightViewModelDelegate , BulkBookingFormHandler, UIScrollViewDelegate , UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *buttonActivityIndicator;

//MARK:- FLIGHTS

@property (weak, nonatomic) IBOutlet HMSegmentedControl *flightSegmentedControl;

@property (weak, nonatomic) IBOutlet UIView *multiCityView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *multiCityViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UITableView *multiCityTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *multiCityTableViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *flightFormHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fromToViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *FromToView;
@property (weak, nonatomic) IBOutlet UILabel *fromTopLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromSubTitleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fromValueHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *FromLabelTopConstraint;


@property (weak, nonatomic) IBOutlet UILabel *toLabel;
@property (weak, nonatomic) IBOutlet UILabel *toTopLabel;
@property (weak, nonatomic) IBOutlet UILabel *toValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *toSubTitleLabel;
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

@property (weak, nonatomic) IBOutlet UIView *flightSearchOuterView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *flightSearchActivityIndicator;
@property (weak, nonatomic) IBOutlet ATButton *flightSearchButton;

@property (weak, nonatomic) IBOutlet UILabel *bulkFlightTravellingLabel;

@property (weak, nonatomic) IBOutlet UIImageView *multiCityRemoveIcon;
@property (weak, nonatomic) IBOutlet UILabel *multicityRemoveTitle;
@property (weak, nonatomic) IBOutlet UIButton *multicityRemoveButton;


@property (weak, nonatomic) IBOutlet UIImageView *multicityAddIcon;
@property (weak, nonatomic) IBOutlet UILabel *multicityAddTitle;
@property (weak, nonatomic) IBOutlet UIButton *multicityAddButton;



@property (weak, nonatomic) IBOutlet UILabel *recentSearchTitleLabel;

@property (weak, nonatomic) IBOutlet UICollectionView *recentSearchCollectionView;

@property (strong , nonatomic) SwiftObjCBridgingController* bridgingObj;

@end

@implementation FlightFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupInitials];
    [self setAerinSearchClosure];
    [self setSharedUrlClosure];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.ScrollView setContentOffset:CGPointZero animated:FALSE];
}

-(void)setupMainView
{
    self.mainView.layer.shadowOffset = CGSizeMake(0.0,16.0);
    self.mainView.layer.shadowRadius = 16.0;
    self.mainView.layer.shadowOpacity = 0.16;
    self.mainView.layer.shadowColor = [UIColor blackColor].CGColor;
    
}
- (void)setupCollectionView {
    self.recentSearchCollectionView.delegate = self.viewModel;
    self.recentSearchCollectionView.dataSource = self.viewModel;
    self.recentSearchCollectionView.backgroundView = nil;
    self.recentSearchCollectionView.backgroundColor = [UIColor clearColor];
    self.recentSearchCollectionView.contentInset = UIEdgeInsetsMake(0.0, 16.0, 0.0, 16.0);
    SnappingCollectionViewLayout * collectionViewLayout = [[ SnappingCollectionViewLayout alloc] init];
    collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.recentSearchCollectionView.collectionViewLayout = collectionViewLayout;
}

- (void)setupInitials {
    self.viewModel = [[FlightFormDataModel alloc] init];
    self.viewModel.delegate = self;
    [self setupMainView];
    [self setupCollectionView];
    [self setupFlightSection];
    [self updateScrollviewContentHeight];
}

- (void)hideLoaderIndicator {
    
    [self.buttonActivityIndicator stopAnimating];
    [self.buttonActivityIndicator setHidden:YES];
    [self.searchButton setTitle:@"Search" forState:UIControlStateNormal];
    self.view.userInteractionEnabled = YES;
    
}
- (void)showLoaderIndicator {
    self.view.userInteractionEnabled = NO;
    [self.buttonActivityIndicator startAnimating];
    [self.buttonActivityIndicator setHidden:NO];
    [self.searchButton setTitle:@"" forState:UIControlStateNormal];
}


- (void)datesSelectedIsReturn:(BOOL)isReturn
{
    if (isReturn) {
        self.flightSegmentedControl.selectedSegmentIndex = 1;
    }else {
        self.flightSegmentedControl.selectedSegmentIndex = 0;
    }
    [self setupDatesInOnwardsReturnView];
    
}


//MARK:- FLIGHTS IMPLEMENTATION

- (void)setupFlightSection {
    [self setupFromAndToView];
    [self setupDatesInOnwardsReturnView];
    [self setupPassengerCountView];
    [self setupFlightClassType];
    [self setupSegmentControl];
    [self setupAttributedTextForFlight];
    [self setupFlightViews];
    [self setupFlightSearchButton];
    [self setupMultiCityTableView];
    
    
    
}
- (void)setupSegmentControl {
    if (self.viewModel.segmentTitleSectionArray.count == 0) self.viewModel.segmentTitleSectionArray = [@[@"Oneway"] mutableCopy];
    
    [self.flightSegmentedControl setSectionTitles:self.viewModel.segmentTitleSectionArray];
    self.flightSegmentedControl.backgroundColor = [UIColor clearColor];
    self.flightSegmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.flightSegmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
    
    // self.flightSegmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 20.0, 0, 20.0);
    // self.flightSegmentedControl.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(0, 20.0, 0, 40.0);
    
    self.flightSegmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    // self.topSegmentControl.frame = CGRectMake(0, 64, self.view.frame.size.width, 46);
    self.flightSegmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    self.flightSegmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.flightSegmentedControl.selectionIndicatorHeight = 2;
    self.flightSegmentedControl.verticalDividerEnabled = NO;
    self.flightSegmentedControl.selectionIndicatorColor = [self getAppColor];
    
    self.flightSegmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [ UIColor ONE_FIVE_THREE_COLOR] , NSFontAttributeName:[UIFont fontWithName:@"SourceSansPro-Regular" size:14]};
    
    self.flightSegmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor FIVE_ONE_COLOR], NSFontAttributeName:[UIFont fontWithName:@"SourceSansPro-Semibold" size:14]};
    
    self.flightSegmentedControl.borderType = HMSegmentedControlBorderTypeNone;
    self.flightSegmentedControl.selectedSegmentIndex = 0;
    //  [self setupSwipe];
}

-(void)setAerinSearchClosure {
    self.bridgingObj = [SwiftObjCBridgingController shared];
    __weak typeof(self) weakSelf = self;
    [self.bridgingObj setOnFetchingFlightFormData:^(NSMutableDictionary<NSString *,id> * dict) {
        [weakSelf.viewModel performFlightSearchWith:dict];
    }];
}

-(void)setSharedUrlClosure {
    self.bridgingObj = [SwiftObjCBridgingController shared];
    __weak typeof(self) weakSelf = self;

    [self.bridgingObj setOnFetchingFlightFormDataForSharedUrl:^(NSMutableDictionary<NSString *  ,id>*  dict){
        [weakSelf.viewModel performFlightSearchWith:dict];
    }];
}


- (IBAction)segmentChanged:(id)sender{
    [self adjustAsPerTopBar];
}
- (void) adjustAsPerTopBar {
    
    self.viewModel.flightSearchType = (FlightSearchType)self.flightSegmentedControl.selectedSegmentIndex;
    [self setupFlightViews];
}

- (void)setupFlightViews {
    
    //    self.flightSegmentedControl.selectedSegmentIndex = self.viewModel.flightSearchType;
    
    [self.flightSegmentedControl setSelectedSegmentIndex:self.viewModel.flightSearchType animated:YES];
    
    if (self.viewModel.flightSearchType == MULTI_CITY ) {
        self.fromToViewHeightConstraint.constant = 0.0;
        self.onwardReturnViewHeightConstraint.constant = 0.0;
        [self.viewModel setupMultiCityView];
        self.multiCityViewHeightConstraint.constant = 2000.0;
        [self reloadMultiCityTableView];
        
    }else {
        self.fromToViewHeightConstraint.constant = 104.0;
        self.onwardReturnViewHeightConstraint.constant = 104.0;
        self.multiCityViewHeightConstraint.constant = 0.0;
        self.flightFormHeight.constant = 465.0;
        
        if (self.viewModel.flightSearchType == SINGLE_JOURNEY) {
            self.viewModel.returnDate  =  nil;
        }
        [self setupDatesInOnwardsReturnView];
        
    }
    [self updateScrollviewContentHeight];
}


-(void) setupFromLabel:(NSArray*)fromFlightArray
{
    if (fromFlightArray.count  > 0) {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.fromTopLabel.alpha = 1.0;
            self.fromLabel.alpha = 0.0;
        }];
        
        self.fromValueLabel.hidden = NO;
        self.fromValueLabel.text = [self.viewModel flightFromText];
        
        
        AirportSearch *airportSearch = fromFlightArray[0];
        
        NSInteger count = fromFlightArray.count;
        switch (count) {
            case 1:
                self.fromSubTitleLabel.hidden = NO;
                [self.fromValueLabel setFont:[UIFont fontWithName:@"SourceSansPro-Semibold" size:26.0]];
                self.fromSubTitleLabel.text = airportSearch.city;
                self.fromValueHeight.constant = 25.0;
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
            
            self.fromTopLabel.alpha = 0.0;
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
            self.toTopLabel.alpha = 1.0;
        }];
        
        
        self.toValueLabel.text = self.viewModel.flightToText;
        
        AirportSearch *airportSearch = toFlightArray[0];
        
        NSInteger count = toFlightArray.count;
        switch (count) {
            case 1:
                self.toValueHeight.constant = 25.0;
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
            self.toTopLabel.alpha = 0.0;
            
        }];
        
        self.toSubTitleLabel.hidden = YES;
        self.toValueLabel.hidden = YES;
    }
}

- (void)setupFromAndToView {
    
    [self setupFromLabel:self.viewModel.fromFlightArray];
    [self setupToLabel: self.viewModel.toFlightArray];
    
    if ( self.viewModel.fromFlightArray.count == 0 && self.viewModel.toFlightArray.count == 0) {
        self.switcherButton.enabled = NO;
    }else {
        self.switcherButton.enabled = YES;
    }
    
}
- (NSString *)generateCSVFromSelectionArray:(NSArray *)array {
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    for (AirportSearch *airportSearch in array) {
        [resultArray addObject:airportSearch.iata];
    }
    return [self generateCSVFromArray:resultArray];
}


//MARK:- Setup Onwards and return Dates
- (void)setupDatesInOnwardsReturnView {
    [self setupOnwardsDateView: self.viewModel.onwardsDate];
    [self setupReturnDateView:self.viewModel.returnDate];
}

- (void) setupOnwardsDateView:(NSDate*)onwardsDate{
    
    if (onwardsDate != nil) {
        [self changeLabelFont:self.onwardsLabel isSmall:YES];
        
        self.onwardsValueLabel.hidden = NO;
        self.onwardsSubTitleLabel.hidden = NO;
        
        self.onwardsValueLabel.text = [self.viewModel dateFormatedFromDate:onwardsDate];
        self.onwardsSubTitleLabel.text = [self.viewModel dayOfDate:onwardsDate];
        
        
    }else {
        [self changeLabelFont:self.onwardsLabel isSmall:NO];
        self.onwardsValueLabel.hidden = YES;
        self.onwardsSubTitleLabel.hidden = YES;
    }
}

- (void)setupReturnDateView:(NSDate*)returnDate {
    if (self.viewModel.flightSearchType == RETURN_JOURNEY ) {
        [self.returnLabel setTextColor:[ UIColor ONE_FIVE_THREE_COLOR] ];
        
        if (returnDate != nil) {
            [self changeLabelFont:self.returnLabel isSmall:YES];
            self.returnValueLabel.hidden = NO;
            self.returnSubTitleLabel.hidden = NO;
            
            self.returnValueLabel.text = [self.viewModel dateFormatedFromDate:returnDate];
            self.returnSubTitleLabel.text = [self.viewModel dayOfDate:returnDate];
            
        }else {
            [self changeLabelFont:self.returnLabel isSmall:NO];
            self.returnValueLabel.hidden = YES;
            self.returnSubTitleLabel.hidden = YES;
        }
    }else {
        [self changeLabelFont:self.returnLabel isSmall:NO];
        [self.returnLabel setTextColor:[UIColor TWO_THREE_ZERO_COLOR]];
        self.returnValueLabel.hidden = YES;
        self.returnSubTitleLabel.hidden = YES;
    }
}


//MARK: Passenger Setup

- (void)setupPassengerCountView
{
    long flightAdultCount = self.viewModel.adultCount;
    [self setupAdultPassengerCount:flightAdultCount];
    long flightChildrenCount = self.viewModel.childrenCount;
    [self setupChilderPassengerCount:flightChildrenCount];
    
    long flightInfantCount = self.viewModel.infantCount ;
    [self setupInfantPassengerCount:flightInfantCount];
}

- (void)setupAdultPassengerCount:(long)flightAdultCount
{
    if (flightAdultCount  > 0) {
        self.passengerAdultCountView.hidden = NO;
        self.passengerAdultCountLabel.text = [NSString stringWithFormat:@"%ld",(long)flightAdultCount];
    }else {
        self.passengerAdultCountView.hidden = YES;
    }
}

- (void)setupChilderPassengerCount:(long)flightChildrenCount {
    
    if (flightChildrenCount > 0) {
        self.passengerChildrenCountView.hidden = NO;
        self.passengerChildrenCountLabel.text = [NSString stringWithFormat:@"%ld",(long)flightChildrenCount];
    }else {
        self.passengerChildrenCountView.hidden = YES;
    }
}

- (void)setupInfantPassengerCount:(long)flightInfantCount {
    
    if (flightInfantCount > 0) {
        self.passengerInfantCountView.hidden = NO;
        self.passengerInfantCountLabel.text = [NSString stringWithFormat:@"%ld",(long)flightInfantCount];
    }else {
        self.passengerInfantCountView.hidden = YES;
    }
}

- (void)setupFlightClassType{
    
    UIImage * flightClassImage = [self.viewModel flightClassImage];
    [self.flightClassTypeImageView setImage:flightClassImage];
    self.flightClassTypeLabel.text = self.viewModel.flightClassName;
}

- (void)setupFlightSearchButton {
    
    [self hideLoaderIndicatorForFilghtSearch];
    [self setCustomButtonView:self.flightSearchButton withOuterView:self.flightSearchOuterView];
    [self.flightSearchButton addTarget:self action:@selector(flightSearchButtonPressed) forControlEvents:UIControlEventTouchDown];
    [self.flightSearchButton addTarget:self action:@selector(flightSearchButtonReleased) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    [self.flightSearchButton configureCommonGreenButton];
}

- (void)setCustomButtonView:(UIButton *)button withOuterView:(UIView *)outerView {
    outerView.layer.shadowOpacity = BUTTON_RELEASED_SHADOW_OPACITY;
    [self setRoundedCornerWithShadowToButton:button outerView:outerView shadowColor:[[UIColor themeBlack] colorWithAlphaComponent:0.2]];
    //    [self applyGradientLayerToButton:button startColor:[UIColor BLUE_GREEN_COLOR] endColor:[UIColor GREEN_BLUE_COLOR]];
}


- (void)flightSearchButtonPressed
{
    
    // Gurpreet
    //    self.flightSearchButton.transform = CGAffineTransformMakeScale(0.9, 0.9);
    
    //    [self customButtonViewPressed:self.flightSearchOuterView];
    
}

- (void)flightSearchButtonReleased {
    
    // Gurpreet
    //    self.flightSearchButton.transform = CGAffineTransformMakeScale(1.0, 1.0);
    
    //[self customButtonViewReleased:self.flightSearchOuterView];
    
}

- (void)hideLoaderIndicatorForFilghtSearch {
    
    [self.flightSearchActivityIndicator stopAnimating];
    [self.flightSearchActivityIndicator setHidden:YES];
    [self.flightSearchButton setTitle:@"Search" forState:UIControlStateNormal];
    self.view.userInteractionEnabled = YES;
    
}
- (void)showLoaderIndicatorForFilghtSearch {
    self.view.userInteractionEnabled = NO;
    [self.flightSearchActivityIndicator startAnimating];
    [self.flightSearchActivityIndicator setHidden:NO];
    [self.flightSearchButton setTitle:@"" forState:UIControlStateNormal];
}


- (void)setupAttributedTextForFlight {
    NSMutableAttributedString *attributedLoginHereSrting =  [[NSMutableAttributedString alloc] initWithString:@"Travelling in a group? Request Bulk Booking"];
    NSMutableDictionary *attributesDictionary = [NSMutableDictionary dictionary];
    [attributesDictionary setObject:[UIFont fontWithName:@"SourceSansPro-Semibold" size:14] forKey:NSFontAttributeName];
    [attributesDictionary setObject:[UIColor GREEN_BLUE_COLOR] forKey:NSForegroundColorAttributeName];
    [attributedLoginHereSrting addAttributes:attributesDictionary range:NSMakeRange(22, 21)];
    self.bulkFlightTravellingLabel.attributedText = attributedLoginHereSrting;
    
    
}
- (IBAction)flightBulkAction:(id)sender {
    
    FlightBulkBookingViewController *controller = (FlightBulkBookingViewController *)[self getControllerForModule:FLIGHT_BULK_BOOKING_CONTROLLER];
    controller.formDataModel = self.viewModel;
    controller.BulkBookingFormDelegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}

//MARK:- FLIGHT SEARCH

-(void)showErrorMessage:(NSString*)errorMessage {
    [AertripToastView toastInView:self.parentViewController.view withText:errorMessage];
}

- (IBAction)searchFlightAction:(id)sender {
    
    [self.viewModel performFlightSearch];
    
}

-(void)showFlightSearchResult:(BookFlightObject*)bookflightObject flightSearchParameters:(NSDictionary*)flightSearchParameters {
    [self hideLoaderIndicatorForFilghtSearch];
    
    self.isInternationalJourney = !bookflightObject.isDomestic && bookflightObject.flightSearchType != SINGLE_JOURNEY;
    
    NSMutableArray *values= [NSMutableArray array];
    
    if (bookflightObject.flightSearchType == MULTI_CITY && !self.isInternationalJourney) {
        NSArray * allKeys = bookflightObject.displayGroups.allKeys;
        
        for (int i = 0 ; i < [allKeys count] ; i++  ) {
            
            NSNumber *number = [NSNumber numberWithInteger:[ [allKeys objectAtIndex:i] integerValue]];
            [values addObject:number];
        }
        
        
    }else {
        values = [NSMutableArray arrayWithArray:bookflightObject.displayGroups.allValues];
    }
    
    // Converting to set and back to array to avoid duplicates in displaygroup
    NSSet *displayGroupSet = [NSSet setWithArray:values];
    values = [NSMutableArray arrayWithArray:[displayGroupSet allObjects]];
    
    NSString * sid = bookflightObject.sid;
    
    int64_t numberOfLegs = 1;
    if (bookflightObject.flightSearchType == RETURN_JOURNEY) {
        numberOfLegs = 2;
    } else if(bookflightObject.flightSearchType == MULTI_CITY) {
        numberOfLegs = self.viewModel.multiCityArray.count;
    }
    
    if(self.isInternationalJourney){
        bookflightObject.isDomestic = false;
    }else{
        bookflightObject.isDomestic = true;
    }
    
    FlightSearchResultVM * flightSearchResponse = [[FlightSearchResultVM alloc] initWithDisplayGroups:values sid:sid bookFlightObject:bookflightObject isInternationalJourney:self.isInternationalJourney numberOfLegs: numberOfLegs];
    
    FlightResultBaseViewController * flightResultView = [[FlightResultBaseViewController alloc] initWithFlightSearchResultVM:flightSearchResponse flightSearchParameters:flightSearchParameters isIntReturnOrMCJourney:self.isInternationalJourney airlineCode:self.viewModel.airlineCode];
    
    
    [self.navigationController pushViewController:flightResultView animated:true];
    
}

//MARK:- Target Action Methods

- (IBAction)fromAction:(id)sender {
    AirportSelectionViewController *controller = (AirportSelectionViewController *)[self getControllerForModule:AIRPORT_SELECTION_CONTROLLER];
    
    AirportSelectionVM * viewModel = [self.viewModel prepareForAirportSelection:true airportSelectionMode:AirportSelectionModeSingleLegJournery];
    viewModel.isFrom = true;
    controller.viewModel = viewModel;
    
    
    if (@available(iOS 13.0, *)) {
        [self presentViewController:controller animated:YES completion:nil];
    }
    else {
        [self presentViewController:controller animated:NO completion:nil];
    }
}

- (IBAction)toAction:(id)sender {
    AirportSelectionViewController *controller = (AirportSelectionViewController *)[self getControllerForModule:AIRPORT_SELECTION_CONTROLLER];
    AirportSelectionVM * viewModel = [self.viewModel prepareForAirportSelection:false airportSelectionMode:AirportSelectionModeSingleLegJournery ];
    viewModel.isFrom = false;
    controller.viewModel = viewModel;
    
    if (@available(iOS 13.0, *)) {
        [self presentViewController:controller animated:YES completion:nil];
    }
    else {
        [self presentViewController:controller animated:NO completion:nil];
    }
}

- (IBAction)onwardsAction:(id)sender {
    
    
    NSBundle * calendarBundle = [NSBundle bundleForClass:AertripCalendarViewController.class];
    UIStoryboard *storyboard = [UIStoryboard   storyboardWithName:@"AertripCalendar" bundle:calendarBundle];
    AertripCalendarViewController * controller = [storyboard instantiateViewControllerWithIdentifier:@"AertripCalendarViewController"];
    
    if ( self.flightSegmentedControl.selectedSegmentIndex == 0) {
        controller.viewModel = [self.viewModel VMForDateSelectionIsOnwardsSelection:YES forReturnMode:NO];
    }
    else {
        controller.viewModel = [self.viewModel VMForDateSelectionIsOnwardsSelection:YES forReturnMode:YES];
    }
    
    if (@available(iOS 13.0, *)) {
        [self presentViewController:controller animated:YES completion:nil];
    }
    else {
        [self presentViewController:controller animated:NO completion:nil];
    }
}
- (IBAction)returnAction:(id)sender {
    
    if (self.viewModel.flightSearchType != RETURN_JOURNEY ) {
        self.flightSegmentedControl.selectedSegmentIndex = 1 ;
        [self segmentChanged:nil];
    }
    
    NSBundle * calendarBundle = [NSBundle bundleForClass:AertripCalendarViewController.class];
    UIStoryboard *storyboard = [UIStoryboard   storyboardWithName:@"AertripCalendar" bundle:calendarBundle];
    AertripCalendarViewController * controller = [storyboard instantiateViewControllerWithIdentifier:@"AertripCalendarViewController"];
    
    controller.viewModel = [self.viewModel VMForDateSelectionIsOnwardsSelection:NO forReturnMode:YES];
    
    if (@available(iOS 13.0, *)) {
        [self presentViewController:controller animated:YES completion:nil];
    }
    else {
        [self presentViewController:controller animated:NO completion:nil];
    }
}

- (IBAction)passengersAction:(id)sender {
    
    FlightAddPassengerViewController *controller = (FlightAddPassengerViewController *)[self getControllerForModule:FLIGHT_ADD_PASSENGER_CONTROLLER];
    controller.travellerCount = self.viewModel.travellerCount;
    controller.delegate = self;
    controller.isForBulking = NO;
    [self presentViewController:controller animated:NO completion:nil];
    
}

- (void)addFlightPassengerAction:(TravellerCount*)travellerCount
{
    self.viewModel.travellerCount = travellerCount;
    [self setupPassengerCountView];
}

- (IBAction)classAction:(id)sender {
    
    HomeFlightAddClassViewController *controller = (HomeFlightAddClassViewController *)[self getControllerForModule:HOME_FLIGHT_ADD_CLASS_CONTROLLER];
    controller.flightClassSelectiondelegate = self;
    controller.flightClass = self.viewModel.flightClass;
    [self presentViewController:controller animated:NO completion:nil];
    
}

- (void)addFlightClassAction:(FlightClass *)flightClass {
    self.viewModel.flightClass = flightClass;
    [self setupFlightClassType];
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

//MARK:- RECENT SEARCHES

-(void)updateRecentSearch
{
    if(self.viewModel.recentSearchArray.count > 0){
        self.recentSearchTitleLabel.hidden = false;
    }else{
        self.recentSearchTitleLabel.hidden = true;
    }
    
    [self.recentSearchCollectionView reloadData];
    [self updateScrollviewContentHeight];
}

//MARK:- MULTICITY IMPLEMENTATION

- (void)setupMultiCityTableView {
    self.multiCityTableView.delegate = self;
    self.multiCityTableView.dataSource = self;
}


- (IBAction)removeMultiCityAction:(id)sender {
    
    [self.viewModel removeLastLegFromJourney];
    [self reloadMultiCityTableView];
}

-(void)disableRemoveMulticityButton:(BOOL)disable
{
    if(disable){
        
        self.multicityRemoveButton.enabled = NO;
        self.multicityRemoveTitle.alpha = 0.2;
        self.multiCityRemoveIcon.alpha = 0.2;
        
    }
    else {
        
        self.multicityRemoveTitle.alpha = 1.0;
        self.multiCityRemoveIcon.alpha = 1.0;
        self.multicityRemoveButton.enabled = YES;
        
    }
}

- (IBAction)addMultiCityAction:(id)sender {
    
    [self.viewModel addFlightLegForMulticityJourney];
    [self reloadMultiCityTableView];
    
}
-(void)disableAddMulticityButton:(BOOL)disable
{
    if(disable){
        
        self.multicityAddIcon.alpha = 0.2;
        self.multicityAddTitle.alpha = 0.2;
        self.multicityAddButton.enabled = NO;
        
    }
    else {
        self.multicityAddButton.enabled = YES;
        self.multicityAddTitle.alpha = 1.0;
        self.multicityAddIcon.alpha = 1.0;
    }
}


- (void)reloadMultiCityTableView {
    [self.multiCityTableView reloadData];
    self.multiCityTableViewHeightConstraint.constant = 80 * self.viewModel.multiCityArray.count;
    self.flightFormHeight.constant = self.multiCityTableViewHeightConstraint.constant + 305.0;
    [self.view layoutIfNeeded];
    [self updateScrollviewContentHeight];
}


- (void)reloadMultiCityTableViewAtIndex:(NSIndexPath*)indexPath {
    
    NSArray * indices = [NSArray arrayWithObject:indexPath];
    [self.multiCityTableView reloadRowsAtIndexPaths:indices withRowAnimation:UITableViewRowAnimationNone];
    
}

- (void)shakeAnimation:(PlaceholderLabels)label atIndex:(NSIndexPath*)indexPath
{
    
    MultiCityFlightTableViewCell * cell = [self.multiCityTableView cellForRowAtIndexPath:indexPath];
    [cell shakeAnimation:label];
    
}

- (void)didFetchCountryCodes:(NSMutableArray *)countryCodes
{
    NSArray *uniqueArray = [[NSOrderedSet orderedSetWithArray:countryCodes] array];
    if((uniqueArray.count > 1)){
        self.isInternationalJourney = true;
    }else{
        self.isInternationalJourney = false;
    }
    //    self.isInternationalJourney = (uniqueArray.count > 1);
}


-(void)shakeAnimation:(PlaceholderLabels)label {
    
    
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

//MARK:- TABLEVIEW DELEGATES
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.viewModel.multiCityArray.count;
    
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
    MulticityFlightLeg *flightLegRow = [self.viewModel.multiCityArray objectAtIndex:indexPath.row];
    cell.flightLegRow = flightLegRow;
    [cell setupFromAndToView];
    [cell setupDateView];
    return cell;
}

////MARK:- MULTICITY CELL HANDLER DELEGATE
- (void)openAirportSelectionControllerFor:(BOOL)isFrom indexPath:(NSIndexPath *)indexPath {
    
    AirportSelectionViewController *controller = (AirportSelectionViewController *)[self getControllerForModule:AIRPORT_SELECTION_CONTROLLER];
    controller.viewModel = [self.viewModel prepareForMultiCityAirportSelection:isFrom indexPath:indexPath];
    
    if (@available(iOS 13.0, *)) {
        [self presentViewController:controller animated:YES completion:nil];
    }
    else {
        [self presentViewController:controller animated:NO completion:nil];
    }
    
}
- (void)openCalenderDateForMulticity:(NSIndexPath *)indexPath {
    
    NSBundle * calendarBundle = [NSBundle bundleForClass:AertripCalendarViewController.class];
    UIStoryboard *storyboard = [UIStoryboard   storyboardWithName:@"AertripCalendar" bundle:calendarBundle];
    AertripCalendarViewController * controller = [storyboard instantiateViewControllerWithIdentifier:@"AertripCalendarViewController"];
    controller.multicityViewModel = [self.viewModel prepareVMForMulticityCalendar:indexPath.row];
    if (@available(iOS 13.0, *)) {
        [self presentViewController:controller animated:YES completion:nil];
    }
    else {
        [self presentViewController:controller animated:NO completion:nil];
    }
}

//MARK:- BULKBOOKINGFORMHANDLER DELEGATE

- (void)updateWithViewModel:(FlightFormDataModel*)viewModel
{
    self.viewModel = viewModel;
    [self setupFlightSection];
    
}


-(void)swapMultiCityAirportsFor:(NSIndexPath*)indexPath{
    
    
    NSMutableArray * fromArray = [NSMutableArray array];
    NSMutableArray *toArray = [NSMutableArray array];
    
    MulticityFlightLeg * currentLeg = [self.viewModel.multiCityArray objectAtIndex:indexPath.row];
    
    AirportSearch * origin = currentLeg.destination;
    AirportSearch * destination = currentLeg.origin;
    
    if ( origin != nil ){
        [fromArray addObject:origin];
    }
    
    //    AirportSearch * destination = currentLeg.origin;
    if ( destination != nil ){//&& ![origin.iata isEqual: destination.iata]) {
        [toArray addObject:destination];
    }
    
    [self.viewModel setMulticityAirports:fromArray toArray:toArray atIndexPath:indexPath];
    
}
//MARK:- Selected Airtport Swapping

- (void)performAirportSwap {
    
    //    [self performAnimationForPlaceholderLabels];
    [self performAirportSwapAnimationForSubTitle];
    [self performAnimationForValueLabels];
    [self airportSwapOnModelView];
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
        
        //        originAnimationLabel.frame = leftLabelTargetFrame;
        //        destinationAnimationLabel.frame = rightLabelTargetFrame;
        
        // Gurpreet
        originAnimationLabel.frame = CGRectMake(leftLabelTargetFrame.origin.x, originAnimationLabel.frame.origin.y, originAnimationLabel.frame.size.width, originAnimationLabel.frame.size.height);
        
        destinationAnimationLabel.frame = CGRectMake(rightLabelTargetFrame.origin.x, destinationAnimationLabel.frame.origin.y, destinationAnimationLabel.frame.size.width, destinationAnimationLabel.frame.size.height);
        
    } completion:^(BOOL finished) {
        
        [originAnimationLabel removeFromSuperview];
        [destinationAnimationLabel removeFromSuperview];
        
        leftLabel.textColor = previousColor;
        rightLabel.textColor = previousColor;
        
    }];
}

- (void)performAirportSwapAnimationForSubTitle {
    
    if ( self.toSubTitleLabel.isHidden && self.fromSubTitleLabel.isHidden ) {
        return;
    }
    
    UILabel * leftLabel = self.fromSubTitleLabel;
    UILabel * rightLabel = self.toSubTitleLabel;
    
    [self swipPositionOfLabels:leftLabel rightLabel:rightLabel];
}


-(void)animateLabel:(UILabel*)sourceLabel targetLabel:(UILabel*)targetLabel {
    
    UILabel *labelCopy = [self deepLabelCopy:sourceLabel];
    UIColor * previousColor = self.fromLabel.textColor;
    
    [labelCopy setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:16.0]];
    sourceLabel.textColor = [UIColor clearColor];
    [self.FromToView addSubview:labelCopy];
    
    CGRect targetRect = targetLabel.frame;
    targetRect.size = sourceLabel.frame.size;
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        labelCopy.frame = targetRect;
        
    } completion:^(BOOL finished) {
        
        labelCopy.alpha = 0.0;
        [labelCopy removeFromSuperview];
        sourceLabel.textColor = previousColor;
    }];
}


-(void)performAnimationForPlaceholderLabels{
    
    if (!self.fromLabel.isHidden) {
        
        //        UILabel *fromLabelCopy = [self deepLabelCopy:self.fromLabel];
        //        UIColor * previousColor = self.fromLabel.textColor;
        //
        //        self.fromLabel.textColor = [UIColor clearColor];
        //        [self.FromToView addSubview:fromLabelCopy];
        //
        //        CGRect targetRect = self.fromTopLabel.frame;
        //        targetRect.size = self.fromLabel.frame.size;
        //
        //
        //        [UIView animateWithDuration:0.3 animations:^{
        //
        //            fromLabelCopy.frame = targetRect;
        //
        //        } completion:^(BOOL finished) {
        //
        //            [fromLabelCopy removeFromSuperview];
        //            self.fromLabel.textColor = previousColor;
        //        }];
        
        [self animateLabel:self.fromLabel targetLabel:self.fromTopLabel];
    }
    
    
    if (!self.toLabel.isHidden) {
        
        [self animateLabel:self.toLabel targetLabel:self.toTopLabel];
        
    }
    
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

- (void)airportSwapOnModelView {
    NSMutableArray * tempArray = self.viewModel.fromFlightArray;
    self.viewModel.fromFlightArray = self.viewModel.toFlightArray;
    self.viewModel.toFlightArray = tempArray;
    
    self.fromValueLabel.hidden = YES;
    self.toValueLabel.hidden = YES;
    [self setupFromAndToView];
}


//MARK:- COMMON METHODS

- (void)changeLabelFont:(UILabel *)label isSmall:(BOOL)isSmall {
    if (isSmall) {
        [label setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:16.0]];
    }else {
        [label setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:20.0]];
        
    }
}

-(void)updateScrollviewContentHeight {
    if(self.viewModel.recentSearchArray.count > 0){
        CGFloat height = self.flightFormHeight.constant + self.recentSearchCollectionView.frame.size.height + 20.0 + 51;
        CGSize size = CGSizeMake(self.ScrollView.contentSize.width, height);
        self.ScrollView.contentSize = size;
    }else{
        CGFloat height = self.flightFormHeight.constant + 20.0 + 300;
        CGSize size = CGSizeMake(self.ScrollView.contentSize.width, height);
        self.ScrollView.contentSize = size;
    }
}

@end
