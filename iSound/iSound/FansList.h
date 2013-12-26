//
//  FansList.h
//  iSound
//
//  Created by Jumax.R on 13-11-10.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import "UserCenter_Super.h"
#import "UIPeople.h"

@interface FansList : UIPeople <RequestDelegate, DownloaderDelegate> {

}

@property (nonatomic, assign) BOOL isFanslist;

@end