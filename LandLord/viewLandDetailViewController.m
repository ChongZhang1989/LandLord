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
        
        if(YES){
            
        }
    }
    else if([sender tag] == 1){
        NSLog(@"attack");
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
