//
//  AirportSelectionViewController.m
//  Aertrip
//
//  Created by Kakshil Shah on 7/11/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "AirportSelectionViewController.h"
#import "AirportTableViewCell.h"
#import "SimpleLabelTableViewCell.h"
#import "AirlineSearchModel.h"


@interface AirportSelectionViewController ()<AirportCellHandler, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate ,CLLocationManagerDelegate , UISearchBarDelegate >
@property (assign, nonatomic) CGFloat primaryDuration;
@property (strong, nonatomic) NSMutableDictionary *displaySections;
@property (strong, nonatomic) NSMutableArray *airportDisplayArray;

@property ( strong , nonatomic) NSMutableArray *popularAirportArray;
@property ( strong , nonatomic) NSMutableArray *recentSearchesAirportArray;
@property ( strong , nonatomic) NSMutableArray *recentSearchesDisplayArray;
@property ( strong , nonatomic) NSMutableArray *nearbyAirportArray;
@property ( strong , nonatomic) NSMutableArray *airlinesArray;



@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fromLabelCenterConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fromValueLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fromValueLabelWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ToLabelCenterConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ToValueLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ToValueLabelWidth;
@property (weak, nonatomic) IBOutlet UIView *fromView;
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromSubTitleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *BackgroundViewLeadingConstraint;
@property (weak, nonatomic) IBOutlet UIButton *dictationButton;
@property (weak, nonatomic) IBOutlet UILabel *fromLabelTop;
@property (weak, nonatomic) IBOutlet UILabel *toLabelTop;
@property (weak, nonatomic) IBOutlet UIView *separatorView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeightConstraint;

@property (weak, nonatomic) IBOutlet UIButton *fromButton;

@property (weak, nonatomic) IBOutlet UIView *toView;
@property (weak, nonatomic) IBOutlet UILabel *toLabel;
@property (weak, nonatomic) IBOutlet UILabel *toValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *toSubTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *toButton;
@property (weak, nonatomic) IBOutlet UITableView *resultTableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (weak, nonatomic) IBOutlet UIView *dimmerLayer;
@property (weak, nonatomic) IBOutlet UIView *TopView;
@property (weak, nonatomic) IBOutlet UIButton *switcherButton;

@property (weak, nonatomic) IBOutlet UIImageView *backingImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraintMainView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet UIView *TableViewHeaderView;

@property (weak, nonatomic) IBOutlet UIVisualEffectView *switcherButtonBlurBackground;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UIView *noResultView;

@property (weak, nonatomic) IBOutlet UIView *doneOutterView;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@property (strong , nonatomic) CLLocationManager * locationManager;
@property (strong , nonatomic) NSString * cellIdentifier;
@property (weak, nonatomic) IBOutlet UILabel *NoResultLabel;
@property ( strong , nonatomic) NSArray * nearestAirports;
@end

@implementation AirportSelectionViewController


-(void)hideTableViewHeader:(BOOL)hide {
    
    if (hide )
        self.resultTableView.tableHeaderView = nil;
    else {
        self.resultTableView.tableHeaderView = self.TableViewHeaderView;
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
     if (@available(iOS 13.0, *)) {
    
     }
     else {
         [self setModalPresentationStyle:UIModalPresentationOverFullScreen];
         [self setModalPresentationCapturesStatusBarAppearance:YES];
     }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupInitials];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     if (@available(iOS 13.0, *)) {
    
     }
     else {
         [self configureInitialBottomViewPosition];
     }
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
     if (@available(iOS 13.0, *)) {
    
     }
     else {
         [self animateBottomViewIn];
     }
    [self startlocationService];
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.bottomHeightConstraint.constant = 50 + self.view.safeAreaInsets.bottom;
}

-(void)createPopularAirportArray
{
    
    NSString * url = [AIRPORT_SEARCH_API stringByAppendingString:@"?q=&popular_airports=1"];
    
    [[Network sharedNetwork] callGETApi:url parameters:nil loadFromCache:NO expires:YES success:^(id dataDictionary) {
  
        NSArray * airports = [Parser parseAirportSearchArray:(NSArray*)dataDictionary];
        self.popularAirportArray = [NSMutableArray arrayWithArray:airports];
        
        if (self.viewModel.isFrom){
            [self toAction:nil];
        }else {
            [self fromAction:nil];
        }
        
    } failure:^(NSString *error, BOOL popup) {
    }];
    
    
    
}
-(NSArray*)getPopularAirportsArray{
    
    NSMutableArray * popularAirportsToDisplay = [NSMutableArray arrayWithArray:self.popularAirportArray];
    NSMutableArray * itemsToRemove = [NSMutableArray arrayWithArray:self.recentSearchesDisplayArray];

    for (AirportSearch * displayAirport in popularAirportsToDisplay){
        if ([self isFlightDestinationInSelectedToOrFrom:displayAirport])
        {
            [itemsToRemove addObject:displayAirport];
        }
    }
    
    if ( itemsToRemove.count > 0 ) {
        [popularAirportsToDisplay removeObjectsInArray:itemsToRemove];
    }

    NSUInteger count = [popularAirportsToDisplay count];
    
    NSRange range = NSMakeRange(0, count);
    if (count > 6 ){
        range = NSMakeRange(0, 6);
    }
    
    return [popularAirportsToDisplay subarrayWithRange:range];
}

-(void)createRecentlySearchedAirportArray
{
    
    NSData * encodedRecentSearch = [NSUserDefaults.standardUserDefaults objectForKey:@"RecentSearches"];
    
    self.recentSearchesAirportArray = [NSKeyedUnarchiver unarchiveObjectWithData:encodedRecentSearch];
    if ( self.recentSearchesAirportArray == nil ) {
        self.recentSearchesAirportArray = [NSMutableArray array];
    }
    self.recentSearchesDisplayArray = [NSMutableArray arrayWithArray:self.recentSearchesAirportArray];
}


- (void)setupInitials {
    self.primaryDuration = 0.4;
    
    [self createPopularAirportArray];
    [self createRecentlySearchedAirportArray];
    [self applyShadowToDoneView];
    [self addSearchBar];
    [self setupDoneButton];
    [self setupTableView];
    self.airportDisplayArray = [[NSMutableArray alloc] init];
    self.displaySections = [[NSMutableDictionary alloc] init];
    [self refreshAllUIElements];
    [self performNearbyAirportsSearch];
    [self notifications];
    [self showNoResultView];
    [self makeTopCornersRounded:self.bottomView withRadius:10.0];
    [self hideLoader:YES];
    [self setSwipeGesture];
    
}

