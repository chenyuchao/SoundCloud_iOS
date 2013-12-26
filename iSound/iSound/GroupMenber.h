//
//  GroupMenber.h
//  iSound
//
//  Created by Jumax.R on 13-11-16.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FansList.h"

@interface GroupMenber : UIPeople <RequestDelegate, DownloaderDelegate> {

    BOOL isMySelf;
}

@property (nonatomic, retain) NSArray *mainlist;
@property (nonatomic, copy)   NSString *userid;
@property (nonatomic, copy)   NSString *groupid;

@end