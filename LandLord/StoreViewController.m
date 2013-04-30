//
//  StoreViewController.m
//  LandLord
//
//  Created by Chong Zhang on 4/27/13.
//  Copyright (c) 2013 CellularNetwork. All rights reserved.
//

#import "StoreViewController.h"


@interface StoreViewController ()
@property (nonatomic, strong) NSMutableArray *purchaseItem;
@property (nonatomic, strong) NSMutableArray *iteminfolist;
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

-(void)additeminfo
{
    NSString *t1 = @"This a sword from a family with long history fighting with thier enemies and standing with courage";
    [_iteminfolist addObject:t1];
    NSString *t2 = @"A weapon made for a general who never lose a war";
    [_iteminfolist addObject:t2];
    NSString *t3 = @"This is the hammer of Thor, the great god of thunder, lightning, storms, oak trees, strength, the son of the god of god";
    [_iteminfolist addObject:t3];
    NSString *t4 = @"This is the weapon of Mars, the great god of war";
    [_iteminfolist addObject:t4];
    NSString *t5 = @"This weapon belongs to Zsus, the great god of the world, the god of god";
    [_iteminfolist addObject:t5];
    NSString *t6 = @"A low and normal wall which could stop some enemies";
    [_iteminfolist addObject:t6];
    NSString *t7 = @"A small house with strong walls and solid structure";
    [_iteminfolist addObject:t7];
    NSString *t8 = @"This used to be the home of Duke Shane, the great hero of Rohan. It is small but beautiful castle with high walls";
    [_iteminfolist addObject:t8];
    NSString *t9 = @"Home of Gandalf, a castle flying in the sky";
    [_iteminfolist addObject:t9];
    NSString *t10 = @"The city of city, the city of king, the city of Aragorn";
    [_iteminfolist addObject:t10];
}
- (void)getItem
{
	NSString *itemurlstr = @"http://lordmap2k13.appspot.com/getinventory";
    NSURL *itemurl = [NSURL URLWithString:itemurlstr];
    NSData *data = [NSData dataWithContentsOfURL:itemurl];
    NSError *error;
    NSDictionary *jsonroot = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    NSArray *infolist = [NSArray arrayWithArray:_iteminfolist];
    
    NSArray *jsonitemlist = [jsonroot objectForKey:@"results"];
    int i = 0;
    for(NSDictionary *result in jsonitemlist){
        itemObj *currobj = [[itemObj alloc] init];
        currobj.index = (NSString *)[result objectForKey: @"index"];
        currobj.price = (NSString *)[result objectForKey:@"price"];
        currobj.atkPoint = (NSString *)[result objectForKey:@"atkPoint"];
        currobj.name = (NSString *)[result objectForKey:@"name"];
        currobj.defPoint = (NSString *)[result objectForKey:@"defPoint"];
        currobj.imagename = [NSString stringWithFormat:@"%@.png", currobj.index];
        NSLog(@"try to take item info");
        currobj.iteminfo = [infolist objectAtIndex:i];
        NSLog(@"%@",currobj.iteminfo);
        [_purchaseItem addObject:currobj];
        i++;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"itemdetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        itemDetailViewController *destViewController = segue.destinationViewController;
        destViewController.itemobj = [_purchaseItem objectAtIndex:indexPath.row];
    }
}
    
//    Purchase *tmp = [[Purchase alloc] init];
//	tmp.name = [[NSString alloc] init];
//	tmp.name = @"Wall";
//	[_purchaseItem addObject:tmp];
//	tmp = [[Purchase alloc] init];
//	tmp.name = [[NSString alloc] init];
//	tmp.name = @"Wall2";
//	[_purchaseItem addObject:tmp];

- (IBAction)pressButton:(id)sender
{
	NSLog(@"%d",[self.tableView indexPathForSelectedRow].row);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	_purchaseItem = [[NSMutableArray alloc] init];
    _iteminfolist = [[NSMutableArray alloc] init];
	self.tableView.dataSource = self;
	self.tableView.delegate = self;
    [self additeminfo];
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
	itemObj *tmp = [_purchaseItem objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:tmp.imagename];
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


- (void)alertShow: (NSString *)title message:(NSString *)message button:(NSString *)button cancel:(NSString*) cancel
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancel otherButtonTitles:button,nil];
    [alert show];
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
    //itemDetailViewController *dev = [[itemDetailViewController alloc] init];
    //[[self navigationController] pushViewController: dev animated:YES];

}

@end
