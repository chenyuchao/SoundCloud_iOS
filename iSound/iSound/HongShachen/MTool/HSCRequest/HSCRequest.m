//
//  HSCRequest.m
//  iSound
//
//  Created by MaoHeng Zhang on 13-10-31.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import "HSCRequest.h"

#define PostAudio  @"user/post_audio"
#define LIKEVOICE  @"voice/like_voice"
#define UNLIKEVOICE @"voice/cancel_like_voice"
#define VOICETRANSPOND @"voice/voice_transpond"
#define ADDPLAYLIST  @"voice/add_play_list"

#define VOICECLASSLIST @"voice/voice_class_list"
#define VOICEPLAYLIST  @"voice/voice_play_list"
#define VOICECLASSADD  @"voice/voice_calss_add"

#define VOICECOMMENTLIST @"voice/voice_comment_list"
#define VOICEADDCOMMENT  @"voice/voice_comment"

#define VOICE_FIND_VOICE @"voice/find_voice"

#define USER_FEEDBACK @"system/user_feedback"

#define CHECKVERSION @"system/checkver"

#define VOICERANKING @"voice/voice_ranking_list"
#define  USERRANKING @"user/user_ranking_list"

@implementation Request(HSCRequest)

#pragma mark - 音频转发人员列表API

- (void)voiceTranspondUserListvoice_id:(NSString *)voice_id
                        pages:(NSString *)pages
                               numbers:(NSString *)numbers
                               user_id:(NSString *)user_id
                withDelegate:(id <RequestDelegate>)delegate
{
    self.delegate = delegate;
    
    JROrderlyDictionary *args = [JROrderlyDictionary dictionary];
    [args setObject:voice_id   forKey:@"voice_id"];
    [args setObject:pages      forKey:@"pages"];
    [args setObject:numbers    forKey:@"numbers"];
    [args setObject:user_id forKey:@"user_id"];
    
    [self startConnection:@"voice/voice_transpond_user_list" args:args];
}
#pragma mark - 播放详情喜欢人员列表

- (void)likeuserlikevoice_id:(NSString *)voice_id
                        page:(NSString *)page
                    per_page:(NSString *)per_page
                     user_id:(NSString *)user_id
                withDelegate:(id <RequestDelegate>)delegate
{
    self.delegate = delegate;
    
    JROrderlyDictionary *args = [JROrderlyDictionary dictionary];
    [args setObject:voice_id   forKey:@"voice_id"];
    [args setObject:page       forKey:@"page"];
    [args setObject:per_page   forKey:@"per_page"];
    [args setObject:user_id forKey:@"user_id"];
    
    [self startConnection:@"user/like_user_list" args:args];
}


#pragma mark - 找回密码1

- (void)findPasswordWithUserName:(NSString *)user_name withDelegate:(id <RequestDelegate>)delegate
{
    self.delegate = delegate;
    
    JROrderlyDictionary *args = [JROrderlyDictionary dictionary];
    [args setObject:user_name  forKey:@"user_name"];
    
    [self startConnection:@"user/find_pwd_first" args:args];
}

#pragma mark - 找回密码2

- (void)findPasswordWithYanzhengma:(NSString *)yanzhengma
                          username:(NSString *)username
                      withDelegate:(id <RequestDelegate>)delegate
{
    self.delegate = delegate;
    
    JROrderlyDictionary *args = [JROrderlyDictionary dictionary];
    [args setObject:yanzhengma  forKey:@"check_number"];
    [args setObject:username    forKey:@"user_name"];
    
    [self startConnection:@"user/find_pwd_two" args:args];
    
}

#pragma mark - 找回密码3

- (void)resetPasswordWithUsernamed:(NSString *)user_name
                          password:(NSString *)password
                      withDelegate:(id <RequestDelegate>)delegate
{
    self.delegate = delegate;
    
    JROrderlyDictionary *args = [JROrderlyDictionary dictionary];
    [args setObject:user_name  forKey:@"user_name"];
    [args setObject:password    forKey:@"new_pwd"];
    
    [self startConnection:@"user/find_pwd_three" args:args];
}

#pragma mark - 

