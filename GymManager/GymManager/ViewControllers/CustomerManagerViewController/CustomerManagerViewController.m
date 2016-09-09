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

@interface CustomerManagerViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, AddNewCustomerViewControllerDelegate, CustomerManagerDelegate, InfoCustomerManagerViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *buttonAddNewCustomer;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *arrCustomers;
@property (strong, nonatomic) UIRefreshControl *refreshReloadData;

@end

@implementation CustomerManagerViewController
{
    NSIndexPath *_indexPath;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
    [self getAllCustomers];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createNewCustomer:)
        name:kAddNEwCustomerVCTitle object:nil];
}

- (void)createNewCustomer:(NSNotification *)notification {
    if (notification) {
        NSDictionary *userInfo = notification.userInfo;
        Customer *customer = userInfo[@"newcustomer"];
        if (!self.arrCustomers) {
            self.arrCustomers = [NSMutableArray array];
        }
        [self.arrCustomers addObject:customer];
        [self.collectionView reloadData];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)getAllCustomers {
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    CustomerManager *customerManager = [[CustomerManager alloc] init];
    customerManager.delegate = self;
    [customerManager getAllCustomers];
}

#pragma mark - CustomerManagerDelegate 
- (void)didResponseWithMessage:(NSString *)message withError:(NSError *)error returnArray:(NSArray *)arrCustomers {
    if (error) {
        [MBProgressHUD hideHUDForView:self.view animated:true];
        [AlertManager showAlertWithTitle:kRegisterRequest message:message viewControler:self reloadAction:^{
            [self getAllCustomers];
        }];
    } else {
        [MBProgressHUD hideHUDForView:self.view animated:true];
        self.arrCustomers = arrCustomers.mutableCopy;
        [self.collectionView reloadData];
    }
}

#pragma mark - Set up view
- (void)setupView {
    self.title = kCustomerManagerTitle;
    self.buttonAddNewCustomer.layer.cornerRadius = kCornerRadiusAddNewCustomer;
    self.refreshReloadData = [[UIRefreshControl alloc] init];
    [self.refreshReloadData addTarget:self action:@selector(reloadDataCollectionViews:)
        forControlEvents:UIControlEventValueChanged];
    [self.collectionView insertSubview:self.refreshReloadData atIndex:0];
}

- (IBAction)reloadDataCollectionViews:(id)sender {
    [self getAllCustomers];
    [self.refreshReloadData endRefreshing];
}

#pragma mark - UICollectionViewDataSources
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrCustomers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomerManagerCollectionViewCell *cell = (CustomerManagerCollectionViewCell *)[collectionView
        dequeueReusableCellWithReuseIdentifier:kCustomerManagerCollectionViewCellIdentifier
        forIndexPath:indexPath];
    [cell cellWithCustomer:self.arrCustomers[indexPath.row]];
    return cell;
}

#pragma mark - UICollecitonViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:true];
    //TODO
    UIStoryboard *customerStoryboard = [UIStoryboard
        storyboardWithName:kCustomerManagerStoryboard bundle:nil];
    if ([self.statusCustomerManagerTitle isEqualToString:kCustomerManagerVCTitle]) {
        InfoCustomerManagerViewController *infoCustomerVC;
        if (!infoCustomerVC) {
            infoCustomerVC = [customerStoryboard
                instantiateViewControllerWithIdentifier:kInfoCustomerManagerViewControllerIdentifier];
        }
        infoCustomerVC.delegate = self;
        infoCustomerVC.customer = self.arrCustomers[indexPath.row];
        _indexPath = indexPath;
        [self.navigationController pushViewController:infoCustomerVC animated:true];
    } else {
        if ([self.delegate respondsToSelector:@selector(selectedCustomer:)]) {
            [self.delegate selectedCustomer:self.arrCustomers[indexPath.row]];
            [self.navigationController popViewControllerAnimated:true];
        }
    }
    
}

#pragma mark - InfoCustomerManagerViewControllerDelegate
- (void)reloadDataCustomers:(Customer *)customer {
    [self.arrCustomers replaceObjectAtIndex:_indexPath.row withObject:customer];
    [self.collectionView reloadData];
}

#pragma mark - Button add new customer
- (IBAction)addNewCustomerPress:(id)sender {
    //TODO
    UIStoryboard *st = [UIStoryboard storyboardWithName:kCustomerManagerStoryboard bundle:nil];
    AddNewCustomerViewController *addNewCustomerVC = [st
        instantiateViewControllerWithIdentifier:kAddNewCustomerViewControllerIdentifier];
    addNewCustomerVC.delegate = self;
    [self.navigationController pushViewController:addNewCustomerVC animated:true];
}

#pragma mark - AddNewCustomerViewControllerDelegate
- (void)addNewCustomer:(Customer *)customer {
    if (!self.arrCustomers) {
        self.arrCustomers = [NSMutableArray array];
    }
    [self.arrCustomers addObject:customer];
    [self.collectionView reloadData];
}

@end
