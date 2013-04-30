//
//  viewLandDetailViewController.m
//  LandLord
//
//  Created by Alex Xia on 4/27/13.
//  Copyright (c) 2013 CellularNetwork. All rights reserved.
//

#import "viewLandDetailViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface viewLandDetailViewController ()
@property (strong, nonatomic) IBOutlet UITextField *landname;
@property (strong, nonatomic) IBOutlet UITextField *landpost;
@end

@implementation viewLandDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self becomeFirstResponder];
    }
    LandLordAppDelegate *delegate = (LandLordAppDelegate *)[[UIApplication sharedApplication] delegate];
    _username = delegate.username;
    
    NSLog(@"Get into new view");
    return self;
}
- (IBAction)ButtonPressed:(id)sender {
    //NSLog(@"%@", [sender self]);
    if([sender tag] == 0){
        NSLog(@"add friends");
        //send request to API and retrive result
        
        NSString *adfriurlstr = [NSString stringWithFormat:@"http://lordmap2k13.appspot.com/addfriend?userId1=%@&userId2=%@",_currland.owner,_username];
        NSURL *adfriurl = [NSURL URLWithString:adfriurlstr];
        NSError *error = nil;
        NSData *data = [NSData dataWithContentsOfURL:adfriurl options:0 error:&error];
        
        NSDictionary *jsonroot = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:0];
        NSString *reply = (NSString *)[jsonroot objectForKey:@"result"];
        
        if([reply isEqualToString:@"yes"]){
            [self confirmShow:@"Great Job" message:@"Your friend invitation has been sent out" button:@"OK"];
        } else {
            [self confirmShow:@"Already Sent" message:@"You have sent friend invitation\nto this person previously,\nlet's wait for confirmation" button:@"OK"];
        }
    }
    else if([sender tag] == 1){
        NSLog(@"attack");
		NSString *urlstr = [NSString stringWithFormat:@"http://lordmap2k13.appspot.com/attack?userId=%@&landId=%@", _username, _currland.currentLandid];
		NSURL *surrurl = [NSURL URLWithString:urlstr];
		NSError *error = nil;
		NSData *surrJSON = [NSData dataWithContentsOfURL:surrurl options:0 error:&error];
		
		NSDictionary *jsonroot = [NSJSONSerialization JSONObjectWithData:surrJSON options:NSJSONReadingMutableContainers error:0];
		NSString *result = [jsonroot objectForKey:@"result"];
		if ([result isEqualToString:@"succeeded"]) {
			[self confirmShow:@"Congratulations" message:@"You got the land!" button:@"OK"];
		} else if ([result isEqualToString:@"failed"]) {
			[self confirmShow:@"Unfortunately" message:@"You cannot conquer the land!" button:@"OK"];
		} else {
			[self confirmShow:@"Sorry" message:@"You cannot attack anymore today!" button:@"OK"];
		}
    } else if ([sender tag] == 2) {
        NSLog(@"%@",_landpost.text);
	}
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
	// Do any additional setup after loading the view.
    self.title = @"Detailed View";
    NSLog(@"Get into new view 2");
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 999)];
    
    _currland = _mappin.currLand;
    NSLog(@"%@", _currland.owner);
    NSLog(@"%@", _currland.type);
    //Determine to show which view according to the user's rel to the land
    if([_currland.type isEqualToString:@"own"]){
        //This is my own land
		CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width;
        CGRect frame = CGRectMake(20, 20, maxWidth - 40, 100);
		_landpost = [[UITextView alloc] initWithFrame:frame];
		_landpost.layer.borderWidth = 5.0f;
		_landpost.layer.borderColor = [[UIColor grayColor] CGColor];
		_landpost.textColor = [UIColor blackColor];
		_landpost.font = [UIFont systemFontOfSize:17.0];
		_landpost.backgroundColor = [UIColor clearColor];
		
		UIButton *postMessage = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		postMessage.frame = CGRectMake(maxWidth - 170, 160,150, 40);
		[postMessage setTag:2];
		[postMessage setTitle:@"Post Message" forState:UIControlStateNormal];
		[postMessage addTarget:self action:@selector(ButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
		
		[view addSubview:postMessage];
		[view addSubview:_landpost];
        [self.view addSubview:view];
        return;
    }
    else if([_currland.type isEqualToString:@"friend"]){
        //If this is a friend's land
        UIButton *atk = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        atk.frame =  CGRectMake(156, 91, 106, 50);
        atk.tag = 1;
        [atk setTitle:@"ATTACK" forState:UIControlStateNormal];
        [atk addTarget:self action:@selector(ButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:atk];
        
        [self.view addSubview:view];
        return;
    }
    
    
    //This is other's land
    
    UIButton *addfri = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    addfri.frame = CGRectMake(10, 91, 106, 50);
    addfri.tag = 0;
    [addfri setTitle:@"Add Friend" forState:UIControlStateNormal];
    [addfri addTarget:self action:@selector(ButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:addfri];
    
    UIButton *atk = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    atk.frame =  CGRectMake(156, 91, 106, 50);
    atk.tag = 1;
    [atk setTitle:@"ATTACK" forState:UIControlStateNormal];
    [atk addTarget:self action:@selector(ButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:atk];
    
    
    [self.view addSubview:view];
   
}

- (void)confirmShow: (NSString *)title message:(NSString *)message button:(NSString *)button
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:button otherButtonTitles:nil];
    [alert show];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
