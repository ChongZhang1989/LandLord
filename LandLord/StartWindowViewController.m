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
	NSString *urlString= [NSString stringWithFormat:@"http://lordmap2k13.appspot.com/login?userId=%@&userPwd=%@", _username, _password];
	NSURL *url = [NSURL URLWithString:urlString];
	NSError *error = nil;
	NSData *placeData = [NSData dataWithContentsOfURL:url options:0 error:&error];
	if (error) {
		NSLog(@"URL request error");
	}
	NSError *jsonError = nil;
	NSDictionary *result = [NSJSONSerialization JSONObjectWithData:placeData options:0 error:&jsonError];
	NSString *res = [result objectForKey:@"result"];
	if ([res isEqualToString:@"yes"])
		return YES;
	return NO;
}

- (IBAction)buttonPressed:(id)sender
{}
@end