-(void)setSwipeGesture{
    
    UISwipeGestureRecognizer * swipeGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeToDismiss)];
    self.view.userInteractionEnabled = YES;
    swipeGesture.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeGesture];
}

-(void)swipeToDismiss{
    [self doneAction:nil];
}



- (void)applyShadowToDoneView {
    
 
    self.doneOutterView.clipsToBounds = NO;
    self.doneOutterView.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.05].CGColor;
    self.doneOutterView.layer.shadowOpacity = 1.0;
    self.doneOutterView.layer.shadowRadius = 10;
    self.doneOutterView.layer.shadowOffset = CGSizeMake(0.0, -6.0);
    
}
- (void) notifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
//MARK:- KEYBOARD LISTENERS
- (void)keyboardWillShow:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets =  self.resultTableView.contentInset;
    contentInsets.bottom = keyboardSize.height;
    self.resultTableView.contentInset = contentInsets;
    self.resultTableView.scrollIndicatorInsets = contentInsets;
}


- (void)keyboardWillHide:(NSNotification *)notification
{
    UIEdgeInsets contentInsets =  self.resultTableView.contentInset;
    contentInsets.bottom = 0.0;
    self.resultTableView.contentInset = contentInsets;
    self.resultTableView.scrollIndicatorInsets = contentInsets;
    
}

- (void)addSearchBar {
    self.searchBar.showsCancelButton = NO;
    self.searchBar.delegate = self;
    
    if (@available(iOS 13, *)) {
        self.searchBar.searchTextField.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:18.0];
    }
    else {
        UITextField *textField = [self.searchBar valueForKey: @"_searchField"];
        [textField setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:18.0]];
    }
    
    
}
- (void)setupTableView {
    self.resultTableView.delegate = self;
    self.resultTableView.dataSource = self;
    self.cellIdentifier = @"AirportCell";
    [self.resultTableView registerNib:[UINib nibWithNibName:@"AirportTableViewCell" bundle:nil]  forCellReuseIdentifier:@"AirportCell"];
    
    [self.resultTableView registerNib:[UINib nibWithNibName:@"AirlineSearchTableViewCell" bundle:nil] forCellReuseIdentifier:@"AirlineSearchCell"];
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedOnAirportNearMe:)];
    self.TableViewHeaderView.userInteractionEnabled = YES;
    [self.TableViewHeaderView addGestureRecognizer:tapGesture];
    [self hideTableViewHeader:NO];
}

-(void)setupDoneButton{
    
    [self.doneButton setTitleColor:[UIColor AertripColor] forState:UIControlStateNormal];
    [self.doneButton setTitleColor:[UIColor TWO_ZERO_FOUR_COLOR] forState:UIControlStateDisabled];
    
}

-(void)tappedOnAirportNearMe:(UITapGestureRecognizer*)sender
{
    AirportSearch * nearestAirport = [self.nearestAirports firstObject];

    [self replaceSelectedAirport:nearestAirport];
    
    if (self.viewModel.isFrom){
        [self toAction:nil];
    }else {
        [self fromAction:nil];
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
    
     if (@available(iOS 13.0, *)) {
         [self dismissViewControllerAnimated:YES completion:nil];
     }
     else {
    
    [UIView animateWithDuration:self.primaryDuration delay:0 options: UIViewAnimationOptionCurveEaseIn animations:^{
        self.dimmerLayer.alpha = 0.0;
        self.topConstraintMainView.constant = (self.view.bounds.size.height);
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
     }
}



//MARK:- AttributedStrings for Cell

-(NSAttributedString*)airportCodeFor:(NSString*)inputString
{
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont fontWithName:@"SourceSansPro-Semibold" size:18]};
    NSMutableAttributedString * mainLabelAttributedString = [[NSMutableAttributedString alloc] initWithString:inputString attributes:attributes];
    NSRange range = [inputString rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];

    if ( range.location != NSNotFound ) {
        attributes = @{NSForegroundColorAttributeName : [UIColor AertripColor], NSFontAttributeName:[UIFont fontWithName:@"SourceSansPro-Semibold" size:18]};
        [mainLabelAttributedString addAttributes:attributes range:range];
    }

    return mainLabelAttributedString;
}


-(NSAttributedString*)mainLabelStringFor:(NSString*)inputString
{
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont fontWithName:@"SourceSansPro-Regular" size:18]};
    NSMutableAttributedString * mainLabelAttributedString = [[NSMutableAttributedString alloc] initWithString:inputString attributes:attributes];
    NSRange range = [inputString rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
    
    if ( range.location != NSNotFound ) {
        attributes = @{NSForegroundColorAttributeName : [UIColor AertripColor], NSFontAttributeName:[UIFont fontWithName:@"SourceSansPro-Regular" size:18]};
        [mainLabelAttributedString addAttributes:attributes range:range];
    }
    
    return mainLabelAttributedString;
}


-(NSAttributedString*)secondaryStringFor:(NSString*)inputString
{
    NSDictionary * attributes = @{NSForegroundColorAttributeName : [UIColor ONE_FIVE_THREE_COLOR],NSFontAttributeName:[UIFont fontWithName:@"SourceSansPro-Regular" size:14]};
    NSMutableAttributedString * secondaryLabelAttributedString = [[NSMutableAttributedString alloc] initWithString:inputString attributes:attributes];
    
    NSRange range = [inputString rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
    if ( range.location != NSNotFound) {
        attributes = @{NSForegroundColorAttributeName : [UIColor AertripColor], NSFontAttributeName:[UIFont fontWithName:@"SourceSansPro-Regular" size:14]};
        [secondaryLabelAttributedString addAttributes:attributes range:range];
    }

    return  secondaryLabelAttributedString;
    
}
//MARK:- NETWORK CALL
- (NSDictionary *)buildDictionaryWithText:(NSString *) searchText {
    
    NSArray *keys = [NSArray arrayWithObjects:@"q", nil];
    NSArray *objects = [NSArray arrayWithObjects: searchText, nil];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjects:objects
                                                           forKeys:keys];
    return parameters;
}
- (void)ResetSearch {

  self.airportDisplayArray = [[NSMutableArray alloc] init];
    self.displaySections = [[NSMutableDictionary alloc] init];
    [self refreshAllUIElements];
}

