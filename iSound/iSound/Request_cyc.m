//
//  RequestCyc.m
//  iSound
//
//  Created by Jumax.R on 13-10-31.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import "Request_cyc.h"

@implementation Request (ChenYuChaoRequest)

- (void)userlogin:(NSString *)uname
         password:(NSString *)password
         delegate:(id <RequestDelegate>)delegate {
    
    self.delegate = delegate;
	JROrderlyDictionary *args = [JROrderlyDictionary dictionary];
	[args setObject:[NSString stringWithFormat:@"%@", uname]	forKey:@"user_name"];
	[args setObject:[NSString stringWithFormat:@"%@", password]	forKey:@"user_pwd"];
	[self startConnection:NWUserLogin args:args];
}

- (void)userRegister:(NSString *)uname
            password:(NSString *)password
            delegate:(id <RequestDelegate>)delegate {

    self.delegate = delegate;
	JROrderlyDictionary *args = [JROrderlyDictionary dictionary];
	[args setObject:[NSString stringWithFormat:@"%@", uname]	forKey:@"user_name"];
	[args setObject:[NSString stringWithFormat:@"%@", password]	forKey:@"user_pwd"];
	[self startConnection:NWUserRegister args:args];
}

- (void)getTagListWithDelegate:(id <RequestDelegate>)delegate {

     self.delegate = delegate;
    [self startConnection:NWTagList args:nil];
}

- (void)getCityListWithDelegate:(id <RequestDelegate>)delegate {

     self.delegate = delegate;
    [self startConnection:NWCityList args:nil];
}

- (void)editBaseInfo:(NSString *)uname
            nickname:(NSString *)nickname
             profile:(NSString *)profile
                 sex:(NSString *)sex
            province:(NSString *)province
                city:(NSString *)city
            delegate:(id <RequestDelegate>)delegate {

    self.delegate = delegate;
	JROrderlyDictionary *args = [JROrderlyDictionary dictionary];
	[args setObject:[NSString stringWithFormat:@"%@", uname]	forKey:@"user_id"];
	[args setObject:[NSString stringWithFormat:@"%@", nickname]	forKey:@"nickname"];
    [args setObject:[NSString stringWithFormat:@"%@", profile]	forKey:@"profile"];
	[args setObject:[NSString stringWithFormat:@"%@", sex]      forKey:@"sex"];
    [args setObject:[NSString stringWithFormat:@"%@", province]	forKey:@"province"];
	[args setObject:[NSString stringWithFormat:@"%@", city]     forKey:@"city"];
	[self startConnection:NWEditInfo args:args];
}

- (void)updateBaseInfo:(NSString *)uname
              nickname:(NSString *)nickname
               profile:(NSString *)profile
                   sex:(NSString *)sex
              province:(NSString *)province
                  city:(NSString *)city
              delegate:(id <RequestDelegate>)delegate {

    self.delegate = delegate;
	JROrderlyDictionary *args = [JROrderlyDictionary dictionary];
	[args setObject:[NSString stringWithFormat:@"%@", uname]	forKey:@"user_id"];
	[args setObject:[NSString stringWithFormat:@"%@", nickname]	forKey:@"nickname"];
    [args setObject:[NSString stringWithFormat:@"%@", profile]	forKey:@"profile"];
	[args setObject:[NSString stringWithFormat:@"%@", sex]      forKey:@"sex"];
    [args setObject:[NSString stringWithFormat:@"%@", province]	forKey:@"province"];
	[args setObject:[NSString stringWithFormat:@"%@", city]     forKey:@"city"];
	[self startConnection:NWUpdateInfo args:args];
}

- (void)addTagForUser:(NSString *)uname
                tagId:(NSString *)tagId
              isFirst:(BOOL)isFirst
             delegate:(id <RequestDelegate>)delegate {

    self.delegate = delegate;
	JROrderlyDictionary *args = [JROrderlyDictionary dictionary];
	[args setObject:[NSString stringWithFormat:@"%@", uname]	forKey:@"user_id"];
	[args setObject:[NSString stringWithFormat:@"%@", tagId]	forKey:@"tag_id"];
    [args setObject:[NSString stringWithFormat:@"%i", isFirst]	forKey:@"is_first"];
	[self startConnection:NWAddTag args:args];
}

