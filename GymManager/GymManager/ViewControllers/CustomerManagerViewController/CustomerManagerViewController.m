//
//  CustomerManagerViewController.m
//  GymManager
//
//  Created by Văn Tiến Tú on 8/14/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "CustomerManagerViewController.h"
#import "CustomerManagerCollectionViewCell.h"
#import "AddNewCustomerViewController.h"
#import "InfoCustomerManagerViewController.h"

NSString *const kCustomerManagerCollectionViewCellIdentifier = @"CustomerManagerCollectionViewCell";
CGFloat const kCornerRadiusAddNewCustomer = 20.0f;
//TODO
NSString *const kNameCustomer = @"Ngo Van Van Duong";

@interface CustomerManagerViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *buttonAddNewCustomer;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation CustomerManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
}

#pragma mark - Set up view
- (void)setupView {
    //TODO
    self.title = kCustomerManagerTitle;
    self.buttonAddNewCustomer.layer.cornerRadius = kCornerRadiusAddNewCustomer;
}

#pragma mark - UICollectionViewDataSources
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //TODO
    return 15;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomerManagerCollectionViewCell *cell = (CustomerManagerCollectionViewCell *)[collectionView
        dequeueReusableCellWithReuseIdentifier:kCustomerManagerCollectionViewCellIdentifier
        forIndexPath:indexPath];
    //TODO
    [cell cellWithName:kNameCustomer avatar:[UIImage imageNamed:kIconUser]];
    return cell;
}

#pragma mark - UICollecitonViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:true];
    //TODO
    UIStoryboard *customerStoryboard = [UIStoryboard
        storyboardWithName:kCustomerManagerStoryboard bundle:nil];
    if ([self.statusCustomerManagerTitle isEqualToString:kCustomerManagerVCTitle]) {
        InfoCustomerManagerViewController *infoCustomerVC = [customerStoryboard
            instantiateViewControllerWithIdentifier:kInfoCustomerManagerViewControllerIdentifier];
        [self.navigationController pushViewController:infoCustomerVC animated:true];
    } else {
        [self.navigationController popViewControllerAnimated:true];
    }
    
}

#pragma mark - Button add new customer
- (IBAction)addNewCustomerPress:(id)sender {
    //TODO
    UIStoryboard *st = [UIStoryboard storyboardWithName:kCustomerManagerStoryboard bundle:nil];
    AddNewCustomerViewController *addNewCustomerVC = [st
        instantiateViewControllerWithIdentifier:kAddNewCustomerViewControllerIdentifier];
    [self.navigationController pushViewController:addNewCustomerVC animated:true];
}

@end