- (void)updateUIAfterAddingAirport {
    
    self.airportDisplayArray = [[NSMutableArray alloc] init];
    self.displaySections = [[NSMutableDictionary alloc] init];

    
    [self populateDisplayArrays];
    [self setupFromAndToView];
    
    
    NSArray * selectedArray;
    if (self.viewModel.isFrom) {
        selectedArray  = self.viewModel.fromFlightArray;
    }else {
        
        selectedArray = self.viewModel.toFlightArray;
        
    }
    
//    NSIndexPath * indexToUpdate;
//
//    if(selectedArray.count > 0 ) {
//        NSInteger index = [selectedArray indexOfObject:[selectedArray lastObject]];
//        indexToUpdate = [NSIndexPath indexPathForRow:index inSection:1];
//        [self.resultTableView beginUpdates];
//        [self.resultTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexToUpdate] withRowAnimation:UITableViewRowAnimationTop];
//        [self.resultTableView endUpdates];
//    }
//    else {
//        indexToUpdate = [NSIndexPath indexPathForRow:0 inSection:0];
//    }

    [self.resultTableView reloadData];
    
    [self showNoResultView];
    [self hideLoader:YES];
}

- (void) performSearchOnServerWithText:(NSString *)searchText
{
    
    [[Network sharedNetwork] callGETApi:AIRPORT_SEARCH_API parameters:[self buildDictionaryWithText:searchText] loadFromCache:NO expires:YES success:^(NSDictionary *dataDictionary) {
        [self handleSearchResultDictionary:dataDictionary];
    } failure:^(NSString *error, BOOL popup) {
        [AertripToastView toastInView:self.view withText:error];
        [self ResetSearch];
    }];
}

- (void)handleSearchResultDictionary:(NSDictionary *)dataDictionary {
    if ([[Parser getValueForKey:@"type" inDictionary:dataDictionary] isEqualToString:@"airports"]) {
        self.cellIdentifier = @"AirportCell";
        [self createAirportArrayFromSearchResult:[Parser parseAirportSearchArray:[dataDictionary objectForKey:@"results"]]];
        [self refreshAllUIElements];
        return;
    }
    
    if ([[Parser getValueForKey:@"type" inDictionary:dataDictionary] isEqualToString:@"airlines"]) {
        self.cellIdentifier = @"AirlineSearchCell";
        [self createAirlineArrayFromSearchResult:[dataDictionary objectForKey:@"results"]];
        [self refreshAllUIElements];
        return;
    }
    
}

-(void)setupLocationService
{
//     Requesting Permission to Use Location Services.
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    [self.locationManager requestWhenInUseAuthorization];
    
}

-(void)startlocationService{
    
    if(self.locationManager == nil){
         [self setupLocationService];
     }
     
     [self.locationManager startUpdatingLocation];
}

-(void)performNearbyAirportsByLocation:(CLLocation*)location
{
    
    NSMutableArray * currentSelectedArray;
    
    if (self.viewModel.isFrom) {
        currentSelectedArray = self.viewModel.fromFlightArray;
    }else {
        currentSelectedArray = self.viewModel.toFlightArray;
    }
    
    if (currentSelectedArray.count == 3 ) {
        return;
    }
    
//    [self.locationManager stopUpdatingLocation];
    
    NSString* latitudeLongituteString = [NSString stringWithFormat:@"?latitude=%.8f&longitude=%.8f",location.coordinate.latitude,location.coordinate.longitude];
    
    NSString * url = [NEARBY_AIRPORT_SEARCH_API stringByAppendingString:latitudeLongituteString];

    [[Network sharedNetwork] callGETApi:url parameters:nil loadFromCache:NO expires:YES success:^(NSDictionary *dataDictionary) {
        [self handleNearbyAirportByLocationResult:dataDictionary];
    } failure:^(NSString *error, BOOL popup) {
        [AertripToastView toastInView:self.view withText:error];
        [self ResetSearch];
    }];
    
}


-(void)performNearbyAirportsSearch
{
    
    NSMutableArray * currentSelectedArray;
    
    if (self.viewModel.isFrom) {
        currentSelectedArray = self.viewModel.fromFlightArray;
    }else {
        currentSelectedArray = self.viewModel.toFlightArray;
    }
    
    if(self.viewModel.airportSelectionMode == AirportSelectionModeMultiCityJourney){
        return;
    }
    
    if (currentSelectedArray.count == 3 || currentSelectedArray.count == 0) {
        return;
    }
    
    
    NSString * outputString = @"";
    for (int i = 0; i<currentSelectedArray.count; i++) {
        
        AirportSearch * currentAirport = currentSelectedArray[i];
        outputString = [outputString stringByAppendingString:currentAirport.iata];
        if (i != currentSelectedArray.count - 1) {
            outputString = [outputString stringByAppendingString:@","];
        }
    }

    [self.nearbyAirportArray removeAllObjects];
//    if (self.resultTableView.numberOfSections > 1) {
    
//        [self.airportDisplayArray removeObjectAtIndex:1];
//
////        [self.resultTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
//
//        [self.resultTableView beginUpdates];
//        [self.resultTableView deleteSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
//        [self.resultTableView endUpdates];
//    }
    
    NSString * url = [NEARBY_AIRPORT_SEARCH_API stringByAppendingFormat:@"?iata_code=%@",outputString];
    [[Network sharedNetwork] callGETApi:url parameters:nil loadFromCache:NO expires:YES success:^(NSDictionary *dataDictionary) {
        [self handleNearbyAirportResult:dataDictionary];
    } failure:^(NSString *error, BOOL popup) {
        [AertripToastView toastInView:self.view withText:error];
        [self ResetSearch];
    }];
    
}

-(void)handleNearbyAirportByLocationResult:(NSDictionary*)responseDictionary
{
    NSArray * airports = [responseDictionary allValues];
    NSArray * Airports = [Parser parseAirportSearchArray:airports];
    
    self.nearestAirports = [Airports sortedArrayUsingComparator:^NSComparisonResult(AirportSearch *airportOne, AirportSearch *airportTwo){
        
        if (airportOne.distance < airportTwo.distance) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        
        if (airportOne.distance > airportTwo.distance) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        return NSOrderedSame;
        }];
}

