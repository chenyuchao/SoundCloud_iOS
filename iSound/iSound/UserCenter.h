//
//  UserCenter.h
//  iSound
//
//  Created by Jumax.R on 13-9-27.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SoundCell.h"

@interface UserCenter : UITableViewController < JRTouchViewDelegate,
                                                JRImageViewDelegate,
                                                UIScrollViewDelegate,
                                                DownloaderDelegate,
                                                RequestDelegate,
                                                UINavigationControllerDelegate,
                                                UIAlertViewDelegate,
                                                UIActionSheetDelegate > {
    
    IBOutlet UIImageView *headView;
    IBOutlet UILabel *fans;
    IBOutlet UILabel *follow;
    IBOutlet UILabel *sound;
    IBOutlet UILabel *name;
    IBOutlet UILabel *userSign;
    IBOutlet UIButton *returnButton;
    IBOutlet UIButton *iPlayList;
    IBOutlet UIButton *iMessage;
    IBOutlet UIButton *iLike;
    IBOutlet UIButton *iGroup;
    IBOutlet UIButton *playing;
    IBOutlet UIView *headerTableView;
    IBOutlet UIView *backGround;
    IBOutlet UIButton *gzButton;
    
    NSInteger lastIndex;
    
    UserInfo *userinfo;
}

@property (nonatomic, retain) NSMutableArray *m4aAudioArray;
@property (nonatomic, retain) NSArray *mainlist;
@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *userhead;
@property (nonatomic) BOOL displayReturn;


@end