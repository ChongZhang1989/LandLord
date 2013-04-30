//
//  messageTableViewController.m
//  LandLord
//
//  Created by Alex Xia on 4/29/13.
//  Copyright (c) 2013 CellularNetwork. All rights reserved.
//

#import "messageTableViewController.h"

@interface messageTableViewController ()
@property (nonatomic, strong) NSMutableArray *pendingfri;
@property (nonatomic, strong) NSMutableArray *pendingtask;
@property (nonatomic, strong) NSMutableArray *atkmsg;
@property (nonatomic, strong) NSMutableArray *showlist;
@property (nonatomic, strong) NSString *username;
@end

@implementation messageTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
   
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
	self.tableView.delegate = self;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    LandLordAppDelegate *delegate = (LandLordAppDelegate *)[[UIApplication sharedApplication] delegate];
    _username = delegate.username;
    _showlist = [[NSMutableArray alloc] init];
    _pendingfri = [[NSMutableArray alloc] init];
    _pendingtask = [[NSMutableArray alloc] init];
    _atkmsg = [[NSMutableArray alloc] init];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"Yes I wanna see my messages");
     [self getData];
    [self.tableView reloadData];
}

- (void)getData
{
	[_showlist removeAllObjects];
	[_atkmsg removeAllObjects];
    [_pendingtask removeAllObjects];
    [_pendingfri removeAllObjects];
    
	NSString *urlstr = [NSString stringWithFormat:@"http://lordmap2k13.appspot.com/showrequests?userId=%@", _username];

	NSLog(urlstr);
	NSURL *surrurl = [NSURL URLWithString:urlstr];
	NSError *error = nil;
	NSData *surrJSON = [NSData dataWithContentsOfURL:surrurl options:0 error:&error];
	
	NSDictionary *jsonroot = [NSJSONSerialization JSONObjectWithData:surrJSON options:NSJSONReadingMutableContainers error:0];
	NSArray *results = [jsonroot objectForKey:@"results"];
    if ([results count] == 0) {
        return;
    }
	for (NSDictionary *result in results) {
		messageObject *msgobj = [[messageObject alloc] init];
        NSString *name = [result objectForKey:@"friend"];
		msgobj.msgtype = @"fri";
        msgobj.msgcontent = [NSString stringWithFormat:@"%@ wants to add you as a friend", name];
        msgobj.counterpart = name;
        [_pendingfri addObject:msgobj];
		[_showlist addObject:msgobj];
        NSLog(msgobj.msgcontent);
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
    
    //Load attack message
    //NSString *atkurlstr = [NSString stringWithFormat:@"<#string#>"]
    
    
	NSLog(@"end");
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    //return 0;
    NSLog(@"implmented?");
    return [_showlist count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
	}
    
    messageObject *tmp = [_showlist objectAtIndex:indexPath.row];
    
    if([tmp.msgtype isEqualToString:@"fri"]){
        cell.textLabel.text = [NSString stringWithFormat:@"Friend Invitation from %@", tmp.counterpart];
    }
    
	//cell.textLabel.text = [NSString stringWithFormat:@"%@",indexPath.row, ];
	//NSLog(cell.textLabel.text);
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

- (void)alertShow: (NSString *)title message:(NSString *)message button:(NSString *)button cancel:(NSString*) cancel
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancel otherButtonTitles:button,nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1){
        NSLog(@"OK");
    } else if (buttonIndex == 0){
        NSLog(@"cancel");
    }
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
    messageObject *tmp = [_showlist objectAtIndex:indexPath.row];
    
    if([tmp.msgtype isEqualToString:@"fri"]){
        [self alertShow:@"Friend Invitation" message:tmp.msgcontent button:@"OK" cancel:@"No, thanks"];
    }

    //NSLog(@"selected");
}

@end