- (void)getRecommendPeople:(NSInteger)page
                  delegate:(id <RequestDelegate>)delegate {

    self.delegate = delegate;
	JROrderlyDictionary *args = [JROrderlyDictionary dictionary];
    [args setObject:[[UserInfo standardUserInfo] user_id]	forKey:@"user_id"];
	[args setObject:[NSString stringWithFormat:@"%i", page]	forKey:@"page"];
	[self startConnection:NWRecommend args:args];
}

- (void)getUserCenterData:(NSString *)uname
                     page:(int)page
                 per_page:(int)number
                 delegate:(id <RequestDelegate>)delegate {
    
    self.delegate = delegate;
	JROrderlyDictionary *args = [JROrderlyDictionary dictionary];
	[args setObject:[NSString stringWithFormat:@"%@", uname]  forKey:@"user_id"];
    [args setObject:[NSString stringWithFormat:@"%i", page]   forKey:@"page"];
    [args setObject:[NSString stringWithFormat:@"%i", number] forKey:@"per_page"];
	[self startConnection:NWUserCenterData args:args];
}

- (void)getOtherUserCenterData:(NSString *)uname
                    otherUname:(NSString *)oUname
                          page:(int)page
                      per_page:(int)number
                      delegate:(id <RequestDelegate>)delegate {

    self.delegate = delegate;
	JROrderlyDictionary *args = [JROrderlyDictionary dictionary];
	[args setObject:[NSString stringWithFormat:@"%@", uname]  forKey:@"user_id"];
    [args setObject:[NSString stringWithFormat:@"%@", oUname] forKey:@"other_user_id"];
    [args setObject:[NSString stringWithFormat:@"%i", page]   forKey:@"page"];
    [args setObject:[NSString stringWithFormat:@"%i", number] forKey:@"per_page"];
	[self startConnection:@"user/other_user_info" args:args];
}

- (void)getUserDescription:(NSString *)uname
                  delegate:(id <RequestDelegate>)delegate {
    
    self.delegate = delegate;
	JROrderlyDictionary *args = [JROrderlyDictionary dictionary];
	[args setObject:[NSString stringWithFormat:@"%@", uname] forKey:@"user_id"];
	[self startConnection:NWUserDescription args:args];
}

- (void)getSoundList:(NSString *)uname
               pages:(int)pages
            delegate:(id <RequestDelegate>)delegate {
    
    self.delegate = delegate;
	JROrderlyDictionary *args = [JROrderlyDictionary dictionary];
	[args setObject:[NSString stringWithFormat:@"%@", uname] forKey:@"user_id"];
    [args setObject:[NSString stringWithFormat:@"%i", pages] forKey:@"pages"];
    [args setObject:[NSString stringWithFormat:@"%@", @"10"] forKey:@"numbers"];
	[self startConnection:NWSoundList args:args];
}

- (void)addFollow:(NSString *)uname
         targetId:(NSString *)targetId
         delegate:(id <RequestDelegate>)delegate {

    self.delegate = delegate;
	JROrderlyDictionary *args = [JROrderlyDictionary dictionary];
	[args setObject:[NSString stringWithFormat:@"%@", uname]    forKey:@"userid"];
    [args setObject:[NSString stringWithFormat:@"%@", targetId] forKey:@"follow_id"];
	[self startConnection:NWAddFollow args:args];
}

- (void)cancelFollow:(NSString *)uname
            targetId:(NSString *)targetId
            delegate:(id<RequestDelegate>)delegate {
    
    self.delegate = delegate;
	JROrderlyDictionary *args = [JROrderlyDictionary dictionary];
	[args setObject:[NSString stringWithFormat:@"%@", uname]    forKey:@"userid"];
    [args setObject:[NSString stringWithFormat:@"%@", targetId] forKey:@"follow_id"];
	[self startConnection:NWCancelFollow args:args];
}

