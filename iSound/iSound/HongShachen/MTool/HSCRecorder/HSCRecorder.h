//
//  HSCRecorder.h
//  AVAudioRecorderDemo
//
//  Created by  Jumax.R on 13-9-30.
//  Copyright (c) 2013年  Jumax.R. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#define kRecordPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"recordTest.aac"]

enum
{
    ENC_AAC  = 1,
    ENC_ALAC = 2,
    ENC_IMA4 = 3,
    ENC_ILBC = 4,
    ENC_ULAW = 5,
    ENC_PCM  = 6,
    ENC_M4A  = 7
} encodingTypes;

@class HSCRecorder;

@protocol HSCRecorderDelegate <NSObject>

@optional
- (void)hscRecorderDidStartRecord:(HSCRecorder *)hscRecorder;
- (void)hscRecorderDidRecording:(HSCRecorder *)hscRecorder power:(CGFloat)power peak:(CGFloat)peak;
- (void)hscRecorderDidPauseRecord:(HSCRecorder *)hscRecorder;
- (void)hscRecorderDidStopRecord:(HSCRecorder *)hscRecorder;

@end

@interface HSCRecorder : NSObject
{
    AVAudioPlayer *audioPlayer;
    NSTimer       *recordTimer;
    double lowPassResults;
    int recordEncoding;

}


@property (nonatomic)     CGFloat recordTimeCount;
@property (nonatomic, assign) id <HSCRecorderDelegate> delegate;
@property (nonatomic, retain) AVAudioRecorder *audioRecorder;

+ (id)standardHSCRecorder;

- (IBAction) startRecording;
- (IBAction) stopRecording;
- (IBAction) continueRecording;
- (IBAction) pauseRecording;

- (IBAction) playRecording;
- (IBAction) stopPlaying;

@end
