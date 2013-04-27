//
//  Purchase.h
//  LandLord
//
//  Created by Chong Zhang on 4/27/13.
//  Copyright (c) 2013 CellularNetwork. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Purchase : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSData *image;
@property NSInteger price;
@property (nonatomic, strong) NSString *description;

@end