-(void)handleNearbyAirportResult:(NSDictionary*)responseDictionary
{
    
   
    NSArray * nearbyAirports = [responseDictionary allValues];
    
    if (nearbyAirports.count > 0) {
        
        NSArray *Airports = [Parser parseAirportSearchArray:nearbyAirports];
        NSArray * nearbyAirports = [Airports sortedArrayUsingComparator:^NSComparisonResult(AirportSearch *airportOne, AirportSearch *airportTwo){
            
            if (airportOne.distance < airportTwo.distance) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            
            if (airportOne.distance > airportTwo.distance) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            
            return NSOrderedSame;
        }];
        
        
        self.nearbyAirportArray = [NSMutableArray arrayWithArray:nearbyAirports];
        
        
        NSMutableSet * selectedAirports = [NSMutableSet set];

        if ( self.viewModel.fromFlightArray.count > 0) {
            [selectedAirports addObjectsFromArray:self.viewModel.fromFlightArray];
        }
        
        if ( self.viewModel.toFlightArray.count > 0) {
            [selectedAirports addObjectsFromArray:self.viewModel.toFlightArray];
        }
        
        NSMutableArray * duplicateAirportsTobeRemoved = [NSMutableArray array];
        for ( AirportSearch * selectedAirport in selectedAirports) {

            for ( AirportSearch *nearbyAirport in self.nearbyAirportArray) {
                
                if ([nearbyAirport.iata isEqualToString:selectedAirport.iata]) {
                    [duplicateAirportsTobeRemoved addObject:nearbyAirport];
                }
            }
        }
        
        [self.nearbyAirportArray removeObjectsInArray:duplicateAirportsTobeRemoved];
        [self appendNearByAirports];
        [self appendRecentlySearchedAirports];
        [self appendPopularAirports];
        [self.resultTableView reloadData];
    }
}

-(void)createAirlineArrayFromSearchResult:(NSArray*)resultArray{
    
    if (resultArray.count > 0){
        
        self.cellIdentifier = @"AirlineSearchCell";
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary * dictionary in resultArray) {
            
            AirlineSearchModel * airlineSearch = [[AirlineSearchModel alloc] initWithDictionary:dictionary];
            [array addObject:airlineSearch];
        }
        self.airportDisplayArray = [[NSMutableArray alloc] init];
        [self.airportDisplayArray addObject:@"SELECT YOUR FLIGHT"];
        self.airlinesArray  = array;
    }
    else {
        self.cellIdentifier = @"";
            NSDictionary * lineOneDictionary =  @{ NSForegroundColorAttributeName : [UIColor blackColor] ,NSFontAttributeName : [UIFont fontWithName:@"SourceSansPro-Regular" size:22.0]  };
            NSMutableAttributedString * noResultLabel = [[NSMutableAttributedString alloc]initWithString:@"Opps" attributes:lineOneDictionary];
        
            NSDictionary * lineTwoDictionary = @{ NSForegroundColorAttributeName : [ UIColor ONE_ZORE_TWO_COLOR]  ,NSFontAttributeName : [UIFont fontWithName:@"SourceSansPro-Regular" size:18.0]  };
            NSMutableAttributedString * line2 = [[NSMutableAttributedString alloc] initWithString:@"\nNo Airports Found" attributes:lineTwoDictionary];
            [noResultLabel appendAttributedString:line2];
        
            self.NoResultLabel.attributedText = noResultLabel;
        
    }
}


- (void)createAirportArrayFromSearchResult:(NSArray *)array {
    
    NSMutableArray *sectionArray = [[NSMutableArray alloc] init];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    self.displaySections = [[NSMutableDictionary alloc] init];
    
    //get sections array of objects
    for (AirportSearch *airportSearch in array) {
        if([self exists:airportSearch.category]) {
            [sectionArray addObject:airportSearch.category];
            if ([dictionary objectForKey:airportSearch.category] == nil) {
                [dictionary setObject:[[NSMutableArray alloc] init] forKey:airportSearch.category];
            }
            [[dictionary objectForKey:airportSearch.category] addObject:airportSearch];
        }else {
            NSString *emptyHeader = @"";
            [sectionArray addObject:emptyHeader];
            if ([dictionary objectForKey:emptyHeader] == nil) {
                [dictionary setObject:[[NSMutableArray alloc] init] forKey:emptyHeader];
            }
            [[dictionary objectForKey:emptyHeader] addObject:airportSearch];
        }
    }
    
    //remove multiple copies
    NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:sectionArray];
    sectionArray = [[orderedSet array] mutableCopy];
    
    self.airportDisplayArray = [sectionArray mutableCopy];
    self.displaySections = dictionary;
    
}


- (void)refreshAllUIElements {
    
    if ( self.viewModel.toFlightArray.count == 0 && self.viewModel.fromFlightArray.count == 0 ) {
        [self.switcherButton setEnabled:false];
    }else {
        [self.switcherButton setEnabled:true];
    }
    
    [self populateDisplayArrays];
    [self setupFromAndToView];
    [self.resultTableView reloadData];
    [self showNoResultView];
    [self hideLoader:YES];

}

-(void)resetSearchbar {
    self.searchBar.text = @"";
}

-(void)appendPopularAirports {
    
    if ( self.searchBar.text.length == 0) {
        
       NSArray * popularAirportsArray = [self getPopularAirportsArray];
        
        NSString * popularAirports = @"POPULAR AIRPORTS";
        [self.airportDisplayArray addObject:popularAirports];
        [self.displaySections setObject:popularAirportsArray forKey:popularAirports];
    }
}

-(void)appendRecentlySearchedAirports{
 
    [self createRecentSearchDisplayArray];
    
    if ( self.searchBar.text.length == 0 && self.recentSearchesDisplayArray.count > 0) {
        
        NSString * recentlysearchedAirports = @"RECENTLY SEARCHED AIRPORTS";
        [self.airportDisplayArray addObject:recentlysearchedAirports];
        [self.displaySections setObject:self.recentSearchesDisplayArray forKey:recentlysearchedAirports];
    }
}

-(void)appendNearByAirports{
    
    if ( self.nearbyAirportArray.count > 0) {
        
        NSString * nearbyAirports = @"NEARBY AIRPORTS";
        [self.airportDisplayArray addObject:nearbyAirports];
        [self.displaySections setObject:self.nearbyAirportArray forKey:nearbyAirports];
        [self.resultTableView reloadData];
    }
}

- (void)populateDisplayArrays {
    if (self.searchBar.text.length == 0) {
        
        if (self.viewModel.airportSelectionMode != AirportSelectionModeMultiCityJourney){
            [self populateDisplayArrayForSinglelegJournery];
        }
        else {
            [self populateDisplayArrayForMultiCityJournery];
        }
    }
}


-(void)populateDisplayArrayForMultiCityJournery{
    
    [self hideTableViewHeader:NO];
    [self appendRecentlySearchedAirports];
    [self appendPopularAirports];

}

