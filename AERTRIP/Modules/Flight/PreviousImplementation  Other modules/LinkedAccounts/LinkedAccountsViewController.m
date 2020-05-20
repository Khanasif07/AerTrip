//
//  LinkedAccountsViewController.m
//  Aertrip
//
//  Created by Kakshil Shah on 22/05/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import "LinkedAccountsViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
//#import "LoginEmailRegisterViewController.h"
//#import <linkedin-sdk/LISDK.h>

//@interface LinkedAccountsViewController () <GIDSignInDelegate,GIDSignInUIDelegate>
//@property (strong, nonatomic) NSString *loginID;
//@property (strong, nonatomic) NSString *firstName;
//@property (strong, nonatomic) NSString *lastName;
//@property (strong, nonatomic) NSString *fullName;
//@property (strong, nonatomic) NSString *email;
//@property (strong, nonatomic) NSString *service;
//@property (strong, nonatomic) NSString *gender;
//@property (strong, nonatomic) NSString *picture;
//@property (strong, nonatomic) NSMutableDictionary *permissions;
//@property (strong, nonatomic) FBSDKLoginManager *loginManager;
//
//@end
//
//@implementation LinkedAccountsViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//}
//
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    [self setupCustomUI];
//}
//
//- (void)setupCustomUI {
//    self.navigationController.navigationBar.hidden = YES;
//    [(MDCShadowLayer *)self.googleButton.layer setElevation:2.f];
//    [(MDCShadowLayer *)self.facebookButton.layer setElevation:2.f];
//    [(MDCShadowLayer *)self.linkedInButton.layer setElevation:2.f];
//    [self setButtonsState];
//}
//
//
//
//-(void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    
//}
//
//- (IBAction)facebookLogin:(id)sender {
//    [self loginToFB];
//}
//- (IBAction)googleAction:(id)sender {
//    if (![self getBooleanForKey:GOOGLE_CONNECTED]) {
//        [self showActivityIndicator];
//        [GIDSignIn sharedInstance].delegate = self;
//        [GIDSignIn sharedInstance].uiDelegate = self;
//        [[GIDSignIn sharedInstance] signIn];
//    }else {
//        [self showMessage:@"You have been already connected" withTitle:@""];
//    }
//    
//    
//}
//
//- (IBAction)linkedInAction:(id)sender {
//    if (![self getBooleanForKey:LINKEDIN_CONNECTED]) {
//
//        [self loginViaLinkedIn];
//    }else {
//        [self showMessage:@"You have been already connected" withTitle:@""];
//    }
//}
//
//- (IBAction)backAction:(id)sender {
//    [self.navigationController popViewControllerAnimated:YES];
//}
//
////MARK:FACEBOOK LOGIN
//- (void) loginToFB {
//    [self login];
//}
//
//
//- (void)login {
//    NSLog(@"after3");
//    
//    NSLog(@"after4");
//    if (![self getBooleanForKey:FACEBOOK_CONNECTED]) {
//        [self showActivityIndicator];
//        [self.loginManager logInWithReadPermissions:@[@"public_profile", @"email", @"user_friends"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
//            NSLog(@"after5");
//            
//            if (error) {
//                [self showError];
//            }else {
//                
//                self.permissions = [[NSMutableDictionary alloc] init];
//                for (NSString *key in result.grantedPermissions) {
//                    [self.permissions setObject:@"1" forKey:key];
//                }
//                for (NSString *key in result.declinedPermissions) {
//                    [self.permissions setObject:@"0" forKey:key];
//                }
//                [self getUserDictionary];
//            }
//        }];
//    }else {
//        [self showMessage:@"You have been already connected" withTitle:@""];
//    }
//    NSLog(@"after6");
//    
//}
//
//- (void)getUserDictionary {
//    if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"public_profile"]) {
//        
//        [[[FBSDKGraphRequest alloc] initWithGraphPath: @"me" parameters:@{@"fields": @"id,name,email,gender,first_name,last_name,picture.type(large)"}]startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
//            if(error) {
//                [self showError];
//            }else {
//                [self getAndStoreParamFromFacebook:result];
//                //FAcebook connected
//                [self saveBoolean:YES forKey:FACEBOOK_CONNECTED];
//                 [self saveValue:[self parseString:self.email] forKey:FACEBOOK_CONNECTED_EMAIL_ID];
//                [self performSelectorOnMainThread:@selector(setButtonsState) withObject:nil waitUntilDone:NO];
//            }
//        }];
//    }else {
//        [self showError];
//        
//    }
//}
//
//- (void)getAndStoreParamFromFacebook:(NSDictionary *)dictionary {
//    
//    self.loginID = [Parser getValueForKey:@"id" inDictionary:dictionary];
//    self.fullName = [Parser getValueForKey:@"name" inDictionary:dictionary];
//    self.email = [Parser getValueForKey:@"email" inDictionary:dictionary];
//    self.gender = [Parser getValueForKey:@"gender" inDictionary:dictionary];
//    self.firstName = [Parser getValueForKey:@"first_name" inDictionary:dictionary];
//    self.lastName = [Parser getValueForKey:@"last_name" inDictionary:dictionary];
//    if ([dictionary objectForKey:@"picture"]) {
//        NSDictionary *data = [[dictionary objectForKey:@"picture"] objectForKey:@"data"];
//        self.picture = [Parser getValueForKey:@"url" inDictionary:data];
//    } else {
//        self.picture = @"";
//    }
//    
//    
//    self.service = @"facebook";
//}
//
//
//
//
//
////MARK: GOOGLE LOGIN
//
//
//- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
//}
//- (void)signIn:(GIDSignIn *)signIn
//presentViewController:(UIViewController *)viewController {
//    [self presentViewController:viewController animated:YES completion:nil];
//}
//- (void)signIn:(GIDSignIn *)signIn
//dismissViewController:(UIViewController *)viewController {
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
//    
//    //NSString *idToken = user.authentication.idToken; // Safe to send to the server
//    if(error) {
//        [self showError];
//    }else {
//        
//        self.loginID = [self parseString:user.userID];
//        self.fullName = [self parseString:user.profile.name];
//        self.email = [self parseString:user.profile.email];
//        self.firstName = [self parseString:user.profile.givenName];
//        self.lastName = [self parseString:user.profile.familyName];
//        self.service = @"google";
//        [self saveValue:user.authentication.accessToken forKey:GOOGLE_ACCESS_TOKEN];
//
//        NSString *urlString = [NSString stringWithFormat:@"https://www.googleapis.com/oauth2/v3/userinfo?access_token=%@",user.authentication.accessToken];
//        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
//        request.HTTPMethod = @"GET";
//        [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//        NSURLSession *session = [NSURLSession sharedSession];
//        [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//            NSError* errorInner;
//            if (errorInner) {
//                self.gender = @"";
//                self.picture = @"";
//                self.permissions = [[NSMutableDictionary alloc] init];
//                
//            } else {
//                NSDictionary* userData = [NSJSONSerialization JSONObjectWithData:data
//                                                                         options:kNilOptions
//                                                                           error:&errorInner];
//                
//                NSLog(@"%@",userData);
//                self.gender = [Parser getValueForKey:@"gender" inDictionary:userData];
//                self.picture = [Parser getValueForKey:@"picture" inDictionary:userData];
//                self.permissions = [[NSMutableDictionary alloc] init];
//            }
//
//        }] resume];
//        [self saveBoolean:YES forKey:GOOGLE_CONNECTED];
//         [self saveValue:[self parseString:self.email] forKey:GOOGLE_CONNECTED_EMAIL_ID];
//        [self performSelectorOnMainThread:@selector(setButtonsState) withObject:nil waitUntilDone:NO];
//    }
//}
//
//-(void) removeIndicator{
//    [self removeActivityIndicator];
//    [self showError];
//}
////MARK:- LINKEDIN
//-(void) getLinkedinData{
//    NSString *url = @"https://api.linkedin.com/v1/people/~:(id,first-name,last-name,picture-url,date-of-birth,email-address)";
//    
//    if ([LISDKSessionManager hasValidSession]) {
//        [[LISDKAPIHelper sharedInstance] getRequest:url
//                                            success:^(LISDKAPIResponse *response) {
//                                                // do something with response
//                                                NSString *dataString = [response data];
//                                                NSError *jsonError;
//                                                NSData *objectData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
//                                                NSDictionary *data = [NSJSONSerialization JSONObjectWithData:objectData
//                                                                                                     options:NSJSONReadingMutableContainers
//                                                                                                       error:&jsonError];
//                                                self.firstName = [Parser getValueForKey:@"firstName" inDictionary:data];
//                                                self.lastName = [Parser getValueForKey:@"lastName" inDictionary:data];
//                                                self.loginID = [Parser getValueForKey:@"id" inDictionary:data];
//                                                self.picture = [Parser getValueForKey:@"pictureUrl" inDictionary:data];
//                                                self.email = [Parser getValueForKey:@"emailAddress" inDictionary:data];
//                                                self.gender = @"";
//                                                self.fullName = [NSString stringWithFormat:@"%@ %@",self.firstName,self.lastName];
//                                                self.permissions = [[NSMutableDictionary alloc] init];
//                                                self.service = @"linkedin";
//                                                [self saveBoolean:YES forKey:LINKEDIN_CONNECTED];
//                                                [self saveValue:[self parseString:self.email] forKey:LINKEDIN_CONNECTED_EMAIL_ID];
//                                                [self performSelectorOnMainThread:@selector(setButtonsState) withObject:nil waitUntilDone:NO];
//
//                                            }
//                                              error:^(LISDKAPIError *apiError) {
//                                                  // do something with error
//                                                  [self performSelectorOnMainThread:@selector(removeIndicator) withObject:nil waitUntilDone:NO];
//                                              }];
//    }
//    else{
//        [self removeActivityIndicator];
//        [self showError];
//    }
//}
//
//-(void) setButtonsState{
//    if ([self getBooleanForKey:FACEBOOK_CONNECTED]) {
//        [self.facebookConnectedButton setEnabled:YES];
//    }else{
//        [self.facebookConnectedButton setEnabled:NO];
//    }
//    
//    
//    if ([self getBooleanForKey:LINKEDIN_CONNECTED]) {
//        [self.linkedinConnectedButton setEnabled:YES];
//    }else{
//        [self.linkedinConnectedButton setEnabled:NO];
//    }
//    
//    
//    if ([self getBooleanForKey:GOOGLE_CONNECTED]) {
//        [self.googleConnectedButton setEnabled:YES];
//    }else{
//        [self.googleConnectedButton setEnabled:NO];
//    }
//    [self removeActivityIndicator];
//}
//
////MARK:- Linked in
//- (void)loginViaLinkedIn {
//    [self showActivityIndicator];
//    [LISDKSessionManager
//     createSessionWithAuth:[NSArray arrayWithObjects:LISDK_BASIC_PROFILE_PERMISSION,LISDK_EMAILADDRESS_PERMISSION, nil]
//     state:nil
//     showGoToAppStoreDialog:NO
//     successBlock:^(NSString *returnState) {
//         NSLog(@"%s","success called!");
//         LISDKSession *session = [[LISDKSessionManager sharedInstance] session];
//         [self performSelectorOnMainThread:@selector(getLinkedinData) withObject:nil waitUntilDone:NO];
//     }
//     errorBlock:^(NSError *error) {
//         NSLog(@"%s","error called!");
//         [self removeActivityIndicator];
//         [self showError];
//     }
//     ];
//}
//
//- (IBAction)disconnectFacebook:(id)sender {
//    [self.loginManager logOut];
//    [self showActivityIndicator];
//    [self saveBoolean:NO forKey:FACEBOOK_CONNECTED];
//    [self performSelector:@selector(setButtonsState) withObject:nil afterDelay:2];
//}
//- (IBAction)disconnectGoogle:(id)sender {
//    [[GIDSignIn sharedInstance] disconnect];
//    [self showActivityIndicator];
//    [self saveValue:@"" forKey:GOOGLE_ACCESS_TOKEN];
//    [self saveBoolean:NO forKey:GOOGLE_CONNECTED];
//
//    [self performSelector:@selector(setButtonsState) withObject:nil afterDelay:2];
//
//
//}
//- (IBAction)disconnectLinkedin:(id)sender {
//    [self showActivityIndicator];
//    [self saveBoolean:NO forKey:LINKEDIN_CONNECTED];
//    [self performSelector:@selector(setButtonsState) withObject:nil afterDelay:2];
//    
//}
//
//
//@end