- (void)getVoiceInfo:(NSString *)uname
             voiceId:(NSString *)vid
                type:(int)type
            delegate:(id<RequestDelegate>)delegate {
    
    self.delegate = delegate;
	JROrderlyDictionary *args = [JROrderlyDictionary dictionary];
	[args setObject:[NSString stringWithFormat:@"%@", uname] forKey:@"user_id"];
    [args setObject:[NSString stringWithFormat:@"%@", vid]   forKey:@"voice_id"];
    [args setObject:[NSString stringWithFormat:@"%i", type]  forKey:@"type"];
	[self startConnection:NWVoiceInfo args:args];
}

- (void)getLikeList:(NSString *)uname
               page:(int)page
           per_page:(int)number
           delegate:(id<RequestDelegate>)delegate {

    self.delegate = delegate;
	JROrderlyDictionary *args = [JROrderlyDictionary dictionary];
	[args setObject:[NSString stringWithFormat:@"%@", uname]  forKey:@"user_id"];
    [args setObject:[NSString stringWithFormat:@"%i", page]   forKey:@"page"];
    [args setObject:[NSString stringWithFormat:@"%i", number] forKey:@"per_page"];
	[self startConnection:NWLikeList args:args];
}

- (void)getFollowList:(NSString *)uname
                 page:(int)page
             per_page:(int)number
             delegate:(id<RequestDelegate>)delegate {
    
    self.delegate = delegate;
	JROrderlyDictionary *args = [JROrderlyDictionary dictionary];
    [args setObject:[[UserInfo standardUserInfo] user_id]     forKey:@"user_id"];
	[args setObject:[NSString stringWithFormat:@"%@", uname]  forKey:@"other_user_id"];
    [args setObject:[NSString stringWithFormat:@"%i", page]   forKey:@"page"];
    [args setObject:[NSString stringWithFormat:@"%i", number] forKey:@"per_page"];
	[self startConnection:@"follow/other_user_follow" args:args];
}

- (void)getFansList:(NSString *)uname
               page:(int)page
           per_page:(int)number
           delegate:(id<RequestDelegate>)delegate {

    self.delegate = delegate;
	JROrderlyDictionary *args = [JROrderlyDictionary dictionary];
    [args setObject:[[UserInfo standardUserInfo] user_id]     forKey:@"user_id"];
	[args setObject:[NSString stringWithFormat:@"%@", uname]  forKey:@"other_user_id"];
    [args setObject:[NSString stringWithFormat:@"%i", page]   forKey:@"page"];
    [args setObject:[NSString stringWithFormat:@"%i", number] forKey:@"per_page"];
	[self startConnection:@"follow/other_user_fans" args:args];
}

- (void)getTimeLineList:(NSString *)uname
                   page:(int)page
               per_page:(int)number
               delegate:(id<RequestDelegate>)delegate {

    self.delegate = delegate;
	JROrderlyDictionary *args = [JROrderlyDictionary dictionary];
	[args setObject:[NSString stringWithFormat:@"%@", uname]  forKey:@"user_id"];
    [args setObject:[NSString stringWithFormat:@"%i", page]   forKey:@"page"];
    [args setObject:[NSString stringWithFormat:@"%i", number] forKey:@"per_page"];
	[self startConnection:NWTimeLineList args:args];
}

- (void)delAudioFromPlayerlist:(NSString *)vid
                   playlist_id:(NSString *)plistId
                      delegate:(id<RequestDelegate>)delegate {

    self.delegate = delegate;
	JROrderlyDictionary *args = [JROrderlyDictionary dictionary];
	[args setObject:[NSString stringWithFormat:@"%@", vid]      forKey:@"voice_id"];
    [args setObject:[NSString stringWithFormat:@"%@", plistId]  forKey:@"playlist_id"];
	[self startConnection:NWDelAudioFromPlayerList args:args];
}

- (void)delAudioPlayerlist:(NSString *)uname
               playlist_id:(NSString *)plistId
                  delegate:(id<RequestDelegate>)delegate {

    self.delegate = delegate;
	JROrderlyDictionary *args = [JROrderlyDictionary dictionary];
	[args setObject:[NSString stringWithFormat:@"%@", uname]    forKey:@"user_id"];
    [args setObject:[NSString stringWithFormat:@"%@", plistId]  forKey:@"playlist_id"];
	[self startConnection:NWDelPlayerList args:args];
}

