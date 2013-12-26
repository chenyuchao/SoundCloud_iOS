//
//  SoundList.h
//  iSound
//
//  Created by Jumax.R on 13-11-11.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import "UserCenter_Super.h"

@interface SoundList : Center_ViewController <UITableViewDataSource, UITableViewDelegate, RequestDelegate> {

    UITableView *mainTableView;
}

@property (nonatomic, copy)  NSString *userid;
@property (nonatomic, retain) NSArray *mainlist;

@end
