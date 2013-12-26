//
//  More.h
//  iSound
//
//  Created by Jumax.R on 13-9-28.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserFack.h"

#define kCheckVersionTag 3423

@interface More : UITableViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate,RequestDelegate>
{
    NSArray *titleArray;
}

@property (nonatomic, copy) NSString *appURL;

@end