//
//  PTManagerViewController.m
//  GymManager
//
//  Created by Văn Tiến Tú on 9/6/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "PTManagerViewController.h"
#import "PTMeetingCollectionViewCell.h"
#import "EditPTManagerViewController.h"
#import "DetailPTManagerViewController.h"

@interface PTManagerViewController ()<TrainerManagerDelegate, EditPTManagerViewControllerDelegate, DetailPTManagerViewControllerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *buttonAddPT;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *arrTrainers;
@property (strong, nonatomic) UIRefreshControl *refreshReloadData;
@property (strong, nonatomic) UILabelNoData *labelNoData;

@end

@implementation PTManagerViewController
{
    NSIndexPath *_indexPath;
    BOOL _modifier;
    BOOL _isRefresh;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
    if (![FBSDKAccessToken currentAccessToken]) {
        [self getAllTrainers];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNewTrainer:)
        name:kAddNewTrainerTitle object:nil];
}

- (void)createLabelNoData {
    if (!self.arrTrainers.count) {
        if (!self.labelNoData) {
            self.labelNoData = [UILabelNoData lableNoData];
            [self.view addSubview:self.labelNoData];
        }
    } else {
        if (self.labelNoData) {
            [self.labelNoData removeFromSuperview];
            self.labelNoData = nil;
        }
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - NSNotificationCenter
- (void)addNewTrainer:(NSNotification *)notification {
    if (!self.arrTrainers) {
        self.arrTrainers = [NSMutableArray array];
    }
    if ([notification.name isEqualToString:kAddNewTrainerTitle]) {
        NSDictionary *userInfo = notification.userInfo;
        Trainer *trainer = userInfo[@"trainer"];
        [self.arrTrainers addObject:trainer];
        [self.collectionView reloadData];
    }
    [self createLabelNoData];
}

- (void)getAllTrainers {
    if (!_isRefresh) {
        [MBProgressHUD showHUDAddedTo:self.view animated:true];
        _isRefresh = false;
    }
    TrainerManager *trainerManager = [[TrainerManager alloc] init];
    trainerManager.delegate = self;
    [trainerManager getAllTrainers];
}

- (void)setupView {
    self.title = kPTManagerVCTitle;
    self.buttonAddPT.layer.cornerRadius = kCornerRadiusButtonAddNewMeeting;
    self.refreshReloadData = [[UIRefreshControl alloc] init];
    [self.refreshReloadData addTarget:self action:@selector(reloadDataCollectionViews:)
        forControlEvents:UIControlEventValueChanged];
    [self.collectionView insertSubview:self.refreshReloadData atIndex:0];
}

- (IBAction)reloadDataCollectionViews:(id)sender {
    _isRefresh = true;
    [self getAllTrainers];
}

#pragma mark - Add new trainer
- (IBAction)addNewPTPress:(id)sender {
    UIStoryboard *st = [UIStoryboard storyboardWithName:kNameStoryboard bundle:nil];
    EditPTManagerViewController *editPTManagerVC = [st
        instantiateViewControllerWithIdentifier:kEditPTManagerViewControllerIdentifier];
    editPTManagerVC.delegate = self;
    [self.navigationController pushViewController:editPTManagerVC animated:true];
}

#pragma mark - TrainerManagerDelegate
- (void)didResponseWithMessage:(NSString *)message withError:(NSError *)error returnArray:(NSArray *)arrTrainer {
    [MBProgressHUD hideHUDForView:self.view animated:true];
    [self.refreshReloadData endRefreshing];
    if (error) {
        [AlertManager showAlertWithTitle:kReminderTitle message:message viewControler:self reloadAction:^{
            [self getAllTrainers];
        }];
    } else {
        if (arrTrainer) {
            self.arrTrainers = arrTrainer.mutableCopy;
            [self.collectionView reloadData];
        }
    }
    [self createLabelNoData];
}

#pragma mark - UICollectionViewDataSources
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrTrainers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PTMeetingCollectionViewCell *cell = (PTMeetingCollectionViewCell *)[collectionView
        dequeueReusableCellWithReuseIdentifier:kPTMeetingCollectionViewCellIdentifier forIndexPath:indexPath];
    Trainer *trainer = self.arrTrainers[indexPath.row];
    [cell cellWithTrainer:trainer];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:true];
    UIStoryboard *st = [UIStoryboard storyboardWithName:kNameStoryboard bundle:nil];
    DetailPTManagerViewController *detailPTManagerVC = [st
        instantiateViewControllerWithIdentifier:kDetailPTManagerViewControllerIdentifier];
    detailPTManagerVC.trainer = self.arrTrainers[indexPath.row];
    _indexPath = indexPath;
    detailPTManagerVC.delegate = self;
    [self.navigationController pushViewController:detailPTManagerVC animated:true];
}

#pragma mark - EditPTManagerViewControllerDelegate
- (void)createNewTrainer:(Trainer *)trainer {
    if (!self.arrTrainers) {
        self.arrTrainers = [NSMutableArray array];
    }
    [self.arrTrainers addObject:trainer];
    [self.collectionView reloadData];
    [self createLabelNoData];
}

#pragma mark - DetailPTManagerViewControlerDelegate
- (void)reloadDataCollectionView:(Trainer *)trainer {
    [self.arrTrainers replaceObjectAtIndex:_indexPath.row withObject:trainer];
    [self.collectionView reloadData];
}

@end