- (void)groupLogoutGroupId:(NSString *)group_id delegate:(id <RequestDelegate>)delegate
{
    self.delegate = delegate;
    
    JROrderlyDictionary *args = [JROrderlyDictionary dictionary];
    [args setObject:group_id  forKey:@"group_id"];
    [args setObject:[[UserInfo standardUserInfo] user_id]     forKey:@"user_id"];

    [self startConnection:@"group/group_logout" args:args];
//
}

#pragma mark -

- (void)searchGroupWithKeyworld:(NSString *)keyWorld
                          pages:(NSString *)pages
                        numbers:(NSString *)numbers
                       delegate:(id <RequestDelegate>)delegate
{
    self.delegate = delegate;
    
    JROrderlyDictionary *args = [JROrderlyDictionary dictionary];
    [args setObject:keyWorld  forKey:@"keyword"];
    [args setObject:pages     forKey:@"pages"];
    [args setObject:numbers   forKey:@"numbers"];
    [self startConnection:@"group/search_group" args:args];
}

- (void)searchUserWithKeyworld:(NSString *)keyWorld
                          pages:(NSString *)pages
                        numbers:(NSString *)numbers
                       delegate:(id <RequestDelegate>)delegate
{
    self.delegate = delegate;
    
    JROrderlyDictionary *args = [JROrderlyDictionary dictionary];
    [args setObject:keyWorld  forKey:@"keywords"];
    [args setObject:pages     forKey:@"page"];
    [args setObject:numbers   forKey:@"per_page"];
    [self startConnection:@"user/search_user" args:args];
}

#pragma mark - 

- (void)searchAudioWithKeyworld:(NSString *)keyWorld
                          pages:(NSString *)pages
                        numbers:(NSString *)numbers
                       delegate:(id <RequestDelegate>)delegate
{
    self.delegate = delegate;
    
    JROrderlyDictionary *args = [JROrderlyDictionary dictionary];
    [args setObject:keyWorld  forKey:@"keyword"];
    [args setObject:pages     forKey:@"pages"];
    [args setObject:numbers   forKey:@"numbers"];
    [self startConnection:@"voice/voice_search" args:args];
    
}

#pragma mark - 

- (void)applyGroupWithUserid:(NSString *)userid
                     groupid:(NSString *)groupid
                    delegate:(id <RequestDelegate>)delegate
{
    self.delegate = delegate;
    
    JROrderlyDictionary *args = [JROrderlyDictionary dictionary];
    [args setObject:userid  forKey:@"userid"];
    [args setObject:groupid forKey:@"group_id"];
    
    [self startConnection:@"group/apply_group" args:args];
}
//

#pragma mark - 

- (void)deleteGroupWithUserid:(NSString *)userid
                      groupid:(NSString *)groupid
                     delegate:(id <RequestDelegate>)delegate
{
    self.delegate = delegate;
    
    JROrderlyDictionary *args = [JROrderlyDictionary dictionary];
    [args setObject:userid     forKey:@"user_id"];
    [args setObject:groupid forKey:@"group_id"];
    
    [self startConnection:@"group/del_group" args:args];
//
}

#pragma mark - 

- (void)groupDetailWithGroup_id:(NSString *)group_id
                 Withdelegate:(id <RequestDelegate>)delegate
{
    self.delegate = delegate;
    
    JROrderlyDictionary *args = [JROrderlyDictionary dictionary];
    [args setObject:[[UserInfo standardUserInfo] user_id] forKey:@"user_id"];
    [args setObject:group_id forKey:@"group_id"];
    [self startConnection:@"group/group_info" args:args];
    
}

#pragma mark - 

- (void)groupWithKeyworld:(NSString *)keyworld
                     Page:(NSString *)page
                 per_page:(NSString *)per_page
             Withdelegate:(id <RequestDelegate>)delegate
{
    self.delegate = delegate;
    
    JROrderlyDictionary *args = [JROrderlyDictionary dictionary];
    [args setObject:keyworld forKey:@"keyword"];
    [args setObject:page     forKey:@"pages"];
    [args setObject:per_page forKey:@"numbers"];
    
    [self startConnection:@"group/search_group" args:args];
}

