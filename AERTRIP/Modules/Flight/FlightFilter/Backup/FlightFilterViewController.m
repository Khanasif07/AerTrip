//
//  FlightFilterViewController.m
//  Aertrip
//
//  Created by Kakshil Shah on 8/27/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//



//selectedIndex 0 = Sort
//selectedIndex 1 = Stops
//selectedIndex 2 = Times
//selectedIndex 3 = Duration
//selectedIndex 4 = Airlines
//selectedIndex 5 = Airports
//selectedIndex 6 = Quality
//selectedIndex 7 = Price

#import "FlightFilterViewController.h"
#import "TwoImageViewAndLabelTableViewCell.h"
#import "TwoLabelAndImageViewTableViewCell.h"
#import "LabelImageTableViewCell.h"
#import "AirportTableViewCell.h"
#import "SimpleLabelTableViewCell.h"


@interface FlightFilterViewController ()
@property (assign, nonatomic) NSRange learMoreRange;
@property (strong,nonatomic) NSArray *filterSectionArray;

@property (strong,nonatomic) NSArray *apiArray;
@property (strong,nonatomic) NSArray *qualityArray;
@property (strong,nonatomic) NSArray *airlinesArray;
@property (strong,nonatomic) NSArray *stopsArray;
@property (strong,nonatomic) NSArray *sortArray;
@property (strong,nonatomic) NSMutableArray *airportDepartureArray;
@property (strong,nonatomic) NSMutableArray *airportArrivalArray;
@property (strong,nonatomic) NSMutableArray *airportLayoverArray;

@property (assign, nonatomic) NSInteger selectedIndex;

@end

@implementation FlightFilterViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupInitials];
}

- (void)setupInitials {
    self.delegate = self;
    self.learMoreRange = NSMakeRange(self.smartSortDescriptionLabel.text.length - 10, 10);
    [self makeLabelClickableBounds:self.smartSortDescriptionLabel range
                                  :self.learMoreRange];

    self.apiArray = @[@"Riya", @"TP", @"Indigo"];
    self.qualityArray = @[@"Hide Overnight Flight Itineraries", @"Hide Overnight Layover Itineraries", @"Hide Change Airport Itineraries", @"Show Longer or More Expensive Flights"];
    self.sortArray = @[@{@"title":@"Smart", @"value": @"Recommended"}, @{@"title":@"Price", @"value": @"Low to high"}, @{@"title":@"Depart", @"value": @"Earliest first"},@{@"title":@"Duration", @"value": @"Shortest first"}];
    self.stopsArray = @[@"Nonstop only", @"Upto 1 stop", @"Upto 2 stops", @"Any number of stops"];
    
    //*** set dynamic later
    self.airlinesArray = [[NSArray alloc] init];
    Itemable *itemable = [Itemable new];
    itemable.itemHeader = @"Mumbai";
    itemable.itemSectionArray = [[NSMutableArray alloc] init];
    AirportSearch *airportSearch = [AirportSearch new];
    airportSearch.iata = @"BOM";
    airportSearch.airport = @"Chhatrapati Shivaji International Airport";
    airportSearch.city = @"Mumbai";
    airportSearch.countryCode = @"IN";
    [itemable.itemSectionArray addObject:airportSearch];
    [itemable.itemSectionArray addObject:airportSearch];

    self.airportDepartureArray = [[NSMutableArray alloc] init];
   // [self.airportDepartureArray addObject:itemable];
    
    self.airportArrivalArray = [[NSMutableArray alloc] init];
  //  [self.airportArrivalArray addObject:itemable];

    self.airportLayoverArray = [[NSMutableArray alloc] init];
  //  [self.airportLayoverArray addObject:itemable];
    //****
    
   

   

    
    [self setupSegmentControl];
    [self setupTableView];
    [self setupRangeSliders];
    [self setupMultiCityTopSegmant];
    [self setupIsRefundableFareButton];
    [self adjustAsPerTopBar];
    

}
- (void)setupTableView {
    self.filterTableView.dataSource = self;
    self.filterTableView.delegate = self;
    
    self.departureTableView.delegate = self;
    self.departureTableView.dataSource = self;
    self.departureTableView.rowHeight = UITableViewAutomaticDimension;
    self.departureTableView.estimatedRowHeight = 44.0;

    self.arrivalTableView.delegate = self;
    self.arrivalTableView.dataSource = self;
    self.arrivalTableView.rowHeight = UITableViewAutomaticDimension;
    self.arrivalTableView.estimatedRowHeight = 44.0;

    self.layoverTableView.delegate = self;
    self.layoverTableView.dataSource = self;
    self.layoverTableView.rowHeight = UITableViewAutomaticDimension;
    self.layoverTableView.estimatedRowHeight = 64.0;

}
- (void)setupDepatureFrame {
    self.departureBlurViewLeadingConstraint.constant = self.departureRangeSlider.leftThumbView.frame.origin.x;
    self.departureBlurViewTralingConstraint.constant = self.departureImagesView.frame.size.width - self.departureRangeSlider.rightThumbView.frame.origin.x - self.departureRangeSlider.rightThumbView.frame.size.width;
    [self.departureImagesView layoutIfNeeded];
}

