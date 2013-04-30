//
//  Land.h
//  LandLord
//
//  Created by Chong Zhang on 4/25/13.
//  Copyright (c) 2013 CellularNetwork. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Land : NSObject
@property CLLocationCoordinate2D upleft;
@property CLLocationCoordinate2D bottomright;
@property NSString *owner;
@property NSString *type;
@property double defence;
@property id landid;
@property id pinid;
@property (nonatomic, strong) NSString *currentLandid;
@property (nonatomic, strong) NSString *landname;
@property (nonatomic, strong) NSString *landmsg;
@end
