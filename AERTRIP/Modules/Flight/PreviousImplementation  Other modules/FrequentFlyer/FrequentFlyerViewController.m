//
//  FrequentFlyerViewController.m
//  Aertrip
//
//  Created by Kakshil Shah on 5/17/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import "FrequentFlyerViewController.h"
#import "TwoLabelAndImageViewTableViewCell.h"
@interface FrequentFlyerViewController ()
@property (strong, nonatomic) NSArray *resultsArray;
@property (nonatomic,strong) NSMutableArray *allArray;

@end

@implementation FrequentFlyerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupInitials];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
}

- (void)setupInitials {
    [self addSearchBar];
    [self setupTableView];
    [self notifications];
    
}
- (void)addSearchBar {
    self.frequentFlyerSearchBar.delegate = self;
}


- (void)setupTableView {
    [self.frequentFlyerTableView setSectionIndexColor:[UIColor GREEN_BLUE_COLOR]];
    self.frequentFlyerTableView.delegate = self;
    self.frequentFlyerTableView.dataSource = self;
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

//MARK:- NETWORK CALL
- (NSDictionary *) buildDictionaryWithText:(NSString *) searchText {

    NSArray *keys = [NSArray arrayWithObjects:@"q", nil];
    NSArray *objects = [NSArray arrayWithObjects: searchText, nil];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjects:objects
                                                           forKeys:keys];
    return parameters;
}
- (void) performSearchOnServerWithText:(NSString *)searchText
{
    
//    [self showActivityIndicator];
    [[Network sharedNetwork] callGETApi:AIRLINE_SEARCH_API parameters:[self buildDictionaryWithText:searchText] loadFromCache:NO expires:YES success:^(NSDictionary *dataDictionary) {
        [self handleDictionary:dataDictionary];
    } failure:^(NSString *error, BOOL popup) {
        [AertripToastView toastInView:self.view withText:error];
        self.allArray = [[NSMutableArray alloc] init];
        [self.frequentFlyerTableView reloadData];
        [self removeActivityIndicator];
    }];
}

- (void)handleDictionary:(NSDictionary *)dataDictionary {

    [self.frequentFlyerTableView reloadData];
    [self removeActivityIndicator];
}

//MARK:- SEARCH DELEGATES
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(sendSearchRequest) withObject:searchText afterDelay:0.35f];

    
    
    if([searchText length] == 0) {
        [searchBar performSelector: @selector(resignFirstResponder)
                        withObject: nil
                        afterDelay: 0.1];
        [self.frequentFlyerTableView reloadData];
        
    }else {
       // [self seachText:searchText];
    }
    
    // [self performSelector:@selector(sendSearchRequest) withObject:searchText afterDelay:0.35f];
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.allArray = [[NSMutableArray alloc] init];
    [self.frequentFlyerTableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar performSelector: @selector(resignFirstResponder)
                    withObject: nil
                    afterDelay: 0.1];
    searchBar.text = @"";
    
    [self.frequentFlyerTableView reloadData];
}
- (void ) sendSearchRequest
{
    if (self.frequentFlyerSearchBar.text.length > 1) {
//        [self.indicatorView startAnimating];
        [self performSearchOnServerWithText:self.frequentFlyerSearchBar.text];
        [self.frequentFlyerTableView setHidden:NO];
    }else {
        self.allArray = [[NSMutableArray alloc] init];
        [self.frequentFlyerTableView reloadData];
    }
    
}
- (BOOL) isSearching{
    if (self.frequentFlyerSearchBar.text.length > 0) {
        return true;
    }
    return false;
}




//MARK:- TABLE VIEW


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.allArray count];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"FrequentFlyerCell";
    TwoLabelAndImageViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[TwoLabelAndImageViewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.lineView.hidden = NO;
    
    FrequentFlightPreferences *frequentFlightPreferences;
    frequentFlightPreferences = [self.allArray objectAtIndex:indexPath.row];

    cell.mainLabel.text = frequentFlightPreferences.flyerName;
    cell.subLabel.text = frequentFlightPreferences.flyerShortName;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FrequentFlightPreferences *frequentFlightPreferences = [self.allArray objectAtIndex:indexPath.row];
    self.frequentFlier.airlineName = frequentFlightPreferences.flyerName;
    self.frequentFlier.airlineCode = frequentFlightPreferences.flyerShortName;
    self.frequentFlier.logoURL = frequentFlightPreferences.flyerFlag;


    [self dismissViewControllerAnimated:YES completion:^{

    }];

}







//MARK:- KEYBOARD LISTENERS
- (void)keyboardWillShow:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets =  self.frequentFlyerTableView.contentInset;
    contentInsets.bottom = keyboardSize.height;
    self.frequentFlyerTableView.contentInset = contentInsets;
    self.frequentFlyerTableView.scrollIndicatorInsets = contentInsets;
}


- (void)keyboardWillHide:(NSNotification *)notification
{
    UIEdgeInsets contentInsets =  self.frequentFlyerTableView.contentInset;
    contentInsets.bottom = 0.0;
    self.frequentFlyerTableView.contentInset = contentInsets;
    self.frequentFlyerTableView.scrollIndicatorInsets = contentInsets;
    
}


- (IBAction)cancelAction:(id)sender {
    [self.frequentFlyerSearchBar resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
