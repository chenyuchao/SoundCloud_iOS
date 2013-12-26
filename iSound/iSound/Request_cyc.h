//
//  RequestCyc.h
//  iSound
//
//  Created by Jumax.R on 13-10-31.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Request (ChenYuChaoRequest)

/*  用户登录
    参数1：用户名
    参数2：密码
    参数3：委托对象
*/

- (void)userlogin:(NSString *)uname
         password:(NSString *)password
         delegate:(id <RequestDelegate>)delegate;

/*  用户注册
    参数1：用户名
    参数2：密码
    参数3：委托对象
*/

- (void)userRegister:(NSString *)uname
            password:(NSString *)password
            delegate:(id <RequestDelegate>)delegate;

/*  获取标签列表
    参数1：委托对象
*/

- (void)getTagListWithDelegate:(id <RequestDelegate>)delegate;

/*  获取城市列表
    参数1：委托对象
*/

- (void)getCityListWithDelegate:(id <RequestDelegate>)delegate;

/*  填写基本信息（首次登录后，用户信息为空的时候调用）
    参数1：用户名
    参数2：昵称
    参数3：签名
    参数4：性别
    参数5：省份
    参数6：城市
    参数7：委托对象
*/

- (void)editBaseInfo:(NSString *)uname
            nickname:(NSString *)nickname
             profile:(NSString *)profile
                 sex:(NSString *)sex
            province:(NSString *)province
                city:(NSString *)city
            delegate:(id <RequestDelegate>)delegate;

/*  修改基本信息
    参数1：用户名
    参数2：昵称
    参数3：签名
    参数4：性别
    参数5：省份
    参数6：城市
    参数7：委托对象
*/

- (void)updateBaseInfo:(NSString *)uname
              nickname:(NSString *)nickname
               profile:(NSString *)profile
                   sex:(NSString *)sex
              province:(NSString *)province
                  city:(NSString *)city
              delegate:(id <RequestDelegate>)delegate;

/*  为用户添加标签
    参数1：用户名
    参数2：标签ID
    参数3：委托对象
*/

- (void)addTagForUser:(NSString *)uname
                tagId:(NSString *)tagId
              isFirst:(BOOL)isFirst
             delegate:(id <RequestDelegate>)delegate;

/*  获取推荐关注
    参数1：页数
    参数2：委托对象
*/

- (void)getRecommendPeople:(NSInteger)page
                  delegate:(id <RequestDelegate>)delegate;

/*
    取得个人中心数据
    参数1：用户id
    参数2：页数
    参数3：每页条数
    参数4：委托对象
*/

- (void)getUserCenterData:(NSString *)uname
                     page:(int)page
                 per_page:(int)number
                 delegate:(id <RequestDelegate>)delegate;

/*
    取得其他用户个人中心数据
    参数1：用户id
    参数2：其他用户id
    参数3：页数
    参数4：每页条数
    参数5：委托对象
*/

- (void)getOtherUserCenterData:(NSString *)uname
                    otherUname:(NSString *)oUname
                          page:(int)page
                      per_page:(int)number
                      delegate:(id <RequestDelegate>)delegate;

/*
    取得个人资料
    参数1：用户id
    参数2：委托对象
*/

- (void)getUserDescription:(NSString *)uname
                  delegate:(id <RequestDelegate>)delegate;

/*
    上传头像
    参数1：用户id
    参数2：图片对象
    参数3：委托对象
*/

- (void)uploadHeader:(NSString *)uname
               image:(UIImage *)image
            delegate:(id <RequestDelegate>)delegate;

/*
    首页声音列表
    参数1：用户id
    参数2：委托对象
*/

- (void)getSoundList:(NSString *)uname
               pages:(int)pages
            delegate:(id <RequestDelegate>)delegate;

/*
    关注某人
    参数1：用户id
    参数2：被关注人的id
    参数3：委托对象
 */

- (void)addFollow:(NSString *)uname
         targetId:(NSString *)targetId
            delegate:(id <RequestDelegate>)delegate;

