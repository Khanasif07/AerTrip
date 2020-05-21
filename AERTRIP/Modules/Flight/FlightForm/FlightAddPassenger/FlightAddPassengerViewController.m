//
//  FlightAddPassengerViewController.m
//  Aertrip
//
//  Created by Kakshil Shah on 7/11/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import "FlightAddPassengerViewController.h"
#import "AertripToastView.h"

@interface FlightAddPassengerViewController ()
@property (strong, nonatomic) NSMutableArray *numberOfInfantArray;
@property (strong, nonatomic) NSMutableArray *numberOfAdultArray;
@property (strong, nonatomic) NSMutableArray *numberOfChildArray;
@property ( assign , nonatomic) CGFloat primaryDuration;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;
@property (weak, nonatomic) IBOutlet UIView *WarningView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;

@end

@implementation FlightAddPassengerViewController

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//MARK:- Additional UI Methods

- (void)setupInitials {
    self.primaryDuration = 0.4;
    [self.WarningView setHidden:YES];
    [self applyShadowToDoneView];
    [self setupBackgroundView];
    [self setupCustomPickerView];
    
}

-(void)setupBackgroundView{
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    self.dimmerLayer.userInteractionEnabled = YES;
    [self.dimmerLayer addGestureRecognizer:tapGesture];
    
    UISwipeGestureRecognizer * swipeGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    self.view.userInteractionEnabled = YES;
    swipeGesture.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeGesture];
}

-(void)dismiss {
      [self animateBottomViewOut];
}


- (void)applyShadowToDoneView {
    
    self.doneView.clipsToBounds = NO;
    self.doneView.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.05].CGColor;
    self.doneView.layer.shadowOpacity = 1.0;
    self.doneView.layer.shadowRadius = 10;
    self.doneView.layer.shadowOffset = CGSizeMake(0.0, -6.0);
    
}
//MARK:- USER INTERACTIONS
- (IBAction)doneAction:(id)sender {
    
        [self.delegate addFlightPassengerAction:self.travellerCount];
        [self animateBottomViewOut];
}

- (IBAction)adultAction:(id)sender {

}
- (IBAction)childAction:(id)sender {

}

- (IBAction)infantAction:(id)sender {

}


//MARK:- PICKER VIEW
- (void)setupCustomPickerView {
    self.numberOfInfantArray = [[NSMutableArray alloc] init];
    self.numberOfAdultArray = [[NSMutableArray alloc] init];
    self.numberOfChildArray = [[NSMutableArray alloc] init];
 
    
    int minimumPassenger = 1 ;
    int maxPassenger = 10 ;
    
    if ( self.isForBulking) {
        minimumPassenger = 10;
        maxPassenger = 101;
    }
    
    for (int i = 0 ; i < maxPassenger ; i++) {
        
        if (i >= minimumPassenger) {
            [self.numberOfAdultArray addObject:[NSString stringWithFormat:@"%ld",(long)i]];
        }
        [self.numberOfInfantArray addObject:[NSString stringWithFormat:@"%ld",(long)i]];
        [self.numberOfChildArray addObject:[NSString stringWithFormat:@"%ld",(long)i]];
        }
    
        if (self.isForBulking){
            [self.numberOfAdultArray addObject:@"100+"];
            [self.numberOfChildArray addObject:@"100+"];
            [self.numberOfInfantArray addObject:@"100+"];
        }
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    NSUInteger adultCountSelection = self.travellerCount.flightAdultCount;
    
    if (self.isForBulking){
        adultCountSelection = adultCountSelection - 10;
    }
    else {
        adultCountSelection = adultCountSelection - 1;
    }
    [self.pickerView selectRow:adultCountSelection inComponent:0 animated:YES];
    [self.pickerView selectRow:self.travellerCount.flightChildrenCount inComponent:1 animated:YES];
    [self.pickerView selectRow:self.travellerCount.flightInfantCount inComponent:2 animated:YES];

    
}
//- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
//    return 93.0;//pickerView.frame.size.width/3;
//}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 35.0;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.numberOfAdultArray.count;
    }else if (component == 1) {
        return self.numberOfChildArray.count;
    }else if (component == 2) {
        return self.numberOfInfantArray.count;
    }
    return 0;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.doneButton.enabled = NO;
    [self setPassangerSelectionInRow:row inComponent:component];
    self.doneButton.enabled = YES;
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    NSString * stringForTitle;
    if (component == 0) {
                stringForTitle = [self.numberOfAdultArray objectAtIndex:row];
    }else if (component == 1) {
               stringForTitle =  [self.numberOfChildArray objectAtIndex:row];
    }else if (component == 2) {
                stringForTitle = [self.numberOfInfantArray objectAtIndex:row];
    }
    
    UILabel * label = [[UILabel alloc] init];
    label.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:23.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = stringForTitle;
    return label;
    
}

//MARK:- BOTTOM ANIMATIONS

