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

@interface DetailPTManagerViewController ()

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
}

- (void)setupView {
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
    [self.navigationController pushViewController:editPTManagerVC animated:true];
}

#pragma mark - Show income this month
- (IBAction)showIncomeThisMonth:(id)sender {
    //TODO
}

@end
