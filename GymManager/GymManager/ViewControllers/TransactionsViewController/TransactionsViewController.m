//
//  TransactionsViewController.m
//  GymManager
//
//  Created by Văn Tiến Tú on 8/11/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "TransactionsViewController.h"
#import "CategoryCell.h"
#import "CalendarViewController.h"
#import "TransactionManager.h"
#import "MBProgressHUD.h"
#import "AddTransactionViewController.h"

NSString *const kAddTransactionSegue = @"AddTransactionSegue";

@interface TransactionsViewController () <UITableViewDelegate,UITableViewDataSource,ExpandableTableViewDelegate,TransactionManagerDelegate>

@property (weak, nonatomic) IBOutlet ExpandableTableView *tableView;
@property (strong, nonatomic) NSMutableArray *arrTrans;
@property (strong, nonatomic) UIRefreshControl *refresh;
@property (strong, nonatomic) TransactionManager *manager;
@property (strong, nonatomic) dispatch_queue_t transactionQueue;

@end

@implementation TransactionsViewController
#pragma mark - View's Life
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.transactionQueue = dispatch_queue_create("transaction_queue", DISPATCH_QUEUE_SERIAL);
    self.manager = [[TransactionManager alloc] init];
    self.manager.delegate = self;
    [self setupView];
    [self reloadDataForWholeView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView {
    //Setup Navigation bar
    UIBarButtonItem *calendarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:kIconCalendar]
        style:UIBarButtonItemStylePlain target:self action:@selector(showCalendar)];
    self.navigationItem.rightBarButtonItem = calendarButton;
    //Setup Tableview
    self.arrTrans = @[].mutableCopy;
    [self.tableView setAllHeadersInitiallyCollapsed:NO];
    [self.tableView setScrollEnabled:NO];
    self.tableView.expandableDelegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:kTransactionCellIndentifier bundle:nil]
        forCellReuseIdentifier:kTransactionCellIndentifier];
    [self.tableView reloadData];
    self.contraintTableViewCell.constant = self.tableView.contentSize.height;
    //Pull to rrefresh
    self.refresh = [[UIRefreshControl alloc] init];
    [self.refresh addTarget:self action:@selector(reloadDataForWholeView)
        forControlEvents:UIControlEventValueChanged];
    [self.scrollView insertSubview:self.refresh atIndex:0];
    [self.scrollView setAlwaysBounceVertical:YES];
    [self.indicaLoadMore setHidden:YES];
}

#pragma mark - Load Data 
- (void)reloadDataForWholeView {
    [self.manager fetchAllTransactionByUser:[[DataStore sharedDataStore] getUserManage]];
    [self.refresh beginRefreshing];
}

#pragma mark - TableView Implementation
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.arrTrans.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableView totalNumberOfRows:((Transaction*)self.arrTrans[section]).items.count inSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kTableViewCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kTableViewHeaderHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CategoryCell *cell = (CategoryCell*)[tableView dequeueReusableCellWithIdentifier:kTransactionCellIndentifier
        forIndexPath:indexPath];
    Transaction *tran = self.arrTrans[indexPath.section];
    Item *item = tran.items[indexPath.row];
    NSString *name;
    NSString *price;
    NSString *quantity;
    if ([item isKindOfClass:[NSDictionary class]]) {
        NSDictionary *itemtDic = (NSDictionary*)item;
        name = itemtDic[@"name"];
        price = [NSString stringWithFormat:@"%@", itemtDic[@"price"]];
        quantity = [NSString stringWithFormat:@"x %@", itemtDic[@"quantity"]];
    } else {
        name = item.name;
        price = [NSString stringWithFormat:@"%.0fĐ", item.price];
        quantity = [NSString stringWithFormat:@"x %ld", (long)item.quantity.integerValue];
    }
    cell.lbCategory.text = name;
    cell.lbCost.text = price;
    cell.lbQuantity.text = quantity;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self.tableView headerWithTransaction:self.arrTrans[section]
        totalRows:((Transaction*)self.arrTrans[section]).items.count inSection:section];
}

