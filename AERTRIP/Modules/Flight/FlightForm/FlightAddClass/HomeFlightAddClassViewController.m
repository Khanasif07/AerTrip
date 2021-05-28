//
//  HomeFlightAddClassViewController.m
//  Aertrip
//
//  Created by Kakshil Shah on 7/11/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import "HomeFlightAddClassViewController.h"
#import "TwoImageViewAndLabelTableViewCell.h"

@class FirebaseEventLogs;

@interface HomeFlightAddClassViewController ()
@property (strong, nonatomic) NSMutableArray *classArray;
@property (strong, nonatomic) FlightClass *selectedFlightClass;
@property (assign, nonatomic) CGFloat primaryDuration;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@end

@implementation HomeFlightAddClassViewController

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
    self.bottomViewBottomConstraint.constant = -(self.bottomView.bounds.size.height);

}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self animateBottomViewIn];
    
}
- (void)createFlightClasses {
    self.classArray = [[NSMutableArray alloc] init];
    
    FlightClass *flightClassOne = [FlightClass new];
    flightClassOne.imageName = @"";
    flightClassOne.name = @"Economy";
    flightClassOne.type = ECONOMY_FLIGHT_TYPE;
    
    
    FlightClass *flightClassTwo = [FlightClass new];
    flightClassTwo.imageName = @"";
    flightClassTwo.name = @"Premium Economy";
    flightClassTwo.type = PREMIUM_FLIGHT_TYPE;
    
    FlightClass *flightClassThree = [FlightClass new];
    flightClassThree.imageName = @"";
    flightClassThree.name = @"Business";
    flightClassThree.type = BUSINESS_FLIGHT_TYPE;
    
    FlightClass *flightClassFour = [FlightClass new];
    flightClassFour.imageName = @"";
    flightClassFour.name = @"First";
    flightClassFour.type = FIRST_FLIGHT_TYPE;
    
    [self.classArray addObject:flightClassOne];
    [self.classArray addObject:flightClassTwo];
    [self.classArray addObject:flightClassThree];
    [self.classArray addObject:flightClassFour];
}

- (void)setupInitials
{
    self.selectedFlightClass = self.flightClass;
    self.primaryDuration = 0.4;
    [self createFlightClasses];
    [self setupTableView];
    [self setupBackgroundView];
    [self makeTopCornersRounded:self.bottomView withRadius:10.0];
    [self applyShadowToDoneView];
    
    [self.doneButton setTitleColor:[UIColor AertripColor] forState:UIControlStateNormal];
    [self.doneButton setTitleColor:[UIColor TWO_ZERO_FOUR_COLOR] forState:UIControlStateDisabled];
}

-(void)setupBackgroundView
{
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(animateBottomViewOut)];
    self.dimmerLayer.userInteractionEnabled = YES;
    [self.dimmerLayer addGestureRecognizer:tapGesture];
    
    UISwipeGestureRecognizer * swipeGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(animateBottomViewOut)];
    self.view.userInteractionEnabled = YES;
    swipeGesture.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeGesture];
}

- (void)setupTableView {
    
    self.classTableView.delegate = self;
    self.classTableView.dataSource = self;
    
    [self reloadTableView];
}

- (void)applyShadowToDoneView {
    
    self.doneView.clipsToBounds = NO;
    self.doneView.layer.shadowColor = [UIColor colorWithDisplayP3Red:0 green:0 blue:0 alpha:0.05].CGColor;
    self.doneView.layer.shadowOpacity = 1.0;
    self.doneView.layer.shadowRadius = 10.0;
    self.doneView.layer.shadowOffset = CGSizeMake(0.0, -6.0);
    
}

- (void)reloadTableView {
    self.classTableViewHeightConstraint.constant = self.classArray.count * 44.0;
    [self.classTableView reloadData];
}

//MARK:- TABLE VIEW
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.classArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"FlightAddClassCell";
    TwoImageViewAndLabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[TwoImageViewAndLabelTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    FlightClass *flightClass = self.classArray[indexPath.row];
    cell.mainLabel.text = flightClass.name;
    if ([self.selectedFlightClass.type isEqualToString:flightClass.type]) {
        cell.secondaryImageView.hidden = NO;
        cell.secondaryImageView.image = AppImages.greenTick;
        [cell.mainLabel setFont:[UIFont fontWithName:@"SourceSansPro-Semibold" size:18.0]];
        cell.mainLabel.textColor = [UIColor AertripColor];
        cell.mainImageView.image = [self getImageForFlightClass:flightClass isSelected:YES];
        
    }else {
        [cell.mainLabel setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:18.0]];
        cell.mainLabel.textColor = [UIColor FIVE_ONE_COLOR];
        cell.secondaryImageView.hidden = YES;
        cell.mainImageView.image = [self getImageForFlightClass:flightClass isSelected:NO];

    }
    return cell;
}


