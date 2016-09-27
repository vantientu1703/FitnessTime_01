//
//  GoogleMapsViewController.m
//  GymManager
//
//  Created by Văn Tiến Tú on 9/22/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "GoogleMapsViewController.h"
#import "AppDelegate.h"

NSString *const kLocationTitle = @"Location";
NSString *const kCellDefault = @"CellDefaults";
NSString *const kMapCellIdentifier = @"MapCell";
NSString *const kMessageCreateFail = @"Save error, Try again later";

@interface GoogleMapsViewController () <GMSMapViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *containMapView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contraintTopMapView;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UILabel *lbInfo;
@property (weak, nonatomic) IBOutlet UIImageView *imgPointing;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *arrLocation;
@property (strong, nonatomic) NSMutableArray *arrMarker;

@end

@implementation GoogleMapsViewController
{
    GMSMapView *_mapView;
    dispatch_queue_t _mapQueue;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.btnCancel.hidden = YES;
    self.infoView.hidden = YES;
    self.imgPointing.hidden = YES;
    self.title = kLocationTitle;
    self.arrMarker = @[].mutableCopy;
    self.arrLocation = [GymLocation MR_findAll].mutableCopy;
    _mapQueue = dispatch_queue_create("map_queue", DISPATCH_QUEUE_SERIAL);
    [self setupView];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.view layoutIfNeeded];
    [self.containMapView addSubview:_mapView];
    [_mapView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.containMapView addConstraint:[NSLayoutConstraint constraintWithItem:_mapView
        attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.containMapView
        attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f]];
    [self.containMapView addConstraint:[NSLayoutConstraint constraintWithItem:_mapView
        attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.containMapView
        attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.0f]];
    [self.containMapView addConstraint:[NSLayoutConstraint constraintWithItem:_mapView
        attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.containMapView
        attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0f]];
    [self.containMapView addConstraint:[NSLayoutConstraint constraintWithItem:_mapView
        attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.containMapView
        attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f]];
    [self.containMapView layoutSubviews];
    [self mapView:_mapView idleAtCameraPosition:_mapView.camera];
}

#pragma mark - MapView
- (void)setupView {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    CLLocationCoordinate2D coordinate = appDelegate.locationManager.location.coordinate;
    if (!coordinate.longitude || !coordinate.latitude) {
        //TODO: Fake data
        coordinate = CLLocationCoordinate2DMake(21.0333f, 105.85f);
    }
    [self setupLocationWithCoordinate:coordinate];
}

- (void)setupLocationWithCoordinate:(CLLocationCoordinate2D)coordiate {
    GMSCameraPosition *camera = [GMSCameraPosition
        cameraWithLatitude:coordiate.latitude longitude:coordiate.longitude zoom:15];
    _mapView = [GMSMapView mapWithFrame:self.containMapView.bounds camera:camera];
    _mapView.camera = camera;
    _mapView.settings.myLocationButton = true;
    _mapView.myLocationEnabled = YES;
    _mapView.settings.compassButton = YES;
    _mapView.delegate = self;
    for (GymLocation *location in self.arrLocation) {
        GMSMarker *marker = [GMSMarker markerWithPosition:CLLocationCoordinate2DMake(location.latitue.doubleValue,
            location.longtitue.doubleValue)];
        marker.map = _mapView;
        marker.title = location.address;
        [self.arrMarker addObject:marker];
    }
}

- (void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position {
    GMSGeocoder *geo = [GMSGeocoder geocoder];
    [geo reverseGeocodeCoordinate:position.target
        completionHandler:^(GMSReverseGeocodeResponse *response, NSError *error) {
        GMSAddress *gmsAddress = response.firstResult;
        if (gmsAddress) {
            dispatch_sync(_mapQueue, ^{
                NSMutableString *addressStr = [[NSMutableString alloc] init];
                if (gmsAddress.thoroughfare) {
                    [addressStr appendString:[NSString stringWithFormat:@"%@ ,", gmsAddress.thoroughfare]];
                }
                if (gmsAddress.subLocality) {
                    [addressStr appendString:[NSString stringWithFormat:@"%@ ,", gmsAddress.subLocality]];
                }
                if (gmsAddress.locality) {
                    [addressStr appendString:[NSString stringWithFormat:@"%@ ,", gmsAddress.locality]];
                }
                if (gmsAddress.country) {
                    [addressStr appendString:[NSString stringWithFormat:@"%@", gmsAddress.country]];
                }
                self.lbInfo.text = addressStr;
            });
        }
    }];
}

#pragma mark - TableView implementation
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.tableView.hidden = !self.arrLocation.count;
    return self.arrLocation.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMapCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kMapCellIdentifier];
    }
    GymLocation *location = self.arrLocation[indexPath.row];
    cell.textLabel.text = location.address;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GymLocation *location = self.arrLocation[indexPath.row];
    [_mapView moveCamera:[GMSCameraUpdate setTarget:CLLocationCoordinate2DMake(location.latitue.doubleValue, location.
        longtitue.doubleValue) zoom:16.0f]];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:  (NSIndexPath *)indexPath {
    //TODO
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive
        title:@"Delete" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [[DataStore sharedDataStore] removeGymLocation:self.arrLocation[indexPath.row] complete:^(BOOL success) {
            if (success) {
                GMSMarker *marker = self.arrMarker[indexPath.row];
                marker.map = nil;
                [self.arrMarker removeObject:marker];
                [self.arrLocation removeObjectAtIndex:indexPath.row];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kCreateFail message:kMessageCreateFail
                    delegate:nil cancelButtonTitle:kOkTitle otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
    }];
    return @[deleteAction];
}

#pragma mark - Action Hanlder
- (IBAction)btnNewLocation:(id)sender {
    [UIView animateWithDuration:0.4 animations:^{
        self.contraintTopMapView.constant = 0.0f;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.btnCancel.hidden = NO;
        self.infoView.hidden = NO;
        self.imgPointing.hidden = NO;
    }];
}

- (IBAction)btnCancelClick:(id)sender {
    [UIView animateWithDuration:0.4 animations:^{
        self.contraintTopMapView.constant = 120.0f;
        [self.view layoutIfNeeded];
        self.btnCancel.hidden = YES;
        self.infoView.hidden = YES;
    } completion:^(BOOL finished) {
        self.imgPointing.hidden = YES;
    }];
}

- (IBAction)btnAddLocation:(id)sender {
    [CustomLoadingView showInView:self.view];
    dispatch_sync(_mapQueue, ^{
        [[DataStore sharedDataStore] setNewGymLocation:self.lbInfo.text lat:@(_mapView.camera.target.latitude)
            long:@(_mapView.camera.target.longitude) complete:^(BOOL success, NSString *message, GymLocation *location) {
            if (success) {
                [self btnCancelClick:nil];
                [self.arrLocation addObject:location];
                [self.tableView setContentOffset:CGPointMake(0, CGFLOAT_MAX)];
                [self.tableView reloadData];
                //Marker
                GMSMarker *marker = [GMSMarker markerWithPosition:
                    CLLocationCoordinate2DMake(location.latitue.doubleValue, location.longtitue.doubleValue)];
                marker.map = _mapView;
                marker.title = location.address;
                [self.arrMarker addObject:marker];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kCreateFail message:message delegate:nil
                    cancelButtonTitle:kOkTitle otherButtonTitles:nil, nil];
                [alert show];
            }
            [CustomLoadingView hideLoadingInView:self.view];
        }];
    });
}

@end
