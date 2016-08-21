//
//  CategoryViewController.m
//  GymManager
//
//  Created by Văn Tiến Tú on 8/19/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "CategoryViewController.h"
#import "CategoryTableViewCell.h"
#import "AddNewCategoryViewController.h"
#import "EditNumberOfCategoryViewController.h"

NSString *const kCategoryTableViewCellIdentifier = @"CategoryTableViewCell";
NSString *const kcategoryViewControllerTitle = @"Category";
CGFloat const kHeightCategoryCell = 44.0f;
CGFloat const kCornerRadiusAddNewVC = 5.0f;

@interface CategoryViewController ()<UITableViewDataSource, UITableViewDelegate, AddNewCategoryViewControllerDelegate, EditNumberOfCategoryViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) AddNewCategoryViewController *addNewCategoryVC;
@property (strong, nonatomic) UIView *viewGreyColorBackground;
@property (strong, nonatomic) EditNumberOfCategoryViewController *editNumberOfCategoryVC;

@end

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

#pragma mark - Set up view
- (void)setupView {
    self.title = kcategoryViewControllerTitle;
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
        target:self action:@selector(addNewCategory:)];
    self.navigationItem.rightBarButtonItem = addButton;
}

#pragma mark - Add button
- (IBAction)addNewCategory:(id)sender {
    [self showAddNewCategoryViewController];
}

- (void)showAddNewCategoryViewController {
    self.navigationItem.rightBarButtonItem.enabled = NO;
    CGSize size = [UIScreen mainScreen].bounds.size;
    [self showViewGreyColorBackground];
    UIStoryboard *st = [UIStoryboard storyboardWithName:kCustomerManagerStoryboard bundle:nil];
    self.addNewCategoryVC = [st
        instantiateViewControllerWithIdentifier:kAddNewCategoryViewControllerIdentifier];
    self.addNewCategoryVC.delegate = self;
    self.addNewCategoryVC.view.frame = CGRectMake(0.0f, 0.0f, size.width - 20.0f, size.height / 2.0f - 80.0f);
    self.addNewCategoryVC.view.center = CGPointMake(size.width / 2.0f, size.height / 3.0f);
    self.addNewCategoryVC.view.layer.cornerRadius = kCornerRadiusAddNewVC;
    [self addChildViewController:self.addNewCategoryVC];
    [self.addNewCategoryVC didMoveToParentViewController:self];
    [self.view addSubview:self.addNewCategoryVC.view];
}

#pragma mark - Init view grey background
- (void)showViewGreyColorBackground {
    self.viewGreyColorBackground = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.viewGreyColorBackground.backgroundColor = [UIColor lightGrayColor];
    self.viewGreyColorBackground.alpha = 0.7f;
    [self.view addSubview:self.viewGreyColorBackground];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
        initWithTarget:self action:@selector(removeAddNewCategoryVCFromParentViewController)];
    self.viewGreyColorBackground.userInteractionEnabled = YES;
    [self.viewGreyColorBackground addGestureRecognizer:tap];
}
#pragma mark - AddNewCategoryViewControllerDelegate
- (void)createNewCategory:(NSString *)categoryItem {
    [self removeAddNewCategoryVCFromParentViewController];
    //TODO
}

- (void)removeAddNewCategoryVCFromParentViewController {
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [self.viewGreyColorBackground removeFromSuperview];
    self.viewGreyColorBackground = nil;
    if (self.addNewCategoryVC) {
        [self.addNewCategoryVC.view removeFromSuperview];
        [self.addNewCategoryVC removeFromParentViewController];
        self.addNewCategoryVC = nil;
    }
    if (self.editNumberOfCategoryVC) {
        [self.editNumberOfCategoryVC.view removeFromSuperview];
        [self.editNumberOfCategoryVC removeFromParentViewController];
        self.editNumberOfCategoryVC = nil;
    }
}

#pragma mark - UITableViewDataSources
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //TODO
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CategoryTableViewCell *cell = (CategoryTableViewCell *)[tableView
        dequeueReusableCellWithIdentifier:kCategoryTableViewCellIdentifier forIndexPath:indexPath];
    //TODO
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kHeightCategoryCell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    [self showEditNumberOfCategoryVC];
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
        title:kEditActionTitle handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            [self showAddNewCategoryViewController];
    }];
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
        title:kDeleteActionTitle handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        //TODO
    }];
    return @[editAction, deleteAction];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return true;
}

#pragma mark - EditNumberOfCategoryViewControllerDelegate
- (void)setNumberOfCategory:(NSInteger)number {
    //TODO
    [self removeAddNewCategoryVCFromParentViewController];
}

- (void)removeEditVCFromParentViewController {
    [self removeAddNewCategoryVCFromParentViewController];
}

- (void)showEditNumberOfCategoryVC {
    self.navigationItem.rightBarButtonItem.enabled = NO;
    CGSize size = [UIScreen mainScreen].bounds.size;
    [self showViewGreyColorBackground];
    UIStoryboard *st = [UIStoryboard storyboardWithName:kCustomerManagerStoryboard bundle:nil];
    self.editNumberOfCategoryVC = [st
        instantiateViewControllerWithIdentifier:kEditNumberOfCategoryViewControllerIdentifier];
    self.editNumberOfCategoryVC.delegate = self;
    self.editNumberOfCategoryVC.view.frame = CGRectMake(0.0f, 0.0f, 200.0f, 150.0f);
    self.editNumberOfCategoryVC.view.center = CGPointMake(size.width / 2.0f, size.height / 3.0f);
    self.editNumberOfCategoryVC.view.layer.cornerRadius = kCornerRadiusAddNewVC;
    [self addChildViewController:self.editNumberOfCategoryVC];
    [self.editNumberOfCategoryVC didMoveToParentViewController:self];
    [self.view addSubview:self.editNumberOfCategoryVC.view];
}

@end