-(void)populateDisplayArrayForSinglelegJournery{
    
    if (self.viewModel.isFrom) {
        
        if (self.viewModel.fromFlightArray.count > 0) {
            [self.airportDisplayArray insertObject:@"" atIndex:0];
            [self.displaySections setObject:self.viewModel.fromFlightArray forKey:@""];
            [self hideTableViewHeader:YES];
            return;
        }else {
            [self hideTableViewHeader:NO];
            [self appendRecentlySearchedAirports];
            [self appendPopularAirports];
            
            return;
        }
    }
    else {
        
        if ( self.viewModel.toFlightArray.count > 0) {
            [self hideTableViewHeader:YES];
            [self.airportDisplayArray insertObject:@"" atIndex:0];
            [self.displaySections setObject:self.viewModel.toFlightArray forKey:@""];
            
            return;
        }else {
            [self hideTableViewHeader:NO];
            [self appendRecentlySearchedAirports];
            [self appendPopularAirports];
            return;
        }
    }
}
- (void)hideLoader:(BOOL)hide {

    if (hide) {
        [self.indicatorView stopAnimating];
        [self.indicatorView setHidden:YES];
    }
    else {
        [self.indicatorView startAnimating];
        [self.indicatorView setHidden:NO];
        
    }
}

- (void)showNoResultView {
    if ( self.searchBar.text.length > 0 ) {
        if (self.airportDisplayArray.count == 0 && self.airlinesArray.count == 0){
            [self.noResultView setHidden:NO];
        }
        else {
            [self.noResultView setHidden:YES];
        }
    }else {
        [self.noResultView setHidden:YES];
    }
}


//MARK:- SEARCH DELEGATES
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    if ([searchText length] == 0 )
    {
        self.dictationButton.hidden = NO;
    }
    else {
        self.dictationButton.hidden = YES;
    }
    if ([searchText length] > 1 ){
        self.NoResultLabel.text = @"Searching..";
        [self performSelector:@selector(sendSearchRequest) withObject:searchText afterDelay:0.35f];
    }
    else {
        [self hideTableViewHeader:YES];
        [self ResetSearch];
    }
    
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar performSelector: @selector(resignFirstResponder)
                    withObject: nil
                    afterDelay: 0.1];
    searchBar.text = @"";

    [self ResetSearch];
}

- (void ) sendSearchRequest
{
    if (self.viewModel.isFrom) {
    
        if( self.viewModel.fromFlightArray.count == 3) {
            [AertripToastView toastInView:self.view withText:@"Cannot add more than 3 locations"];
            return ;
        }
    }
    else {
        if( self.viewModel.toFlightArray.count == 3 ) {
                [AertripToastView toastInView:self.view withText:@"Cannot add more than 3 locations"];
                return;
            }
    }
    
        [self hideLoader:NO];
        [self performSearchOnServerWithText:self.searchBar.text];
   
}
//MARK:- TABLE VIEW

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.searchBar resignFirstResponder];
    
    CGFloat contentOffset = scrollView.contentOffset.y;
    self.separatorView.alpha = 1.0 - contentOffset / 100.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
       if ([self.cellIdentifier isEqualToString:@"AirportCell"]) {
           return self.airportDisplayArray.count;
       }else if ([self.cellIdentifier isEqualToString:@"AirlineSearchCell"]){
           return  1;
       }
    
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    NSInteger count = 0;
    if ([self.cellIdentifier isEqualToString:@"AirportCell"]) {
        NSString *key = [self.airportDisplayArray objectAtIndex:section];
        count = [[self.displaySections objectForKey:key] count];
    }
    else if ([self.cellIdentifier isEqualToString:@"AirlineSearchCell"]){
        count = self.airlinesArray.count;
    }

    return count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    CGFloat height = 0.0;
    if ([self.cellIdentifier isEqualToString:@"AirportCell"]) {
        height = 64.0;
    }
    else if ([self.cellIdentifier isEqualToString:@"AirlineSearchCell"]){
        height = 44.0;
    }
    
    return height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    NSString *key = [self.airportDisplayArray objectAtIndex:section];
    if ([self exists:key]) {
        return 28.0;
    }
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *cellIdentifier = @"HeaderCell";
    SimpleLabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[SimpleLabelTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *key = [self.airportDisplayArray objectAtIndex:section];
    cell.mainLabel.text = [key uppercaseString];
   
    return [cell contentView];
}
- (AirportSearch *)airportSearchForIndexPath:(NSIndexPath * _Nonnull)indexPath {
    
    NSString *key = [self.airportDisplayArray objectAtIndex:indexPath.section];
    NSArray *array = [self.displaySections objectForKey:key];
    AirportSearch *airportSearch = [array objectAtIndex:indexPath.row];
    return airportSearch;
}

- (AirportTableViewCell *)airportCellForIndexPath:(NSIndexPath * _Nonnull)indexPath tableView:(UITableView * _Nonnull)tableView {
    AirportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AirportCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.indexPath = indexPath;
    
    AirportSearch * airportSearch = [self airportSearchForIndexPath:indexPath];
    
    cell.flightShortNameLabel.attributedText = [self airportCodeFor:airportSearch.iata];
    
    if ( airportSearch.distanceLabel && indexPath.section == 1 )
        cell.distanceLabel.text = airportSearch.distanceLabel;
    else
        cell.distanceLabel.text = @"";
    
    NSString * mainLabelText = [NSString stringWithFormat:@"%@, %@",airportSearch.city, airportSearch.countryCode];
    
    cell.mainLabel.attributedText = [self mainLabelStringFor:mainLabelText];
    
    cell.secondaryLabel.attributedText = [self secondaryStringFor:airportSearch.airport];
    
    
    if (self.viewModel.airportSelectionMode != AirportSelectionModeMultiCityJourney) {
        if ([self isFlightDestinationSelected:airportSearch]) {
            [cell.addButton setHidden:YES];
            
            [cell.removeButton setHidden:NO];
        }else {
            [cell.addButton setHidden:NO];
            [cell.removeButton setHidden:YES];
        }
    }
    else {
  
        if ([self isFlightDestinationSelected:airportSearch]) {
            [cell.addButton setHidden:YES];
            [cell.vierticalLineView setHidden:YES];
            [cell.removeButton setHidden:NO];
        }else {
            
            [cell.addButton setHidden:YES];
            [cell.removeButton setHidden:YES];
            [cell.vierticalLineView setHidden:YES];
        }
    }
    
    NSString *key = [self.airportDisplayArray objectAtIndex:indexPath.section];
    NSInteger count = [[self.displaySections objectForKey:key] count];
    
    cell.horizontalLineView.hidden = NO;
    
    if (indexPath.row == count - 1 ) {
        if( indexPath.section < self.airportDisplayArray.count - 1 ) {
            cell.horizontalLineView.hidden = YES;
        }
    }

    return cell;
}

