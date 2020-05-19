//
//  AssignToPassengerViewController.m
//  Aertrip
//
//  Created by Kakshil Shah on 9/10/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import "AssignToPassengerViewController.h"
#import "PassengerCollectionViewCell.h"
@interface AssignToPassengerViewController ()
@property (nonatomic,strong) NSMutableArray *selectedPassengerArray;

@end

@implementation AssignToPassengerViewController


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
    self.bottomViewBottomConstraint.constant = -(self.mainView.bounds.size.height);
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self animateBottomViewIn];
    
}
- (void)setupInitials {
    self.selectedPassengerArray = [[NSMutableArray alloc] init];
    self.backingImageView.image = self.backingImage;
    [self makeTopCornersRounded:self.mainView withRadius:10.0];
    [self applyShadowToAssignView];
    [self setupCollectionView];
}
- (void)applyShadowToAssignView {
    
    self.assignView.clipsToBounds = NO;
    self.assignView.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5].CGColor;
    self.assignView.layer.shadowOpacity = 0.6;
    self.assignView.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    
}
- (void)setupCollectionView {
    
    self.passengerCollectionView.delegate = self;
    self.passengerCollectionView.dataSource = self;
    self.passengerCollectionView.contentInset = UIEdgeInsetsMake(0.0, 15.0, 0.0, 15.0);
    [self.passengerCollectionView registerNib:[UINib nibWithNibName:@"PassengerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PassengerCell"];

    [self.passengerCollectionView reloadData];
}
//MARK:- COLLECTION VIEW

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.passengerArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    //    NSInteger tag = [self getStartInt:collectionView.tag];
    PassengerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PassengerCell" forIndexPath:indexPath];
    GuestDetail *details = [self.passengerArray objectAtIndex:indexPath.row];
    NSString *name = details.firstName;
    if (![self exists:name]) {
        name = details.noNameString;
    }
    if ([self exists:details.profileImage]) {

    }else {
        cell.shortNameLabel.text = [self getInitials:name];
    }
    cell.nameLabel.text = name;
    if ([self isPassengerSelected:details]) {
        cell.selectionView.hidden = NO;
    }else {
        cell.selectionView.hidden = YES;
    }
    return cell;
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(90.0, 140.0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  
    GuestDetail *details = [self.passengerArray objectAtIndex:indexPath.row];
    if ([self isPassengerSelected:details]) {
        [self removeObjectFromArray:details];
    } else {
        [self.selectedPassengerArray addObject:details];
    }
    [self.passengerCollectionView reloadData];
}

- (BOOL)isPassengerSelected:(GuestDetail *)detail {
    NSString *nameDetail = [NSString stringWithFormat:@"%@ %@",detail.firstName, detail.lastName];
    if (![self exists:nameDetail]) {
        nameDetail = detail.noNameString;
    }
    for (GuestDetail *guestDetail in self.selectedPassengerArray) {
        NSString *nameGuestDetail = [NSString stringWithFormat:@"%@ %@",guestDetail.firstName, guestDetail.lastName];
        if (![self exists:nameGuestDetail]) {
            nameGuestDetail = guestDetail.noNameString;
        }
        if ([nameDetail isEqualToString:nameGuestDetail]) {
            return YES;
        }
    }
    return NO;
}

- (void)removeObjectFromArray:(GuestDetail *)detail {
    NSString *nameDetail = [NSString stringWithFormat:@"%@ %@",detail.firstName, detail.lastName];
    if (![self exists:nameDetail]) {
        nameDetail = detail.noNameString;
    }
    for (GuestDetail *guestDetail in self.selectedPassengerArray) {
        NSString *nameGuestDetail = [NSString stringWithFormat:@"%@ %@",guestDetail.firstName, guestDetail.lastName];
        if (![self exists:nameGuestDetail]) {
            nameGuestDetail = guestDetail.noNameString;
        }
        if ([nameDetail isEqualToString:nameGuestDetail]) {
            [self.selectedPassengerArray removeObject:guestDetail];
            break;
        }
        
    }
}

//MARK:- BOTTOM ANIMATIONS

- (void)animateBottomViewIn {
    [UIView animateWithDuration:0.2 delay:0 options: UIViewAnimationOptionCurveEaseInOut animations:^{
        self.dimmerLayer.alpha = 0.3;
        self.bottomViewBottomConstraint.constant = 0;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}
- (void)animateBottomViewOut {
    [UIView animateWithDuration:0.2 delay:0 options: UIViewAnimationOptionCurveEaseIn animations:^{
        self.dimmerLayer.alpha = 0.0;
        self.bottomViewBottomConstraint.constant = -(self.mainView.bounds.size.height);
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}


- (IBAction)assignAction:(id)sender {
    [self animateBottomViewOut];
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
