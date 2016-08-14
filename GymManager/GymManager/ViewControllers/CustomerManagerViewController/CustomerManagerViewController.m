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

NSString *const kCustomerManagerCollectionViewCellIdentifier = @"CustomerManagerCollectionViewCell";
NSString *const kCustomerTitle = @"Customer Manager";
CGFloat const kCornerRadiusAddNewCustomer = 20.0f;
//TODO
NSString *const kNameCustomer = @"Ngo Van Van Duong";
NSString *const kIconUser = @"ic_user";

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
    self.title = kCustomerTitle;
    self.buttonAddNewCustomer.layer.cornerRadius = kCornerRadiusAddNewCustomer;
}

#pragma mark - UICollectionViewDataSources
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //TODO
    return 15;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomerManagerCollectionViewCell *cell = (CustomerManagerCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kCustomerManagerCollectionViewCellIdentifier forIndexPath:indexPath];
    //TODO
    [cell initWithNameCustomer:kNameCustomer avatar:[UIImage imageNamed:kIconUser]];
    return cell;
}

#pragma mark - UICollecitonViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:true];
    //TODO
}

#pragma mark - Button add new customer
- (IBAction)addNewCustomerPress:(id)sender {
    //TODO
    UIStoryboard *st = [UIStoryboard storyboardWithName:kNameStoryboard bundle:nil];
    AddNewCustomerViewController *addNewCustomerVC = [st instantiateViewControllerWithIdentifier:kAddNewCustomerViewControllerIdentifier];
    [self.navigationController pushViewController:addNewCustomerVC animated:true];
}

@end