//- (NSString *)getImageNameForFlightClass:(FlightClass *)flightClass isSelected:(BOOL) isSelected{
//
//    if (isSelected) {
//        if ([flightClass.type isEqualToString:ECONOMY_FLIGHT_TYPE]) {
//            return @"EconomyClassGreen";
//        }else if ([flightClass.type isEqualToString:BUSINESS_FLIGHT_TYPE]) {
//            return @"BusinessClassGreen";
//
//        }else if ([flightClass.type isEqualToString:PREMIUM_FLIGHT_TYPE]) {
//            return @"PremiumEconomyClassGreen";
//
//        }else if ([flightClass.type isEqualToString:FIRST_FLIGHT_TYPE]) {
//            return @"FirstClassGreen";
//
//        }
//    }else {
//        if ([flightClass.type isEqualToString:ECONOMY_FLIGHT_TYPE]) {
//            return @"EconomyClassBlack";
//        }else if ([flightClass.type isEqualToString:BUSINESS_FLIGHT_TYPE]) {
//            return @"BusinessClassBlack";
//
//        }else if ([flightClass.type isEqualToString:PREMIUM_FLIGHT_TYPE]) {
//            return @"PreEconomyClassBlack";
//
//        }else if ([flightClass.type isEqualToString:FIRST_FLIGHT_TYPE]) {
//            return @"FirstClassBlack";
//
//        }
//    }
//    return @"";
//
//}

- (UIImage *)getImageForFlightClass:(FlightClass *)flightClass isSelected:(BOOL) isSelected{
   
    if (isSelected) {
        if ([flightClass.type isEqualToString:ECONOMY_FLIGHT_TYPE]) {
            return AppImages.EconomyClassGreen;
        }else if ([flightClass.type isEqualToString:BUSINESS_FLIGHT_TYPE]) {
            return AppImages.BusinessClassGreen;

        }else if ([flightClass.type isEqualToString:PREMIUM_FLIGHT_TYPE]) {
            return AppImages.PremiumEconomyClassGreen;

        }else if ([flightClass.type isEqualToString:FIRST_FLIGHT_TYPE]) {
            return AppImages.FirstClassGreen;

        }
    }else {
        if ([flightClass.type isEqualToString:ECONOMY_FLIGHT_TYPE]) {
            return AppImages.EconomyClassBlack;
        }else if ([flightClass.type isEqualToString:BUSINESS_FLIGHT_TYPE]) {
            return AppImages.BusinessClassBlack;

        }else if ([flightClass.type isEqualToString:PREMIUM_FLIGHT_TYPE]) {
            return AppImages.PreEconomyClassBlack;

        }else if ([flightClass.type isEqualToString:FIRST_FLIGHT_TYPE]) {
            return AppImages.FirstClassBlack;

        }
    }
    return AppImages.EconomyClassBlack;
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FlightClass *flightClass = self.classArray[indexPath.row];
    if (![self.selectedFlightClass.type isEqualToString:flightClass.name]) {
        self.selectedFlightClass = flightClass;
        self.flightClass = flightClass;
        
    }
    [self.classTableView reloadData];
    [self.flightClassSelectiondelegate addFlightClassAction:self.flightClass];
  
    [self performSelector:@selector(animateBottomViewOut) withObject:self afterDelay:0.1];
    
    if ([flightClass.type isEqualToString:ECONOMY_FLIGHT_TYPE]) {
        [self logEvent:@"28"];
    }else if ([flightClass.type isEqualToString:BUSINESS_FLIGHT_TYPE]) {
        [self logEvent:@"29"];
    }else if ([flightClass.type isEqualToString:PREMIUM_FLIGHT_TYPE]) {
        [self logEvent:@"30"];
    }else if ([flightClass.type isEqualToString:FIRST_FLIGHT_TYPE]) {
        [self logEvent:@"31"];
    }
}

//MARK:- BOTTOM ANIMATIONS

- (void)animateBottomViewIn {
    [UIView animateWithDuration:self.primaryDuration delay:0 options: UIViewAnimationOptionCurveEaseInOut animations:^{
        self.dimmerLayer.alpha = 0.3;
        self.bottomViewBottomConstraint.constant = 0.0;
        self.bottomViewHeight.constant = 50 + self.view.safeAreaInsets.bottom ;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}
- (void)animateBottomViewOut {
    [UIView animateWithDuration:self.primaryDuration delay:0 options: UIViewAnimationOptionCurveEaseIn animations:^{
        self.dimmerLayer.alpha = 0.0;
        self.bottomViewBottomConstraint.constant = -(self.bottomView.bounds.size.height);
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

- (IBAction)doneAction:(id)sender {
    [self logEvent:@"24"];
        [self animateBottomViewOut];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


///Firebase events log function
- (void) logEvent:(NSString *) name{
    FirebaseEventLogs *eventController = FirebaseEventLogs.shared;
    [eventController logCabinClassSelectionEvents: name];
}

@end