- (void)animateBottomViewIn {
    [UIView animateWithDuration:self.primaryDuration delay:0 options: UIViewAnimationOptionCurveEaseInOut animations:^{
        self.dimmerLayer.alpha = 0.3;
        self.bottomViewBottomConstraint.constant = 0;
        self.bottomViewHeight.constant = 50 + self.view.safeAreaInsets.bottom;
         if (self.travellerCount.flightAdultCount + self.travellerCount.flightChildrenCount > 6 ) {
            self.viewHeight.constant = 410 + self.view.safeAreaInsets.bottom;
            [self.WarningView setHidden:FALSE];
         }
         else {
            self.viewHeight.constant = 358 + self.view.safeAreaInsets.bottom;
         }
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




- (void)applyPassengerSelection:(NSInteger)component count:(NSInteger)count {
    switch (component) {
        case 0:
            self.travellerCount.flightAdultCount = count ;

            break;
        case 1 :
            self.travellerCount.flightChildrenCount = count;
            break;
        case 2 :
            self.travellerCount.flightInfantCount = count;
            break;
        default:
            break;
    }
}

- (TravellerCount *)tempTravellerCountForUIInteraction:(NSInteger)component row:(NSInteger)row {
    TravellerCount * tempTravellerCount = [[TravellerCount alloc] init];
    tempTravellerCount.flightAdultCount = self.travellerCount.flightAdultCount;
    tempTravellerCount.flightChildrenCount = self.travellerCount.flightChildrenCount;
    tempTravellerCount.flightInfantCount = self.travellerCount.flightInfantCount;
    
    switch (component) {
        case 0:
            tempTravellerCount.flightAdultCount = row + 1 ;
            if (self.isForBulking) {
                tempTravellerCount.flightAdultCount =  row +  10 ;
            }
            break;
        case 1 :
            tempTravellerCount.flightChildrenCount = row;
            break;
        case 2 :
            tempTravellerCount.flightInfantCount = row;
            break;
        default:
            break;
    }
    return tempTravellerCount;
}

-(void)setPassangerSelectionInRow:(NSInteger)row  inComponent:(NSInteger)component {
    
    TravellerCount * tempTravellerCount = [self tempTravellerCountForUIInteraction:component row:row];
    
    
    if ( self.isForBulking) {
        [self validateUserSelectionForBulkBooking:tempTravellerCount];
    }
    else {
        [self validateUserSelection:tempTravellerCount component:component row:row];
    }
    
}


-(void)validateUserSelection:(TravellerCount *)tempTravellerCount component:(NSUInteger)component row:(NSUInteger)row
{
    if ( tempTravellerCount.flightInfantCount > tempTravellerCount.flightAdultCount) {

        NSUInteger adultCount = tempTravellerCount.flightAdultCount ;
        [self.pickerView selectRow:adultCount inComponent:2 animated:YES];
        [AertripToastView toastInView:self.view withText:@"Infants should not exceed adults"];

        self.travellerCount.flightAdultCount = adultCount;
        self.travellerCount.flightInfantCount = adultCount;
        
        return;
    }

    
    if ( tempTravellerCount.flightAdultCount + tempTravellerCount.flightChildrenCount > 9 ) {
        NSString * message = [NSString stringWithFormat:@"Total passengers cannot be more than 9"];
        [AertripToastView toastInView:self.view withText:message];
        
        NSUInteger selection;
        
        if ( component == 0) {
            selection = 9 - self.travellerCount.flightChildrenCount - 1;
        }
        else {
            selection = 9 - self.travellerCount.flightAdultCount;
        }
        
        [self pickerView:self.pickerView didSelectRow:selection inComponent:component];
        [self.pickerView selectRow:selection inComponent:component animated:YES];
        
        return;
    }
    self.travellerCount = tempTravellerCount;
    
    if (self.travellerCount.flightAdultCount + self.travellerCount.flightChildrenCount > 6 ) {
        
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.viewHeight.constant = 410  + self.view.safeAreaInsets.bottom;
            [self.view layoutIfNeeded];

        } completion:^(BOOL finished){
             [self.WarningView setHidden:FALSE];
        }];
            
       
    }else {

        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.WarningView setHidden:YES];
            self.viewHeight.constant = 358 + self.view.safeAreaInsets.bottom;
            [self.view layoutIfNeeded];
          } completion:nil];
    }
}


-(void)validateUserSelectionForBulkBooking:(TravellerCount *)tempTravellerCount
{
    
    if ( tempTravellerCount.flightInfantCount > tempTravellerCount.flightAdultCount) {
        
        NSUInteger adultCount = tempTravellerCount.flightAdultCount ;
        [self.pickerView selectRow:adultCount inComponent:2 animated:YES];
        [AertripToastView toastInView:self.view withText:@"Infats should not exceed adults"];
        
        self.travellerCount.flightAdultCount = adultCount;
        self.travellerCount.flightInfantCount = adultCount;
        return;
    }
    
    self.travellerCount = tempTravellerCount;
    
}


@end