- (void)groupLikePage:(NSString *)page
             per_page:(NSString *)per_page
         Withdelegate:(id <RequestDelegate>)delegate
{
    
    self.delegate = delegate;
    
    JROrderlyDictionary *args = [JROrderlyDictionary dictionary];
    [args setObject:page     forKey:@"page"];
    [args setObject:per_page forKey:@"per_page"];
    
    [self startConnection:@"group/group_ranking_list" args:args];
    
}

#pragma mark - 

- (void)userLikePage:(NSString *)page
            per_page:(NSString *)per_page
        Withdelegate:(id <RequestDelegate>)delegate

{
    self.delegate = delegate;
    
    JROrderlyDictionary *args = [JROrderlyDictionary dictionary];
    [args setObject:[[UserInfo standardUserInfo] user_id]      forKey:@"user_id"];
    [args setObject:page     forKey:@"page"];
    [args setObject:per_page forKey:@"per_page"];
    
    [self startConnection:USERRANKING args:args];
    
}

#pragma mark - 热门音频排行

- (void)audioLikePage:(NSString *)page
             per_page:(NSString *)per_page
         Withdelegate:(id <RequestDelegate>)delegate
{
    self.delegate = delegate;
    
    JROrderlyDictionary *args = [JROrderlyDictionary dictionary];
    [args setObject:page     forKey:@"page"];
    [args setObject:per_page forKey:@"per_page"];
    
    [self startConnection:VOICERANKING args:args];
    
}

- (void)checkVersionWithdelegate:(id <RequestDelegate>)delegate
{
    self.delegate = delegate;
    
    JROrderlyDictionary *args = [JROrderlyDictionary dictionary];
    [args setObject:JJD_VERSION    forKey:@"version"];
    
    [self startConnection:CHECKVERSION args:args];
    
}

#pragma mark - 用户反馈

- (void)userFeedback:(NSString *)content delegate:(id <RequestDelegate>)delegate
{
    self.delegate = delegate;
    
    JROrderlyDictionary *args = [JROrderlyDictionary dictionary];
    [args setObject:[[UserInfo standardUserInfo] userAccount] forKey:@"user_name"];
    [args setObject:content    forKey:@"content"];
    
    [self startConnection:USER_FEEDBACK args:args];
}

- (void)findVoiceWithPages:(NSString *)pages
                   numbers:(NSString *)numbers
                  delegate:(id <RequestDelegate>)delegate
{
    self.delegate = delegate;
    
    JROrderlyDictionary *args = [JROrderlyDictionary dictionary];
    [args setObject:[[UserInfo standardUserInfo] user_id] forKey:@"user_id"];
    [args setObject:pages    forKey:@"pages"];
    [args setObject:@"20"    forKey:@"numbers"];
    
    [self startConnection:VOICE_FIND_VOICE args:args];
//
}

- (void)addCommentWithVoice_id:(NSString *)voice_id
                          type:(NSString *)type
                       comment:(NSString *)comment
                      delegate:(id <RequestDelegate>)delegate
{
    self.delegate = delegate;
    
    JROrderlyDictionary *args = [JROrderlyDictionary dictionary];
    [args setObject:[[UserInfo standardUserInfo] user_id] forKey:@"user_id"];
    [args setObject:voice_id    forKey:@"voice_id"];
    [args setObject:type        forKey:@"type"];
    [args setObject:comment     forKey:@"comment"];
    
    [self startConnection:VOICEADDCOMMENT args:args];
//    VOICEADDCOMMENT
}

- (void)voiceCommentListWithVoiceId:(NSString *)voice_id
                              pages:(NSString *)pages
                            numbers:(NSString *)numbers
                               type:(NSString *)type
                           delegate:(id <RequestDelegate>)delegate
{
    self.delegate = delegate;
    
    JROrderlyDictionary *args = [JROrderlyDictionary dictionary];
    [args setObject:voice_id forKey:@"voice_id"];
    [args setObject:pages    forKey:@"pages"];
    [args setObject:numbers  forKey:@"numbers"];
    [args setObject:type     forKey:@"type"];
    
    [self startConnection:VOICECOMMENTLIST args:args];
}

#pragma mark - 创建新播放列表

