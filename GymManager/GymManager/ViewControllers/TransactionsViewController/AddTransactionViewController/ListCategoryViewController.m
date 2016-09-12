//
//  ListCategoryViewController.m
//  GymManager
//
//  Created by Thinh on 8/15/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "ListCategoryViewController.h"
#import "CategoryCell.h"
#import "PopoverQuatityViewController.h"
#import "PopoverEditItemViewController.h"
#import "CategoryManager.h"

NSString *const kShowEditSegue = @"ShowEditSegue";

@interface ListCategoryViewController () <UITableViewDelegate, UITableViewDataSource, CategoryManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refresh;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnCancel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnEdit;
@property (strong, nonatomic) NSMutableArray *arrCategory;
@property (strong, nonatomic) PopoverQuatityViewController *quantityView;
@property (strong, nonatomic) CategoryManager *manager;
@property (strong, nonatomic) DataStore *dataStore;
@property (copy, nonatomic) void(^completionBlock)(Item *item);

@end

@implementation ListCategoryViewController

#pragma mark - View's life
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.refresh = [[UIRefreshControl alloc] init];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.navigationController setNavigationBarHidden:NO];
    self.arrCategory = @[].mutableCopy;
    [self.tableView registerNib:[UINib nibWithNibName:kTransactionCellIndentifier bundle:nil]
         forCellReuseIdentifier:kTransactionCellIndentifier];
    self.tableView.allowsSelectionDuringEditing = YES;
    [self.refresh addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refresh atIndex:0];
    self.manager = [[CategoryManager alloc] init];
    self.dataStore = [DataStore sharedDataStore];
    self.manager.delegate = self;
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData {
    if (![self.dataStore getItemsListWithSelectedItemsList:nil].count) {
        [self.refresh beginRefreshing];
        [self.manager getAllItemsByUser:[self.dataStore getUserManage]];
    } else {
        self.arrCategory = [self.dataStore getItemsListWithSelectedItemsList:self.arrCategoryPicked].mutableCopy;
        [self.tableView reloadData];
    }
}

- (void)reloadData {
    [self.refresh beginRefreshing];
    [self.manager getAllItemsByUser:[self.dataStore getUserManage]];
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
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    Item *item = self.arrCategory[indexPath.row];
    cell.lbCategory.text = item.name;
    cell.lbCost.text = [NSString stringWithFormat:@"%@ Đ", [[NumberFormatterDecimal formatter]
        stringFromNumber:@(item.price)]];
    [cell.lbQuantity setHidden:YES];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.isEditing) {
        [self performSegueWithIdentifier:kShowEditSegue sender:indexPath];
    } else {
        if (![self.showCategoryTitle isEqualToString:kShowCategoryTitle]) {
            [self performSegueWithIdentifier:kShowQuantitySegue sender:indexPath];
        }
    }
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *ac1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive
        title:@"Delete" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self.manager deleteItem:self.arrCategory[indexPath.row] ByUser:[self.dataStore getUserManage]
            atIndexPath:indexPath];
        [MBProgressHUD showHUDAddedTo:[self.tableView cellForRowAtIndexPath:indexPath] animated:YES];
    }];
    return @[ac1];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - Button Hanlder
- (IBAction)btnCancelClick:(id)sender {
    if (self.tableView.isEditing) {
        [self performSegueWithIdentifier:kShowEditSegue sender:nil];
    } else {
        if ([self.showCategoryTitle isEqualToString:kShowCategoryTitle]) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (IBAction)btnEdit:(id)sender {
    if (self.tableView.isEditing) {
        self.mode = ItemListModeEdit;
        [self.tableView setEditing:NO animated:YES];
        [self.btnCancel setTitle:@"Cancel"];
        [self.btnEdit setTitle:@"Edit"];
    } else {
        self.mode = ItemListModeNormal;
        [self.tableView setEditing:YES animated:YES];
        [self.btnCancel setTitle:@"Add"];
        [self.btnEdit setTitle:@"Done"];
    }
}

#pragma mark - APi delegate
- (void)didFetchAllItemsWithMessage:(NSString *)message withError:(NSError *)error returnItems:(NSArray *)items {
    if (error) {
        [self.manager showAlertByMessage:message title:@"Error"];
    } else {
        [self.arrCategory removeAllObjects];
        for (Item *item in items) {
            BOOL contain = NO;
            for (Item *curItem in self.arrCategoryPicked) {
                if ([curItem.id isEqualToString:item.id]) {
                    contain = YES;
                    break;
                }
            }
            if (!contain) {
                [self.arrCategory addObject:item];
            }
        }
        [self.tableView reloadData];
        [self.dataStore setItemsList:items];
    }
    [self.refresh endRefreshing];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)didCreateItem:(Item*)item WithMessage:(NSString *)message withError:(NSError *)error {
    if (error) {
        [self.manager showAlertByMessage:message title:@"Error"];
    } else {
        [self.arrCategory addObject:item];
        [self.dataStore addItem:item];
        [self.tableView reloadData];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)didUpdateItem:(Item *)item WithMessage:(NSString *)message withError:(NSError *)error atIndexPath:(NSIndexPath *)indexPath {
    if (error) {
        [self.manager showAlertByMessage:message title:@"Error"];
    } else {
        self.arrCategory[indexPath.row] = item;
        [self.dataStore updateItem:item];
        [self.tableView reloadData];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)didDeleteItemWithMessage:(NSString *)message withError:(NSError *)error atIndexPath:(NSIndexPath *)indexPath{
    if (error) {
        [self.manager showAlertByMessage:message title:@"Error"];
    } else {
        [self.dataStore deleteItem:self.arrCategory[indexPath.row]];
        [self.arrCategory removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    }
    [MBProgressHUD hideHUDForView:[self.tableView cellForRowAtIndexPath:indexPath] animated:YES];
}

#pragma mark - navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kShowQuantitySegue]) {
        PopoverQuatityViewController *quantityVC = segue.destinationViewController;
        [quantityVC didEnterQuantityWithCompletionBlock:^(NSUInteger quantity) {
            Item *item;
            NSIndexPath *path = (NSIndexPath*)sender;
            item = [self.arrCategory[path.row] copy];
            item.quantity = @(quantity);
            self.completionBlock(item);
            [self btnCancelClick:sender];
        }];
    }
    if ([segue.identifier isEqualToString:kShowEditSegue]) {
        PopoverEditItemViewController *editVC = [segue destinationViewController];
        NSIndexPath *path = (NSIndexPath*)sender;
        if (path) {
            editVC.item = self.arrCategory[path.row];
        }
        [editVC didEditItemWithCompletionBlock:^(Item *item) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            if (sender) {
                [self.manager updateItem:item ByUser:[self.dataStore getUserManage]atIndexPath:path];
            } else {
                [self.manager createItem:item ByUser:[self.dataStore getUserManage]];
            }
        }];
    }
}

- (void)didAddItemWithCompletionBlock:(void(^)(Item *item))block {
    self.completionBlock = block;
}

@end
