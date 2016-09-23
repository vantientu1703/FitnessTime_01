//
//  GoogleMapsViewController.m
//  GymManager
//
//  Created by Văn Tiến Tú on 9/22/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "GoogleMapsViewController.h"

NSString *const kLocationTitle = @"Location";
NSString *const kCellDefault = @"CellDefaults";

@interface GoogleMapsViewController ()<GMSMapViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *containtView;

@end

@implementation GoogleMapsViewController
{
    GMSMapView *_mapView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (void)setupView {
    self.title = kLocationTitle;
    CLLocationCoordinate2D coordinate = [[DataStore sharedDataStore] getCoordinateMylocation];
    if (!coordinate.longitude || !coordinate.latitude) {
        //TODO: Fake data
        coordinate = CLLocationCoordinate2DMake(21.0333f, 105.85f);
    }
    [self setupLocationWithCoordinate:coordinate];
}

- (void)setupLocationWithCoordinate:(CLLocationCoordinate2D)coordiate {
    GMSCameraPosition *camera = [GMSCameraPosition
        cameraWithLatitude:coordiate.latitude longitude:coordiate.longitude zoom:15];
    if (_mapView) {
        [_mapView removeFromSuperview];
        _mapView = nil;
    }
    _mapView = [GMSMapView mapWithFrame:self.containtView.bounds camera:camera];
    GMSMarker *marker = [GMSMarker markerWithPosition:coordiate];
    marker.position = camera.target;
    marker.appearAnimation = kGMSMarkerAnimationPop;
    marker.map = _mapView;
    _mapView.settings.myLocationButton = true;
    _mapView.myLocationEnabled = YES;
    _mapView.settings.compassButton = YES;
    _mapView.delegate = self;
    [self.containtView addSubview:_mapView];
}

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    [[DataStore sharedDataStore] setMylocation:coordinate];
    [self setupLocationWithCoordinate:coordinate];
}

@end