- (void)creatVoiceListWithTitle:(NSString *)title
                          image:(UIImage *)image
                       delegate:(id <RequestDelegate>)delegate
{
    self.delegate = delegate;
    // MD5加密
    
    NSString *uname = [[UserInfo standardUserInfo] user_id];
    
	NSMutableString *args = [NSMutableString stringWithFormat:@"api_user=ios_280&from=ios&playlist_name=%@&user_id=%@", title,uname];
    NSString *md5Str      = [[Custom MD5:[NSString stringWithFormat:@"%@%@%@",PrivateKey, args, PrivateKey]] lowercaseString];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:@"ios_280" forKey:@"api_user"];
    [params setObject:@"ios"     forKey:@"from"];
    [params setObject:uname      forKey:@"user_id"];
    [params setObject:title      forKey:@"playlist_name"];
    [params setObject:md5Str     forKey:@"sign"];
    
    NSString *aurl = [NSString stringWithFormat:@"%@%@", OutNetAddress, VOICECLASSADD];
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
    [body appendFormat:@"Content-Disposition: form-data; name=\"images\"; filename=\"user_header.png\"\r\n"];
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


#pragma mark - 音频分类列表API

- (void)voiceClassList:(NSString *)uname delegate:(id <RequestDelegate>)delegate
{
    self.delegate = delegate;
    
    JROrderlyDictionary *args = [JROrderlyDictionary dictionary];
    [args setObject:uname forKey:@"user_id"];
    [self startConnection:VOICECLASSLIST args:args];
}
#pragma mark - 声音播放列表

- (void)audioPlayList:(NSString *)listId
             fromPage:(NSInteger)fromPage
          pageNumbers:(NSInteger)pageNumbers
             delegate:(id <RequestDelegate>)delegate
{
    self.delegate = delegate;
    
    JROrderlyDictionary *args = [JROrderlyDictionary dictionary];
    [args setObject:[NSString stringWithFormat:@"%@",listId]      forKey:@"playlist_id"];
    [args setObject:[NSString stringWithFormat:@"%d",fromPage]    forKey:@"pages"];
    [args setObject:[NSString stringWithFormat:@"%d",pageNumbers] forKey:@"numbers"];
    [self startConnection:VOICEPLAYLIST args:args];
}

#pragma mark - 添加播放列表

- (void)addPlayList:(NSString *)voice_id
         playlistId:(NSString *)playlist_id
           delegate:(id <RequestDelegate>)delegate
{
    self.delegate = delegate;
    
    JROrderlyDictionary *args = [JROrderlyDictionary dictionary];
    
    [args setObject:voice_id forKey:@"voice_id"];
    [args setObject:playlist_id forKey:@"playlist_id"];
    [self startConnection:ADDPLAYLIST args:args];
}

#pragma mark - 转发

- (void)transpondAudio:(NSString *)voice_id
                  type:(NSString *)type
              group_id:(NSString *)group_id
              delegate:(id <RequestDelegate>)delegate
{
    if ([voice_id isEqualToString:@""])
    {
        [MTool showAlertViewWithMessage:@"打不到音频文件"];
        return;
    }
    
    self.delegate = delegate;
    
    JROrderlyDictionary *args = [JROrderlyDictionary dictionary];
    
    [args setObject:voice_id forKey:@"voice_id"];
    [args setObject:type forKey:@"type"];
    [args setObject:group_id forKey:@"group_id"];
    [args setObject:[[UserInfo standardUserInfo] user_id] forKey:@"user_id"];
    [self startConnection:VOICETRANSPOND args:args];
}

#pragma mark - 取消收藏

- (void)unFavoritesAudio:(NSString *)voice_id delegate:(id <RequestDelegate>)delegate
{
    self.delegate = delegate;
    
    JROrderlyDictionary *args = [JROrderlyDictionary dictionary];
    
    [args setObject:voice_id forKey:@"voice_id"];
    [args setObject:[[UserInfo standardUserInfo] user_id] forKey:@"user_id"];
    [self startConnection:UNLIKEVOICE args:args];
//
}

#pragma mark - 收藏

