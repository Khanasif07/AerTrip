//
//  CheckoutViewController.m
//  Aertrip
//
//  Created by Kakshil Shah on 7/24/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import "CheckoutViewController.h"
//#import <Razorpay/Razorpay.h>
//#import "BookingIncompleteViewController.h"

@interface CheckoutViewController () 
@property (assign, nonatomic) BOOL isConfirmBooking;
//@property (strong, nonatomic) Razorpay *razorpay;

@end

@implementation CheckoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupInitials];
    
}


- (void)setupInitials {
//    self.razorpay = [Razorpay initWithKey:@"rzp_test_QJYU8TtB6deJgb" andDelegate:self];
    [self.aertripWalletSwitchButton setOn:NO];
    [self setupBillingView];
    [self.view layoutIfNeeded];
}

- (void)showPaymentForm { // called by your app
    int price = 0;
    
    if (self.isFlight) {
        if ([self exists:self.bookFlightObject.journey.airlineFare.totalPayable]) {
            int value = (int)[self.bookFlightObject.journey.airlineFare.totalPayable doubleValue];
            if (value > 0.0) {
                price = value * 100;
            }
        }
        
    }else{
    
//        if ([self exists:self.hotelDetailRates.price]) {
//            int value = (int)[self.hotelDetailRates.price doubleValue];
//            if (value > 0.0) {
//                price = value * 100;
//            }
//        }
    }
//    NSString *amount = [NSString stringWithFormat:@"%i",price];
    NSString *email = @"";
    NSString *phone = @"";

    User *user = [self loadObjectFromPreferences:USER_OBJECT];

    if ([self exists:user.email]) {
        email = user.email;
    }
    
    if ([self exists:user.mobile]) {
        phone = user.mobile;
    }
    
    if ([self exists:self.mobile]) {
        phone = self.mobile;
    }
//    NSDictionary *options = @{
//                              @"amount": amount, // mandatory, in paise
//                              // all optional other than amount.
//                              @"image": @"https://cdn.razorpay.com/logos/A6xgGEE8oSmUOw_medium.png",
//                              @"name": @"Aertrip",
//                              @"prefill" : @{
//                                      @"email": email,
//                                      @"contact": phone
//                                      },
//                              @"theme": @{
//                                      @"color": @"#20cb9a"
//                                      }
//                              };
//    [self.razorpay open:options];
}


- (void)onPaymentSuccess:(nonnull NSString*)payment_id {
    [self saveValue:payment_id forKey:PAYMENT_ID];
    [self saveValue:self.itenaryID forKey:ITENARY_ID];
    [self showModule:BOOKING_CONFIRMED_CONTROLLER animated:YES];
}

- (void)onPaymentError:(int)code description:(nonnull NSString *)str {
    [AertripToastView toastInView:self.view withText:OOPS_ERROR_MESSAGE];
}



