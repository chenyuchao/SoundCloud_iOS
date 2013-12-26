//
//  PlayerList.h
//  iSound
//
//  Created by Jumax.R on 13-11-11.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import "UserCenter_Super.h"
#import "JGGUI.h"
#import "CreatePlayerList.h"

#define kPlayListTag 235
#define kTypeListTag 425
#define kCreatPlayListTag 723

@protocol PlayerListDelegate <NSObject>

- (void)didSelectedPlayerList:(NSString *)listId name:(NSString *)name;

@end

@interface PlayerList : JGGUI <RequestDelegate, CreatePlayerListDelegate, UIActionSheetDelegate>
{
    
}

@property (nonatomic, assign) id <PlayerListDelegate> delegate;

@end