- (void)favoritesAudio:(NSString *)voice_id delegate:(id <RequestDelegate>)delegate
{
    self.delegate = delegate;
    
    JROrderlyDictionary *args = [JROrderlyDictionary dictionary];
    
    [args setObject:voice_id forKey:@"voice_id"];
    [args setObject:[[UserInfo standardUserInfo] user_id] forKey:@"user_id"];
    [self startConnection:LIKEVOICE args:args];
}

- (void)snedAudioWithTitle:(NSString *)title
                      city:(NSString *)city
                  group_id:(NSString *)group_id
                 is_public:(NSString *)is_public
                 voice_tag:(NSString *)voice_tag
                imageArray:(NSMutableArray *)imageArray
                 voicePath:(NSString *)voicePath
                  delegate:(id <RequestDelegate>)_delegate
{
    self.delegate = _delegate;
    
    NSData *voiceData = [NSData dataWithContentsOfFile:voicePath];
    
    NSString *voice_length = [NSString stringWithFormat:@"%i",voiceData.length];
    NSString *voice_name   = title;
    // MD5加密
    NSString *user_id = [[UserInfo standardUserInfo] user_id];
	NSMutableString *args = [NSMutableString stringWithFormat:@"api_user=ios_280&city=%@&from=ios&group_id=%@&is_public=%@&user_id=%@&voice_length=%@&voice_name=%@",city,group_id,is_public,user_id,voice_length,voice_name];
    if ([group_id isEqualToString:@""])
    {
        args = [NSMutableString stringWithFormat:@"api_user=ios_280&city=%@&from=ios&is_public=%@&user_id=%@&voice_length=%@&voice_name=%@",city,is_public,user_id,voice_length,voice_name];
    }
    NSString *md5Str      = [[Custom MD5:[NSString stringWithFormat:@"%@%@%@",PrivateKey, args, PrivateKey]] lowercaseString];
    
    NSLog(@"%@", args);
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:@"ios_280"    forKey:@"api_user"];
    [params setObject:@"ios"        forKey:@"from"];
    [params setObject:user_id       forKey:@"user_id"];
    [params setObject:voice_name    forKey:@"voice_name"];
    [params setObject:city          forKey:@"city"];
    [params setObject:voice_length  forKey:@"voice_length"];
    [params setObject:is_public     forKey:@"is_public"];
    [params setObject:group_id      forKey:@"group_id"];
    [params setObject:md5Str        forKey:@"sign"];
    
    NSString *aurl = [NSString stringWithFormat:@"%@%@", OutNetAddress, PostAudio];
    
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
        if ([[params valueForKey:key] isEqualToString:@""] || ![params valueForKey:key])
        {
            continue;
        }
        [body appendFormat:@"%@\r\n",MPboundary];
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
        [body appendFormat:@"%@\r\n",[params objectForKey:key]];
    }
    
    //添加分界线，换行
    NSMutableData *requestData = [NSMutableData data];
    [requestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    for (NSInteger i = 0; i < [imageArray count]; i ++)
    {
        NSMutableString *string = [NSMutableString string];
        
        UIImage *image = [imageArray objectAtIndex:i];
        
        [string appendFormat:@"%@\r\n",MPboundary];
        [string appendFormat:@"%@\r\n",MPboundary];
        [string appendFormat:@"Content-Disposition: form-data; name=\"file[%i]\"; filename=\"pic.png\"\r\n", i];
        [string appendFormat:@"Content-Type: image/png\r\n\r\n"];
        [requestData appendData:[string dataUsingEncoding:NSUTF8StringEncoding]];
        [requestData appendData:UIImagePNGRepresentation(image)];
    }
    
    NSMutableString *string = [NSMutableString string];
    
    [string appendFormat:@"%@\r\n",MPboundary];
    [string appendFormat:@"%@\r\n",MPboundary];
    [string appendFormat:@"Content-Disposition: form-data; name=\"voice\"; filename=\"record.m4a\"\r\n"];
    [string appendFormat:@"Content-Type: music/m4a\r\n\r\n"];
    [requestData appendData:[string dataUsingEncoding:NSUTF8StringEncoding]];
    [requestData appendData:voiceData];
    
    [requestData appendData:[[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary]
                             dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *content = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%ld", (unsigned long)[requestData length]] forHTTPHeaderField:@"Content-Length"];
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