- (void)getGroupList:(NSString *)uname
               pages:(int)page
              number:(int)number
            delegate:(id<RequestDelegate>)delegate {

    self.delegate = delegate;
	JROrderlyDictionary *args = [JROrderlyDictionary dictionary];
	[args setObject:[NSString stringWithFormat:@"%@", uname]  forKey:@"user_id"];
    [args setObject:[NSString stringWithFormat:@"%i", page]   forKey:@"pages"];
    [args setObject:[NSString stringWithFormat:@"%i", number] forKey:@"numbers"];
	[self startConnection:NWGroupList args:args];
}

- (void)getGroupMember:(NSString *)uname
               groupId:(NSString *)gid
              delegate:(id<RequestDelegate>)delegate
{
    NSLog(@"%@",[[UserInfo standardUserInfo] user_id]);
    NSLog(@"%@",uname);
    self.delegate = delegate;
	JROrderlyDictionary *args = [JROrderlyDictionary dictionary];
	[args setObject:[NSString stringWithFormat:@"%@", uname] forKey:@"user_id"];
    [args setObject:[NSString stringWithFormat:@"%@", gid]   forKey:@"group_id"];
	[self startConnection:NWGroupMember args:args];
}

- (void)inviteUserToGroup:(NSString *)uname
                  groupId:(NSString *)gid
                 inviteId:(NSString *)inid
                 delegate:(id<RequestDelegate>)delegate {

    self.delegate = delegate;
	JROrderlyDictionary *args = [JROrderlyDictionary dictionary];
	[args setObject:[NSString stringWithFormat:@"%@", uname] forKey:@"manage_id"];
    [args setObject:[NSString stringWithFormat:@"%@", gid]   forKey:@"group_id"];
    [args setObject:[NSString stringWithFormat:@"%@", inid]  forKey:@"invite_id"];
	[self startConnection:NWAddUserToGroup args:args];
}

- (void)deleteUsesrAudio:(NSString *)uname
                  audoId:(NSString *)aid
                delegate:(id<RequestDelegate>)delegate {

    self.delegate = delegate;
	JROrderlyDictionary *args = [JROrderlyDictionary dictionary];
	[args setObject:[NSString stringWithFormat:@"%@", uname] forKey:@"user_id"];
    [args setObject:[NSString stringWithFormat:@"%@", aid]   forKey:@"voice_id"];
	[self startConnection:NWDeleteAudio args:args];
}

- (void)getGroupAudioList:(NSString *)group_id
                    pages:(int)pages
                  numbers:(int)number
                 delegate:(id<RequestDelegate>)delegate {

    self.delegate = delegate;
	JROrderlyDictionary *args = [JROrderlyDictionary dictionary];
	[args setObject:[NSString stringWithFormat:@"%@", group_id] forKey:@"group_id"];
    [args setObject:[NSString stringWithFormat:@"%i", pages]    forKey:@"pages"];
    [args setObject:[NSString stringWithFormat:@"%i", number]   forKey:@"numbers"];
	[self startConnection:NWGroupAudioList args:args];
}

- (void)getTimeLineAudioList:(NSString *)uname
                        year:(NSString *)year
                       month:(NSString *)month
                        city:(NSString *)city
                       pages:(int)page
                     numbers:(int)number
                    delegate:(id<RequestDelegate>)delegate {

    self.delegate = delegate;
	JROrderlyDictionary *args = [JROrderlyDictionary dictionary];
	[args setObject:[NSString stringWithFormat:@"%@", uname]    forKey:@"user_id"];
    [args setObject:[NSString stringWithFormat:@"%@", year]     forKey:@"release_year"];
    [args setObject:[NSString stringWithFormat:@"%@", month]    forKey:@"release_month"];
    [args setObject:[NSString stringWithFormat:@"%@", city]     forKey:@"city"];
    [args setObject:[NSString stringWithFormat:@"%i", page]     forKey:@"page"];
    [args setObject:[NSString stringWithFormat:@"%i", number]   forKey:@"per_page"];
	[self startConnection:NWTimeLineAudioList args:args];
}

