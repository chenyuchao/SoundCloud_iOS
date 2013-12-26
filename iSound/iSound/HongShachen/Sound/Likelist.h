//
//  Likelist.h
//  iSound
//
//  Created by Jumax.R on 13-12-24.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPeople.h"

@interface Likelist : UIPeople <RequestDelegate, DownloaderDelegate>
{
    
}

@property (nonatomic, assign) BOOL isLikelist;
@property (nonatomic, copy) NSString *voice_id;
@property (nonatomic, copy) NSString *user_id;
@end
