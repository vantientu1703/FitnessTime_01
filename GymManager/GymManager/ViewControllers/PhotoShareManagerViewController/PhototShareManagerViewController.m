//
//  PhototShareManagerViewController.m
//  GymManager
//
//  Created by Văn Tiến Tú on 9/20/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "PhototShareManagerViewController.h"
#import "PhotoShareManagerCollectionViewCell.h"

NSString *const kPhotoShareManagerCollectionViewCellIdentifier = @"PhotoShareManagerCollectionViewCell";
NSString *const kImageKeys = @"imagekey%ld";

@interface PhototShareManagerViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, AlertManagerDelegate, PhotoShareManagerCollectionViewCellDelegate, ELCImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *arrImages;

@end

@implementation PhototShareManagerViewController
{
    NSInteger _totalKeys;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self showTakePhoto];
}

- (void)setupView {
    _totalKeys = 0;
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]
        initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPress:)];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
        initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donePress:)];
    self.navigationItem.rightBarButtonItem = doneButton;
    self.navigationItem.leftBarButtonItem = cancelButton;
}

- (IBAction)cancelPress:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)donePress:(id)sender {
    if ([self.delegate respondsToSelector:@selector(fillImageToViewWithArrayImages:)]) {
        __block NSMutableArray *images = [NSMutableArray array];
        if (self.arrImages.count) {
            for (NSInteger idx = 0; idx < _totalKeys; idx++) {
                NSString *key = [NSString stringWithFormat:kImageKeys, idx];
                UIImage *image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:key];
                if (image) {
                    [images addObject:image];
                }
            };
        }
        [self.delegate fillImageToViewWithArrayImages:images];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showTakePhoto {
    AlertManager *alert = [[AlertManager alloc] init];
    alert.delegate = self;
    [alert showChooseImageAlertWithTitle:kReminderTitle vieController:self];
}

#pragma mark - AlertManagerDelegate
- (void)showQBImagePikcerController:(ELCImagePickerController *)qbImagePickerController {
    qbImagePickerController.imagePickerDelegate = self;
    [self presentViewController:qbImagePickerController animated:YES completion:NULL];
}

#pragma mark - ELCImagePickerControllerDelegate
- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info {
    for (NSDictionary *dict in info) {
        UIImage *choosenImage = dict[UIImagePickerControllerOriginalImage];
        if (!self.arrImages) {
            self.arrImages = [NSMutableArray array];
        }
        UIImage *ima = [Utils convertImageToThumbnailImage:choosenImage withSize:CGSizeMake(200.f, 100.f)];
        NSInteger index;
        if (!self.arrImages.count) {
            index = 0;
        } else {
            index = self.arrImages.count;
        }
        _totalKeys += 1;
        NSString *key = [NSString stringWithFormat:kImageKeys, index];
        [[SDImageCache sharedImageCache] storeImage:choosenImage forKey:key];
        [self.arrImages addObject:ima];
    }
    [self.collectionView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    if (!self.arrImages) {
        self.arrImages = [NSMutableArray array];
    }
    UIImage *ima = [Utils convertImageToThumbnailImage:chosenImage withSize:CGSizeMake(200.f, 100.f)];
    NSInteger index;
    if (!self.arrImages.count) {
        index = 0;
    } else {
        index = self.arrImages.count;
    }
    _totalKeys += 1;
    NSString *key = [NSString stringWithFormat:kImageKeys, index];
    [[SDImageCache sharedImageCache] storeImage:chosenImage forKey:key];
    [self.arrImages addObject:ima];
    [self.collectionView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma  mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoShareManagerCollectionViewCell *cell = (PhotoShareManagerCollectionViewCell *)[collectionView
        dequeueReusableCellWithReuseIdentifier:kPhotoShareManagerCollectionViewCellIdentifier forIndexPath:indexPath];
    cell.imageViewShare.image = [Utils convertImageToThumbnailImage:self.arrImages[indexPath.row]
        withSize:cell.imageViewShare.bounds.size];
    cell.imageViewShare.contentMode = UIViewContentModeScaleAspectFill;
    cell.imageViewShare.clipsToBounds = YES;
    cell.collectionView = collectionView;
    cell.delegate = self;
    return cell;
}

- (void)didDeleteImage:(NSIndexPath *)indexPath {
    NSString *key = [NSString stringWithFormat:kImageKeys, indexPath.row];
    [[SDImageCache sharedImageCache] removeImageForKey:key];
    [self.arrImages removeObjectAtIndex:indexPath.row];
    [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    [self.collectionView reloadData];
}

- (IBAction)cameraPress:(id)sender {
    [self showTakePhoto];
}

@end
