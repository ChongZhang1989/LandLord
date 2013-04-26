//
//  LandLordViewController.h
//  LandLord
//
//  Created by Chong Zhang on 4/23/13.
//  Copyright (c) 2013 CellularNetwork. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MyPinView.h"
#import "MapPin.h"
#import "OrgPin.h"

@interface LandLordViewController : UIViewController<MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;


@end
