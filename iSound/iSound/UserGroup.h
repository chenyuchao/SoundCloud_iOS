//
//  UserGroup.h
//  iSound
//
//  Created by Jumax.R on 13-11-2.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGGUI.h"
#import "CreateGroup.h"

@protocol UserGroupDelegate <NSObject>

@optional
- (void)didSelectedGroup:(NSString *)title groupID:(NSString *)gid;
- (void)didSelectedGroups:(NSString *)titles groupIDs:(NSString *)gids;

@end

@interface UserGroup : JGGUI <CreateGroupDelegate>  {

}

@property (nonatomic, retain) NSArray *ids;
@property (nonatomic, assign) id <UserGroupDelegate> delegate;

@end
