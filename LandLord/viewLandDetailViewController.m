//
//  viewLandDetailViewController.m
//  LandLord
//
//  Created by Alex Xia on 4/27/13.
//  Copyright (c) 2013 CellularNetwork. All rights reserved.
//

#import "viewLandDetailViewController.h"

@interface viewLandDetailViewController ()

@end

@implementation viewLandDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    NSLog(@"Get into new view");
    return self;
}
- (IBAction)ButtonPressed:(id)sender {
    NSLog(@"%@", [sender self]);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
	// Do any additional setup after loading the view.
    self.title = @"Detailed View";
    NSLog(@"Get into new view 2");
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 999)];
    UIButton *test = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    test.frame = CGRectMake(10, 61+30, 106, 50);
    test.tag = 0;
    [test setTitle:@"RETWEET" forState:UIControlStateNormal];
    [test addTarget:self action:@selector(ButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:test];
    [self.view addSubview:view];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
