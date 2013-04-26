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
#import "idObject.h"


@interface LandLordViewController ()
@property (nonatomic, strong) NSMutableArray *surroundings;
@property (nonatomic, strong) NSString *username;
@property CLLocationCoordinate2D buyloc1;
@property CLLocationCoordinate2D buyloc2;
@property CLLocationCoordinate2D currBuyLoc;
@property (nonatomic, strong) NSMutableArray *buypins;
@property (nonatomic, strong) NSMutableArray *landlist;
@property (nonatomic, strong) NSMutableArray *removePinid;
@property (nonatomic, strong) NSMutableArray *removeRecid;
@end

@implementation LandLordViewController

@synthesize surroundings = _surroundings;
@synthesize username = _username;
@synthesize buypins = _buypins;
@synthesize landlist = _landlist;
@synthesize removePinid = _removePinid;
@synthesize removeRecid = _removeRecid;

IBOutlet CLLocationManager *locationManager;
id recid;


int cntBuyLoc = 0;

int refresh = 0;

- (void)viewDidLoad
{
    [super viewDidLoad];
	//initilize locaiton manager
	locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	
	_landlist = [[NSMutableArray alloc] init];
	[_mapView setDelegate:self];
    LandLordAppDelegate *delegate = (LandLordAppDelegate *)[[UIApplication sharedApplication] delegate];
    _username = delegate.username;
    NSLog(_username);
    _buypins = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) showLand
{
	int i = 0;
	for (Land *land in _landlist) {
		CLLocationCoordinate2D center;
		center.latitude = (land.upleft.latitude + land.bottomright.latitude) / 2;
		center.longitude = (land.upleft.longitude + land.bottomright.longitude) / 2;
		[self putPinsOnMap:center landindex:i];
		[self putRecOnMap:land landindex:i];
		i++;
	}
}

