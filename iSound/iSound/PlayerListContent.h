//
//  PlayerListContent.h
//  iSound
//
//  Created by 郭子健 on 13-11-13.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerListContent : Center_TableView <RequestDelegate>  {
    
}

@property (nonatomic, copy) NSString *listId;
@property (nonatomic, retain) NSArray *mainlist;

@end