- (AirlineSearchTableViewCell *)airlineCellAtIndex:(NSIndexPath*)indexPath tableView:(UITableView * _Nonnull)tableView
{
    AirlineSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AirlineSearchCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    AirlineSearchModel * airlineSearch = self.airlinesArray[indexPath.row];
    cell.LeftTitle.text = airlineSearch.leftString;
    cell.rightTitle.text = airlineSearch.rightString;
    return cell;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell;
    if ([self.cellIdentifier isEqualToString:@"AirportCell"]){
        cell = [self airportCellForIndexPath:indexPath tableView:tableView];
    }
    if ([self.cellIdentifier isEqualToString:@"AirlineSearchCell"]){
        cell = [self airlineCellAtIndex:indexPath tableView:tableView];
    }
    
    return cell;
}

- (void)onAirportCellSelected:(NSIndexPath * _Nonnull)indexPath {
    NSArray *array = [[NSArray alloc] init];
    NSString *key = [self.airportDisplayArray objectAtIndex:indexPath.section];
    array = [self.displaySections objectForKey:key];
    AirportSearch *airportSearch = [array objectAtIndex:indexPath.row];
    
    if ([self isFlightDestinationSelected:airportSearch]) {
        return;
    }
    
    [self addSelectedAirport:airportSearch];
    
    if ( [self.viewModel.fromFlightArray count] > 0 && [self.viewModel.toFlightArray count] > 0 ){
        [self.view endEditing:YES];
    }
    
    if ( self.viewModel.isFrom){
        [self toAction:nil];
    }else {
        [self fromAction:nil];
    }
}

-(void)onAirlineCellSelected:(NSIndexPath * _Nonnull)indexPath {
    
    AirlineSearchModel * airlineSearch = [self.airlinesArray objectAtIndex:indexPath.row];

    [self.viewModel.fromFlightArray removeAllObjects];
    [self.viewModel.toFlightArray removeAllObjects];

    
    [self.viewModel.fromFlightArray addObject:airlineSearch.origin];
    [self.viewModel.toFlightArray addObject:airlineSearch.destination];
    
    [self doneAction:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if ([self.cellIdentifier isEqualToString:@"AirportCell"]){
        [self onAirportCellSelected:indexPath];
        return;
    }
    
    if ([self.cellIdentifier isEqualToString:@"AirlineSearchCell"]){
        [self onAirlineCellSelected:indexPath];
    }
}

- (void)replaceSelectedAirport:(AirportSearch *)airportSearch {
    if (self.viewModel.isFrom) {
        
        [self.viewModel.fromFlightArray removeAllObjects];
        [self.viewModel.fromFlightArray addObject:airportSearch];
        [self addToRecentSearches:airportSearch];
        
    }else {
        
        [self.viewModel.toFlightArray removeAllObjects];
        [self.viewModel.toFlightArray addObject:airportSearch];
        [self addToRecentSearches:airportSearch];
        
    }
    [self.switcherButton setEnabled:true];
}

-(void)addSelectedAirport:(AirportSearch*)airportSearch {
    
    [self replaceSelectedAirport:airportSearch];
    [self updateUIAfterAddingAirport];
    
}

- (void)addAction:(NSIndexPath *)indexPath {
    NSArray *array = [[NSArray alloc] init];
    NSString *key = [self.airportDisplayArray objectAtIndex:indexPath.section];
    array = [self.displaySections objectForKey:key];
    AirportSearch *airportSearch = [array objectAtIndex:indexPath.row];

    if (![self isFlightDestinationSelected:airportSearch]) {
        [self addObjectToArray:airportSearch];
        [self performNearbyAirportsSearch];
    }
    
    self.searchBar.text = @"";
    
    [self updateUIAfterAddingAirport];

}


- (void)removeAction:(NSIndexPath *)indexPath {
    NSArray *array = [[NSArray alloc] init];
    NSString *key = [self.airportDisplayArray objectAtIndex:indexPath.section];
    array = [self.displaySections objectForKey:key];
    AirportSearch *airportSearch = [array objectAtIndex:indexPath.row];
    
    if ([self isFlightDestinationSelected:airportSearch]) {
        [self removeObjectFromoArray:airportSearch];
        [self.nearbyAirportArray removeAllObjects];
        [self performNearbyAirportsSearch];
    }
    
    self.searchBar.text = @"";
    
    [self ResetSearch];
    
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
}

//MARK:- SMART FUNCTIONS


- (BOOL)isFlightDestinationSelected: (AirportSearch *)airportSearch  {
    if (self.viewModel.isFrom) {
        for (AirportSearch *airportSearchObj in self.viewModel.fromFlightArray) {
            if ([airportSearchObj.iata isEqualToString:airportSearch.iata]) {
                return true;
            }
        }
        return false;
    }else {
        for (AirportSearch *airportSearchObj in self.viewModel.toFlightArray) {
            if ([airportSearchObj.iata isEqualToString:airportSearch.iata]) {
                return true;
            }
        }
        return false;
    }
}

- (BOOL)isFlightDestinationInSelectedToOrFrom: (AirportSearch *)airportSearch  {
    
        for (AirportSearch *airportSearchObj in self.viewModel.fromFlightArray) {
            if ([airportSearchObj.iata isEqualToString:airportSearch.iata]) {
                return true;
            }
        }
    
        for (AirportSearch *airportSearchObj in self.viewModel.toFlightArray) {
            if ([airportSearchObj.iata isEqualToString:airportSearch.iata]) {
                return true;
            }
        }
        return false;
}
- (void)removeObjectFromoArray: (AirportSearch *)airportSearch  {
    if (self.viewModel.isFrom) {
        for (AirportSearch *airportSearchObj in self.viewModel.fromFlightArray) {
            if ([airportSearchObj.iata isEqualToString:airportSearch.iata]) {
                [self.viewModel.fromFlightArray removeObject:airportSearch];
                break;
            }
        }
    }else {
        for (AirportSearch *airportSearchObj in self.viewModel.toFlightArray) {
            if ([airportSearchObj.iata isEqualToString:airportSearch.iata]) {
                [self.viewModel.toFlightArray removeObject:airportSearch];
                break;
            }
        }
    }
    
    if (self.viewModel.toFlightArray.count == 0 && self.viewModel.fromFlightArray.count == 0 ) {
        [self.switcherButton setEnabled:false];
    }
        
    
}


- (void)createRecentSearchDisplayArray {
    
    // update recent searches display array
    self.recentSearchesDisplayArray = [NSMutableArray arrayWithArray:self.recentSearchesAirportArray];
    
    NSMutableArray * itemsToRemove = [[NSMutableArray alloc]init];
    
    for (AirportSearch * displayAirport in self.recentSearchesDisplayArray){
        
        if ([self isFlightDestinationInSelectedToOrFrom:displayAirport]) {
            [itemsToRemove addObject:displayAirport];
        }
    }
    
    [self.recentSearchesDisplayArray removeObjectsInArray:itemsToRemove];
}

- (void)addToRecentSearches:(AirportSearch *)airportSearch {
    
    if (self.recentSearchesAirportArray.count == 5){
        [self.recentSearchesAirportArray removeLastObject];
    }
    
    // Remove earlier search
    AirportSearch * earlierAirport = nil;
    for (AirportSearch * previouslySearchedAirport in self.recentSearchesAirportArray) {
        
        if ([previouslySearchedAirport.iata isEqualToString:airportSearch.iata]){
            earlierAirport = previouslySearchedAirport;
            break;
        }
    }
    
    if (earlierAirport !=nil) {
        [self.recentSearchesAirportArray removeObject:earlierAirport];
    }
    
    airportSearch.distanceLabel = @"";
    [self.recentSearchesAirportArray insertObject:airportSearch atIndex:0];
    
    NSData * encodedRecentSearch = [NSKeyedArchiver archivedDataWithRootObject:self.recentSearchesAirportArray];
    
    [NSUserDefaults.standardUserDefaults setObject:encodedRecentSearch forKey:@"RecentSearches"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self createRecentSearchDisplayArray];
        
}

- (void)addObjectToArray: (AirportSearch *)airportSearch {
    
    // To Avoid adding duplicate of previously selected airport

    if ([self isFlightDestinationSelected:airportSearch]) {
        return;
    }
    
    if (self.viewModel.isFrom) {
        
        [self.viewModel.fromFlightArray addObject:airportSearch];
        [self addToRecentSearches:airportSearch];
        
    }else {
        
        [self.viewModel.toFlightArray addObject:airportSearch];
        [self addToRecentSearches:airportSearch];
        
    }
    
    [self.switcherButton setEnabled:true];
}



- (void)setupFromView {
    if (self.viewModel.fromFlightArray.count > 0) {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.fromLabelTop.alpha = 1.0;
            self.fromLabel.alpha = 0.0;
        }];
        
        self.fromValueLabel.hidden = NO;
        self.fromValueLabel.text = [self generateCSVFromSelectionArray:self.viewModel.fromFlightArray];
        
        NSUInteger count = self.viewModel.fromFlightArray.count;
        AirportSearch *airportSearch = [self.viewModel.fromFlightArray objectAtIndex:0];
        
        switch (count) {
            case 1:
                self.fromSubTitleLabel.text = airportSearch.city;
                self.fromSubTitleLabel.hidden = NO;
                self.fromValueLabelHeight.constant = 36.0;
                self.fromValueLabel.font = [UIFont fontWithName:@"SourceSansPro-SemiBold" size:26.0];
                break;
            case 2 :
                self.fromSubTitleLabel.hidden = YES;
                self.fromValueLabelHeight.constant = 60.0;
                self.fromValueLabel.font = [UIFont fontWithName:@"SourceSansPro-SemiBold" size:20.0];
                break;
            case 3 :
                self.fromSubTitleLabel.hidden = YES;
                self.fromValueLabelHeight.constant = 60.0;
                self.fromValueLabel.font = [UIFont fontWithName:@"SourceSansPro-SemiBold" size:20.0];
                break;
            default:
                break;
        }
        


        [self.fromView layoutIfNeeded];
        
    }else {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.fromLabelTop.alpha = 0.0;
            self.fromLabel.alpha = 1.0;
        }];
        

        self.fromSubTitleLabel.hidden = YES;
        self.fromValueLabel.hidden = YES;
        
        [self.fromView layoutIfNeeded];
    }
}

