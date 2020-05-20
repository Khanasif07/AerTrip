//
//  TravellerListImportViewController.m
//  Aertrip
//
//  Created by Kakshil Shah on 5/31/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import "TravellerListImportViewController.h"
#import "SimpleLabelTableViewCell.h"
#import "LabelImageTableViewCell.h"
#import <Contacts/Contacts.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

//@interface TravellerListImportViewController ()<GIDSignInDelegate, GIDSignInUIDelegate>
//
//@property (strong, nonatomic) NSArray *topSectionArray;
//@property (assign, nonatomic) NSInteger selectedIndex;
//@property (strong, nonatomic) NSArray *resultsArray;
//@property (strong, nonatomic) NSMutableDictionary *travellerSectionDictionary;
//@property (strong, nonatomic) NSMutableArray *sectionArray;
//@property (nonatomic,strong) NSMutableArray *allTravellerArray;
//@property (strong, nonatomic) NSMutableArray *selectedArray;
//@property (strong, nonatomic) NSArray *emptySectionArray;
//@property (strong, nonatomic) NSMutableArray *contactArray;
//@property (strong, nonatomic) NSMutableArray *itemableArray;
//@property (strong, nonatomic) NSMutableArray *facebookFriendsArray;
//@property (strong, nonatomic) NSMutableArray *googleFriendsArray;
//
//@property (strong, nonatomic) FBSDKLoginManager *loginManager;
//@property (strong, nonatomic) NSMutableDictionary *permissions;
//@property (strong, nonatomic) NSString *loginID;
//@property (strong, nonatomic) NSString *firstName;
//@property (strong, nonatomic) NSString *lastName;
//@property (strong, nonatomic) NSString *fullName;
//@property (strong, nonatomic) NSString *email;
//@property (strong, nonatomic) NSString *service;
//@property (strong, nonatomic) NSString *gender;
//@property (strong, nonatomic) NSString *picture;
//
//@end
//
//@implementation TravellerListImportViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    [self setupInitials];
//}
//
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.hidden = YES;
//    
//}
//
//- (void)setupInitials {
//    
//    
//    [self makeTextChangesAsPerIsImport];
//    self.emptyView.hidden = YES;
//    self.itemableArray = [[NSMutableArray alloc] init];
//    self.selectedArray = [[NSMutableArray alloc] init];
//    self.facebookFriendsArray = [[NSMutableArray alloc] init];
//    self.googleFriendsArray = [[NSMutableArray alloc] init];
//    self.allTravellerArray = [[NSMutableArray alloc] init];
//
//    self.selectedIndex = 0;
//    
//    [(MDCShadowLayer *)self.emptyViewButton.layer setElevation:2.f];
//
//    self.emptySectionArray = @[@{ @"imageName":@"Friends0", @"title":@"We will show you a list of your contacts to add them as travellers", @"buttonName":@"Allow Contacts", @"buttonIconName": @"", @"buttonColor":[UIColor appColor]},
//                               @{ @"imageName":@"Friends1", @"title":@"Connect with Facebook to import your friends to the travellers list.", @"buttonName":@"Connect with Facebook", @"buttonIconName": @"facebookIconWhite", @"buttonColor":[UIColor FB_COLOR]},
//                               @{ @"imageName":@"Friends2", @"title":@"Connect with Google to import your contacts to the travellers list", @"buttonName":@"Connect with Google", @"buttonIconName": @"googleIconColor", @"buttonColor":[ UIColor WHITE_COLOR]}];
//    
//    self.topSectionArray = @[@"Contacts",@"Facebook",@"Google"];
//    [self setupSegmentControl];
//    [self setupTableView];
//    [self addSearchBar];
//    [self notifications];
//    Itemable *itemable = [[Itemable alloc] init];
//    itemable.itemHeader = @"Contacts";
//    itemable.itemSectionArray = [[NSMutableArray alloc]init];
//    itemable.itemSectionDictionary = [[NSMutableDictionary alloc] init];
//    [self.itemableArray addObject:itemable];
//    
//    
//    itemable = [[Itemable alloc] init];
//    itemable.itemHeader = @"Facebook";
//    itemable.itemSectionArray = [[NSMutableArray alloc]init];
//    itemable.itemSectionDictionary = [[NSMutableDictionary alloc] init];
//    [self.itemableArray addObject:itemable];
//    
//    itemable = [[Itemable alloc] init];
//    itemable.itemHeader = @"Google";
//    itemable.itemSectionArray = [[NSMutableArray alloc]init];
//    itemable.itemSectionDictionary = [[NSMutableDictionary alloc] init];
//    [self.itemableArray addObject:itemable];
//    
//    
//    if ([self isContactPermissionAuthorized]) {
//        [self getContactsDetailsFromAddressBook];
//    }else {
//        if ([self getBooleanForKey:FACEBOOK_CONNECTED]) {
//            [self getFriendListWithNextCursor:nil];
//        }else {
//            if ([self getBooleanForKey:GOOGLE_CONNECTED]) {
//                [self getGooglePeopleList:@""];
//            }
//        }
//       
//        [self reloadEverything];
//    }
//    
//   
//
//}
//
//- (void)makeTextChangesAsPerIsImport {
//    if (self.isImport) {
//        [self.importButton setTitle:@"Import" forState:UIControlStateNormal];
//        self.titleTextLabel.text = @"Select Contacts to import";
//
//    }else {
//        [self.importButton setTitle:@"Done" forState:UIControlStateNormal];
//        self.titleTextLabel.text = @"Select Contacts";
//
//    }
//    
//}
//- (void) notifications {
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillShow:)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillHide:)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:nil];
//}
//- (void)setupTableView {
//    [self.importTableView setSectionIndexColor:[UIColor GREEN_BLUE_COLOR]];
//    self.importTableView.delegate = self;
//    self.importTableView.dataSource = self;
//   
//
//    
//    
//}
//
//- (void)getAlphabeticArray:(NSArray *)travellersArray {
//    
//    NSMutableArray *sectionArray = [[NSMutableArray alloc] init];
//    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
//    self.travellerSectionDictionary = [[NSMutableDictionary alloc] init];
//    
//    //get traveller sections array of objects
//    for (NSDictionary *traveller in travellersArray) {
//        if([self exists:[traveller objectForKey:@"first_name"]]) {
//            NSString *initilaCharacter = [[[traveller objectForKey:@"first_name"] substringToIndex:1] uppercaseString];
//            if ([self exists:initilaCharacter]) {
//                [sectionArray addObject:initilaCharacter];
//                if ([dictionary objectForKey:initilaCharacter] == nil) {
//                    [dictionary setObject:[[NSMutableArray alloc] init] forKey:initilaCharacter];
//                }
//                [[dictionary objectForKey:initilaCharacter] addObject:traveller];
//                [self.allTravellerArray addObject:traveller];
//            }
//        }
//    }
//    
//    //remove multiple copies
//    NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:sectionArray];
//    sectionArray = [[orderedSet array] mutableCopy];
//    //sort section alphabetically
//    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:nil ascending:YES];
//    self.sectionArray = [[sectionArray sortedArrayUsingDescriptors:@[sd]] mutableCopy];
//    self.travellerSectionDictionary = dictionary;
//    
//}
//- (void)reloadEverything {
//    
//    if([self isSearching]) {
//        self.emptyView.hidden = YES;
//        [self.importTableView reloadData];
//    }else {
//        Itemable *itemable = [self.itemableArray objectAtIndex:self.selectedIndex];
//        [self handleEmptyView];
//        
//        if (itemable.itemSectionArray.count > 0) {
//            [self.importTableView reloadData];
//        }
//    }
//    
//    
//    
//    [self removeActivityIndicator];
//
//}
//
////MARK:- SEARCH DELEGATES
//- (void)addSearchBar {
//    self.travellerSearchBar.delegate = self;
//}
//
//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
//{
//    //    [NSObject cancelPreviousPerformRequestsWithTarget:self];
//    if([searchText length] == 0) {
//        [searchBar performSelector: @selector(resignFirstResponder)
//                        withObject: nil
//                        afterDelay: 0.1];
//        [self reloadEverything];
//        
//    }else {
//        [self seachText:searchText];
//    }
//}
//
//
//- (BOOL) isSearching{
//    if (self.travellerSearchBar.text.length > 0) {
//        return true;
//    }
//    return false;
//}
//
//- (void)seachText:(NSString *)text {
//    [self filterTravellerWithString:text];
//}
//- (void) filterTravellerWithString : (NSString *)searchString {
//    
//    
//    self.resultsArray = [self.allTravellerArray  filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSDictionary*  evulateItem, NSDictionary<NSString *,id> * _Nullable bindings) {
//        NSString *fullName = [NSString stringWithFormat:@"%@ %@", [evulateItem objectForKey:@"first_name"], [evulateItem objectForKey:@"last_name"]];
//        if([[fullName uppercaseString] containsString:[searchString uppercaseString]]) {
//            return YES;
//        }
//        return NO;
//    }]];
//    [self reloadEverything];
//    
//}
//
//
//
////MARK:- SEGMENT CONTROL
//    
//    
//- (void)setupSegmentControl {
//        
//    //    NSMutableArray *sectionTitles = [[NSMutableArray alloc] init];
//    
//    //Check for empty state -> HMSegment cannot handle empty sectionTitles
//    
//    
//    [self.topSegmentControl setSectionTitles:self.topSectionArray];
//    self.topSegmentControl.backgroundColor = [UIColor clearColor];
//    self.topSegmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
//    self.topSegmentControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
////    self.topSegmentControl.segmentEdgeInset = UIEdgeInsetsMake(0, 20.0, 0, 20.0);
////    self.topSegmentControl.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(0, 20.0, 0, 40.0);
//    self.topSegmentControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
//    // self.topSegmentControl.frame = CGRectMake(0, 64, self.view.frame.size.width, 46);
//    self.topSegmentControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
//    self.topSegmentControl.selectionIndicatorHeight = 2;
//    self.topSegmentControl.verticalDividerEnabled = NO;
//    self.topSegmentControl.selectionIndicatorColor = [self getAppColor];
//    
//    self.topSegmentControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor FIVE_ONE_COLOR], NSFontAttributeName:[UIFont fontWithName:@"SourceSansPro-Regular" size:16]};
//    
//    self.topSegmentControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor FIVE_ONE_COLOR], NSFontAttributeName:[UIFont fontWithName:@"SourceSansPro-Semibold" size:16]};
//    
//    self.topSegmentControl.borderType = HMSegmentedControlBorderTypeNone;
//    self.topSegmentControl.selectedSegmentIndex = 0;
//    
//    [self setupSwipe];
//}
//- (void)setupSwipe {
//    
//    UISwipeGestureRecognizer *recognizer;
//    
//    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
//    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
//    [[self importTableView] addGestureRecognizer:recognizer];
//    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
//    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
//    [[self importTableView] addGestureRecognizer:recognizer];
//  //  [self.emptyView addGestureRecognizer:recognizer];
//    
//}
//
//-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer {
//    NSLog(@"Swipe received.");
//    
//    int selectedIndex = (int)self.topSegmentControl.selectedSegmentIndex;
//    
//    if(recognizer.direction == UISwipeGestureRecognizerDirectionRight)
//    {
//        if (selectedIndex > 0) {
//            [self.topSegmentControl setSelectedSegmentIndex:selectedIndex-1 animated:YES];
//            [self adjustAsPerTopBar];
//        }
//    }
//    else
//    {
//        if (selectedIndex < (self.topSectionArray.count - 1)) {
//            [self.topSegmentControl setSelectedSegmentIndex:selectedIndex+1 animated:YES];
//            [self adjustAsPerTopBar];
//        }
//    }
//    
//}
//- (IBAction)segmentChanged:(id)sender {
//    [self adjustAsPerTopBar];
//}
//
//- (void) adjustAsPerTopBar{
//    self.selectedIndex = self.topSegmentControl.selectedSegmentIndex;
//    [self reloadEverything];
////    [self.importTableView reloadData];
//}
//
//
//
//
////MARK:- TABLE VIEW
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    if ([self isSearching]) {
//        return 1;
//    }else {
//       Itemable *itemable = [self.itemableArray objectAtIndex:self.selectedIndex];
//        return itemable.itemSectionArray.count;
//    }
//    
//}
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if ([self isSearching]) {
//        return self.resultsArray.count;
//    }else {
//        Itemable *itemable = [self.itemableArray objectAtIndex:self.selectedIndex];
//        NSString *key = [itemable.itemSectionArray objectAtIndex:section];
//        return  [[itemable.itemSectionDictionary objectForKey:key] count];
//    }
//    
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 44.0;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 28.0;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 0.1;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    static NSString *cellIdentifier = @"TravellerHeaderCell";
//    SimpleLabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if (cell == nil) {
//        cell = [[SimpleLabelTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
//    if ([self isSearching]) {
//        cell.mainLabel.text = @"Search Result";
//    }else {
//        Itemable *itemable = [self.itemableArray objectAtIndex:self.selectedIndex];
//        NSString *key = [itemable.itemSectionArray objectAtIndex:section];
//        cell.mainLabel.text = key;
//    }
//    return [cell contentView];
//}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *cellIdentifier = @"TravellerCell";
//    LabelImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if (cell == nil) {
//        cell = [[LabelImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//    }
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.lineView.hidden = NO;
//    NSArray *travellerArray = [[NSArray alloc] init];
//    if ([self isSearching]) {
//        travellerArray = self.resultsArray;
//    } else {
//        Itemable *itemable = [self.itemableArray objectAtIndex:self.selectedIndex];
//        NSString *key = [itemable.itemSectionArray objectAtIndex:indexPath.section];
//        travellerArray = [itemable.itemSectionDictionary objectForKey:key];
//    }
//    NSDictionary *traveller = travellerArray[indexPath.row];
//    
//    cell.titleLabel.text = [NSString stringWithFormat:@"%@ %@",[traveller objectForKey:@"first_name"], [traveller objectForKey:@"last_name"]];
//    
//    if (indexPath.row == travellerArray.count -1) {
//        cell.lineView.hidden = YES;
//    }
//    
//    if ([self isTravellerSelected:traveller]) {
//        cell.coreImageView.image = [UIImage imageNamed:@"selectOption"];
//        
//    }else {
//        cell.coreImageView.image = [UIImage imageNamed:@"unSelectOption"];
//        
//    }
//    
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSMutableArray *travellerArray = [[NSMutableArray alloc] init];
//    if ([self isSearching]) {
//        travellerArray = [self.resultsArray mutableCopy];
//    }else {
//        Itemable *itemable = [self.itemableArray objectAtIndex:self.selectedIndex];
//        NSString *key = [itemable.itemSectionArray objectAtIndex:indexPath.section];
//        travellerArray = [itemable.itemSectionDictionary objectForKey:key];
//
//    }
//    NSDictionary *traveller = travellerArray[indexPath.row];
//    if ([self isTravellerSelected:traveller]) {
//        [self removeObjectFromoArray:traveller];
//    } else {
//        [self.selectedArray addObject:traveller];
//    }
//    [self travellerSelected];
//    
//    
//}
//
//
////MARK:- SMART FUNCTIONS
//
//- (void)handleEmptyView {
//    Itemable *itemable = [self.itemableArray objectAtIndex:self.selectedIndex];
//
//    if (itemable.itemSectionArray.count > 0) {
//        self.emptyView.hidden = YES;
//
//    }else {
//        self.emptyView.hidden = NO;
//        NSDictionary *emptyDictionary = [self.emptySectionArray objectAtIndex:self.selectedIndex];
//        self.emptyImageView.image = [UIImage imageNamed:[emptyDictionary objectForKey:@"imageName"]];
//        self.emptyButtonLabel.text = [emptyDictionary objectForKey:@"buttonName"];
//        self.emptyButtonIconImageView.image = [UIImage imageNamed:[emptyDictionary objectForKey:@"buttonIconName"]];
//        self.emptyTitleLabel.text = [emptyDictionary objectForKey:@"title"];
//        [self.emptyViewButton setBackgroundColor:[emptyDictionary objectForKey:@"buttonColor"]];
//        self.emptyButtonLabel.textColor = [UIColor whiteColor];
//        if (self.selectedIndex == 0) {
//            self.emptyButtonImageViewWidth.constant = 0;
//            self.emptyButtonImageViewTrailingConstraint.constant = 0;
//        }else if (self.selectedIndex == 1) {
//            self.emptyButtonImageViewTrailingConstraint.constant = 19;
//            self.emptyButtonImageViewWidth.constant = 10;
//            self.emptyButtonImageViewHeight.constant = 29;
//
//
//        }else if (self.selectedIndex == 2) {
//            self.emptyButtonImageViewTrailingConstraint.constant = 19;
//            self.emptyButtonImageViewWidth.constant = 20;
//            self.emptyButtonImageViewHeight.constant = 20;
//            self.emptyButtonLabel.textColor = [UIColor blackColor];
//        }
//    }
//    
//}
//
//
//
//- (BOOL)isTravellerSelected: (NSDictionary *)traveller {
//    
//    for (NSDictionary *travellerObj in self.selectedArray) {
//        
//        if ([[travellerObj objectForKey:@"first_name"] isEqualToString:[traveller objectForKey:@"first_name"]] && [[travellerObj objectForKey:@"last_name"] isEqualToString:[traveller objectForKey:@"last_name"]]) {
//            return true;
//        }
//    }
//    return false;
//}
//
//- (void)removeObjectFromoArray: (NSDictionary *)traveller {
//    for (NSDictionary *travellerObj in self.selectedArray) {
//        if ([[travellerObj objectForKey:@"first_name"] isEqualToString:[traveller objectForKey:@"first_name"]] && [[travellerObj objectForKey:@"last_name"] isEqualToString:[traveller objectForKey:@"last_name"]]) {
//            [self.selectedArray removeObject:traveller];
//            break;
//        }
//    }
//}
//- (void)travellerSelected {
//    
//    if (self.selectedArray.count) {
//        self.titleTextLabel.text = [NSString stringWithFormat:@"%lu Contacts Selected",(unsigned long)self.selectedArray.count];
//    }else {
//        if (self.isImport) {
//            self.titleTextLabel.text = @"Select Contacts to import";
//        }else {
//            self.titleTextLabel.text = @"Select Contacts";
//
//        }
//    }
//    
//    
//    [self.importTableView reloadData];
//}
//
////MARK:- USER INTERACTION
//
//- (IBAction)emptyViewButtonAction:(id)sender {
//    if (self.selectedIndex == 0) {
//        [self getContactsDetailsFromAddressBook];
//    }else if ( self.selectedIndex == 1) {
//        [self connectToFacebook];
//    }else if ( self.selectedIndex == 2) {
//        [self showActivityIndicator];
//        [GIDSignIn sharedInstance].delegate = self;
//        [GIDSignIn sharedInstance].uiDelegate = self;
//        [[GIDSignIn sharedInstance] setScopes:@[@"profile",@"https://www.googleapis.com/auth/plus.login", @"https://www.googleapis.com/auth/contacts.readonly"]];
//        [[GIDSignIn sharedInstance] signIn];
//    }
//    
//}
//
//
//- (IBAction)cancelAction:(id)sender {
//    
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//- (IBAction)importAction:(id)sender {
//    if (self.selectedArray.count > 0) {
//        if (self.isImport) {
//            [self fetchDataFromServerInBG:NO];
//        }else {
//            [self.delegate addGuests:self.selectedArray];
//            [self dismissViewControllerAnimated:YES completion:nil];
//        }
//
//    }else {
//        [self showMessage:@"Please select contact" withTitle:OOPS_ERROR_TITLE];
//    }
//    
//}
//
//- (NSDictionary *)buildDictionaryForImport {
//    NSMutableDictionary *parametersDynamic = [[NSMutableDictionary alloc] init];
//    NSInteger i = 0;
//    for (NSDictionary *dictionary in self.selectedArray) {
//        [parametersDynamic setObject:[Parser getValueForKey:@"last_name" inDictionary:dictionary] forKey:[NSString stringWithFormat:@"data[%ld][last_name]",(long)i]];
//        [parametersDynamic setObject:[Parser getValueForKey:@"first_name" inDictionary:dictionary] forKey:[NSString stringWithFormat:@"data[%ld][first_name]",(long)i]];
//        [parametersDynamic setObject:[Parser getValueForKey:@"salutation" inDictionary:dictionary] forKey:[NSString stringWithFormat:@"data[%ld][salutation]",(long)i]];
//        [parametersDynamic setObject:[Parser getValueForKey:@"dob" inDictionary:dictionary] forKey:[NSString stringWithFormat:@"data[%ld][dob]",(long)i]];
//        [parametersDynamic setObject:[Parser getValueForKey:@"notes" inDictionary:dictionary] forKey:[NSString stringWithFormat:@"data[%ld][notes]",(long)i]];
//        
//        NSInteger j = 0;
//        for (NSDictionary *emailDict in [dictionary objectForKey:@"email"]) {
//             [parametersDynamic setObject:[Parser getValueForKey:@"email" inDictionary:emailDict] forKey:[NSString stringWithFormat:@"data[%ld][email][%ld][contact_value]",(long)i, (long)j]];
//            [parametersDynamic setObject:[Parser getValueForKey:@"email_type" inDictionary:emailDict] forKey:[NSString stringWithFormat:@"data[%ld][email][%ld][contact_type]",(long)i, (long)j]];
//             [parametersDynamic setObject:@"" forKey:[NSString stringWithFormat:@"data[%ld][email][%ld][contact_label]",(long)i, (long)j]];
//            j++;
//        }
//        
//        j = 0;
//        for (NSDictionary *mobileDict in [dictionary objectForKey:@"mobile"]) {
//            [parametersDynamic setObject:[Parser getValueForKey:@"mobile" inDictionary:mobileDict] forKey:[NSString stringWithFormat:@"data[%ld][mobile][%ld][contact_value]",(long)i, (long)j]];
//            [parametersDynamic setObject:[Parser getValueForKey:@"mobile_type" inDictionary:mobileDict] forKey:[NSString stringWithFormat:@"data[%ld][mobile][%ld][contact_type]",(long)i, (long)j]];
//            [parametersDynamic setObject:[Parser getValueForKey:@"mobile_type" inDictionary:mobileDict] forKey:[NSString stringWithFormat:@"data[%ld][mobile][%ld][contact_label]",(long)i, (long)j]];
//            [parametersDynamic setObject:@"" forKey:[NSString stringWithFormat:@"data[%ld][mobile][%ld][sd]",(long)i, (long)j]];
//            j++;
//        }
//        i++;
//       
//    }
//    return parametersDynamic;
//}
//
//- (void)fetchDataFromServerInBG:(BOOL)inBG {
//    if (!inBG) {
//        [self showActivityIndicator];
//    }
//    [[Network sharedNetwork] callApi:IMPORT_TRAVELLER_API parameters:[self buildDictionaryForImport] loadFromCache:NO expires:NO success:^(NSDictionary *dataDictionary) {
//        [self handleDataDictionary:dataDictionary];
//        
//    } failure:^(NSString *error, BOOL popup) {
//        [ALToastView toastInView:self.view withText:error];
//        [self removeActivityIndicator];
//    }];
//}
//
//- (void)handleDataDictionary:(NSDictionary *)dataDictionary {
//    [self removeActivityIndicator];
//    [self dismissViewControllerAnimated:YES completion:nil];
//
//}
//
////MARK:- FETCH CONTACTS
//- (BOOL)isContactPermissionAuthorized {
//    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
//    if ( status == CNAuthorizationStatusNotDetermined || status == CNAuthorizationStatusDenied || status == CNAuthorizationStatusRestricted) {
//        return NO;
//    }
//    return YES;
//}
//- (void)getContactsDetailsFromAddressBook {
//    //ios 9+
//    [self showActivityIndicator];
//    CNContactStore *store = [[CNContactStore alloc] init];
//    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
//        if (granted == YES) {
//            //keys with fetching properties
//            NSArray *keys = @[CNContactBirthdayKey,CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey, CNContactEmailAddressesKey];
//            NSError *error;
//            NSMutableArray *contacts = [NSMutableArray array];
//            CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:keys];
//            
//            BOOL success = [store enumerateContactsWithFetchRequest:request error:&error usingBlock:^(CNContact * __nonnull contact, BOOL * __nonnull stop) {
//                [contacts addObject:contact];
//                
//            }];
//            
//            if (!success) {
//                NSLog(@"error fetching contacts %@", error);
//            } else {
//                self.contactArray = [[NSMutableArray alloc] init];
//                for (CNContact *contact in contacts) {
//                    [self.contactArray addObject:[self buildDictionaryFor:contact]];
//                }
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self getAlphabeticArray:self.contactArray];
//                    Itemable *itemable = [[Itemable alloc] init];
//                    itemable.itemHeader = @"Contacts";
//                    itemable.itemSectionArray = self.sectionArray;
//                    itemable.itemSectionDictionary = self.travellerSectionDictionary;
//                    [self.itemableArray replaceObjectAtIndex:0 withObject:itemable];
//                    [self reloadEverything];
//                    if ([self getBooleanForKey:FACEBOOK_CONNECTED]) {
//                        [self getFriendListWithNextCursor:nil];
//                    }else {
//                        if ([self getBooleanForKey:GOOGLE_CONNECTED]) {
//                            [self getGooglePeopleList:@""];
//                        }
//                    }
//                    
//                });
//            }
//        }else {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self reloadEverything];
//            });
//        }
//    }];
//}
//
//- (NSDictionary *) buildDictionaryFor:(CNContact *) contact {
//    NSMutableDictionary *parametersDynamic = [[NSMutableDictionary alloc] init];
//    NSString *firstName = [self parseString:contact.givenName];
//    NSString *lastName = [self parseString:contact.familyName];
//    NSString *birthDayStr = @"";
//    
//    NSDateComponents *birthDayComponent = contact.birthday;
//    if (birthDayComponent == nil) {
//        // NSLog(@"Component: %@",birthDayComponent);
//        birthDayStr = @"";
//    }else{
//        birthDayComponent = contact.birthday;
//        NSInteger day = [birthDayComponent day];
//        NSInteger month = [birthDayComponent month];
//        NSInteger year = [birthDayComponent year];
//        NSLog(@"Year: %ld, Month: %ld, Day: %ld",(long)year,(long)month,(long)day);
//        birthDayStr = [NSString stringWithFormat:@"%ld-%ld-%ld",(long)day,(long)month,(long)year];
//    }
//    NSString *dob = birthDayStr;
//    NSString *doa = @"";
//    NSString *notes = @"";
//    NSMutableArray *emailArray = [[NSMutableArray alloc] init];
//    for (CNLabeledValue *labelValue in contact.emailAddresses) {
//        NSString *email = labelValue.value;
//        if ([email length] > 0) {
//            NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
//            [dictionary setObject:email forKey:@"email"];
//            NSString *label = labelValue.label;
//            label = [CNLabeledValue localizedStringForLabel:label];
//            if ([self exists:label]) {
//                [dictionary setObject:label forKey:@"email_type"];
//            }
//            [emailArray addObject:dictionary];
//        }
//    }
//    [parametersDynamic setValue:emailArray forKey:@"email"];
//
//    NSMutableArray *mobileArray = [[NSMutableArray alloc] init];
//    for (CNLabeledValue *labelValue in contact.phoneNumbers) {
//        NSString *phone = [labelValue.value stringValue];
//        if ([phone length] > 0) {
//            NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
//            [dictionary setObject:phone forKey:@"mobile"];
//            NSString *label = labelValue.label;
//            label = [CNLabeledValue localizedStringForLabel:label];
//            if ([self exists:label]) {
//                [dictionary setObject:label forKey:@"mobile_type"];
//            }
//            [mobileArray addObject:dictionary];
//        }
//    }
//    [parametersDynamic setValue:mobileArray forKey:@"mobile"];
//    [parametersDynamic setValue:@"" forKey:@"salutation"];
//    [parametersDynamic setValue:firstName forKey:@"first_name"];
//    [parametersDynamic setValue:lastName forKey:@"last_name"];
//    [parametersDynamic setValue:dob forKey: @"dob"];
//    [parametersDynamic setValue:doa forKey:@"doa"];
//    [parametersDynamic setValue:notes forKey:@"notes"];
//    [parametersDynamic setValue:@"" forKey:@"profile_picture"];
//    NSString *content = @"";
//    
//    
//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parametersDynamic
//                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
//                                                         error:&error];
//    
//    if (! jsonData) {
//        NSLog(@"Got an error: %@", error);
//    } else {
//        content = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    }
//    
//    // [parametersDynamic setValue:content forKey:@"content"];
//    
//    
//    return parametersDynamic;
//}
//
//
//
////MARK:- FACEBOOK LOGIN , FRIENDS
//- (void)connectToFacebook {
//    [self showActivityIndicator];
//    self.loginManager =  [[FBSDKLoginManager alloc] init];
//    [self.loginManager logInWithReadPermissions:@[@"public_profile", @"email", @"user_friends"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
//        
//        if (error) {
//            [self showError];
//        }else {
//            
//            self.permissions = [[NSMutableDictionary alloc] init];
//            for (NSString *key in result.grantedPermissions) {
//                [self.permissions setObject:@"1" forKey:key];
//            }
//            for (NSString *key in result.declinedPermissions) {
//                [self.permissions setObject:@"0" forKey:key];
//            }
//            [self getUserDictionary];
//        }
//    }];
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
//                [self saveValue:[self parseString:self.email] forKey:FACEBOOK_CONNECTED_EMAIL_ID];
//
//                [self getFriendListWithNextCursor:nil];
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
//    self.service = @"facebook";
//}
//
//- (void)getFriendListWithNextCursor:(NSString *)nextCursor {
//
//    if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"user_friends"]) {
//
//        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
//        if (nextCursor == nil) {
//            parameters = nil;
//        } else {
//            parameters = [[NSMutableDictionary alloc] init];
//            [parameters setValue:nextCursor forKey:@"after"];
//        }
//
//        [[[FBSDKGraphRequest alloc] initWithGraphPath: @"/me/friends" parameters:parameters]startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
//            if(error) {
//                [self showError];
//
//            }else {
//                NSMutableDictionary *mDicResult = [[NSMutableDictionary alloc]initWithDictionary:result];
//                for (NSDictionary * fbItem in [mDicResult valueForKey:@"data"]) {
//                    [self.facebookFriendsArray addObject:[self buildDictionaryForFB:fbItem]];
//                }
//
//                if ([[mDicResult valueForKey:@"paging"] objectForKey:@"next"] != nil) {
//                    NSString *nextCursor = mDicResult[@"paging"][@"cursors"][@"after"];
//                    [self getFriendListWithNextCursor:nextCursor];
//                }else {
//                    [self getAlphabeticArray:self.facebookFriendsArray];
//                    Itemable *itemable = [[Itemable alloc] init];
//                    itemable.itemHeader = @"Facebook";
//                    itemable.itemSectionArray = self.sectionArray;
//                    itemable.itemSectionDictionary = self.travellerSectionDictionary;
//                    [self.itemableArray replaceObjectAtIndex:1 withObject:itemable];
//                    [self performSelectorOnMainThread:@selector(reloadEverything) withObject:nil waitUntilDone:NO];
//                    if ([self getBooleanForKey:GOOGLE_CONNECTED]) {
//                        [self getGooglePeopleList:@""];
//                    }
//                }
//            }
//        }];
//    }else {
//        [self removeActivityIndicator];
//    }
//}
//
//- (NSDictionary *)buildDictionaryForFB:(NSDictionary *)fbItem {
//    NSArray *arrayOfName = [[fbItem objectForKey:@"name"] componentsSeparatedByString:@" "];
//    NSMutableDictionary *parametersDynamic = [[NSMutableDictionary alloc] init];
//    NSString *firstName = [fbItem objectForKey:@"name"];
//    NSString *lastName = @"";
//    if (arrayOfName.count > 0) {
//        firstName = arrayOfName[0];
//        if (arrayOfName.count >= 2) {
//            lastName = arrayOfName[1];
//        }
//    }
//    NSString *dob = @"";
//    NSString *doa = @"";
//    NSString *notes = @"";
//    
//    [parametersDynamic setValue:@"" forKey:@"salutation"];
//    [parametersDynamic setValue:firstName forKey:@"first_name"];
//    [parametersDynamic setValue:lastName forKey:@"last_name"];
//    [parametersDynamic setValue:dob forKey: @"dob"];
//    [parametersDynamic setValue:doa forKey:@"doa"];
//    [parametersDynamic setValue:notes forKey:@"notes"];
//    [parametersDynamic setValue:@"" forKey:@"profile_picture"];
//
//    return parametersDynamic;
//}
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
//            [self saveBoolean:YES forKey:GOOGLE_CONNECTED];
//            [self saveValue:[self parseString:self.email] forKey:GOOGLE_CONNECTED_EMAIL_ID];
//
//            [self getGooglePeopleList:@""];
//            
//            
//        }] resume];
//    }
//}
//
//- (void)getGooglePeopleList:(NSString *)pageTocken {
//    NSString *urlString = [NSString stringWithFormat:@"https://people.googleapis.com/v1/people/me/connections?access_token=%@&personFields=names,emailAddresses,birthdays&pageToken=%@",[self getValueForKey:GOOGLE_ACCESS_TOKEN], pageTocken];
//    NSURL *url = [NSURL URLWithString:urlString];
//    
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    [request setHTTPMethod:@"GET"];
//    [request setURL:url];
//  
//    
//    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:
//      ^(NSData * _Nullable data,
//        NSURLResponse * _Nullable response,
//        NSError * _Nullable error) {
//          if (data!=nil) {
//
//              NSError *erro = nil;
//              NSString *myString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//              NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&erro ];
//              if ([json objectForKey:@"connections"]) {
//                  for (NSDictionary *dictionary in [json objectForKey:@"connections"]) {
//                      NSArray *nameArray = [dictionary objectForKey:@"names"];
//                      if (nameArray.count > 0) {
//                          NSDictionary *names = [nameArray objectAtIndex:0];
//                          [self.googleFriendsArray addObject:[self buildDictionaryForGoogle:names]];
//
//                      }
//                  }
//                 
//                  
//              }
//              [self getAlphabeticArray:self.googleFriendsArray];
//              Itemable *itemable = [[Itemable alloc] init];
//              itemable.itemHeader = @"Google";
//              itemable.itemSectionArray = self.sectionArray;
//              itemable.itemSectionDictionary = self.travellerSectionDictionary;
//              [self.itemableArray replaceObjectAtIndex:2 withObject:itemable];
//              
//              if([json objectForKey:@"nextPageToken"]) {
//                  if ([self exists:[json objectForKey:@"nextPageToken"]]) {
//                      [self getGooglePeopleList:[json objectForKey:@"nextPageToken"]];
//                  }else {
//                      [self performSelectorOnMainThread:@selector(reloadEverything) withObject:nil waitUntilDone:NO];
//                  }
//              }else {
//                  [self performSelectorOnMainThread:@selector(reloadEverything) withObject:nil waitUntilDone:NO];
//              }
//              NSLog(@"Data received: %@ json data %@", myString, json);
//          }else {
//              [self performSelectorOnMainThread:@selector(reloadEverything) withObject:nil waitUntilDone:NO];
//          }
//      }] resume];
//
//
//    
//    
//    
//}
//
//- (NSDictionary *)buildDictionaryForGoogle:(NSDictionary *)dictionary {
//    NSMutableDictionary *parametersDynamic = [[NSMutableDictionary alloc] init];
//    [parametersDynamic setValue:@"" forKey:@"salutation"];
//    [parametersDynamic setValue:[Parser getValueForKey:@"givenName" inDictionary:dictionary] forKey:@"first_name"];
//    [parametersDynamic setValue:[Parser getValueForKey:@"familyName" inDictionary:dictionary] forKey:@"last_name"];
//    [parametersDynamic setValue:@"" forKey: @"dob"];
//    [parametersDynamic setValue:@"" forKey:@"doa"];
//    [parametersDynamic setValue:@"" forKey:@"notes"];
//    
//    return parametersDynamic;
//}
//
//
////MARK:- KEYBOARD LISTENERS
//- (void)keyboardWillShow:(NSNotification *)notification
//{
//    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//    UIEdgeInsets contentInsets =  self.importTableView.contentInset;
//    contentInsets.bottom = keyboardSize.height;
//    self.importTableView.contentInset = contentInsets;
//    self.importTableView.scrollIndicatorInsets = contentInsets;
//}
//
//
//- (void)keyboardWillHide:(NSNotification *)notification
//{
//    UIEdgeInsets contentInsets = self.importTableView.contentInset;
//    contentInsets.bottom = 0.0;
//    self.importTableView.contentInset = contentInsets;
//    self.importTableView.scrollIndicatorInsets = contentInsets;
//    
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//
//@end



