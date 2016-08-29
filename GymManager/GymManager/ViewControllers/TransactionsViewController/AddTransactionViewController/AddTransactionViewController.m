//
//  AddTransactionViewController.m
//  GymManager
//
//  Created by Thinh on 8/15/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "AddTransactionViewController.h"
#import "CategoryCell.h"
#import "AddTransactionManager.h"
#import "CustomerManagerViewController.h"
#import "CalendarViewController.h"
#import "ListCategoryViewController.h"
#import "PopoverQuatityViewController.h"
#import "DateFormatter.h"

NSString *const kCategoryListSegue = @"CategoryListSegue";

@interface AddTransactionViewController () <UITableViewDelegate, UITableViewDataSource, AddTransactionManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *arrCategory;
@property (strong, nonatomic) AddTransactionManager *manager;
@property (strong, nonatomic) Transaction *transaction;
@property (strong, nonatomic) Transaction *editedTransaction;
@property (copy, nonatomic) void(^callBackBlock)(Transaction* returnTran);

@end

@implementation AddTransactionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
    self.manager = [[AddTransactionManager alloc] init];
    self.manager.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView {
    //TableView with fake data
    self.arrCategory = @[].mutableCopy;
    [self.tableView registerNib:[UINib nibWithNibName:kTransactionCellIndentifier bundle:nil]
         forCellReuseIdentifier:kTransactionCellIndentifier];
    self.tableView.scrollEnabled = NO;
    if (self.transaction) {
        self.lbCustomerName.text = self.transaction.user.fullName;
        self.arrCategory = self.transaction.items.mutableCopy;
    }
    [self reloadTableView];
}

- (void)reloadTableView {
    [self.tableView reloadData];
    self.contraintTableViewHeight.constant = self.tableView.contentSize.height;
}

- (void)reloadSumTotal {
    NSInteger sum = 0;
    for (Item *item in self.arrCategory) {
        sum += (item.price * item.quantity.integerValue);
    }
    self.lbTotalCost.text = [NSString stringWithFormat:@"%ld Đ", (long)sum];
}

- (Transaction *)genarateTransaction {
    Transaction *tran = [[Transaction alloc] init];
    //TODO change customerId after customer pick viewcontroller has done
    tran.userId = @"1";
    tran.items = self.arrCategory.copy;
    return tran;
}

- (BOOL)editTransaction {
    self.editedTransaction = [self.transaction copy];
    BOOL edited = NO;
    if (![self.transaction.items isEqualToArray:self.arrCategory]) {
        self.editedTransaction.items = self.arrCategory.copy;
        edited = YES;
    }
    if ([self.lbCustomerName.text isEqualToString:self.transaction.user.fullName]) {
        //TODO
        edited = YES;
    }
    return edited;
}

#pragma mark - TableView implementation
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrCategory.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:kTransactionCellIndentifier
        forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    Item *item = self.arrCategory[indexPath.row];
    cell.lbCategory.text = item.name;
    cell.lbCost.text = [NSString stringWithFormat:@"%.0f",item.price];
    cell.lbQuantity.text = [NSString stringWithFormat:@" x %@", item.quantity.stringValue];
    return cell;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *ac1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
        title:@"Edit" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self performSegueWithIdentifier:kShowQuantitySegue sender:indexPath];
    }];
    UITableViewRowAction *ac2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Delete" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self.arrCategory removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        [self reloadTableView];
    }];
    return @[ac2, ac1];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //TODO
}

#pragma mark - Button Handler
- (IBAction)btnAddCategoryClick:(id)sender {
    //TODO
}

- (IBAction)btnSubmitClick:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    User *user = [[DataStore sharedDataStore] getUserManage];
    if (self.arrCategory.count) {
        if (self.transaction) {
            if ([self editedTransaction]) {
                [self.manager editTransaction:[self editedTransaction] byUser:user atIndexPath:nil];
            }
        } else {
            [self.manager createTransaction:[self genarateTransaction] byUser:user];
        }
    }
}

- (IBAction)didTapCustomer:(id)sender {
    CustomerManagerViewController *cusVC = [[UIStoryboard storyboardWithName:kCustomerManagerStoryboard bundle:nil]
        instantiateViewControllerWithIdentifier:kCustomerManagerViewControllerIdentifier];
    [self.navigationController pushViewController:cusVC animated:YES];
}

- (IBAction)didTapDate:(id)sender {
    CalendarViewController *calVC = [[UIStoryboard storyboardWithName:kCalendarIdentifier bundle:nil]
        instantiateInitialViewController];
    [calVC didPickDateWithCompletionBlock:^(NSDate *dateSelected, CalendarPickerState state) {
        DateFormatter *formater = [[DateFormatter alloc] init];
        self.lbDate.text = [formater dateFormatterFullInfo:dateSelected];
    }];
    [self.navigationController pushViewController:calVC animated:YES];
}

#pragma mark - Api delegate
- (void)didEditTransaction:(Transaction *)transaction withMessage:(NSString *)message withError:(NSError *)error atIndexPath:(NSIndexPath *)indexPath {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (error) {
        [self.manager showAlertByMessage:message title:kCreateFail];
    } else {
        [self.manager showAlertByMessage:message title:kCreateSuccess];
        self.callBackBlock([self editedTransaction]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didCreateTransaction:(Transaction *)transaction withMessage:(NSString *)message withError:(NSError *)error {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (error) {
        [self.manager showAlertByMessage:message title:kCreateFail];
    } else {
        [self.manager showAlertByMessage:message title:kCreateSuccess];
        self.callBackBlock(transaction);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kCategoryListSegue]) {
        ListCategoryViewController *listVC = ((UINavigationController*)[segue
            destinationViewController]).viewControllers.firstObject;
        [listVC didAddItemWithCompletionBlock:^(Item *item) {
            [self.arrCategory addObject:item];
            [self reloadTableView];
            [self reloadSumTotal];
        }];
    }
    if ([segue.identifier isEqualToString:kShowQuantitySegue]) {
        PopoverQuatityViewController *quantityVC = [segue destinationViewController];
        NSIndexPath *path = (NSIndexPath*)sender;
        Item *item = self.arrCategory[path.row];
        quantityVC.item = item;
        [quantityVC didEnterQuantityWithCompletionBlock:^(NSUInteger quantity) {
            item.quantity = [NSNumber numberWithInteger:quantity];
            [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationTop];
            [self reloadSumTotal];
        }];
    }
}

#pragma mark - Block callback
- (void)updateTransaction:(Transaction *)transaction withCompleteBlock:(void(^)(Transaction* returnTran))block {
    self.callBackBlock = block;
    self.transaction = transaction;
}

@end