- (void)setupToView {
    if (self.viewModel.toFlightArray.count > 0) {
        [self changeLabelFont:self.toLabel isSmall:YES];
        self.toValueLabel.hidden = NO;

        [UIView animateWithDuration:0.4 animations:^{
            
            self.toLabel.alpha = 0.0;
            self.toLabelTop.alpha = 1.0;
        }];
        
        self.toValueLabel.text = [self generateCSVFromSelectionArray:self.viewModel.toFlightArray];
        
        AirportSearch *airportSearch = [self.viewModel.toFlightArray objectAtIndex:0];
        NSUInteger count = self.viewModel.toFlightArray.count;

        switch (count) {
            case 1:
                self.toSubTitleLabel.text = airportSearch.city;
                self.toSubTitleLabel.hidden = NO;
                self.ToValueLabelHeight.constant = 36.0;
                self.toValueLabel.font = [UIFont fontWithName:@"SourceSansPro-SemiBold" size:26.0];
                break;
            case 2 :
                self.toSubTitleLabel.hidden = YES;
                self.ToValueLabelHeight.constant = 60.0;
                self.toValueLabel.font = [UIFont fontWithName:@"SourceSansPro-SemiBold" size:20.0];
                break;
            case 3 :
                self.toSubTitleLabel.hidden = YES;
                self.ToValueLabelHeight.constant = 60.0;
                self.toValueLabel.font = [UIFont fontWithName:@"SourceSansPro-SemiBold" size:20.0];
                break;
            default:
                break;
        }
        
        
        [self.toView layoutIfNeeded];
        
    }else {
        [self changeLabelFont:self.toLabel isSmall:NO];
        self.toSubTitleLabel.hidden = YES;
        self.toValueLabel.hidden = YES;
        
        [UIView animateWithDuration:0.4 animations:^{
            
            self.toLabel.alpha = 1.0;
            self.toLabelTop.alpha = 0.0;
            
        }];
        
        [self.toView layoutIfNeeded];
    }
}

- (void)setupFromAndToView {
    
    [self setupFromView];
    [self setupToView];
    [self setupSwitcherButton];
    [self changeColorTab];
}

