//
//  MyLandViewController.m
//  LandLord
//
//  Created by Chong Zhang on 4/26/13.
//  Copyright (c) 2013 CellularNetwork. All rights reserved.
//

#import "MyLandViewController.h"
#import "Land.h"
#import "LandLordAppDelegate.h"
//#import "viewLandDetailViewController.h"



@interface MyLandViewController ()
@property (nonatomic, strong) NSMutableArray *landlist;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSMutableArray *showlist;
@property (nonatomic, strong) CLGeocoder *reverseGeocoder;
@property (nonatomic, strong) NSLock *mylock;
@end

@implementation MyLandViewController
@synthesize landlist = _landlist;
@synthesize username = _username;
@synthesize showlist = _showlist;
@synthesize reverseGeocoder = _reverseGeocoder;
@synthesize mylock = _mylock;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewDidAppear:(BOOL)animated
{
    [self getData];
	[self.tableView reloadData];
}

- (void)getData
{
	[_showlist removeAllObjects];
	[_landlist removeAllObjects];
	NSString *urlstr = [NSString stringWithFormat:@"http://lordmap2k13.appspot.com/showland?userId=%@", _username];
	NSLog(urlstr);
	NSURL *surrurl = [NSURL URLWithString:urlstr];
	NSError *error = nil;
	NSData *surrJSON = [NSData dataWithContentsOfURL:surrurl options:0 error:&error];
	
	NSDictionary *jsonroot = [NSJSONSerialization JSONObjectWithData:surrJSON options:NSJSONReadingMutableContainers error:0];
	NSArray *results = [jsonroot objectForKey:@"results"];
	for (NSDictionary *result in results) {
		Land *land = [[Land alloc] init];
		CLLocationCoordinate2D p;
		p.latitude = [[result objectForKey:@"lat0"] floatValue];
		p.longitude = [[result objectForKey:@"long0"] floatValue];
		land.upleft = p;
		p.latitude = [[result objectForKey:@"lat1"] floatValue];
		p.longitude = [[result objectForKey:@"long1"] floatValue];
		land.bottomright = p;
		land.owner = [result objectForKey:@"owner"];
		land.type = [result objectForKey:@"rel"];
		[_landlist addObject:land];
        NSString *landname = [result objectForKey:@"name"];
        if([landname isEqualToString:@""]){
            NSString *lname = @"";
             [_showlist addObject:lname];
        } else {
            NSString *lname = [NSString stringWithFormat:@" - %@", landname];
             [_showlist addObject:lname];
        }
		
        
        //[_showlist addObject:[NSString stringWithFormat:@"(%f, %f)", p.latitude, p.longitude]];

//		dispatch_async(dispatch_get_main_queue(),^ {
//		CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//		CLLocation *tmp = [[CLLocation alloc] initWithLatitude:p.latitude longitude:p.longitude];
//		[geocoder reverseGeocodeLocation:tmp
//                       completionHandler:^(NSArray *placemarks, NSError *error) {
//						   
//						   CLPlacemark *place = [placemarks objectAtIndex:0];
//						   NSString *addr = [place.addressDictionary objectForKey:@"Street"];
//						   if (addr == nil) {
//							   [_showlist addObject:[NSString stringWithFormat:@"(%f, %f)", p.latitude, p.longitude]];
//						   } else {
//							   [_showlist addObject:addr];
//						   }
//						   NSLog(@"hello");
//						   [_mylock lock];
//						   flg = 1;
//						   [_mylock unlock];
//					   }];
//			});
//		NSLog(@"world");
//		[_mylock lock];
//		while(!flg) {
//			[_mylock unlock];
//			[_mylock lock];
//		}
//		[_mylock unlock];
//		CLLocation *tmp = [[CLLocation alloc] initWithLatitude:p.latitude longitude:p.longitude];
//		[self.reverseGeocoder reverseGeocodeLocation:tmp
//								   completionHandler:^(NSArray *placemarks, NSError *error) {
//									   CLPlacemark *placemark = [placemarks objectAtIndex:0];
//									   NSString *addr = [placemark.addressDictionary objectForKey:@"Street"];
//									   [_showlist addObject:addr];
//									   NSLog(@"hello");
//								   }];
	}
	NSLog(@"end");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setTitle:@"My Lands"];
	self.tableView.dataSource = self;
	self.tableView.delegate = self;
    _landlist = [[NSMutableArray alloc] init];
	_showlist = [[NSMutableArray alloc] init];
	LandLordAppDelegate *delegate = (LandLordAppDelegate *)[[UIApplication sharedApplication] delegate];
    _username = delegate.username;
	[self getData];
	//[self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
	return [_showlist count];
}
*/
 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
	NSLog(@"implmented?");
    return [_showlist count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UITableViewCell *cell =	[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
	}
	cell.textLabel.text = [NSString stringWithFormat:@"Land %d %@",indexPath.row, [_showlist objectAtIndex:indexPath.row]];
	NSLog(cell.textLabel.text);
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/
- (IBAction)refreshPressed:(id)sender
{
	[self getData];
	[self.tableView reloadData];
	//[self.view addSubview:self.tableView];
}

#pragma mark - Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    NSLog(@"select it");
    LandLordAppDelegate *delegate = (LandLordAppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.currLand = [_landlist objectAtIndex:[indexPath row]];
    if(delegate.currLand == nil){
        NSLog(@"Well, it does not work");
        
    } else {
        NSLog(@"Yep, it works");
    }
    LandLordViewController *tarView = [[LandLordViewController alloc] init];
    CLLocationCoordinate2D location;
    
    NSString *t = @"This is a test notification message";
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"notification" object:t userInfo:nil];
    
    self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
}

@end
