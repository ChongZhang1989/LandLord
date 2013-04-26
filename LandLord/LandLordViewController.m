//
//  LandLordViewController.m
//  LandLord
//
//  Created by Chong Zhang on 4/23/13.
//  Copyright (c) 2013 CellularNetwork. All rights reserved.
//

#import "LandLordViewController.h"
#import "LandLordAppDelegate.h"
#import "Land.h"


@interface LandLordViewController ()
@property (nonatomic, strong) NSMutableArray *surroundings;
@property (nonatomic, strong) NSString *username;
@end

@implementation LandLordViewController

@synthesize surroundings = _surroundings;
@synthesize username = _username;

int refresh = 0;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	[_mapView setDelegate:self];
    LandLordAppDelegate *delegate = (LandLordAppDelegate *)[[UIApplication sharedApplication] delegate];
    _username = delegate.username;
    NSLog(_username);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getSurroundings:(CLLocationCoordinate2D) location
{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^
    {
        NSString *urlstr = [NSString stringWithFormat:@"http://lordmap2k13.appspot.com/login?userId=fewafdf&userPwd=aefae"];
        NSURL *surrurl = [NSURL URLWithString:urlstr];
        NSError *error = nil;
        NSData *surrJSON = [NSData dataWithContentsOfURL:surrurl options:0 error:&error];
        
        NSDictionary *jsonroot = [NSJSONSerialization JSONObjectWithData:surrJSON options:NSJSONReadingMutableContainers error:0];
        
        
        //Add pins here in a new thread
        
        
        
    });
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mv viewForAnnotation:(id <MKAnnotation>)annotation
{
    NSString *annotationIdentifier = @"LandPin";
    MyPinView *pinView = (MyPinView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
    if([annotation isKindOfClass:[MapPin class]])
    {
    if(!pinView)
    {
        pinView = [[MyPinView alloc]
                   initWithAnnotation: annotation
                   reuseIdentifier:annotationIdentifier];
        pinView.canShowCallout = YES;
        UIImageView *houseIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Supporting Files/iconbeast lite - png/home.png"]];
        [houseIconView setFrame:CGRectMake(0, 0, 30, 30)];
        pinView.leftCalloutAccessoryView = houseIconView;
        //[houseIconView release];
    }
    else{
        pinView.annotation = annotation;
    }
    
    return pinView;
    }
    else if([annotation isKindOfClass:[OrgPin class]])
    {
        MKPinAnnotationView *newPin = (MKPinAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
        [newPin setEnabled:YES];
        [newPin setPinColor:MKPinAnnotationColorPurple];
        [newPin setAnimatesDrop:YES];
        return newPin;
    }
    
    return nil;
    
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    MKPolygonView *polygonView = [[MKPolygonView alloc] initWithPolygon:overlay];
	polygonView.lineWidth = 0;
    polygonView.strokeColor = [UIColor clearColor];
    polygonView.fillColor = [[UIColor redColor] colorWithAlphaComponent: 0.5];
    return polygonView;
}


- (void)putRecOnMap: (Land *) land
{
	CLLocationCoordinate2D p1 = land.upleft;
	CLLocationCoordinate2D p2 = land.bottomright;
	CLLocationCoordinate2D p[4];
	p[0] = p1;
	p[2] = p2;
	p[1].latitude = p1.latitude;
	p[1].longitude = p2.longitude;
	p[3].latitude = p2.latitude;
	p[3].longitude = p1.longitude;
	MKPolygon *poly = [MKPolygon polygonWithCoordinates:p count:4];
	[_mapView addOverlay:poly];
}

-(void)putPinsOnMap: (CLLocationCoordinate2D)location
{
    MapPin *pin = [[MapPin alloc] init];
    [pin setTitle:@"This is a test"];
    [pin setCoordinate:location];
    [_mapView addAnnotation:pin];
}

- (void)defaultPinsOnMap: (CLLocationCoordinate2D)location
{
}

- (void)longPress:(UILongPressGestureRecognizer*)gesture
{
	if (gesture.state == UIGestureRecognizerStateBegan) {
		CGPoint touchPoint = [gesture locationInView:[self mapView]];
		CLLocationCoordinate2D location = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
		NSLog(@"lat = %f, long = %f", location.latitude, location.longitude);
	}
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
	if (!refresh) {
		refresh = 1;
		[self getSurroundings:[_mapView centerCoordinate]];
	}
	UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
	[self.mapView addGestureRecognizer:longPress];
    
}

@end
