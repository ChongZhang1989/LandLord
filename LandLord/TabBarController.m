//
//  TabBarController.m
//  LandLord
//
//  Created by Chong Zhang on 4/25/13.
//  Copyright (c) 2013 CellularNetwork. All rights reserved.
//

#import "TabBarController.h"
#import "LandLordAppDelegate.h"

@interface TabBarController ()

@end

@implementation TabBarController

@synthesize username = _username;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	NSLog(@"username = %@", _username);
    LandLordAppDelegate *delegate = (LandLordAppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.username = _username;
    NSLog(@"==========shuai===========");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
