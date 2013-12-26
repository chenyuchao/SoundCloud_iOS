//
//  RecordDraw.h
//  Bowen
//
//  Created by up72 on 13-9-15.
//  Copyright (c) 2013年 up72. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <QuartzCore/QuartzCore.h>
#import "HSCRecorder.h"

#define kRecordM4A(fileNamed)     [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m4a",fileNamed]]

typedef NS_ENUM(NSInteger, ShowMode)
{
    MinimizeMode,
    MaximizeMode,
    ClipMode
    //    UIButtonTypeCustom = 0,           // no button type
    //    UIButtonTypeRoundedRect,          // rounded rect, flat white button, like in address card
    //
    //    UIButtonTypeDetailDisclosure,
    //    UIButtonTypeInfoLight,
    //    UIButtonTypeInfoDark,
    //    UIButtonTypeContactAdd,
};

@class RecordDraw;

@protocol RecordDrawDelegate <NSObject>

- (void)recordDrawDidRecording:(RecordDraw *)recordDrawView;

@end

@interface RecordDraw : UIView<HSCRecorderDelegate,AVAudioPlayerDelegate>
{
    HSCRecorder *recorder;
    
    NSMutableArray *visibleArray;
    NSMutableArray *allPowerArray;
    NSInteger animationIndex;
    
    NSTimer *timer;
    
    NSInteger fromClipIndex;
    NSInteger clipLength;
}

@property (nonatomic, assign) id <RecordDrawDelegate> delegate;
@property (nonatomic, copy) NSString *recordFilePath;
@property (nonatomic) ShowMode showMode;
@property (nonatomic) CGFloat curPower;
@property (nonatomic) CGFloat recordTimeCount;

- (void)play;
//- (void)stop;

- (void)startRecording;
- (void)stopRecording;

- (void)pauseRecording;
- (void)continueRecording;

- (void)resetData;

- (void)clipAudioFromIndex:(CGFloat)fromIndex toIndex:(CGFloat)toIndex;

- (BOOL)exportAsset:(AVAsset *)avAsset
        fromSeconds:(NSString *)fromSeconds
          toSeconds:(NSString *)toSeconds
         toFilePath:(NSString *)filePath;

@end
