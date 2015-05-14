# MapDistanceMaster

iOS系统自带的定位服务可以实现很多需求。比如：获取当前经纬度，获取当前位置信息等等。

####获取当前经纬度

首先导入#import <CoreLocation/CoreLocation.h>，定义CLLocationManager的实例，实现CLLocationManagerDelegate。

	@interface ViewController ()<CLLocationManagerDelegate>
	{
	    CLLocationManager *_locationManager;
	}
	
	@end
	
开始定位的方法：

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

实现代理方法：

	-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
	{
	    NSLog(@"Longitude = %f", manager.location.coordinate.longitude);
	    NSLog(@"Latitude = %f", manager.location.coordinate.latitude);
	    [_locationManager stopUpdatingLocation];
	}
	
####获取当前位置信息

在上面的代理方法中
	
	
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
这样就很简单获取了当前位置的详细信息。

####获取某一个地点的经纬度

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
	
####计算两个地点之间的距离

	- (double)distanceByLongitude:(double)longitude1 latitude:(double)latitude1 longitude:(double)longitude2 latitude:(double)latitude2{
	    CLLocation* curLocation = [[CLLocation alloc] initWithLatitude:latitude1 longitude:longitude1];
	    CLLocation* otherLocation = [[CLLocation alloc] initWithLatitude:latitude2 longitude:longitude2];
	    double distance  = [curLocation distanceFromLocation:otherLocation];//单位是m
	    return distance;
	}

首先我们可以用上面的getLongitudeAndLatitudeWithCity方法获取某一个地点的经纬度。比如我们获取北京和上海的经纬度分别为：北京Longitude = 116.405285，Latitude = 39.904989 上海Longitude = 121.472644， Latitude = 31.231706, 那么北京和上海之间的距离就是：

    double distance = [self distanceByLongitude:116.405285 latitude:39.904989 longitude:121.472644 latitude:31.231706];
    NSLog(@"Latitude = %f", distance);

计算的是大概的距离，可能没有那么精准。输入结果为：

	distance = 1066449.749194
	
代码下载地址:<a href="https://github.com/worldligang/MapDistanceMaster.git"target="_blank"title="MapDistanceMaster">MapDistanceMaster</a>

更多iOS技术请关注微信iOS开发
	
	iOSDevTip