- (void)setupBillingView {
    
    if (self.isFlight) {
        
        self.baseFareView.hidden = YES;
        if ([self exists:self.bookFlightObject.journey.airlineFare.baseFare]) {
            int value = (int)[self.bookFlightObject.journey.airlineFare.baseFare doubleValue];
            if (value > 0.0) {
                self.baseFareValueLabel.text = [NSString stringWithFormat:@"%@ %@", @"₹", self.bookFlightObject.journey.airlineFare.baseFare];
                self.baseFareView.hidden = NO;
            }
        }
        
        self.taxesView.hidden = YES;
        if ([self exists:self.bookFlightObject.journey.airlineFare.taxes]) {
            int value = (int)[self.bookFlightObject.journey.airlineFare.taxes doubleValue];
            if (value > 0.0) {
                self.taxesValueLabel.text = [NSString stringWithFormat:@"%@ %@", @"₹", self.bookFlightObject.journey.airlineFare.taxes];
                
                if ([self exists:self.bookFlightObject.journey.airlineFare.totalPayable]) {
                    double mainValue = [self.bookFlightObject.journey.airlineFare.totalPayable doubleValue];
                    int newValue = mainValue - value;
                    self.baseFareValueLabel.text = [NSString stringWithFormat:@"%@ %i", @"₹", newValue];
                }
                
                self.taxesView.hidden = NO;
            }
        }
        
        self.aertripWalletView.hidden = YES;
        if ([self.aertripWalletSwitchButton isOn]) {
            self.aertripWalletValueLabel.text = @"0.0";
            self.aertripWalletView.hidden = NO;
        }
        
        self.discountView.hidden = YES;
        self.fareBrkupInstructionHeightConstraint.constant = 0;
        self.totalPayableValueLabel.text = [NSString stringWithFormat:@"%@ %@", @"₹", self.bookFlightObject.journey.airlineFare.totalPayable];
        [self handleCheckoutButton];
        
    }else{
    
    self.baseFareView.hidden = YES;

    
    self.taxesView.hidden = YES;

    
    self.aertripWalletView.hidden = YES;
    if ([self.aertripWalletSwitchButton isOn]) {
        self.aertripWalletValueLabel.text = @"0.0";
        self.aertripWalletView.hidden = NO;
    }
    
    self.discountView.hidden = YES;

    self.fareBrkupInstructionHeightConstraint.constant = 0;

    [self handleCheckoutButton];
    }
}
- (void)handleCheckoutButton {
    self.isConfirmBooking = YES;
    self.bottomLabel.text = @"Confirm Booking";

    if (self.isFlight) {
        if ([self exists:self.bookFlightObject.journey.airlineFare.totalPayable]) {
            double value = [self.bookFlightObject.journey.airlineFare.totalPayable doubleValue];
            if (value > 0.0) {
                self.isConfirmBooking = NO;
                self.bottomLabel.text = [NSString stringWithFormat:@"Pay %@",self.totalPayableValueLabel.text];
            }
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)walletSwitchAction:(id)sender {
    [self setupBillingView];
}



- (IBAction)removeCouponAction:(id)sender {
}
- (IBAction)applyCouponAction:(id)sender {
    [self showModule:APPLY_COUPON_CODE_CONTROLLER animated:YES];
}




//MARK:- NETWORK CALL


- (NSMutableDictionary *)buildDictionary {
    NSMutableDictionary *parametersDynamic = [[NSMutableDictionary alloc] init];
    return parametersDynamic;
}


- (void) fetchDataFromServerInBG:(BOOL)isBG {
    
    if (!isBG) {
        [self showActivityIndicator];
    }
    [[Network sharedNetwork] callGETApi:MAKE_PAYMENT_API parameters:[self buildDictionary] loadFromCache:YES expires:YES success:^(NSDictionary *dataDictionary) {
        [self handleDictionary:dataDictionary];
    } failure:^(NSString *error, BOOL popup) {
        [AertripToastView toastInView:self.view withText:error];
        [self removeActivityIndicator];
    }];
}

- (void)handleDictionary:(NSDictionary *)dataDictionary {
    [self removeActivityIndicator];
}


- (IBAction)checkoutAction:(id)sender {
    if (self.isFlight) {
        [self openBookingIncomplete];
    }else {
        [self showPaymentForm];
    }
}


// Booking in complete flow

- (void)openBookingIncomplete {
//    BookingIncompleteViewController *controller = (BookingIncompleteViewController *)[self getControllerForModule:BOOKING_INCOMPLETE_CONTROLLER];
//    controller.mobile = self.mobile;
//    controller.itenaryID = self.itenaryID;
//    controller.bookFlightObject = self.bookFlightObject;
//    controller.bookingAmount = self.bookFlightObject.journey.airlineFare.totalPayable;
//    controller.paidAmount = @"0";
//    
//    [self presentViewController:controller animated:YES completion:nil];
    
}



@end
