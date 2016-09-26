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

@interface PhototShareManagerViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, AlertManagerDelegate, QBImagePickerControllerDelegate, PhotoShareManagerCollectionViewCellDelegate>

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
- (void)showQBImagePikcerController:(QBImagePickerController *)qbImagePickerController {
    qbImagePickerController.delegate = self;
    qbImagePickerController.allowsMultipleSelection = YES;
    qbImagePickerController.showsNumberOfSelectedAssets = YES;
    [self presentViewController:qbImagePickerController animated:YES completion:NULL];
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    if (!self.arrImages) {
        self.arrImages = [NSMutableArray array];
    }
    [self.arrImages addObject:chosenImage];
    [self.collectionView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - QBImagePickerControllerDelegate
- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets {
    PHImageRequestOptions *requestOptions = [[PHImageRequestOptions alloc] init];
    requestOptions.resizeMode   = PHImageRequestOptionsResizeModeExact;
    requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    // this one is key
    requestOptions.synchronous = true;
    PHImageManager *manager = [PHImageManager defaultManager];
    __block NSMutableArray *images = [NSMutableArray arrayWithCapacity:[assets count]];
    // assets contains PHAsset objects.
    __block UIImage *ima;
    if (!self.arrImages) {
        self.arrImages = [NSMutableArray array];
    }
    [assets enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [manager requestImageForAsset:obj targetSize:PHImageManagerMaximumSize
            contentMode:PHImageContentModeDefault options:requestOptions
            resultHandler:^void(UIImage *image, NSDictionary *info) {
            ima = [Utils convertImageToThumbnailImage:image withSize:CGSizeMake(200.f, 100.f)];
            [images addObject:ima];
            NSInteger index = idx + self.arrImages.count;
            NSString *key = [NSString stringWithFormat:kImageKeys, index];
            [[SDImageCache sharedImageCache] storeImage:ima forKey:key];
        }];
    }];
    _totalKeys += images.count;
    [self.arrImages addObjectsFromArray:images];
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