/*
    取消关注某人
    参数1：用户id
    参数2：被关注人的id
    参数3：委托对象
 */

- (void)cancelFollow:(NSString *)uname
            targetId:(NSString *)targetId
            delegate:(id <RequestDelegate>)delegate;

/*
    取得音频详情
    参数1：用户id
    参数2：声音id
    参数3：音频类型
    参数4：委托对象
*/

- (void)getVoiceInfo:(NSString *)uname
             voiceId:(NSString *)vid
                type:(int)type
            delegate:(id<RequestDelegate>)delegate;

/*
    收藏列表
    参数1：用户id
    参数2：页数
    参数3：每页条数
    参数4：委托对象
 */

- (void)getLikeList:(NSString *)uname
               page:(int)page
           per_page:(int)number
           delegate:(id<RequestDelegate>)delegate;

/*
    关注列表
    参数1：用户id
    参数2：页数
    参数3：每页条数
    参数4：委托对象
*/

- (void)getFollowList:(NSString *)uname
                 page:(int)page
             per_page:(int)number
             delegate:(id<RequestDelegate>)delegate;

/*
    粉丝列表
    参数1：用户id
    参数2：页数
    参数3：每页条数
    参数4：委托对象
 */

- (void)getFansList:(NSString *)uname
               page:(int)page
           per_page:(int)number
           delegate:(id<RequestDelegate>)delegate;

/*
    声音时间轴
    参数1：用户id
    参数2：页数
    参数3：每页条数
    参数4：委托对象
 */

- (void)getTimeLineList:(NSString *)uname
                   page:(int)page
               per_page:(int)number
               delegate:(id<RequestDelegate>)delegate;

/*
    从播放列表中删除声音
    参数1：音频id
    参数2：播放列表id
    参数3：委托对象
 */

- (void)delAudioFromPlayerlist:(NSString *)vid
                   playlist_id:(NSString *)plistId
                      delegate:(id<RequestDelegate>)delegate;

/*
     删除音频播放列表
     参数1：用户id
     参数2：播放列表id
     参数3：委托对象
*/

- (void)delAudioPlayerlist:(NSString *)uname
               playlist_id:(NSString *)plistId
                  delegate:(id<RequestDelegate>)delegate;

/*
     获取群组列表
     参数1：用户id
     参数2：页数
     参数3：每页条数
     参数4：委托对象
*/

- (void)getGroupList:(NSString *)uname
               pages:(int)page
              number:(int)number
            delegate:(id<RequestDelegate>)delegate;

/*
     添加群组
     参数1：用户id
     参数2：群组名称
     参数3：群组简介
     参数4：群组头像
     参数5：委托对象
 */

- (void)addGroupList:(NSString *)uname
                name:(NSString *)name
                sign:(NSString *)sign
               image:(UIImage *)image
            delegate:(id<RequestDelegate>)delegate;

/*
     获取群组成员
     参数1：用户id
     参数2：群组id
     参数3：委托对象
 */

- (void)getGroupMember:(NSString *)uname
               groupId:(NSString *)gid
              delegate:(id<RequestDelegate>)delegate;

/*
     邀请用户加入群组
     参数1：用户id
     参数2：群组id
     参数3：被邀请人id
     参数4：委托对象
 */

- (void)inviteUserToGroup:(NSString *)uname
                  groupId:(NSString *)gid
                 inviteId:(NSString *)inid
                 delegate:(id<RequestDelegate>)delegate;

/*
    删除音频
    参数1：用户id
    参数2：群组id
    参数3：被邀请人id
    参数4：委托对象
 */

- (void)deleteUsesrAudio:(NSString *)uname
                  audoId:(NSString *)aid
                delegate:(id<RequestDelegate>)delegate;

/*
    获取群组音频列表
    参数1：群组id
    参数2：页数
    参数3：分页数量
    参数4：委托对象
 */

