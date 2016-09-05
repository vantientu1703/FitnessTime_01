//
//  DetailPTManagerViewController.m
//  GymManager
//
//  Created by Văn Tiến Tú on 8/19/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "DetailPTManagerViewController.h"
#import "EditPTManagerViewController.h"

CGFloat const kCornerRadiusImageViewPT = 40.0f;

@interface DetailPTManagerViewController ()<EditPTManagerViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewBackground;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewPT;
@property (weak, nonatomic) IBOutlet UILabel *labelNamePT;
@property (weak, nonatomic) IBOutlet UILabel *labelPhoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *labelDateOfBirth;
@property (weak, nonatomic) IBOutlet UILabel *labelAddress;
@property (weak, nonatomic) IBOutlet UILabel *labelEmail;
@property (weak, nonatomic) IBOutlet UILabel *labelIncomeThisMonth;
@property (weak, nonatomic) IBOutlet UILabel *labelShowIncomeThisMonth;

@end

@implementation DetailPTManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
    [self setupInfoTrainer];
}

- (void)setupInfoTrainer {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kURLImage, self.trainer.avatar]];
    [self.imageViewPT sd_setImageWithURL:url
        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!image) {
            self.imageViewPT.image = [UIImageConstant imageUserConstant];
        }
    }];
    DateFormatter *dateFormatter = [[DateFormatter alloc] init];
    self.labelAddress.text = self.trainer.address;
    self.labelDateOfBirth.text = [dateFormatter dateFormatterDateMonthYear:self.trainer.birthday];
    self.labelEmail.text = self.trainer.email;
    self.labelNamePT.text = self.trainer.fullName;
    self.labelPhoneNumber.text = self.trainer.telNumber;
}

- (void)setupView {
    self.title = kDetailPTManagerTitle;
    self.viewBackground.layer.cornerRadius = kCornerRadiusViewBackground;
    self.imageViewPT.layer.cornerRadius = kCornerRadiusImageViewPT;
    self.imageViewPT.layer.masksToBounds = YES;
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]
        initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
        target:self action:@selector(editPTProfile:)];
    self.navigationItem.rightBarButtonItem = editButton;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
        initWithTarget:self action:@selector(showIncomeThisMonth:)];
    [self.labelShowIncomeThisMonth addGestureRecognizer:tap];
    [self.labelIncomeThisMonth addGestureRecognizer:tap];
    self.labelIncomeThisMonth.userInteractionEnabled = true;
    self.labelShowIncomeThisMonth.userInteractionEnabled = true;
}

#pragma mark - Edit button
- (IBAction)editPTProfile:(id)sender {
    //TODO
    UIStoryboard *st = [UIStoryboard storyboardWithName:kNameStoryboard bundle:nil];
    EditPTManagerViewController *editPTManagerVC = [st
        instantiateViewControllerWithIdentifier:kEditPTManagerViewControllerIdentifier];
    editPTManagerVC.trainer = self.trainer;
    editPTManagerVC.statusEditString = kEditTrainerTitle;
    editPTManagerVC.delegate = self;
    [self.navigationController pushViewController:editPTManagerVC animated:true];
}

#pragma mark - Show income this month
- (IBAction)showIncomeThisMonth:(id)sender {
    //TODO
}

#pragma mark - EditPTManagerViewControllerDelegate
- (void)updateTrainer:(Trainer *)trainer {
    self.trainer = trainer;
    [self setupInfoTrainer];
    if ([self.delegate respondsToSelector:@selector(reloadDataCollectionView:)]) {
        [self.delegate reloadDataCollectionView:trainer];
    }
}

@end
