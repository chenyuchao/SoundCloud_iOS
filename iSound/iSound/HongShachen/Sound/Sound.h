//
//  Sound.h
//  iSound
//
//  Created by Jumax.R on 13-9-27.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignIn.h"
#import "SoundCell.h"
#import "EGORefreshTableHeaderView.h"

#define kSoundListTag 234
#define kFindVoiceTag 4521
#define kGroupListTag 2597
#define kGroupAudioListTag 9527
#define kWorldTag 24387
#define kDEFAULTVALUE -100

NS_ENUM(NSInteger, SOUNDTYPE)
{
    SOUNDTYPE_NOR = 0,
    SOUNDTYPE_LIKE,
    SOUNDTYPE_KEYWORLD
};

@interface Sound : UIViewController <UITableViewDelegate, UITableViewDataSource, RequestDelegate, JRTouchViewDelegate,UIScrollViewDelegate,EGORefreshTableHeaderDelegate>
{
    //下拉视图
    EGORefreshTableHeaderView * _refreshHeaderView;
    //刷新标识，是否正在刷新过程中
    BOOL _reloading;
    
    IBOutlet UIImageView *titleView;
    IBOutlet UITableView *soundTableView;
    IBOutlet UIButton *rightButton;
    IBOutlet UIScrollView *soundScrollView;
    
    NSInteger groupCount;
    
    NSInteger soundType;
    
    NSInteger likeMoreIndex;

    
    UIView *selectView;
}

@property (nonatomic, retain) UIButton *guanzhuButton;

@property (nonatomic, retain) NSMutableArray *mainlist;
@property (nonatomic, retain) NSMutableArray *grouplist;
@property (nonatomic) enum SOUNDTYPE soundAudioType;
@property (nonatomic, copy) NSString *keyWorld;
@property (nonatomic, copy) NSString *groupTitle;
@property (nonatomic, copy) NSString *groupId;

@end