- (void)reloadAirportView {
   
    [self reloadAirportDepartureView];
    [self reloadAirportArrivalView];
    [self reloadAirportLayoverView];

}

- (void)reloadAirportDepartureView {
    [self.departureTableView reloadData];
    if (self.airportDepartureArray.count > 0) {
        self.departureViewHeightConstraint.constant = 2000;
        self.departureTableHeightConstraint.constant = self.departureTableView.contentSize.height;
    }else {
        self.departureViewHeightConstraint.constant = 0;
        self.departureTableHeightConstraint.constant = 0.0;
    }
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    [self.view layoutSubviews];

}

- (void)reloadAirportArrivalView {
    [self.arrivalTableView reloadData];
    if (self.airportArrivalArray.count > 0) {
        self.arrivalViewHeightConstraint.constant = 2000;
        self.arrivalTableHeightConstraint.constant = self.arrivalTableView.contentSize.height;
    }else {
        self.arrivalViewHeightConstraint.constant = 0;
        self.arrivalTableHeightConstraint.constant = 0.0;
    }
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    [self.view layoutSubviews];

}

- (void)reloadAirportLayoverView {
    [self.layoverTableView reloadData];
    if (self.airportLayoverArray.count > 0) {
        self.layoverViewHeightConstraint.constant = 2000;
        self.layoverTableHeightConstraint.constant = self.layoverTableView.contentSize.height;
    }else {
        self.layoverViewHeightConstraint.constant = 0;
        self.layoverTableHeightConstraint.constant = 0.0;
    }
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    [self.view layoutSubviews];

    
}

//MARK:- SETUP MULTI CITY SEGMENT CONTROL

- (void)setupMultiCityTopSegmant {
    if (self.isMultiCity) {
        self.multiCitySegmentWrapperHeightConstraint.constant = 50;
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (int i = 0 ; i < 5 ; i++) {
            [array addObject:[NSString stringWithFormat:@"%d", i+1]];
        }
        [self.multiCitySegmentControl initWithItems:array] ;
        self.multiCitySegmentControl.selectedSegmentIndex = 0;
    }else {
        self.multiCitySegmentWrapperHeightConstraint.constant = 0;
    }
}

- (IBAction)changeMultiCitySegmentAction:(id)sender {
    
}


//MARK:- SEGMENT CONTROL


- (void) setupSegmentControl {
    
    self.filterSectionArray = @[@"Sort", @"Stops", @"Times", @"Duration", @"Airlines", @"Airports", @"Quality", @"Price", @"API"];
    
    
    [self.topSegmentControl setSectionTitles:self.filterSectionArray];
    self.topSegmentControl.backgroundColor = [UIColor clearColor];
    self.topSegmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.topSegmentControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleDynamic;
    self.topSegmentControl.segmentEdgeInset = UIEdgeInsetsMake(0, 20.0, 0, 20.0);
    self.topSegmentControl.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(0, 20.0, 0, 40.0);
    
    self.topSegmentControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    // self.topSegmentControl.frame = CGRectMake(0, 64, self.view.frame.size.width, 46);
    self.topSegmentControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.topSegmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.topSegmentControl.selectionIndicatorHeight = 2;
    self.topSegmentControl.verticalDividerEnabled = NO;
    self.topSegmentControl.selectionIndicatorColor = [self getAppColor];
    
    self.topSegmentControl.titleTextAttributes = @{NSForegroundColorAttributeName : UIColor.FIVE_ONE_COLOR, NSFontAttributeName:[UIFont fontWithName:@"SourceSansPro-Regular" size:16]};
    
    self.topSegmentControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : UIColor.FIVE_ONE_COLOR, NSFontAttributeName:[UIFont fontWithName:@"SourceSansPro-Semibold" size:16]};
    
    self.topSegmentControl.borderType = HMSegmentedControlBorderTypeNone;
    self.topSegmentControl.selectedSegmentIndex = 0;
    // [self setupSwipe];
}

