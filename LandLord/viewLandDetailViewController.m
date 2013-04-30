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
        //post land post
        NSLog(@"%@",_landpost.text);
        
        NSString *nameurlstr = [NSString stringWithFormat:@"http://lordmap2k13.appspot.com/setmsg?landId=%@&msg=%@", _currland.currentLandid, _landpost.text];
        NSURL *nameurl = [NSURL URLWithString:nameurlstr];
        NSData *data = [NSData dataWithContentsOfURL:nameurl];
        if(data == nil){
            [self confirmShow:@"Already Sent" message:@"New land post update failed due to network connection, please try again later" button:@"OK"];
        }
        NSDictionary *jsonroot = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:0];
        NSString *reply = [jsonroot objectForKey:@"result"];
        if([reply isEqualToString:@"yes"]){
            [self confirmShow:@"Great Job" message:@"The new land post for your land has been updated" button:@"OK"];
        } else {
            [self confirmShow:@"Already Sent" message:@"New land post update failed due to server problem, please try again later" button:@"OK"];
        }

        
	} else if([sender tag] == 3){
        //post land name
        NSLog(@"%@", _landname.text);
        NSString *nameurlstr = [NSString stringWithFormat:@"http://lordmap2k13.appspot.com/setname?landId=%@&name=%@", _currland.currentLandid, _landname.text];
        NSLog(@"%@",nameurlstr);
        NSURL *nameurl = [NSURL URLWithString:nameurlstr];
        NSData *namedata = [NSData dataWithContentsOfURL:nameurl];
        NSLog(@"Get data from name!");
        if(namedata == nil){
             [self confirmShow:@"Already Sent" message:@"New name update failed due to network connection, please try again later" button:@"OK"];
        }
        NSLog(@"try to get jsonroot");
        NSDictionary *jsonroot = [NSJSONSerialization JSONObjectWithData:namedata options:NSJSONReadingMutableContainers error:0];
        NSLog(@"get jsonroot");
        NSString *reply = [jsonroot objectForKey:@"result"];
        if([reply isEqualToString:@"yes"]){
            NSLog(@"get into confirm yes");
            [self confirmShow:@"Great Job" message:@"The new name for your land has been updated" button:@"OK"];
        } else {
            NSLog(@"get into confirm no");
            [self confirmShow:@"Already Sent" message:@"New name update failed due to server problem, please try again later" button:@"OK"];
        }
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
	// Do any additional setup after loading the view.
    self.title = @"Detailed View";
    NSLog(@"Get into new view 2");
    
    _landpost.delegate = self;
    _landpost.delegate = self;
    
    CGFloat width =[UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"mylandview.jpg"]];
    _currland = _mappin.currLand;
    NSLog(@"%@", _currland.owner);
    NSLog(@"%@", _currland.type);
    
    //Get the name and message of the land
    NSString *lname = _currland.landname;
    NSString *lmsg = _currland.landmsg;
    
    //Determine to show which view according to the user's rel to the land
    if([_currland.type isEqualToString:@"own"]){
        //This is my own land
		CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width;
        //To set name for the land
        CGRect framename = CGRectMake(20, 20, maxWidth - 40, 40);
        _landname = [[UITextField alloc] initWithFrame:framename];
        _landname.layer.borderWidth = 0;
        _landname.layer.borderColor = [[UIColor blueColor] CGColor];
        _landname.font = [UIFont systemFontOfSize:17.0];
        _landname.backgroundColor = [UIColor whiteColor];
        _landname.text = lname;
        
        UIButton *postname = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        postname.frame = CGRectMake(maxWidth - 170, 60, 150, 60);
        [postname setTag: 3];
        [postname setTitle:@"Post Name" forState:UIControlStateNormal];
        [postname addTarget:self action:@selector(ButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [view addSubview:_landname];
        [view addSubview:postname];
        
        //To set land post
        CGRect frame = CGRectMake(20, 120, maxWidth - 40, 50);
		_landpost = [[UITextView alloc] initWithFrame:frame];
		_landpost.layer.borderWidth = 0;
		_landpost.layer.borderColor = [[UIColor grayColor] CGColor];
		_landpost.textColor = [UIColor blackColor];
		_landpost.font = [UIFont systemFontOfSize:17.0];
		_landpost.backgroundColor = [UIColor whiteColor];
		_landpost.text = lmsg;
        
		UIButton *postMessage = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		postMessage.frame = CGRectMake(maxWidth - 170, 180,150, 40);
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
