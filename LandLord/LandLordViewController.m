//
//  LandLordViewController.m
//  LandLord
//
//  Created by Chong Zhang on 4/23/13.
//  Copyright (c) 2013 CellularNetwork. All rights reserved.
//

#import "LandLordViewController.h"
#import "LandLordAppDelegate.h"


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

-(void)putPinsOnMap: (CLLocationCoordinate2D)location
{
    MapPin *pin = [[MapPin alloc] init];
    [pin setTitle:@"This is a test"];
    [pin setCoordinate:location];
    [_mapView addAnnotation:pin];
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
	NSLog(@"Hello");
	NSLog(_username);
	NSLog(@"Hello2");
	if (!refresh) {
		refresh = 1;
		[self getSurroundings:[_mapView centerCoordinate]];
	}
   
    
}

@end
