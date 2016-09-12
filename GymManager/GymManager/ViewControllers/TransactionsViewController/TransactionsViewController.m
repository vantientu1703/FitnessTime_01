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

@interface TransactionsViewController () <UITableViewDelegate,UITableViewDataSource,ExpandableTableViewDelegate,TransactionManagerDelegate,UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewEmpty;
@property (weak, nonatomic) IBOutlet ExpandableTableView *tableView;
@property (strong, nonatomic) NSMutableArray *arrTrans;
@property (strong, nonatomic) UIRefreshControl *refresh;
@property (strong, nonatomic) TransactionManager *manager;
@property (strong, nonatomic) dispatch_queue_t transactionQueue;
@property (strong, nonatomic) NSNumberFormatter *numberFormatter;
@property (weak, nonatomic) IBOutlet UILabel *lbOverviewDetail;

@end

@implementation TransactionsViewController
#pragma mark - View's Life
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.transactionQueue = dispatch_queue_create("transaction_queue", DISPATCH_QUEUE_SERIAL);
    self.manager = [[TransactionManager alloc] init];
    self.numberFormatter = [NumberFormatterDecimal formatter];
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
    [self.tableView setAllHeadersInitiallyCollapsed:YES];
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
    self.lbOverviewDetail.text = @"All";
    [self.refresh beginRefreshing];
}

- (void)reloadOverView {
    self.lbNumOfTrans.text = @(self.arrTrans.count).stringValue;
    NSInteger sum = 0;
    for (Transaction *tran in self.arrTrans) {
        sum += tran.totalPrice;
    }
    self.lbTotalIncome.text = [NSString stringWithFormat:@"%@ Đ",[self.numberFormatter stringFromNumber:@(sum)]];
    self.viewEmpty.hidden = (self.arrTrans.count);
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    Transaction *tran = self.arrTrans[indexPath.section];
    Item *item = tran.items[indexPath.row];
    NSString *name;
    NSString *price;
    NSString *quantity;
    if ([item isKindOfClass:[NSDictionary class]]) {
        NSDictionary *itemtDic = (NSDictionary*)item;
        name = itemtDic[@"name"];
        NSNumber *priceNumber = @(((NSString*)itemtDic[@"price"]).integerValue);
        price = [self.numberFormatter stringFromNumber:priceNumber];
        quantity = [NSString stringWithFormat:@"x %@", itemtDic[@"quantity"]];
    } else {
        name = item.name;
        price = [self.numberFormatter stringFromNumber:@(item.price)];
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
- (void)didEditSection:(NSUInteger)section withHeaderView:(HeaderViewContent *)headerView {
    [self performSegueWithIdentifier:kAddTransactionSegue sender:@(section)];
}

- (void)didDeleteSection:(NSUInteger)section {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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
    UIActionSheet *picker = [[UIActionSheet alloc] initWithTitle:@"Filter By :" delegate:self
        cancelButtonTitle:kCancelTitle destructiveButtonTitle:nil otherButtonTitles:@"Day", @"Month", @"Year", nil];
    [picker showInView:self.view];
}

#pragma mark - Data handler
- (void)didFetchAllTransctionWithMessage:(NSString *)message withError:(NSError *)error returnTransactions:(NSArray *)transactions {
    if (error) {
        [self.manager showAlertByMessage:message title:error.localizedDescription];
    } else {
        [self.arrTrans removeAllObjects];
        self.arrTrans = [[transactions reverseObjectEnumerator] allObjects].mutableCopy;
        [self.tableView reloadData];
        [self reloadOverView];
        self.contraintTableViewCell.constant = self.tableView.contentSize.height;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    [self.refresh endRefreshing];
}

- (void)didDeleteTransctionWithMessage:(NSString *)message withError:(NSError *)error atSection:(NSInteger)section {
    dispatch_sync(self.transactionQueue, ^{
        [self.arrTrans removeObjectAtIndex:section];
        [self.tableView reloadData];
        [UIView animateWithDuration:0.3 animations:^{
            self.contraintTableViewCell.constant = self.tableView.contentSize.height;
            [self.view layoutIfNeeded];
            [self reloadOverView];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    });
}

#pragma mark - Action sheet picker delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        CalendarViewController *calVC = [[UIStoryboard storyboardWithName:@"Calendar" bundle:nil]
            instantiateInitialViewController];
        calVC.state = buttonIndex;
        [calVC didPickDateWithCompletionBlock:^(NSDate *dateSelected, CalendarPickerState state) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self.manager fetchAllTransactionByUser:[[DataStore sharedDataStore] getUserManage] withFilterState:state
                date:dateSelected];
            DateFormatter *formatter = [DateFormatter sharedInstance];
            switch (state) {
                case CalendarPickerStateDay:
                    self.lbOverviewDetail.text = [formatter stringFromDate:dateSelected
                        withFormat:DateFormatterTypeFullText];
                    break;
                case CalendarPickerStateMonth:
                    self.lbOverviewDetail.text = [formatter stringFromDate:dateSelected
                        withFormat:DateFormatterTypeFullTextWithMonth];
                    break;
                default:
                    self.lbOverviewDetail.text = [formatter stringFromDate:dateSelected
                        withFormat:DateFormatterTypeYear];
                    break;
            }
        }];
        [self.navigationController pushViewController:calVC animated:YES];
    }
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([kAddTransactionSegue isEqualToString:segue.identifier]) {
        AddTransactionViewController *addVC = (AddTransactionViewController*)[segue destinationViewController];
        if (sender) {
            //If edit transaction
            NSNumber *index = (NSNumber*)sender;
            Transaction *transaction = (Transaction*)self.arrTrans[index.integerValue];
            [addVC updateTransaction:transaction withCompleteBlock:^(Transaction *returnTran) {
                //Update tableview in queue
                dispatch_sync(self.transactionQueue, ^{
                    returnTran.createdAt = transaction.createdAt;
                    self.arrTrans[index.integerValue] = returnTran;
                    [self.tableView reloadData];
                    [self reloadOverView];
                });
            }];
        } else {
            [addVC updateTransaction:nil withCompleteBlock:^(Transaction *returnTran) {
                //Update tableview in queue
                dispatch_sync(self.transactionQueue, ^{
                    [self.arrTrans insertObject:returnTran atIndex:0];
                    [self.tableView reloadData];
                    self.contraintTableViewCell.constant = self.tableView.contentSize.height;
                    [self reloadOverView];
                });
            }];
        }
    }
}

@end
