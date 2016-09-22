//
//  GoogleMapsViewController.m
//  GymManager
//
//  Created by Văn Tiến Tú on 9/22/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "GoogleMapsViewController.h"

NSString *const kLocationTitle = @"Location";

@interface GoogleMapsViewController ()

@property (weak, nonatomic) IBOutlet UIView *containtView;

@end

@implementation GoogleMapsViewController
{
    GMSMapView *_mapView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
}

- (void)setupView {
    self.title = kLocationTitle;
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.868f longitude:151.2086f zoom:15];
    _mapView = [GMSMapView mapWithFrame:self.containtView.bounds camera:camera];
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = camera.target;
    marker.appearAnimation = kGMSMarkerAnimationPop;
    marker.map = _mapView;
    _mapView.settings.myLocationButton = true;
    _mapView.myLocationEnabled = YES;
    _mapView.settings.compassButton = YES;
    [self.containtView addSubview:_mapView];
}

@end
