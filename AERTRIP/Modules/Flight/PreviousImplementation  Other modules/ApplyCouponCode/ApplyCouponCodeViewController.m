//
//  ApplyCouponCodeViewController.m
//  Aertrip
//
//  Created by Kakshil Shah on 7/28/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import "ApplyCouponCodeViewController.h"
#import "CouponCodeTableViewCell.h"
@interface ApplyCouponCodeViewController ()
@property (strong, nonatomic) NSMutableArray *allArray;

@end

@implementation ApplyCouponCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupInitials];
}
- (void)setupInitials {
    [self setupTableView];
    [self handleEmptyView];
}

- (void)setupTableView {
    self.couponTableView.delegate = self;
    self.couponTableView.dataSource = self;
    [self.couponTableView reloadData];
}
- (void)handleEmptyView {
    self.emptyView.hidden = YES;
    if (self.allArray.count == 0) {
        self.emptyView.hidden = NO;
    }
    
}
//MARK:- TABLE VIEW
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 5;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 141.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CouponCodeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CouponCodeCell"];
    if (cell == nil) {
        NSArray *customCell = [[NSBundle mainBundle] loadNibNamed:@"CouponCodeTableViewCell" owner:self options:nil];
        cell = [customCell objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
   
}


- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)applyAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
