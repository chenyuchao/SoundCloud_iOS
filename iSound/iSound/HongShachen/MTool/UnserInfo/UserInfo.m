//
//  UserInfo.m
//  iSound
//
//  Created by MaoHeng Zhang on 13-10-24.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo
@synthesize userDict;

static UserInfo *userinfo = nil;

+ (id)standardUserInfo
{
    if (!userinfo)
    {
        userinfo = [[UserInfo alloc] init];
    }
   return userinfo;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];

        self.userDict  = [userdefaults objectForKey:kUserInfoDict];
        self.user_id   = [userdefaults objectForKey:@"user_id"];
        self.is_first  = [userdefaults boolForKey:@"is_first"];
        self.nickname  = [userdefaults objectForKey:@"nickname"];
        self.user_id   = [userdefaults objectForKey:@"user_id"];
        self.head_image= [userdefaults objectForKey:@"head_image"];
        self.sign      = [userdefaults objectForKey:@"sign"];
        self.fans      = [userdefaults objectForKey:@"fans"];
        self.follow    = [userdefaults objectForKey:@"follow"];
        self.sound     = [userdefaults objectForKey:@"sound"];
        self.userAccount = [userdefaults objectForKey:@"userAccount"];
    }
    
    return self;
}

- (void)userDataWithDict:(NSDictionary *)infoDict
{
    [self clearUserInfoData];
    self.head_image = [infoDict objectForKey:@"head_image"];
    self.is_first   = [[infoDict objectForKey:@"is_first"] intValue] == 1 ? YES : NO;
    self.nickname   = [infoDict objectForKey:@"nickname"];
    self.user_id    = [NSString stringWithFormat:@"%d",[[infoDict objectForKey:@"user_id"] intValue]];

    [APService setTags:nil
                 alias:self.user_id
      callbackSelector:@selector(tagsAliasCallback:tags:alias:)
                object:self];
}


- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {

    if (iResCode != 0)
    {
        [APService setTags:[NSSet setWithObjects:@"1", nil]
                     alias:self.user_id
          callbackSelector:@selector(tagsAliasCallback:tags:alias:)
                    object:self];
    }
}

- (void)setUserDict:(NSMutableDictionary *)newValue
{
    if (userDict != newValue)
    {
        userDict = [newValue copy];
    }
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setObject:userDict forKey:kUserInfoDict];
    [userdefaults synchronize];
}

- (void)setUserAccount:(NSString *)newValue
{
    if (_userAccount != newValue)
    {
       _userAccount = [newValue copy];
    }
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setObject:_userAccount forKey:@"userAccount"];
    [userdefaults synchronize];
}

- (void)setHead_image:(NSString *)newValue
{
    if (_head_image != newValue)
    {
        _head_image = [newValue copy];
        
        NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
        [userdefaults setObject:_head_image forKey:@"head_image"];
        [userdefaults synchronize];
    }
}

- (void)setIs_first:(BOOL)newValue
{
    _is_first = newValue;
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setBool:_is_first forKey:@"is_first"];
    [userdefaults synchronize];
}

- (void)setNickname:(NSString *)newValue
{
    if (_nickname != newValue)
    {
        _nickname = newValue;
        
        NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
        [userdefaults setObject:_nickname forKey:@"nickname"];
        [userdefaults synchronize];
    }
}

- (void)setUser_id:(NSString *)newValue
{
    if (_user_id != newValue)
    {
        _user_id = newValue;
        
        NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
        [userdefaults setObject:_user_id forKey:@"user_id"];
        [userdefaults synchronize];
    }
}

- (void)setSign:(NSString *)sign
{
    if (_sign != sign)
    {
        _sign = sign;
        
        NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
        [userdefaults setObject:_sign forKey:@"sign"];
        [userdefaults synchronize];
    }
}

- (void)setFollow:(NSString *)follow
{
    if (_follow != follow)
    {
        _follow = follow;
        
        NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
        [userdefaults setObject:_follow forKey:@"follow"];
        [userdefaults synchronize];
    }
}

- (void)setFans:(NSString *)fans
{
    if (_fans != fans)
    {
        _fans = fans;
        
        NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
        [userdefaults setObject:_fans forKey:@"fans"];
        [userdefaults synchronize];
    }
}

- (void)setSound:(NSString *)sound
{
    if (_sound != sound)
    {
        _sound = sound;
        
        NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
        [userdefaults setObject:_sound forKey:@"sound"];
        [userdefaults synchronize];
    }
}



- (void)clearUserInfoData
{
    MoviePlayer *moviePlayer = [MoviePlayer standardMoviePlayer];
    moviePlayer.playlist = nil;
    [moviePlayer stopAudio];

    self.userDict   = nil;
    self.head_image = nil;
    self.is_first   = NO;
    self.nickname   = nil;
    self.user_id    = nil;
    self.fans       = nil;
    self.follow     = nil;
    self.sound      = nil;
}

@end
