//
//  SoundDetail.h
//  iSound
//
//  Created by Jumax.R on 13-11-5.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "AudioPropress.h"
#import "PreViewController.h"
#import "UMSocialControllerService.h"//友盟
#import "MoviePlayer.h"
#import "PlayerList.h"
#import "CommentView.h"
#import "UserGroup.h"
#import "TestViewController.h"
#import "Likelist.h"

#define kVoiceInfoTag 235
#define kVoiceTranspond 2435
#define kUNLikeAudioTag 8776
#define kLikeAudioTag 543
#define kAddPlaylist 876
#define kGuanzhuTag 7823
#define kGuanzhuCancle 341782
//友盟
@interface SoundDetail : UIViewController<  AudioPropressDelegate,
                                            RequestDelegate,
                                            DownloaderDelegate,
                                            JRImageViewDelegate,
                                            UMSocialUIDelegate,
                                            MoviePlayerDelegate,
                                            PlayerListDelegate,
                                            CommentViewDelegate,
                                            UserGroupDelegate,
                                            UIActionSheetDelegate>
{
    UIImageView *bulrView;
    IBOutlet UIView *burlBackground;
    IBOutlet JRImageView *headerView;
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *bodyLabel;
    IBOutlet UILabel *dateLabel;
    IBOutlet UILabel *label0;
    IBOutlet UILabel *label1;
    IBOutlet UILabel *label2;
    IBOutlet UILabel *label3;
    IBOutlet UIScrollView *mainScrollView;
    IBOutlet UIView *mainView;
    IBOutlet UILabel *timeLabel;
    IBOutlet UIButton *playBtn;
    IBOutlet UIButton *favBtn;
    IBOutlet UIView   *playBGView;
    IBOutlet UIButton *gobackBtn;
    IBOutlet UIButton *goforwardBtn;
    IBOutlet UIButton *zfBtn;
    IBOutlet UIButton *guanzhuBtn;
    IBOutlet UIView *detailView;
    IBOutlet UILabel *ylikeLabel;
    IBOutlet UILabel *yzhuanfaLabel;
    IBOutlet UIButton *shardBtn;
    IBOutlet UIButton *lBtn;
    
    IBOutlet AudioPropress *propressView;
    MoviePlayer *moviePlayer;
    double lastPlaytime;
    NSTimer *updateTimer;
    NSDateFormatter *dateFormatter;
}

+ (id)standardSoundDetail;

@property (nonatomic, retain) NSArray *mainlist;
@property (nonatomic, assign) BOOL playing;
@property (nonatomic, copy) NSMutableDictionary *dataDict;
@property (nonatomic, copy) NSString *group_id;
@property (nonatomic, retain) NSDictionary *audioInfo;
@property (nonatomic) BOOL isGroup;

- (void)playAudioAtIndex:(int)index;

@end
