//
//  UserInfo.h
//  iSound
//
//  Created by MaoHeng Zhang on 13-10-24.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SoundDetail.h"

#define kUserInfoDict @"UserInfoDict"

@interface UserInfo : NSObject

@property (nonatomic, copy) NSMutableDictionary *userDict;

@property (nonatomic, copy) NSString *head_image;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *sign;
@property (nonatomic, copy) NSString *follow;
@property (nonatomic, copy) NSString *fans;
@property (nonatomic, copy) NSString *sound;
@property (nonatomic, copy) NSString *userAccount;

@property (nonatomic) BOOL is_first;


+ (id)standardUserInfo;

- (void)clearUserInfoData;

- (void)userDataWithDict:(NSDictionary *)infoDict;

@end