- (void)getMessageList:(NSString *)uname
              delegate:(id <RequestDelegate>)delegate {

    self.delegate = delegate;
	JROrderlyDictionary *args = [JROrderlyDictionary dictionary];
	[args setObject:[NSString stringWithFormat:@"%@", uname]    forKey:@"user_id"];
	[self startConnection:NWMessageList args:args];
}

- (void)reviewComingGroup:(NSString *)uname
                  groupId:(NSString *)gid
                  applyId:(NSString *)aid
                    agree:(int)state
                 delegate:(id <RequestDelegate>)delegate {

    self.delegate = delegate;
	JROrderlyDictionary *args = [JROrderlyDictionary dictionary];
	[args setObject:[NSString stringWithFormat:@"%@", uname] forKey:@"manage_id"];
    [args setObject:[NSString stringWithFormat:@"%@", gid]   forKey:@"gorup_id"];
    [args setObject:[NSString stringWithFormat:@"%@", aid]   forKey:@"apply_id"];
    [args setObject:[NSString stringWithFormat:@"%i", state] forKey:@"state"];
	[self startConnection:NWReviewGroup args:args];
}

- (void)agreeToGroup:(NSString *)uname
             groupId:(NSString *)gid
            delegate:(id <RequestDelegate>)delegate {

    self.delegate = delegate;
	JROrderlyDictionary *args = [JROrderlyDictionary dictionary];
	[args setObject:[NSString stringWithFormat:@"%@", uname] forKey:@"invite_id"];
    [args setObject:[NSString stringWithFormat:@"%@", gid]   forKey:@"gorup_id"];
	[self startConnection:NWAgreeGroup args:args];
}

- (void)delGroupAudio:(NSString *)uname
              groupId:(NSString *)gid
              audioId:(NSString *)aid
             delegate:(id <RequestDelegate>)delegate {
    
    self.delegate = delegate;
	JROrderlyDictionary *args = [JROrderlyDictionary dictionary];
	[args setObject:[NSString stringWithFormat:@"%@", uname] forKey:@"invite_id"];
    [args setObject:[NSString stringWithFormat:@"%@", gid]   forKey:@"gorup_id"];
    [args setObject:[NSString stringWithFormat:@"%@", aid]   forKey:@"voice_id"];
	[self startConnection:@"group/del_group_voice" args:args];
}

- (void)synchronizeWeiboUsers:(NSString *)synchronize_users
                     delegate:(id <RequestDelegate>)delegate {

    self.delegate = delegate;
	JROrderlyDictionary *args = [JROrderlyDictionary dictionary];
	[args setObject:[NSString stringWithFormat:@"%@", synchronize_users] forKey:@"synchronize_users"];
	[self startConnection:@"user/synchronize_users" args:args];
}

- (void)otherLogin:(NSString *)uname
          platform:(NSString *)platform
          delegate:(id <RequestDelegate>)delegate {

    self.delegate = delegate;
	JROrderlyDictionary *args = [JROrderlyDictionary dictionary];
	[args setObject:[NSString stringWithFormat:@"%@", uname] forKey:@"user_name"];
    [args setObject:[NSString stringWithFormat:@"%@", platform] forKey:@"user_from"];
	[self startConnection:@"user/third_party_login" args:args];
}

- (void)logout:(NSString *)uname
      delegate:(id <RequestDelegate>)delegate {

    self.delegate = delegate;
	JROrderlyDictionary *args = [JROrderlyDictionary dictionary];
	[args setObject:[[UserInfo standardUserInfo] user_id] forKey:@"user_id"];
	[self startConnection:@"user/logout" args:args];
}

