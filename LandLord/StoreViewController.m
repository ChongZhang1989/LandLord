//
//  StoreViewController.m
//  LandLord
//
//  Created by Chong Zhang on 4/27/13.
//  Copyright (c) 2013 CellularNetwork. All rights reserved.
//

#import "StoreViewController.h"
#import "Purchase.h"

@interface StoreViewController ()
@property (nonatomic, strong) NSMutableArray *purchaseItem;
@end

@implementation StoreViewController
@synthesize purchaseItem = _purchaseItem;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)getItem
{
	NSString *itemurlstr = @"http://lordmap2k13.appspot.com/getinventory";
    NSURL *itemurl = [NSURL URLWithString:itemurlstr];
    NSData *data = [NSData dataWithContentsOfURL:itemurl];
    NSError *error;
    NSDictionary *jsonroot = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    NSArray *jsonitemlist = [jsonroot objectForKey:@"results"];
    
    for(NSDictionary *result in jsonitemlist){
        itemObj *currobj = [[itemObj alloc] init];
        currobj.index = (NSString *)[result objectForKey: @"index"];
        currobj.price = (NSString *)[result objectForKey:@"price"];
        currobj.atkPoint = (NSString *)[result objectForKey:@"atkPoint"];
        currobj.name = (NSString *)[result objectForKey:@"name"];
        currobj.defPoint = (NSString *)[result objectForKey:@"defPoint"];
        [_purchaseItem addObject:currobj];
    }
    
//    Purchase *tmp = [[Purchase alloc] init];
//	tmp.name = [[NSString alloc] init];
//	tmp.name = @"Wall";
//	[_purchaseItem addObject:tmp];
//	tmp = [[Purchase alloc] init];
//	tmp.name = [[NSString alloc] init];
//	tmp.name = @"Wall2";
//	[_purchaseItem addObject:tmp];
}
- (IBAction)pressButton:(id)sender
{
	NSLog(@"%d",[self.tableView indexPathForSelectedRow].row);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	_purchaseItem = [[NSMutableArray alloc] init];
	self.tableView.dataSource = self;
	self.tableView.delegate = self;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	[self getItem];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

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
	return [_purchaseItem count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UITableViewCell *cell =	[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
	}
	NSLog(@"%d, %@",indexPath.row, [_purchaseItem objectAtIndex:indexPath.row]);
	NSLog(@"%d", indexPath.row);
	NSLog(@"called 1!");
	Purchase *tmp = [_purchaseItem objectAtIndex:indexPath.row];
	cell.textLabel.text = tmp.name;
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
}

@end
