//
//  SoundRecord.h
//  iSound
//
//  Created by MaoHeng Zhang on 13-10-4.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordDraw.h"
#import "HSCMoveView.h"
#import "SoundSaved.h"

#define kAlertCloseTag 8764


@interface SoundRecord : UIViewController<  RecordDrawDelegate,
                                            HSCMoveViewDelegate,
                                            UINavigationControllerDelegate,
                                            AVAudioPlayerDelegate,
                                            UIAlertViewDelegate,SoundSavedDelegate>
{
    RecordDraw  *recordView;
    IBOutlet UILabel *timeLabel;
    IBOutlet UILabel *shitingLabel;
    IBOutlet UILabel *chongluLabel;
    IBOutlet UIButton *chongluBtn;
    IBOutlet UIButton *playBtn;
    IBOutlet UIButton *cancelClip;
    IBOutlet UIButton *sureClip;
    IBOutlet UIButton *recordBtn;
    IBOutlet UILabel  *saveLabel;
    IBOutlet UIButton *saveBtn;
    
    BOOL isClip;
    BOOL isReplay;
    
    NSTimer *playTimer;
    NSTimer *recordTimer;
    
    NSInteger playTimeCount;
    
    NSInteger timerCount;
    NSInteger fromTime;
    NSInteger toTime;
    
    NSMutableArray *m4aArray;
    
    IBOutlet UILabel *recordLabel;
    IBOutlet UIImageView *bgView;
    IBOutlet UIView      *playView;
    
    IBOutlet UIView *leftBGView;
    IBOutlet HSCMoveView *leftView;
    
    IBOutlet UIView *rightBGView;
    IBOutlet HSCMoveView *rightView;
    
    AVAudioPlayer *audioPlayer;
    
    CGRect initleftBGViewRect;
    CGRect initleftViewRect;
    CGRect initrightBGViewRect;
    CGRect initrightViewRect;
}

@property (nonatomic, copy) NSString *m4aArrayPath;
@property (nonatomic, copy) NSString *kM4APath;

//@property (nonatomic, retain) 

@end
