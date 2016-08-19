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

NSString *const kPTMeetingCollectionViewCellIdentifier = @"MeetingCollectionViewCell";
CGFloat const kTriggerVerticalOffset = 100.0f;
CGFloat const kCornerRadiusButtonAddNewMeeting = 20.0f;
//TODO
NSString *const kNameTrainer = @"Nguyen Van Van Duong";

@interface PTMeetingViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) UIRefreshControl *refreshReloadData;
@property (strong, nonatomic) UIRefreshControl *refreshLoadMoreData;
@property (weak, nonatomic) IBOutlet UIButton *buttonAddNewMeeting;

@end

@implementation PTMeetingViewController

#pragma mark - View's life
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
}

- (void)setupView {
    self.title = kPTMeetingViewControllerTitle;
    self.buttonAddNewMeeting.layer.cornerRadius = kCornerRadiusButtonAddNewMeeting;
    self.refreshReloadData = [[UIRefreshControl alloc] init];
    [self.refreshReloadData addTarget:self action:@selector(reloadDataCollectionView:)
        forControlEvents:UIControlEventValueChanged];
    [self.collectionView insertSubview:self.refreshReloadData atIndex:0];
    
    self.refreshLoadMoreData = [[UIRefreshControl alloc] init];
    [self.refreshLoadMoreData addTarget:self action:@selector(loadMoreData:)
        forControlEvents:UIControlEventValueChanged];
    self.refreshLoadMoreData.triggerVerticalOffset = kTriggerVerticalOffset;
    self.collectionView.bottomRefreshControl = self.refreshLoadMoreData;
}

#pragma mark - Load data from server
- (IBAction)loadMoreData:(id)sender {
    //TODO
    [self.refreshLoadMoreData endRefreshing];
}

- (IBAction)reloadDataCollectionView:(id)sender {
    //TODO
    [self.refreshReloadData endRefreshing];
}

#pragma mark - UICollectionViewDataSources
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //TODO
    return 12;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //TODO
    PTMeetingCollectionViewCell *cell = (PTMeetingCollectionViewCell *)[collectionView
        dequeueReusableCellWithReuseIdentifier:kPTMeetingCollectionViewCellIdentifier
        forIndexPath:indexPath];
    [cell initWithImageName:[UIImage imageNamed:kIconUser] withNameTrainer:kNameTrainer];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:true];
    //TODO
    UIStoryboard *st = [UIStoryboard storyboardWithName:kNameStoryboard bundle:nil];
    DetailPTManagerViewController *detailPTManagerVC = [st
        instantiateViewControllerWithIdentifier:kDetailPTManagerViewControllerIdentifier];
    [self.navigationController pushViewController:detailPTManagerVC animated:true];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    //TODO
}

#pragma mark - Add new meeting
- (IBAction)buttonAddNewMeetingPress:(id)sender {
    UIStoryboard *st = [UIStoryboard storyboardWithName:kNameStoryboard bundle:nil];
    MeetingDetailViewController *meetingDetailViewController = [st
        instantiateViewControllerWithIdentifier:kMeetingDetailViewControllerIdentifier];
    [self.navigationController pushViewController:meetingDetailViewController animated:true];
}

@end
