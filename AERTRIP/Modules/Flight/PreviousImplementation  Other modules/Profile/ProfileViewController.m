//
//  ProfileViewController.m
//  Aertrip
//
//  Created by Kakshil Shah on 24/04/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import "ProfileViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "AddTravellerViewController.h"


@interface ProfileViewController ()
@property (strong, nonatomic) UserDetails *userDetails;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    
    [self loadData];
    [self fetchDataFromServerInBG:NO];
}

-(void) loadData {
    User *user = [self loadObjectFromPreferences:USER_OBJECT];
    self.nameLabel.text = user.name;
    self.shortNameLabel.text = [[self getInitials:user.name] uppercaseString];
    self.largeShortNameLabel.text = self.shortNameLabel.text;
    if ([self exists:user.email]) {
        self.emailLabel.text = user.email;
        self.emailHeight.constant = 20;
    }else{
        self.emailHeight.constant = 0;
    }
    
    if ([self exists:user.mobile]) {
        self.mobileLabel.text = user.mobile;
        self.phonenumberHeight.constant = 20;
    }else{
        self.phonenumberHeight.constant = 0;
    }
    self.blurView.backgroundColor = [UIColor clearColor];
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = self.blurView.bounds;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.blurView addSubview:blurEffectView];
}

//MARK:- GET USER META

- (void)fetchDataFromServerInBG:(BOOL)inBG {
    if (!inBG) {
        [self showActivityIndicator];
    }
    [[Network sharedNetwork] callGETApi:USERS_META_API parameters:nil loadFromCache:YES expires:YES success:^(NSDictionary *dataDictionary) {
        [self handleDictionary:dataDictionary];
    } failure:^(NSString *error, BOOL popup) {
        [ALToastView toastInView:self.view withText:error];
        [self removeActivityIndicator];
    }];
}

- (void)handleDictionary:(NSDictionary *)dataDictionary {
    self.userDetails = [Parser parseUserDetails:dataDictionary];
    [self saveObjectToPreferences:self.userDetails.user forKey:USER_OBJECT];
    [self loadData];
    [self removeActivityIndicator];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)goBack:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)editAction:(id)sender {
    AddTravellerViewController *controller = (AddTravellerViewController *)[self getControllerForModule:ADD_TRAVELLER_CONTROLLER];
    controller.userDetails = self.userDetails;
    controller.isSelfTraveller = YES;
    controller.isAddTraveller = NO;
    [self.navigationController pushViewController:controller animated:YES];
}
- (IBAction)travellerListAction:(id)sender {
    [self pushModule:TRAVELLER_LIST_CONTROLLER animated:YES];
}

- (IBAction)hotelPreferencesAction:(id)sender {
    [self pushModule:HOTEL_PREFERENCES_CONTROLLER animated:YES];

}

- (IBAction)logout:(id)sender {
    
    //ask for confirmation
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Are you sure you want to log out?"
                                          message:nil
                                          preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Cancel action");
                                       //FirebaseAnalytics
                                       
                                   }];
    
    UIAlertAction *logOut = [UIAlertAction
                             actionWithTitle:@"Log Out"
                             style:UIAlertActionStyleDestructive
                             handler:^(UIAlertAction *action)
                             {
                                 [self fetchDataForLogoutInBG:NO];
                                 
                             }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:logOut];
    alertController.view.tintColor = [self getAppColor];
    [self presentViewController:alertController animated:YES completion:nil];

    
}
- (void)logOutAction {
    [self removeActivityIndicator];
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    [loginManager logOut];
    [[GIDSignIn sharedInstance] disconnect];
    [self saveValue:@"" forKey:USERID_KEY];
    [self saveObjectToPreferences:nil forKey:USER_OBJECT];

    if ( self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

//Mark:- logout api call
- (void)fetchDataForLogoutInBG:(BOOL)inBG {
    if (!inBG) {
        [self showActivityIndicator];
    }
    [[Network sharedNetwork] callGETApi:USERS_LOGOUT_API parameters:nil loadFromCache:YES expires:NO success:^(NSDictionary *dataDictionary) {
        [self logOutAction];
    } failure:^(NSString *error, BOOL popup) {
        [ALToastView toastInView:self.view withText:error];
        [self removeActivityIndicator];
    }];
}
- (IBAction)openLinkedAccounts:(id)sender {
    [self pushModule:LINKED_ACCOUNTS_CONTROLLER animated:YES];
}


- (IBAction)quickPayPressed:(id)sender {
    [self pushModule:QUICK_PAY_MODULE animated:YES];
}

@end
