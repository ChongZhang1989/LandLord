//
//  StartWindowViewController.m
//  LandLord
//
//  Created by Chong Zhang on 4/25/13.
//  Copyright (c) 2013 CellularNetwork. All rights reserved.
//

#import "StartWindowViewController.h"

@interface StartWindowViewController ()

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;

@end

@implementation StartWindowViewController

@synthesize username = _username;
@synthesize password = _password;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getUsername:(id)sender
{
	_username = [sender text];
}

- (IBAction)getPassword:(id)sender
{
	_password = [sender text];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
	NSLog(_username);
	NSLog(_password);
	return YES;
}

- (IBAction)buttonPressed:(id)sender
{}
@end