- (void)uploadHeader:(NSString *)uname
               image:(UIImage *)image
            delegate:(id <RequestDelegate>)delegate {
    
    self.delegate = delegate;
    // MD5加密
	NSMutableString *args = [NSMutableString stringWithFormat:@"api_user=ios_280&from=ios&user_id=%@", uname];
    NSString *md5Str      = [[Custom MD5:[NSString stringWithFormat:@"%@%@%@",PrivateKey, args, PrivateKey]] lowercaseString];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:@"ios_280" forKey:@"api_user"];
    [params setObject:@"ios"     forKey:@"from"];
    [params setObject:uname      forKey:@"user_id"];
    [params setObject:md5Str     forKey:@"sign"];
    
    NSString *aurl = [NSString stringWithFormat:@"%@%@", OutNetAddress, NWUploadHeader];
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:aurl]];
    NSString *MPboundary = [[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    NSString *endMPboundary = [[NSString alloc]initWithFormat:@"%@--",MPboundary];
    NSData   *data = UIImagePNGRepresentation(image);
    NSMutableString *body = [[NSMutableString alloc] init];
    NSArray *keys = [params allKeys];
    
    //遍历keys
    for(int i = 0;i < [keys count];i++)
    {
        NSString *key = [keys objectAtIndex:i];
        [body appendFormat:@"%@\r\n",MPboundary];
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
        [body appendFormat:@"%@\r\n",[params objectForKey:key]];
    }
    
    //添加分界线，换行
    [body appendFormat:@"%@\r\n",MPboundary];
    [body appendFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"user_header.png\"\r\n"];
    [body appendFormat:@"Content-Type: image/png\r\n\r\n"];
    
    NSString *end = [[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    NSMutableData *requestData = [NSMutableData data];
    [requestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    [requestData appendData:data];
    [requestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%i", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:requestData];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:60];

    receiveData = [[NSMutableData alloc] init];
    [NSURLConnection connectionWithRequest:request delegate:self];
    if ([self.delegate respondsToSelector:@selector(downloadWillStart:)])
    {
        [self.delegate downloadWillStart:self];
    }
}

- (void)addGroupList:(NSString *)uname
                name:(NSString *)name
                sign:(NSString *)sign
               image:(UIImage *)image
            delegate:(id<RequestDelegate>)delegate {

    self.delegate = delegate;
    // MD5加密
	NSMutableString *args = [NSMutableString stringWithFormat:@"api_user=ios_280&create_user_id=%@&from=ios&group_name=%@&group_profile=%@", uname, name,sign];
    NSString *md5Str      = [[Custom MD5:[NSString stringWithFormat:@"%@%@%@",PrivateKey, args, PrivateKey]] lowercaseString];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:@"ios_280" forKey:@"api_user"];
    [params setObject:@"ios"     forKey:@"from"];
    [params setObject:uname      forKey:@"create_user_id"];
    [params setObject:name       forKey:@"group_name"];
    [params setObject:sign       forKey:@"group_profile"];
    [params setObject:md5Str     forKey:@"sign"];
    
    NSString *aurl = [NSString stringWithFormat:@"%@%@", OutNetAddress, NWAddGroup];
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:aurl]];
    NSString *MPboundary = [[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    NSString *endMPboundary = [[NSString alloc]initWithFormat:@"%@--",MPboundary];
    NSMutableString *body = [[NSMutableString alloc] init];
    NSArray *keys = [params allKeys];
    
    //遍历keys
    for(int i = 0;i < [keys count];i++)
    {
        NSString *key = [keys objectAtIndex:i];
        [body appendFormat:@"%@\r\n",MPboundary];
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
        [body appendFormat:@"%@\r\n",[params objectForKey:key]];
    }
    
    //添加分界线，换行
    [body appendFormat:@"%@\r\n",MPboundary];
    [body appendFormat:@"Content-Disposition: form-data; name=\"group_logo\"; filename=\"groupLogo.png\"\r\n"];
    [body appendFormat:@"Content-Type: image/png\r\n\r\n"];
    
    NSString *end = [[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    NSMutableData *requestData = [NSMutableData data];
    [requestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    [requestData appendData:UIImagePNGRepresentation(image)];
    [requestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%i", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:requestData];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:60];
    
    receiveData = [[NSMutableData alloc] init];
    [NSURLConnection connectionWithRequest:request delegate:self];
    if ([self.delegate respondsToSelector:@selector(downloadWillStart:)])
    {
        [self.delegate downloadWillStart:self];
    }
}

@end
