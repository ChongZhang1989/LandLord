//
//  MyPinView.m
//  LandLord
//
//  Created by Alex Xia on 4/25/13.
//  Copyright (c) 2013 CellularNetwork. All rights reserved.
//

#import "MyPinView.h"

@implementation MyPinView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if(self != nil)
    {
        CGRect frame = self.frame;
        frame.size = CGSizeMake(60.0, 85.0);
        self.frame = frame;
        self.backgroundColor = [UIColor clearColor];
        self.centerOffset = CGPointMake(-5, -5);
    }
    return self;
}

-(void) drawRect: (CGRect) rect
{
    [[UIImage imageNamed:@"camp.png"] drawInRect:CGRectMake(30, 30.0, 30.0, 30.0)];
    
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
