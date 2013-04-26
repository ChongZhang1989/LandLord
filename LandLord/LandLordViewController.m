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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getSurroundings:(CLLocationCoordinate2D) location
{
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
    LandLordAppDelegate *delegate = (LandLordAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"Start to get it");
    NSLog(delegate.username);
    NSLog(@"Yes I did");
}

@end
