//
//  StartWindowViewController.m
//  LandLord
//
//  Created by Chong Zhang on 4/25/13.
//  Copyright (c) 2013 CellularNetwork. All rights reserved.
//

#import "StartWindowViewController.h"
#import "LandLordViewController.h"
#import "TabBarController.h"

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

- (void)confirmShow: (NSString *)title message:(NSString *)message button:(NSString *)button
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:button otherButtonTitles:nil];
    [alert show];
}


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
	//for test convenience
	//return YES;
	
	
	NSString *urlString= [NSString stringWithFormat:@"http://lordmap2k13.appspot.com/login?userId=%@&userPwd=%@", _username, _password];
	NSURL *url = [NSURL URLWithString:urlString];
	NSError *error = nil;
	NSData *placeData = [NSData dataWithContentsOfURL:url options:0 error:&error];
	if (error) {
		NSLog(@"URL request error");
		return NO;
	}
	NSError *jsonError = nil;
	NSDictionary *result = [NSJSONSerialization JSONObjectWithData:placeData options:0 error:&jsonError];
	if (jsonError) {
		return NO;
	}
	NSString *res = [result objectForKey:@"result"];
	if ([res isEqualToString:@"yes"])
		return YES;
	[self confirmShow:@"Sorry" message:@"Your username or password is wrong!" button:@"OK"];
	return NO;
}

- (IBAction)buttonPressed:(id)sender
{}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"login"]) {
		//LandLordViewController *landView = segue.destinationViewController;
		//landView.username = _username;
		TabBarController *barView = segue.destinationViewController;
		barView.username = _username;
	}
}

@end
