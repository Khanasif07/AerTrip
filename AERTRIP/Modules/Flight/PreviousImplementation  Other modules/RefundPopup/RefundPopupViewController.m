//
//  RefundPopupViewController.m
//  Aertrip
//
//  Created by Kakshil Shah on 9/12/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import "RefundPopupViewController.h"

@interface RefundPopupViewController ()

@end

@implementation RefundPopupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)confirmAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
