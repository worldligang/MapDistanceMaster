//
//  ViewController.m
//  MapDistanceMaster
//
//  Created by ligang on 15/5/14.
//  Copyright (c) 2015年 ligang. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController ()<CLLocationManagerDelegate>
{
    CLLocationManager *_locationManager;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self startLocating];
    [self getLongitudeAndLatitudeWithCity:@"上海"];
    double distance = [self distanceByLongitude:116.405285 latitude:39.904989 longitude:121.472644 latitude:31.231706];
    NSLog(@"distance = %f", distance);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getLongitudeAndLatitudeWithCity:(NSString *)city
{
    //city可以为中文
    NSString *oreillyAddress = city;
    CLGeocoder *myGeocoder = [[CLGeocoder alloc] init];
    [myGeocoder geocodeAddressString:oreillyAddress completionHandler:^(NSArray *placemarks, NSError *error) {
        if ([placemarks count] > 0 && error == nil)
        {
            NSLog(@"Found %lu placemark(s).", (unsigned long)[placemarks count]);
            CLPlacemark *firstPlacemark = [placemarks objectAtIndex:0];
            NSLog(@"Longitude = %f", firstPlacemark.location.coordinate.longitude);
            NSLog(@"Latitude = %f", firstPlacemark.location.coordinate.latitude);
        }
        else if ([placemarks count] == 0 && error == nil)
        {
            NSLog(@"Found no placemarks.");
        }
        else if (error != nil)
        {
            NSLog(@"An error occurred = %@", error);
        }
    }];
}

- (void)startLocating
{
    if([CLLocationManager locationServicesEnabled])
    {
        _locationManager = [[CLLocationManager alloc] init];
        //设置定位的精度
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        _locationManager.distanceFilter = 100.0f;
        _locationManager.delegate = self;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] > 8.0)
        {
            [_locationManager requestAlwaysAuthorization];
            [_locationManager requestWhenInUseAuthorization];
        }
        //开始实时定位
        [_locationManager startUpdatingLocation];
    }
}


-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSLog(@"Longitude = %f", manager.location.coordinate.longitude);
    NSLog(@"Latitude = %f", manager.location.coordinate.latitude);
    [_locationManager stopUpdatingLocation];
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:manager.location completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark * placemark in placemarks) {
            NSDictionary *test = [placemark addressDictionary];
            //  Country(国家)  State(城市)  SubLocality(区)
            NSLog(@"%@", [test objectForKey:@"Country"]);
            NSLog(@"%@", [test objectForKey:@"State"]);
            NSLog(@"%@", [test objectForKey:@"SubLocality"]);
            NSLog(@"%@", [test objectForKey:@"Street"]);
        }
    }];

}

- (double)distanceByLongitude:(double)longitude1 latitude:(double)latitude1 longitude:(double)longitude2 latitude:(double)latitude2{
    CLLocation* curLocation = [[CLLocation alloc] initWithLatitude:latitude1 longitude:longitude1];
    CLLocation* otherLocation = [[CLLocation alloc] initWithLatitude:latitude2 longitude:longitude2];
    double distance  = [curLocation distanceFromLocation:otherLocation];//单位是m
    return distance;
}


@end