- (IBAction)segmentChanged:(id)sender {
    [self adjustAsPerTopBar];
}

- (void) adjustAsPerTopBar {
    
    self.selectedIndex = self.topSegmentControl.selectedSegmentIndex;
    [self hideAllSection];
    switch (self.selectedIndex) {
        case 0:
        {
            self.smartSortView.hidden = NO;

        }
        case 1:
        case 4:
        case 6:
        case 8:
        {
            self.filterTableView.hidden = NO;
            [self.filterTableView reloadData];
            break;
        }
        case 2:
        {
            self.timesView.hidden = NO;
            break;

        }
        case 3:
        {
            self.durationView.hidden = NO;
            break;

        }
        case 5:
        {
            self.airportView.hidden = NO;
            [self reloadAirportView];
            break;
        }
        case 7:
        {
            self.priceView.hidden = NO;
            break;
        }
        default:
            break;
    }

}
- (void)hideAllSection {
    self.filterTableView.hidden = YES;
    self.timesView.hidden = YES;
    self.durationView.hidden = YES;
    self.airportView.hidden = YES;
    self.priceView.hidden = YES;
    self.smartSortView.hidden = YES;

}
//MARK:- TABLE VIEW
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.selectedIndex == 5 && tableView == self.departureTableView) {
        return self.airportDepartureArray.count;
    }
    if (self.selectedIndex == 5 && tableView == self.arrivalTableView) {
        return self.airportArrivalArray.count;
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (self.selectedIndex) {
        case 0:
            return self.sortArray.count;
            break;
        case 1:
            return self.stopsArray.count;
            break;
        case 4:
            return self.airlinesArray.count;
            break;
        case 5:
        {
            if (tableView == self.departureTableView) {
                return self.airportDepartureArray.count;
            }else if (tableView == self.arrivalTableView) {
                return self.airportArrivalArray.count;

            }else if (tableView == self.layoverTableView) {
                return self.airportLayoverArray.count;
            }
            break;
        }
        case 6:
            return self.qualityArray.count;
            break;
        case 8:
            return self.apiArray.count;
            break;
        default:
            break;
    }
    
    return 0;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.selectedIndex == 5 && ( tableView == self.departureTableView || tableView == self.arrivalTableView))
    return 35.0;
    
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedIndex == 5 && tableView == self.layoverTableView) {
        return 64.0;
    }
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.selectedIndex == 5 && ( tableView == self.departureTableView || tableView == self.arrivalTableView)) {
        
    
        static NSString *cellIdentifier = @"HeaderCell";
        SimpleLabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[SimpleLabelTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        Itemable *itemable;
        if (tableView == self.departureTableView) {
            itemable = [self.airportDepartureArray objectAtIndex:section];
        }else if (tableView == self.arrivalTableView) {
            itemable = [self.airportArrivalArray objectAtIndex:section];
        }
        cell.mainLabel.text = itemable.itemHeader;
        
        return [cell contentView];
    }
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (self.selectedIndex) {
        case 0: {
            static NSString *cellIdentifier = @"SortCell";
            TwoLabelAndImageViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[TwoLabelAndImageViewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSDictionary *sortDict =  [self.sortArray objectAtIndex:indexPath.row];
            
            
            cell.mainLabel.text = [sortDict objectForKey:@"title"];
            cell.subLabel.text = [sortDict objectForKey:@"value"];;
            
            if ([[sortDict objectForKey:@"title"] isEqualToString:[self.flightFilter.sortSelected objectForKey:@"title"]]) {
                [cell.coreImageView setImage:AppImages.greenTick];
            }else {
                [cell.coreImageView setImage:nil];
            }
            return  cell;
            break;
        }case 1: {
            static NSString *cellIdentifier = @"LabelImageCell";
            LabelImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[LabelImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NSString *name =  [self.stopsArray objectAtIndex:indexPath.row];
            cell.titleLabel.text = name;

            if ([name isEqualToString:self.flightFilter.stopSelected]) {
                [cell.coreImageView setImage:AppImages.greenTick];
            }else {
                [cell.coreImageView setImage:nil];
            }
            
            return  cell;
            
        }
        case 4: {
            static NSString *cellIdentifier = @"TwoImageLabelCell";
            TwoImageViewAndLabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[TwoImageViewAndLabelTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSDictionary *dictionary =  [self.airlinesArray objectAtIndex:indexPath.row];
            
            
            cell.mainLabel.text = [dictionary objectForKey:@"name"];
            [cell.mainImageView setImage:[UIImage imageNamed:[dictionary objectForKey:@"iconName"]]];
            
            if ([self isAirlineSelected:dictionary]) {
                [cell.secondaryImageView setImage:AppImages.selectOption];
            }else {
                [cell.secondaryImageView setImage:AppImages.unSelectOption];
            }
            
            return  cell;
            
        }
        case 5: {
            AirportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AirportCell"];
            if (cell == nil) {
                NSArray *customCell = [[NSBundle mainBundle] loadNibNamed:@"AirportTableViewCell" owner:self options:nil];
                cell = [customCell objectAtIndex:0];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.vierticalLineView.hidden = YES;
            cell.horizontalLineView.hidden = YES;
            Itemable *itemable;
            NSMutableArray *selectedArray;
            if (tableView == self.departureTableView) {
                itemable = [self.airportDepartureArray objectAtIndex:indexPath.section];
                selectedArray = self.flightFilter.airportDepartureSelectedArray;
            }else if (tableView == self.arrivalTableView) {
                 itemable = [self.airportArrivalArray objectAtIndex:indexPath.section];
                selectedArray = self.flightFilter.airportArrivalSelectedArray;
            }else if (tableView == self.layoverTableView){
                 itemable = [self.airportLayoverArray objectAtIndex:indexPath.section];
                selectedArray = self.flightFilter.airportLayoverSelectedArray;
            }
            AirportSearch *airportSearch = [itemable.itemSectionArray objectAtIndex:indexPath.row];
            cell.flightShortNameLabel.text = airportSearch.iata;
            cell.distanceLabel.text = @"";
            if (tableView == self.layoverTableView) {
                cell.secondaryLabel.text = airportSearch.airport;
                cell.mainLabel.text = [NSString stringWithFormat:@"%@, %@",airportSearch.city, airportSearch.countryCode];
            }else {
                cell.mainLabel.text = airportSearch.airport;
                cell.secondaryLabel.text = @"";
            }
            
            if ([self isAirportSelected:airportSearch forArray:selectedArray]) {
                
//                [cell.addRemoveButton setImage:[UIImage imageNamed:@"selectOption"] forState:UIControlStateNormal];
            }else {
//                [cell.addRemoveButton setImage:[UIImage imageNamed:@"unSelectOption"] forState:UIControlStateNormal];
            }
            
            return  cell;
            
        }
        case 6: {
            static NSString *cellIdentifier = @"LabelImageCell";
            LabelImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[LabelImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NSString *name =  [self.qualityArray objectAtIndex:indexPath.row];
            cell.titleLabel.text = name;
            
            if ([self isObjectSelected:self.flightFilter.qualitySelectedArray object:name]) {
                [cell.coreImageView setImage:AppImages.selectOption];
            }else {
                [cell.coreImageView setImage:AppImages.unSelectOption];
            }
            
            return  cell;
            
        }
        case 8: {
            static NSString *cellIdentifier = @"LabelImageCell";
            LabelImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[LabelImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NSString *name =  [self.apiArray objectAtIndex:indexPath.row];
            cell.titleLabel.text = name;
            
            if ([self isObjectSelected:self.flightFilter.apiSelectedArray object:name]) {
                [cell.coreImageView setImage:AppImages.selectOption];
            }else {
                [cell.coreImageView setImage:AppImages.unSelectOption];
            }
            
            return  cell;
            
        }
        default:
            break;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    switch (self.selectedIndex) {
        case 0:
        {
            NSDictionary *sortDict =  [self.sortArray objectAtIndex:indexPath.row];
            if ([[sortDict objectForKey:@"title"] isEqualToString:[self.flightFilter.sortSelected objectForKey:@"title"]]) {
                self.flightFilter.sortSelected = [[NSDictionary alloc] init];
            }else {
                self.flightFilter.sortSelected = sortDict;
            }
            [self.filterTableView reloadData];
            break;
        }
        case 1:
        {
            NSString *name =  [self.stopsArray objectAtIndex:indexPath.row];
            if ([self.flightFilter.stopSelected isEqualToString:name]) {
                self.flightFilter.stopSelected = @"";
            }else {
                self.flightFilter.stopSelected = name;
            }
            [self.filterTableView reloadData];
            break;
        }
        case 4: {
            NSDictionary *dictionary =  [self.airlinesArray objectAtIndex:indexPath.row];
            if ([self isAirlineSelected:dictionary]) {
                [self removeAirlineFromArray:dictionary];
            }else {
                [self.flightFilter.airlinesSelectedArray addObject:dictionary];

            }
            [self.filterTableView reloadData];
            break;
        }
        case 5:
        {
            Itemable *itemable;
            if (tableView == self.departureTableView) {
                itemable = [self.airportDepartureArray objectAtIndex:indexPath.section];
                AirportSearch *airportSearch = [itemable.itemSectionArray objectAtIndex:indexPath.row];
                if ([self isAirportSelected:airportSearch forArray:self.flightFilter.airportDepartureSelectedArray]) {
                    [self removeAirportSelected:airportSearch forArray:self.flightFilter.airportDepartureSelectedArray];
                } else {
                    [self.flightFilter.airportDepartureSelectedArray addObject:airportSearch];
                }
                [self reloadAirportDepartureView];
            }else if (tableView == self.arrivalTableView) {
                itemable = [self.airportArrivalArray objectAtIndex:indexPath.section];
                AirportSearch *airportSearch = [itemable.itemSectionArray objectAtIndex:indexPath.row];
                if ([self isAirportSelected:airportSearch forArray:self.flightFilter.airportArrivalSelectedArray]) {
                    [self removeAirportSelected:airportSearch forArray:self.flightFilter.airportArrivalSelectedArray];
                } else {
                    [self.flightFilter.airportArrivalSelectedArray addObject:airportSearch];
                }
                [self reloadAirportArrivalView];

            }else if (tableView == self.layoverTableView){
                itemable = [self.airportLayoverArray objectAtIndex:indexPath.section];
                AirportSearch *airportSearch = [itemable.itemSectionArray objectAtIndex:indexPath.row];
                if ([self isAirportSelected:airportSearch forArray:self.flightFilter.airportLayoverSelectedArray]) {
                    [self removeAirportSelected:airportSearch forArray:self.flightFilter.airportLayoverSelectedArray];
                } else {
                    [self.flightFilter.airportLayoverSelectedArray addObject:airportSearch];
                }
                [self reloadAirportLayoverView];

            }
            
            break;

        }
        case 6:
        {
            NSString *name =  [self.qualityArray objectAtIndex:indexPath.row];
            if ([self isObjectSelected:self.flightFilter.qualitySelectedArray object:name]) {
                [self removeObjectFromoArray:self.flightFilter.qualitySelectedArray object:name];
                
            }else {
                [self.flightFilter.qualitySelectedArray addObject:name];
            }
            [self.filterTableView reloadData];
            break;
            
        }
        case 8:
        {
            NSString *name =  [self.apiArray objectAtIndex:indexPath.row];
            if ([self isObjectSelected:self.flightFilter.apiSelectedArray object:name]) {
                [self removeObjectFromoArray:self.flightFilter.apiSelectedArray object:name];
                
            }else {
                [self.flightFilter.apiSelectedArray addObject:name];
            }
            [self.filterTableView reloadData];
            break;
            
        }
        default:
            break;
    }
    
}

//MARK:- SMART FUNCTIONS

- (BOOL)isAirportSelected: (AirportSearch *)airportSearch forArray:(NSArray *)array{
    for (AirportSearch *airportSearchObj in array) {
        if ([airportSearchObj.iata isEqualToString:airportSearch.iata]) {
            return true;
        }
    }
    return false;
}
- (void)removeAirportSelected: (AirportSearch *)airportSearch forArray:(NSMutableArray *)selectedArray{
    for (AirportSearch *airportSearchObj in selectedArray) {
        if ([airportSearchObj.iata isEqualToString:airportSearch.iata]) {
            [selectedArray removeObject:airportSearchObj];
            break;
        }
    }
}

- (BOOL)isObjectSelected:(NSMutableArray *)selectedArray object:(NSString *)name {
    for (NSString *nameString in selectedArray) {
        if ([nameString isEqualToString:name]) {
            return true;
        }
    }
    return false;
}

- (void)removeObjectFromoArray:(NSMutableArray *)selectedArray object:(NSString *)name {
    for (NSString *nameString in selectedArray) {
        if ([nameString isEqualToString:name]) {
            [selectedArray removeObject:nameString];
            break;
        }
    }
}
- (BOOL)isAirlineSelected:(NSDictionary *)dictionary {
    NSString *name = [dictionary objectForKey:@"name"];
    for (NSDictionary *dictionary in self.flightFilter.airlinesSelectedArray) {
        if ([[dictionary objectForKey:@"name"] isEqualToString:name]) {
            return true;
        }
    }
    return false;
}

- (void)removeAirlineFromArray:(NSDictionary *)dictionary {
    NSString *name = [dictionary objectForKey:@"name"];
    
    for (NSDictionary *dictionary in self.flightFilter.airlinesSelectedArray) {
        if ([[dictionary objectForKey:@"name"] isEqualToString:name]) {
            [self.flightFilter.airlinesSelectedArray removeObject:dictionary];
            break;
        }
    }
}

- (void)setupIsRefundableFareButton {
    if (self.flightFilter.isRefundableFare) {
        [self.refundableSelectedButton setImage:AppImages.selectOption forState:UIControlStateNormal];
    }else {
        [self.refundableSelectedButton setImage:AppImages.unSelectOption forState:UIControlStateNormal];
    }
}

//MARK:-PRICE RANGE SLIDER

- (void)setupRangeSliders {
    //price slider
    [self.priceRangeSlider addTarget:self
                              action:@selector(setPriceLabels)
                    forControlEvents:UIControlEventValueChanged];
    [self.priceRangeSlider setMinValue:5000 maxValue:10000];
    [self.priceRangeSlider setLeftValue:[self.flightFilter.priceRangeLow doubleValue] rightValue:[self.flightFilter.priceRangeHigh doubleValue]];
    [self setupImagesToSlider:self.priceRangeSlider];
    self.priceRangeSlider.minimumDistance = 1000;
    [self setPriceLabels];
    
    //Timings sliders
    [self.departureRangeSlider addTarget:self
                              action:@selector(setDepartureTimeLabel)
                    forControlEvents:UIControlEventValueChanged];
    [self.departureRangeSlider setMinValue:0.0 maxValue:24.0];
    [self.departureRangeSlider setLeftValue:[self.flightFilter.departureTimeRangeLow doubleValue] rightValue:[self.flightFilter.departureTimeRangeHigh doubleValue]];
    [self setupImagesToSlider:self.departureRangeSlider];
    self.departureRangeSlider.minimumDistance = 1;
    [self setDepartureTimeLabel];
    [self giveBorderToView:self.departureImagesView withColor: UIColor.TWO_THREE_ZERO_COLOR withBorderWidth:1.0 withRadius:10.0];

    
    [self.arrivalRangeSlider addTarget:self
                                  action:@selector(setArrivalTimeLabels)
                        forControlEvents:UIControlEventValueChanged];
    [self.arrivalRangeSlider setMinValue:0.0 maxValue:24.0];
    [self.arrivalRangeSlider setLeftValue:[self.flightFilter.arrivalTimeRangeLow doubleValue] rightValue:[self.flightFilter.arrivalTimeRangeHigh doubleValue]];
    [self setupImagesToSlider:self.arrivalRangeSlider];
    self.arrivalRangeSlider.minimumDistance = 1;
    [self setArrivalTimeLabels];
    
    
    //Duration sliders
    [self.tripDurationRangeSlider addTarget:self
                                  action:@selector(setTripDurationLabels)
                        forControlEvents:UIControlEventValueChanged];
    [self.tripDurationRangeSlider setMinValue:0.0 maxValue:24.0];
    [self.tripDurationRangeSlider setLeftValue:[self.flightFilter.tripDurationRangeLow doubleValue] rightValue:[self.flightFilter.tripDurationRangeHigh doubleValue]];
    [self setupImagesToSlider:self.tripDurationRangeSlider];
    self.tripDurationRangeSlider.minimumDistance = 1;
    [self setTripDurationLabels];
    
    [self.layoverDurationRangeSlider addTarget:self
                                action:@selector(setLayoverDurationLabels)
                      forControlEvents:UIControlEventValueChanged];
    [self.layoverDurationRangeSlider setMinValue:0.0 maxValue:24.0];
    [self.layoverDurationRangeSlider setLeftValue:[self.flightFilter.layoverDurationRangeLow doubleValue] rightValue:[self.flightFilter.layoverDurationRangeHigh doubleValue]];
    [self setupImagesToSlider:self.layoverDurationRangeSlider];
    self.layoverDurationRangeSlider.minimumDistance = 1;
    [self setLayoverDurationLabels];
}

- (void)setupImagesToSlider:(MARKRangeSlider *)rangeSlider {
    [rangeSlider setTrackImage: AppImages.greyColorTrack];
    [rangeSlider setLeftThumbImage: AppImages.sliderHandle];
    [rangeSlider setRightThumbImage: AppImages.sliderHandle];
    [rangeSlider setRangeImage: AppImages.greenBlueRangeImage];
}
- (void)rangeSliderValueDidChange:(MARKRangeSlider *)slider {
    [self setPriceLabels];
}


- (void)setPriceLabels {
    
    self.flightFilter.priceRangeLow = [NSString stringWithFormat:@"%0.0f",self.priceRangeSlider.leftValue];
    self.flightFilter.priceRangeHigh = [NSString stringWithFormat:@"%0.0f",self.priceRangeSlider.rightValue];

    self.priceFromValueLabel.text = [NSString stringWithFormat:@"₹%@",self.flightFilter.priceRangeLow];
    self.priceToValueLabel.text = [NSString stringWithFormat:@"₹%@",self.flightFilter.priceRangeHigh];
    
}
- (void)setDepartureTimeLabel {
    self.flightFilter.departureTimeRangeLow = [NSString stringWithFormat:@"%0.0f",self.departureRangeSlider.leftValue];
    self.flightFilter.departureTimeRangeHigh = [NSString stringWithFormat:@"%0.0f",self.departureRangeSlider.rightValue];
    self.departureTimeValueLabel.text = [NSString stringWithFormat:@"%@-%@",self.flightFilter.departureTimeRangeLow, self.flightFilter.departureTimeRangeHigh];
    [self setupDepatureFrame];

}
- (void)setArrivalTimeLabels {
    self.flightFilter.arrivalTimeRangeLow = [NSString stringWithFormat:@"%0.0f",self.arrivalRangeSlider.leftValue];
    self.flightFilter.arrivalTimeRangeHigh = [NSString stringWithFormat:@"%0.0f",self.arrivalRangeSlider.rightValue];
    self.arrivalFromTimeValueLabel.text = [NSString stringWithFormat:@"%@",self.flightFilter.arrivalTimeRangeLow];
    self.arrivalToTimeValueLabel.text = [NSString stringWithFormat:@"%@",self.flightFilter.arrivalTimeRangeHigh];
}
- (void)setTripDurationLabels {
    self.flightFilter.tripDurationRangeLow = [NSString stringWithFormat:@"%0.0f",self.tripDurationRangeSlider.leftValue];
    self.flightFilter.tripDurationRangeHigh = [NSString stringWithFormat:@"%0.0f",self.tripDurationRangeSlider.rightValue];

    self.tripDurationFromValueLabel.text = [NSString stringWithFormat:@"%@hr",self.flightFilter.tripDurationRangeLow];
    self.tripDurationToValueLabel.text = [NSString stringWithFormat:@"%@hr",self.flightFilter.tripDurationRangeHigh];
}
- (void)setLayoverDurationLabels {
    self.flightFilter.layoverDurationRangeLow = [NSString stringWithFormat:@"%0.0f",self.layoverDurationRangeSlider.leftValue];
    self.flightFilter.layoverDurationRangeHigh = [NSString stringWithFormat:@"%0.0f",self.layoverDurationRangeSlider.rightValue];

    self.layoverDurationFromValueLabel.text = [NSString stringWithFormat:@"%@hr",self.flightFilter.layoverDurationRangeLow];
    self.layoverDurationToValueLabel.text = [NSString stringWithFormat:@"%@hr",self.flightFilter.layoverDurationRangeHigh];
}

//MARK:- USER INTERACTIONS

- (IBAction)departureAirportAction:(id)sender {
    
    
}


- (IBAction)arrivalAirportAction:(id)sender {
}

- (IBAction)layoverAirportAction:(id)sender {
    
    
}

- (IBAction)refundableFareAction:(id)sender {
    
    self.flightFilter.isRefundableFare = !self.flightFilter.isRefundableFare;
    [self setupIsRefundableFareButton];
}


- (void)performAction:(id)data {
    if ([data isKindOfClass:[NSNumber class]]) {
        NSInteger indexChar = [data integerValue];
        if (NSLocationInRange(indexChar, self.learMoreRange)) {
            
            //open learn more
            NSLog(@"learn more");
        }
    }
}

- (IBAction)clearAllAction:(id)sender {
    self.flightFilter.apiSelectedArray = [[NSMutableArray alloc] init];
    self.flightFilter.qualitySelectedArray = [[NSMutableArray alloc] init];
    self.flightFilter.qualitySelectedArray = [[NSMutableArray alloc] init];
    self.flightFilter.airlinesSelectedArray = [[NSMutableArray alloc] init];
    self.flightFilter.airportDepartureSelectedArray = [[NSMutableArray alloc] init];
    self.flightFilter.airportArrivalSelectedArray = [[NSMutableArray alloc] init];
    self.flightFilter.airportLayoverSelectedArray = [[NSMutableArray alloc] init];
    self.flightFilter.isRefundableFare = FLIGHT_FILTER_DEFAULT_IS_REFUNDABLEFARE;
    self.flightFilter.stopSelected = @"";

    self.flightFilter.priceRangeLow = FLIGHT_FILTER_DEFAULT_PRICE_RANGE_LOW;
    self.flightFilter.priceRangeHigh = FLIGHT_FILTER_DEFAULT_PRICE_RANGE_HIGH;
    self.flightFilter.layoverDurationRangeLow = FLIGHT_FILTER_DEFAULT_LAYOVER_RANGE_LOW;
    
    self.flightFilter.layoverDurationRangeHigh = FLIGHT_FILTER_DEFAULT_LAYOVER_RANGE_HIGH;
    self.flightFilter.tripDurationRangeLow = FLIGHT_FILTER_DEFAULT_TRIP_RANGE_LOW; self.flightFilter.tripDurationRangeHigh = FLIGHT_FILTER_DEFAULT_TRIP_RANGE_HIGH;
    
    self.flightFilter.departureTimeRangeLow = FLIGHT_FILTER_DEFAULT_DEPARTURE_TIME_RANGE_LOW; self.flightFilter.departureTimeRangeHigh = FLIGHT_FILTER_DEFAULT_DEPARTURE_TIME_RANGE_HIGH;
    self.flightFilter.arrivalTimeRangeLow = FLIGHT_FILTER_DEFAULT_ARRIVAL_TIME_RANGE_LOW; self.flightFilter.arrivalTimeRangeHigh = FLIGHT_FILTER_DEFAULT_ARRIVAL_TIME_RANGE_HIGH;

    [self.delegateFlight applyFilter:YES];

}
- (IBAction)doneAction:(id)sender {
    [self.delegateFlight applyFilter:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
