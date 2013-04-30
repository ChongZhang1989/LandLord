//
//  viewLandDetailViewController.h
//  LandLord
//
//  Created by Alex Xia on 4/27/13.
//  Copyright (c) 2013 CellularNetwork. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Land.h"
#import "MapPin.h"
#import "LandLordAppDelegate.h"

@interface viewLandDetailViewController : UIViewController <UITextFieldDelegate>
@property (nonatomic, strong)Land *currland;
@property (nonatomic, strong)MapPin *mappin;
@property (nonatomic, strong)NSString *username;
@end
