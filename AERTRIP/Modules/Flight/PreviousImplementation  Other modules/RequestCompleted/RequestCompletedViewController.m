//
//  RequestCompletedViewController.m
//  Aertrip
//
//  Created by Kakshil Shah on 9/12/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import "RequestCompletedViewController.h"

@interface RequestCompletedViewController ()

@end

@implementation RequestCompletedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)returnHomeAction:(id)sender {
    [self showModule:HOME_MODULE animated:YES];
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