-(void)setupSwitcherButton{
    
    
    self.switcherButtonBlurBackground.layer.cornerRadius = 22.0;
    self.switcherButtonBlurBackground.clipsToBounds = YES;
    
    
}
- (void)changeColorTab {
    if (self.viewModel.isFrom) {

        [UIView animateWithDuration:0.2 animations:^{
            self.BackgroundViewLeadingConstraint.constant = 0;
            [self.TopView layoutIfNeeded];
        }];
        
        [self.fromLabel setTextColor:[UIColor GREEN_BLUE_COLOR]];
        [self.fromLabel setFont:[UIFont fontWithName:@"SourceSansPro-SemiBold" size:18]];
        [self.fromLabelTop setTextColor:[UIColor GREEN_BLUE_COLOR]];
        [self.fromLabelTop setFont:[UIFont fontWithName:@"SourceSansPro-SemiBold" size:16]];
        [self.toLabelTop setTextColor:[UIColor ONE_FIVE_THREE_COLOR]];
        [self.toLabelTop setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:16]];
        [self.toLabel setTextColor:[UIColor ONE_FIVE_THREE_COLOR]];
        [self.toLabel setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:18]];
        
    }else {
        [self.toLabelTop setTextColor:[UIColor GREEN_BLUE_COLOR]];
        [self.toLabelTop setFont:[UIFont fontWithName:@"SourceSansPro-SemiBold" size:16]];
        [self.toLabel setFont:[UIFont fontWithName:@"SourceSansPro-SemiBold" size:18]];
        [self.toLabel setTextColor:[UIColor GREEN_BLUE_COLOR]];
        [self.fromLabelTop setTextColor:[UIColor ONE_FIVE_THREE_COLOR]];
        [self.fromLabelTop setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:16]];
        [self.fromLabel setTextColor:[UIColor ONE_FIVE_THREE_COLOR]];
        [self.fromLabel setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:18]];
        
        
        [UIView animateWithDuration:0.2 animations:^{
            self.BackgroundViewLeadingConstraint.constant = self.view.frame.size.width/2;
            [self.TopView layoutIfNeeded];
        }];
    }
}

- (NSString *)generateCSVFromSelectionArray:(NSArray *)array {
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    for (AirportSearch *airportSearch in array) {
        [resultArray addObject:airportSearch.iata];
    }
    
    if (!array) {
        return @"";
    }
    if (array.count == 0) {
        return @"";
    }
    
    if (array.count == 1 ) {
        return [resultArray firstObject];
    }
    
    NSString *outputString = @"";
    for (int i = 0; i<array.count; i++) {
        outputString = [outputString stringByAppendingString:resultArray[i]];
        if (i != array.count - 1) {
            outputString = [outputString stringByAppendingString:@", "];
        }
        if (i == array.count - 2) {
            outputString = [outputString stringByAppendingString:@"\n"];
        }
    }
    
    return outputString;
}

- (IBAction)fromAction:(id)sender {
    self.viewModel.isFrom = YES;
    [self setupFromAndToView];
    self.searchBar.text = @"";
    self.airportDisplayArray = [[NSMutableArray alloc] init];
    self.displaySections = [[NSMutableDictionary alloc] init];
    [self refreshAllUIElements];
    [self performNearbyAirportsSearch];
}

- (IBAction)toAction:(id)sender {
    self.viewModel.isFrom = NO;
    [self setupFromAndToView];
  
    self.searchBar.text = @"";
    self.airportDisplayArray = [[NSMutableArray alloc] init];
    self.displaySections = [[NSMutableDictionary alloc] init];
    [self refreshAllUIElements];
    [self performNearbyAirportsSearch];
}

- (IBAction)InvertAirportSelection:(UIButton*)sender {
    
    
    if ( self.viewModel.fromFlightArray.count == 0 &  self.viewModel.toFlightArray.count == 0 ) {
        return;
    }
    
    [self performAirportSwitch];
        
    [UIView animateWithDuration:0.2 animations:^{
        if (CGAffineTransformEqualToTransform(sender.transform, CGAffineTransformIdentity)) {
            sender.transform = CGAffineTransformMakeRotation(M_PI * 0.999);
        } else {
            sender.transform = CGAffineTransformIdentity;
        }
    }];
}

- (IBAction)doneAction:(id)sender {
    
    
    for( AirportSearch * fromAirport in self.viewModel.fromFlightArray) {
        for ( AirportSearch * toAirport in self.viewModel.toFlightArray) {
        
            if ([fromAirport.iata isEqualToString:toAirport.iata]) {
             
                [AertripToastView toastInView:self.view withText:@"Origin and destination cannot be same"];
                return;
            }
        }
    }
    
    [self.viewModel onDoneButtonTapped];
    [self animateBottomViewOut];
}


- (void)changeLabelFont:(UILabel *)label isSmall:(BOOL)isSmall {
    if (isSmall) {
        [label setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:16.0]];
    }else {
        [label setFont:[UIFont fontWithName:@"SourceSansPro-SemiBold" size:18.0]];
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//MARK:- Core location Services Delegate Methods

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{

    NSLog(@"Error: %@",error.description);
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currentLocation = [locations lastObject];
    [self.locationManager stopUpdatingLocation];
    [self performNearbyAirportsByLocation:currentLocation];
}

- (void)performAirportSwitch {
    
    //    [self performAnimationForPlaceholderLabels];
    [self performAirportSwapAnimationForSubTitle];
    [self performAnimationForValueLabels];
    [self airportSwapOnModelView];
}

- (void)swapPositionOfLabels:(UILabel *)leftLabel rightLabel:(UILabel *)rightLabel {
    UILabel * originAnimationLabel =  [self deepLabelCopy:leftLabel];
    UILabel * destinationAnimationLabel =  [self deepLabelCopy:rightLabel];
    
    UIColor * previousColor = leftLabel.textColor;
    
    leftLabel.textColor = [UIColor clearColor];
    rightLabel.textColor = [UIColor clearColor];
    
    [self.fromView addSubview:originAnimationLabel];
    [self.fromView addSubview:destinationAnimationLabel];


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

- (void)performAirportSwapAnimationForSubTitle {
    
    if ( self.toSubTitleLabel.isHidden && self.fromSubTitleLabel.isHidden ) {
        return;
    }
    
    UILabel * leftLabel = self.fromSubTitleLabel;
    UILabel * rightLabel = self.toSubTitleLabel;
    
    [self swapPositionOfLabels:leftLabel rightLabel:rightLabel];
}


-(void)animateLabel:(UILabel*)sourceLabel targetLabel:(UILabel*)targetLabel {
    
    UILabel *labelCopy = [self deepLabelCopy:sourceLabel];
    UIColor * previousColor = self.fromLabel.textColor;
    
    [labelCopy setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:16.0]];
    sourceLabel.textColor = [UIColor clearColor];
    [self.fromView addSubview:labelCopy];
    
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
    
        [self animateLabel:self.fromLabel targetLabel:self.fromLabelTop];
    }
    
    
    if (!self.toLabel.isHidden) {
        
        [self animateLabel:self.toLabel targetLabel:self.toLabelTop];
        
    }
    
}

- (void)performAnimationForValueLabels {
    
    UILabel * leftLabel = self.fromValueLabel;
    UILabel * rightLabel = self.toValueLabel;
    
    [self swapPositionOfLabels:leftLabel rightLabel:rightLabel];
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


@end