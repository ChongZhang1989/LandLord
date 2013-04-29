//
//  messageObject.h
//  LandLord
//
//  Created by Alex Xia on 4/29/13.
//  Copyright (c) 2013 CellularNetwork. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface messageObject : NSObject
@property (nonatomic, strong) NSString *msgtype;
@property (nonatomic, strong) NSString *msgcontent;
@property (nonatomic, strong) NSString *localindex;
@end
