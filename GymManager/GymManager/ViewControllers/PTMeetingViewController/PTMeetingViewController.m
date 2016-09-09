//
//  PushViewController.m
//  GymManager
//
//  Created by Văn Tiến Tú on 8/11/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "PTMeetingViewController.h"
#import "PTMeetingCollectionViewCell.h"
#import <CCBottomRefreshControl/UIScrollView+BottomRefreshControl.h>
#import "MeetingDetailViewController.h"
#import "DetailPTManagerViewController.h"
#import "TodayMeetingsViewController.h"
#import "EditPTManagerViewController.h"
#import "TrainerManager.h"
#import "DetailMeetingPTViewController.h"

CGFloat const kTriggerVerticalOffset = 100.0f;
//TODO
NSString *const kNameTrainer = @"Nguyen Van Van Duong";

@interface PTMeetingViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, TrainerManagerDelegate, EditPTManagerViewControllerDelegate, DetailPTManagerViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) UIRefreshControl *refreshReloadData;
@property (strong, nonatomic) UIRefreshControl *refreshLoadMoreData;
@property (weak, nonatomic) IBOutlet UIButton *buttonAddNewMeeting;
@property (strong, nonatomic) NSMutableArray *arrTrainers;

@end

@implementation PTMeetingViewController
{
    NSIndexPath *_indexPath;
}
#pragma mark - View's life
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
    [self getAllTrainers];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNewTrainer:)
        name:kAddNewTrainerTitle object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTrainers:)
        name:kUpdateTrainerTitle object:nil];
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
}

- (void)updateTrainers:(NSNotification *)notification {
    if (notification) {
        NSDictionary *userInfo = notification.userInfo;
        Trainer *trainer = userInfo[@"trainer"];
        [self.arrTrainers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            Trainer *trainerIntance = (Trainer *)obj;
            if (trainer.id == trainerIntance.id) {
                [self.arrTrainers replaceObjectAtIndex:idx withObject:trainer];
                [self.collectionView reloadData];
                return;
            }
        }];
    }
}

- (void)getAllTrainers {
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    TrainerManager *trainerManager = [[TrainerManager alloc] init];
    trainerManager.delegate = self;
    [trainerManager getAllTrainers];
}

- (void)setupView {
    if ([self.statusAddNewMeeting isEqualToString:kDetailMeetingTitle]) {
        self.title = kPTMeetingViewControllerTitle;
    } else {
        self.title = kPTManagerVCTitle;
    }
    self.buttonAddNewMeeting.layer.cornerRadius = kCornerRadiusButtonAddNewMeeting;
    self.refreshReloadData = [[UIRefreshControl alloc] init];
    [self.refreshReloadData addTarget:self action:@selector(reloadDataCollectionViews:)
        forControlEvents:UIControlEventValueChanged];
    [self.collectionView insertSubview:self.refreshReloadData atIndex:0];
}

#pragma mark - TrainerManagerDelegate
- (void)didResponseWithMessage:(NSString *)message withError:(NSError *)error returnArray:(NSArray *)arrTrainer {
    if (error) {
        [AlertManager showAlertWithTitle:kReminderTitle message:message viewControler:self reloadAction:^{
            [self getAllTrainers];
        }];
    } else {
        if (arrTrainer) {
            [MBProgressHUD hideHUDForView:self.view animated:true];
            self.arrTrainers = arrTrainer.mutableCopy;
            [self.collectionView reloadData];
        }
    }
}

#pragma mark - Load data from server
- (IBAction)loadMoreData:(id)sender {
    //TODO
    [self.refreshLoadMoreData endRefreshing];
}

- (IBAction)reloadDataCollectionViews:(id)sender {
    [self getAllTrainers];
    [self.refreshReloadData endRefreshing];
}

#pragma mark - UICollectionViewDataSources
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrTrainers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PTMeetingCollectionViewCell *cell = (PTMeetingCollectionViewCell *)[collectionView
        dequeueReusableCellWithReuseIdentifier:kPTMeetingCollectionViewCellIdentifier
        forIndexPath:indexPath];
    Trainer *trainer = self.arrTrainers[indexPath.row];
    [cell cellWithTrainer:trainer];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:true];
    UIStoryboard *st = [UIStoryboard storyboardWithName:kDetailMeetingPTStoryboardIdentifier bundle:nil];
    if ([self.statusAddNewMeeting isEqualToString:kDetailMeetingTitle]) {
        DetailMeetingPTViewController *detailMeetingPTVC = [st
            instantiateViewControllerWithIdentifier:kDetailMeetingPTVCIdentifier];
        detailMeetingPTVC.statusDetailMeeting = kDetailMeetingsTrainerVCTitle;
        detailMeetingPTVC.trainer = self.arrTrainers[indexPath.row];
        [self.navigationController pushViewController:detailMeetingPTVC animated:true];
    } else if ([self.statusAddNewMeeting isEqualToString:kDetailPTManagerTitle]) {
        DetailPTManagerViewController *detailPTManagerVC = [st
            instantiateViewControllerWithIdentifier:kDetailPTManagerViewControllerIdentifier];
        detailPTManagerVC.trainer = self.arrTrainers[indexPath.row];
        _indexPath = indexPath;
        detailPTManagerVC.delegate = self;
        [self.navigationController pushViewController:detailPTManagerVC animated:true];
    } else if ([self.statusAddNewMeeting isEqualToString:kStatusAddNewMeeting]) {
        if ([self.delegate respondsToSelector:@selector(selectedTrainer:)]) {
            [self.delegate selectedTrainer:self.arrTrainers[indexPath.row]];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    //TODO
}

#pragma mark - DetailPTManagerViewControllerDelegate
- (void)reloadDataCollectionView:(Trainer *)trainer {
    [self.arrTrainers replaceObjectAtIndex:_indexPath.row withObject:trainer];
    [self.collectionView reloadData];
}

#pragma mark - Add new meeting
- (IBAction)buttonAddNewMeetingPress:(id)sender {
    UIStoryboard *st = [UIStoryboard storyboardWithName:kNameStoryboard bundle:nil];
    if ([self.statusAddNewMeeting isEqualToString:kDetailMeetingTitle]) {
        MeetingDetailViewController *meetingDetailViewController = [st
            instantiateViewControllerWithIdentifier:kMeetingDetailViewControllerIdentifier];
        meetingDetailViewController.statusEditMeeting = kAddNewMeetingTitle;
        [self.navigationController pushViewController:meetingDetailViewController animated:true];
    } else {
        EditPTManagerViewController *editPTManagerVC = [st
            instantiateViewControllerWithIdentifier:kEditPTManagerViewControllerIdentifier];
        editPTManagerVC.delegate = self;
        [self.navigationController pushViewController:editPTManagerVC animated:true];
    }
}

#pragma mark - EditPTManagerViewControllerDelegate
- (void)createNewTrainer:(Trainer *)trainer {
    if (!self.arrTrainers) {
        self.arrTrainers = [NSMutableArray array];
    }
    [self.arrTrainers addObject:trainer];
    [self.collectionView reloadData];
}

@end
