//
//  OrgPin.h
//  LandLord
//
//  Created by Alex Xia on 4/25/13.
//  Copyright (c) 2013 CellularNetwork. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface OrgPin :  NSObject<MKAnnotation>

@property (nonatomic, strong) NSString *title, *subtitle, *time, *tweetID;
@property CLLocationCoordinate2D coordinate;
@end