- (void)getSurroundings:(CLLocationCoordinate2D) location
{
	NSLog(@"get surroundings");
	[locationManager startUpdatingLocation];
	MKCoordinateSpan span = MKCoordinateSpanMake(0.02, 0.02);
	MKCoordinateRegion region = MKCoordinateRegionMake(locationManager.location.coordinate, span);
	[_mapView setRegion:region];
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^
    {
		NSString *urlstr = [NSString stringWithFormat:@"http://lordmap2k13.appspot.com/getsurrounding?userId=%@&lat=%f&lng=%f", _username, locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude];
		NSLog(urlstr);
        NSURL *surrurl = [NSURL URLWithString:urlstr];
        NSError *error = nil;
        NSData *surrJSON = [NSData dataWithContentsOfURL:surrurl options:0 error:&error];
        
        NSDictionary *jsonroot = [NSJSONSerialization JSONObjectWithData:surrJSON options:NSJSONReadingMutableContainers error:0];
        NSArray *results = [jsonroot objectForKey:@"results"];
		for (idObject *r in _removePinid) {
			[_mapView removeAnnotation:r.removeid];
		}
		for (idObject *r in _removeRecid) {
			[_mapView removeOverlay:r.removeid];
		}
		[_removePinid removeAllObjects];
		[_removeRecid removeAllObjects];
		[_landlist removeAllObjects];
		for (NSDictionary *result in results) {
			Land *land = [[Land alloc] init];
			CLLocationCoordinate2D p;
			p.latitude = [[result objectForKey:@"lat0"] floatValue];
			p.longitude = [[result objectForKey:@"long0"] floatValue];
			land.upleft = p;
			p.latitude = [[result objectForKey:@"lat1"] floatValue];
			p.longitude = [[result objectForKey:@"long1"] floatValue];
			land.bottomright = p;
			land.owner = [result objectForKey:@"owner"];
			land.type = [result objectForKey:@"rel"];
			[self.landlist addObject:land];
		}
        //Add pins here in a new thread
		dispatch_async(dispatch_get_main_queue(), ^
					   {
						   [self showLand];
					   });
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
        //[newPin setPinColor:MKPinAnnotationColorPurple];
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


- (id)putRecOnMap: (Land *) land landindex:(NSInteger) landindex
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
	if (landindex >= 0) {
		NSLog(@"put rec on map remove related");
		idObject *tmp = [[idObject alloc] init];
		tmp.removeid = [poly self];
		[[self removeRecid] addObject:tmp];
	}
	return [poly self];
}

-(void)putPinsOnMap: (CLLocationCoordinate2D)location landindex:(NSInteger) landindex
{
    MapPin *pin = [[MapPin alloc] init];
    [pin setTitle:@"This is a test"];
    [pin setCoordinate:location];
    [_mapView addAnnotation:pin];
	idObject *tmp = [[idObject alloc] init];
	tmp.removeid = [pin self];
	[[self removePinid] addObject:tmp];
}

- (void)defaultPinsOnMap: (CLLocationCoordinate2D)location
{
    OrgPin *pin = [[OrgPin alloc] init];
	[pin setCoordinate:location];
	[self.mapView addAnnotation:pin];
    [_buypins addObject:[pin self]];
	if (!cntBuyLoc) {
		//cntBuyLoc++;
        self.buyloc1 = self.currBuyLoc;
		return;
	}
     self.buyloc2 = self.currBuyLoc;
	Land *land = [[Land alloc] init];
	CLLocationCoordinate2D tmp;
	tmp.latitude = MIN(self.buyloc1.latitude, self.buyloc2.latitude);
	tmp.longitude = MAX(self.buyloc1.longitude, self.buyloc2.longitude);
	land.upleft = tmp;
	tmp.latitude = MAX(self.buyloc1.latitude, self.buyloc2.latitude);
	tmp.longitude = MIN(self.buyloc1.longitude, self.buyloc2.longitude);
	land.bottomright = tmp;
    
	recid = [self putRecOnMap:land landindex:-1];
}

- (BOOL)purchaseLand
{
	Land *land = [[Land alloc] init];
	CLLocationCoordinate2D tmp;
	tmp.latitude = MIN(self.buyloc1.latitude, self.buyloc2.latitude);
	tmp.longitude = MAX(self.buyloc1.longitude, self.buyloc2.longitude);
	land.upleft = tmp;
	tmp.latitude = MAX(self.buyloc1.latitude, self.buyloc2.latitude);
	tmp.longitude = MIN(self.buyloc1.longitude, self.buyloc2.longitude);
	land.bottomright = tmp;
	NSString *urlstr = [NSString stringWithFormat:@"http://lordmap2k13.appspot.com/buyland?userId=%@&lat0=%f&long0=%f&lat1=%f&long1=%f", _username, land.upleft.latitude, land.upleft.longitude, land.bottomright.latitude, land.bottomright.longitude];
	NSLog(urlstr);
	NSURL *url = [NSURL URLWithString:urlstr];
	NSError *error = nil;
	NSData *placeData = [NSData dataWithContentsOfURL:url options:0 error:&error];
	if (error) {
		NSLog(@"error = %@", error);
		NSLog(@"URL request error");
		return NO;
	}
	NSError *jsonError = nil;
	NSDictionary *result = [NSJSONSerialization JSONObjectWithData:placeData options:0 error:&jsonError];
	if (jsonError) {
		return NO;
	}
	NSString *res = [result objectForKey:@"result"];
	NSLog(@"ret = %@", res);
	if ([res isEqualToString:@"yes"]) {
		return YES;
	} else {
		return NO;
	}
    
}

- (void)alertShow: (NSString *)title message:(NSString *)message button:(NSString *)button cancel:(NSString*) cancel
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancel otherButtonTitles:button,nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1){
        NSLog(@"OK");
        if(cntBuyLoc == 0){
            cntBuyLoc++;
        } else if(cntBuyLoc == 1) {
			[self purchaseLand];
			//remove selected area
			[_mapView removeOverlay:recid];
			NSArray *removelist = [NSArray arrayWithArray:_buypins];
			[_mapView removeAnnotations:removelist];
            [self.buypins removeAllObjects];
			
			[self getSurroundings:[_mapView centerCoordinate]];
            cntBuyLoc = 0;
        }
    } else if(buttonIndex == 0) {
        NSLog(@"retry");
        NSArray *removelist = [NSArray arrayWithArray:_buypins];
        [_mapView removeAnnotations:removelist];
		[self.buypins removeAllObjects];
        if(cntBuyLoc == 1){
            cntBuyLoc = 0;
		[_mapView removeOverlay:recid];
        }
    }
}

- (void)longPress:(UILongPressGestureRecognizer*)gesture
{
	if (gesture.state == UIGestureRecognizerStateBegan) {
		CGPoint touchPoint = [gesture locationInView:[self mapView]];
		CLLocationCoordinate2D location = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
        self.currBuyLoc = location;
		NSLog(@"lat = %f, long = %f", location.latitude, location.longitude);
		if (cntBuyLoc == 0) {
            [self defaultPinsOnMap:self.currBuyLoc];
            [self alertShow:@"Choose Land" message:@"Confirm this place as first point for your land?" button:@"OK" cancel:@"Cancel"];
		} else {
            [self defaultPinsOnMap:self.currBuyLoc];
			[self alertShow:@"Confirm Land" message:@"Confirm this area as the land you want?" button:@"OK" cancel:@"Cancel"];
            
		}
		
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
