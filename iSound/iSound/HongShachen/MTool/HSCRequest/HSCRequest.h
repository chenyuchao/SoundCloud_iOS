//
//  RequestCyc.h
//  iSound
//
//  Created by Jumax.R on 13-10-31.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Request (HSCRequest)

- (void)voiceTranspondUserListvoice_id:(NSString *)voice_id
                                 pages:(NSString *)pages
                               numbers:(NSString *)numbers
                               user_id:(NSString *)user_id
                          withDelegate:(id <RequestDelegate>)delegate;

- (void)likeuserlikevoice_id:(NSString *)voice_id
                        page:(NSString *)page
                    per_page:(NSString *)per_page
                     user_id:(NSString *)user_id
                withDelegate:(id <RequestDelegate>)delegate;

- (void)findPasswordWithUserName:(NSString *)user_name
                    withDelegate:(id <RequestDelegate>)delegate;

- (void)findPasswordWithYanzhengma:(NSString *)yanzhengma
                          username:(NSString *)username
                      withDelegate:(id <RequestDelegate>)delegate;

- (void)resetPasswordWithUsernamed:(NSString *)user_name
                          password:(NSString *)password
                      withDelegate:(id <RequestDelegate>)delegate;

- (void)groupLogoutGroupId:(NSString *)group_id
                  delegate:(id <RequestDelegate>)delegate;

- (void)searchGroupWithKeyworld:(NSString *)keyWorld
                          pages:(NSString *)pages
                        numbers:(NSString *)numbers
                       delegate:(id <RequestDelegate>)delegate;

- (void)searchAudioWithKeyworld:(NSString *)keyWorld
                          pages:(NSString *)pages
                        numbers:(NSString *)numbers
                       delegate:(id <RequestDelegate>)delegate;

- (void)searchUserWithKeyworld:(NSString *)keyWorld
                         pages:(NSString *)pages
                       numbers:(NSString *)numbers
                      delegate:(id <RequestDelegate>)delegate;

- (void)groupWithKeyworld:(NSString *)keyworld
                     Page:(NSString *)page
                 per_page:(NSString *)per_page
             Withdelegate:(id <RequestDelegate>)delegate;

- (void)applyGroupWithUserid:(NSString *)userid
                     groupid:(NSString *)groupid
                    delegate:(id <RequestDelegate>)delegate;

- (void)deleteGroupWithUserid:(NSString *)userid
                      groupid:(NSString *)groupid
                     delegate:(id <RequestDelegate>)delegate;

- (void)groupDetailWithGroup_id:(NSString *)group_id
                   Withdelegate:(id <RequestDelegate>)delegate;

- (void)groupLikePage:(NSString *)page
             per_page:(NSString *)per_page
         Withdelegate:(id <RequestDelegate>)delegate;

- (void)userLikePage:(NSString *)page
            per_page:(NSString *)per_page
        Withdelegate:(id <RequestDelegate>)delegate;

- (void)audioLikePage:(NSString *)page
             per_page:(NSString *)per_page
         Withdelegate:(id <RequestDelegate>)delegate;

- (void)checkVersionWithdelegate:(id <RequestDelegate>)delegate;

- (void)userFeedback:(NSString *)content delegate:(id <RequestDelegate>)delegate;

- (void)findVoiceWithPages:(NSString *)pages
                   numbers:(NSString *)numbers
                  delegate:(id <RequestDelegate>)delegate;

- (void)addCommentWithVoice_id:(NSString *)voice_id
                          type:(NSString *)type
                       comment:(NSString *)comment
                      delegate:(id <RequestDelegate>)delegate;

- (void)voiceCommentListWithVoiceId:(NSString *)voice_id
                              pages:(NSString *)pages
                            numbers:(NSString *)numbers
                               type:(NSString *)type
                           delegate:(id <RequestDelegate>)delegate;

- (void)creatVoiceListWithTitle:(NSString *)title
                          image:(UIImage *)image
                       delegate:(id <RequestDelegate>)delegate;

- (void)voiceClassList:(NSString *)uname delegate:(id <RequestDelegate>)delegate;

- (void)audioPlayList:(NSString *)listId
             fromPage:(NSInteger)fromPage
          pageNumbers:(NSInteger)pageNumbers
             delegate:(id <RequestDelegate>)delegate;

- (void)addPlayList:(NSString *)voice_id
         playlistId:(NSString *)playlist_id
           delegate:(id <RequestDelegate>)delegate;

- (void)transpondAudio:(NSString *)voice_id
                  type:(NSString *)type
              group_id:(NSString *)group_id
              delegate:(id <RequestDelegate>)delegate;

- (void)unFavoritesAudio:(NSString *)voice_id delegate:(id <RequestDelegate>)delegate;

- (void)favoritesAudio:(NSString *)voice_id delegate:(id <RequestDelegate>)delegate;

- (void)snedAudioWithTitle:(NSString *)title
                      city:(NSString *)city
                  group_id:(NSString *)group_id
                 is_public:(NSString *)is_public
                 voice_tag:(NSString *)voice_tag
                imageArray:(NSMutableArray *)imageArray
                 voicePath:(NSString *)voicePath
                  delegate:(id <RequestDelegate>)_delegate;

@end


