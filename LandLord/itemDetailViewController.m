//
//  itemDetailViewController.m
//  LandLord
//
//  Created by Alex Xia on 4/29/13.
//  Copyright (c) 2013 CellularNetwork. All rights reserved.
//

#import "itemDetailViewController.h"

@interface itemDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *itemImage;
@property (weak, nonatomic) IBOutlet UILabel *iteminfolabel;
@property (weak, nonatomic) IBOutlet UILabel *cost;
@property (nonatomic, strong) NSString *username;

@end

@implementation itemDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)buyitem:(id)sender {
    NSLog(@"Get pressed");
    NSString *urlstr = [NSString stringWithFormat:@"http://lordmap2k13.appspot.com/buyitem?userId=%@&index=%@", _username,_itemobj.index];
    NSLog(urlstr);
    NSURL *url = [NSURL URLWithString:urlstr];
    NSLog(@"setup url");
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSLog(@"Got data");
    NSDictionary *jsonroot = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error:0];
    NSString *result = (NSString *)[jsonroot objectForKey:@"result"];
    NSString *bal = (NSString *)[jsonroot objectForKey:@"balance"];
    NSLog(@"got reply");
    if([result isEqualToString:@"yes"]){
        NSString *msg = [NSString stringWithFormat:@"You have got %@,\nyour balance in account is %@", _itemobj.name, bal];
        [self confirmShow: @"Greeings" message:msg button:@"OK"];
    } else {
        NSString *msg = [NSString stringWithFormat:@"You don't have sufficient balance in account"];
        [self confirmShow:@"Purchase failed" message:msg button:@"OK"];
    }
    
}

- (void)confirmShow: (NSString *)title message:(NSString *)message button:(NSString *)button
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:button otherButtonTitles:nil];
    [alert show];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    LandLordAppDelegate *delegate = (LandLordAppDelegate *)[[UIApplication sharedApplication] delegate];
    _username = delegate.username;
    
	// Do any additional setup after loading the view.
    NSLog(@"%@", _itemobj.name);
    [self setTitle:_itemobj.name];
    [_itemImage setImage:[UIImage imageNamed:_itemobj.imagename]];
    //[_iteminfo setText:_itemobj.iteminfo];
    [_iteminfolabel setText:[NSString stringWithFormat:@"%@", _itemobj.iteminfo]];
    [_cost setText:[NSString stringWithFormat:@"COST: %@",_itemobj.price]];
    NSLog(@"%@", _itemobj.iteminfo);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