- (void)getGroupAudioList:(NSString *)group_id
                    pages:(int)page
                  numbers:(int)number
                 delegate:(id<RequestDelegate>)delegate;

/*
    获取时间轴音频列表
    参数1：用户id
    参数2：年份
    参数3：月份
    参数4：城市
    参数5：页数
    参数6：分页数量
    参数7：委托对象
*/

- (void)getTimeLineAudioList:(NSString *)uname
                        year:(NSString *)year
                       month:(NSString *)month
                        city:(NSString *)city
                       pages:(int)page
                     numbers:(int)number
                    delegate:(id<RequestDelegate>)delegate;

/*  获取消息列表
    参数1：用户名
    参数2：委托对象
*/

- (void)getMessageList:(NSString *)uname
              delegate:(id <RequestDelegate>)delegate;

/*  审批申请入群
    参数1：用户名
    参数2：群组id
    参数3：申请者id
    参数4：是否同意
    参数5：委托对象
*/

- (void)reviewComingGroup:(NSString *)uname
                  groupId:(NSString *)gid
                  applyId:(NSString *)aid
                    agree:(int)state
                 delegate:(id <RequestDelegate>)delegate;

/*  同意加入群组
    参数1：用户名
    参数2：群组id
    参数3：委托对象
*/

- (void)agreeToGroup:(NSString *)uname
             groupId:(NSString *)gid
            delegate:(id <RequestDelegate>)delegate;

/*  删除群组音频
    参数1：用户名
    参数2：群组id
    参数3：声音id
    参数4：委托对象
*/

- (void)delGroupAudio:(NSString *)uname
              groupId:(NSString *)gid
              audioId:(NSString *)aid
             delegate:(id <RequestDelegate>)delegate;

/*  同步微博用户
    参数1：用户的好友 用','逗号隔开
    参数4：委托对象
*/

- (void)synchronizeWeiboUsers:(NSString *)synchronize_users
                     delegate:(id <RequestDelegate>)delegate;

/*  第三方登录
    参数1：用户名
    参数2：平台来源 1 = 新浪， 2 = 腾讯
    参数3：委托对象
*/

- (void)otherLogin:(NSString *)uname
          platform:(NSString *)platform
          delegate:(id <RequestDelegate>)delegate;

/*  退出登录
    参数1：用户名
    参数2：委托对象
 */

- (void)logout:(NSString *)uname
      delegate:(id <RequestDelegate>)delegate;

@end


#define NWUserLogin              @"user/login"
#define NWUserRegister           @"user/register"
#define NWTagList                @"common/tag_list"
#define NWCityList               @"common/areas"
#define NWEditInfo               @"user/login_first"
#define NWUpdateInfo             @"user/change_info"
#define NWAddTag                 @"user/add_tag"
#define NWRecommend              @"user/login_three"
#define NWUploadHeader           @"user/change_head_img"
#define NWUserCenterData         @"user/personal_center"
#define NWUserDescription        @"user/view_info"
#define NWSoundList              @"voice/get_follow_voice_list"
#define NWAddFollow              @"follow/follow_add"
#define NWCancelFollow           @"follow/follow_del"
#define NWVoiceInfo              @"voice/voice_info"
#define NWLikeList               @"voice/like_list"
#define NWTimeLineList           @"voice/user_voice_timeline"
#define NWDelAudioFromPlayerList @"voice/del_playlist_voice"
#define NWDelPlayerList          @"voice/del_class_list"
#define NWGroupList              @"group/group_list"
#define NWAddGroup               @"group/add_group"
#define NWGroupMember            @"group/group_user_list"
#define NWAddUserToGroup         @"group/invite_group"
#define NWDeleteAudio            @"voice/del_user_voice"
#define NWGroupAudioList         @"group/group_voice_list"
#define NWTimeLineAudioList      @"voice/voice_timeline_info"
#define NWMessageList            @"common/news_list"
#define NWReviewGroup            @"group/examine_apply"
#define NWAgreeGroup             @"group/pass_invite"

