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
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSLog(@"%@", _itemobj.name);
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