#pragma mark - actionsheet in tableview delegate
- (void)didEditSection:(NSUInteger)section {
    [self performSegueWithIdentifier:kAddTransactionSegue sender:@(section)];
}

- (void)didDeleteSection:(NSUInteger)section {
    [self.manager deleteTransaction:self.arrTrans[section] byUser:[[DataStore sharedDataStore] getUserManage]
        atSection:section];
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *ac1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
        title:@"Edit" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        //TODO
    }];
    UITableViewRowAction *ac2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive
        title:@"Delete" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        //TODO
    }];
    return @[ac2, ac1];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (void)didEndAnimationWithNumberOffCellChange:(NSInteger)numberOfCell{
    CGFloat height = kTableViewCellHeight * numberOfCell;
    [UIView animateWithDuration:0.3 animations:^{
        self.contraintTableViewCell.constant += height;
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - Action Hanlder
- (IBAction)btnLoadMoreClick:(id)sender {
    //TODO refresh data here
    [self.indicaLoadMore setHidden:NO];
    [self.indicaLoadMore startAnimating];
    [self.btnLoadMore setHidden:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.indicaLoadMore setHidden:YES];
        [self.btnLoadMore setHidden:NO];
    });
}

- (IBAction)btnAddTranClick:(id)sender {
    [self performSegueWithIdentifier:kAddTransactionSegue sender:nil];
}

- (void)showCalendar {
    CalendarViewController *calVC = [[UIStoryboard storyboardWithName:@"Calendar" bundle:nil]
        instantiateInitialViewController];
    [calVC didPickDateWithCompletionBlock:^(NSDate *dateSelected, CalendarPickerState state) {
        //TODO
    }];
    [self.navigationController pushViewController:calVC animated:YES];
}

#pragma mark - Data handler
- (void)didFetchAllTransctionWithMessage:(NSString *)message withError:(NSError *)error returnTransactions:(NSArray *)transactions {
    [self.refresh endRefreshing];
    if (error) {
        [self.manager showAlertByMessage:message title:error.localizedDescription];
    } else {
        [self.arrTrans removeAllObjects];
        self.arrTrans = transactions.mutableCopy;
        [self.tableView reloadData];
        self.contraintTableViewCell.constant = self.tableView.contentSize.height;
    }
}

- (void)didDeleteTransctionWithMessage:(NSString *)message withError:(NSError *)error atSection:(NSInteger)section {
    dispatch_sync(self.transactionQueue, ^{
        [self.arrTrans removeObjectAtIndex:section];
        [self.tableView reloadData];
        [UIView animateWithDuration:0.3 animations:^{
            self.contraintTableViewCell.constant = self.tableView.contentSize.height;
            [self.view layoutIfNeeded];
        }];
    });
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([kAddTransactionSegue isEqualToString:segue.identifier]) {
        AddTransactionViewController *addVC = (AddTransactionViewController*)[segue destinationViewController];
        if (sender) {
            //If edit transaction
            NSNumber *index = (NSNumber*)sender;
            [addVC updateTransaction:[self.arrTrans[index.integerValue] copy] withCompleteBlock:^(Transaction *returnTran) {
                //Update tableview in queue
                dispatch_sync(self.transactionQueue, ^{
                    self.arrTrans[index.integerValue] = returnTran;
                    [self.tableView reloadData];
                });
            }];
        } else {
            [addVC updateTransaction:nil withCompleteBlock:^(Transaction *returnTran) {
                //Update tableview in queue
                dispatch_sync(self.transactionQueue, ^{
                    [self.arrTrans insertObject:returnTran atIndex:0];
                    [self.tableView reloadData];
                    self.contraintTableViewCell.constant = self.tableView.contentSize.height;
                });
            }];
        }
    }
}

@end
