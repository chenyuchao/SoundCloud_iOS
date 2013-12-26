//
//  HSCRecorder.m
//  AVAudioRecorderDemo
//
//  Created by  Jumax.R on 13-9-30.
//  Copyright (c) 2013年  Jumax.R. All rights reserved.
//

#import "HSCRecorder.h"

#define ktimescale 0.1

static HSCRecorder *hscRecorder = nil;

@implementation HSCRecorder
@synthesize audioRecorder;
@synthesize delegate;
@synthesize recordTimeCount;

+ (id)standardHSCRecorder
{
    if (!hscRecorder)
    {
        hscRecorder = [[HSCRecorder alloc] init];
    }
    return hscRecorder;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        recordEncoding = ENC_AAC;
        
        recordTimer = [NSTimer scheduledTimerWithTimeInterval:ktimescale
                                                       target:self
                                                     selector:@selector(recordUpdate)
                                                     userInfo:nil
                                                      repeats:YES];
        [self stopTimer];
    }
    
    return self;
}

#pragma mark - timer

- (void)startTimer
{
    [recordTimer setFireDate:[NSDate distantPast]];
}

- (void)stopTimer
{
    [recordTimer setFireDate:[NSDate distantFuture]];
}

- (void)recordUpdate
{
    [audioRecorder updateMeters];
    
    float power = -[audioRecorder averagePowerForChannel:0];//录音峰值
    float peak  = [audioRecorder peakPowerForChannel:0];
    
    const double ALPHA = 0.05;
	double peakPowerForChannel = pow(10, (0.05 * [audioRecorder peakPowerForChannel:0]));
    
	lowPassResults = ALPHA * peakPowerForChannel + (1.0 - ALPHA) * lowPassResults;//打火机吹风峰值
    
    //    NSLog(@"lowPassResults = %f",lowPassResults);
//        NSLog(@"power = %f",power);
    //    NSLog(@"peak  = %f",peak);
    //    NSLog(@"---------------");
//    NSLog(@"power = %f",power);
    recordTimeCount += 0.1;
    
    if ([delegate respondsToSelector:@selector(hscRecorderDidRecording:power:peak:)])
    {
//        [delegate hscRecorderDidRecording:self power:power/3 peak:peak];
        [delegate hscRecorderDidRecording:self power:(60 - power)/2 peak:peak];
    }
}

#pragma mark -

-(IBAction)startRecording
{
    [self startTimer];
    // Init audio with record capability
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
    
    //    NSMutableDictionary *recordSetting = [[[NSMutableDictionary alloc]init] autorelease];
    //    //设置录音格式  AVFormatIDKey==kAudioFormatLinearPCM
    //    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    //    //设置录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
    //    [recordSetting setValue:[NSNumber numberWithFloat:44100] forKey:AVSampleRateKey];
    //    //录音通道数  1 或 2
    //    [recordSetting setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    //    //线性采样位数  8、16、24、32
    //    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    //    //录音的质量
    //    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
    
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    if(recordEncoding == ENC_PCM)
    {
        [recordSetting setObject:[NSNumber numberWithInt: kAudioFormatLinearPCM] forKey: AVFormatIDKey];
        [recordSetting setObject:[NSNumber numberWithFloat:44100.0] forKey: AVSampleRateKey];
        [recordSetting setObject:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
        [recordSetting setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
        [recordSetting setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
        [recordSetting setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    }
    else
    {
        NSNumber *formatObject;
        
        switch (recordEncoding)
        {
            case (ENC_AAC):
                formatObject = [NSNumber numberWithInt: kAudioFormatMPEG4AAC];
                break;
            case (ENC_ALAC):
                formatObject = [NSNumber numberWithInt: kAudioFormatAppleLossless];
                break;
            case (ENC_IMA4):
                formatObject = [NSNumber numberWithInt: kAudioFormatAppleIMA4];
                break;
            case (ENC_ILBC):
                formatObject = [NSNumber numberWithInt: kAudioFormatiLBC];
                break;
            case (ENC_ULAW):
                formatObject = [NSNumber numberWithInt: kAudioFormatULaw];
                break;
            default:
                formatObject = [NSNumber numberWithInt: kAudioFormatAppleIMA4];
        }
        
        [recordSetting setObject:formatObject forKey: AVFormatIDKey];
        [recordSetting setObject:[NSNumber numberWithFloat:44100.0] forKey: AVSampleRateKey];
        [recordSetting setObject:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
        [recordSetting setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
        [recordSetting setObject:[NSNumber numberWithInt: AVAudioQualityHigh] forKey: AVEncoderAudioQualityKey];
    }

    NSURL *url = [NSURL fileURLWithPath:kRecordPath];
    
    NSError *error = nil;
    
    audioRecorder = [[ AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:&error];
    //    [audioRecorder release];
    //    audioRecorder = nil;
    //    if (!audioRecorder)
    //    {
    //
    //    }
    
    if ([audioRecorder prepareToRecord] == YES)
    {
        audioRecorder.meteringEnabled = YES;
        
        recordTimeCount = 0.0f;
        
        [audioRecorder record];
        
        if ([delegate respondsToSelector:@selector(hscRecorderDidStartRecord:)])
        {
            [delegate hscRecorderDidStartRecord:self];
        }
    }
    else
    {
        int errorCode = CFSwapInt32HostToBig ([error code]);
        NSLog(@"Error: %@ [%4.4s])" , [error localizedDescription], (char*)&errorCode);
    }
    
//    [recordSetting release];
    NSLog(@"recording");
}

- (IBAction)continueRecording
{
    [self startTimer];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];

    [audioRecorder record];
    
    if ([delegate respondsToSelector:@selector(hscRecorderDidStartRecord:)])
    {
        [delegate hscRecorderDidStartRecord:self];
    }
}

- (IBAction)pauseRecording
{
    [audioRecorder pause];
    [self stopTimer];
    
    if ([delegate respondsToSelector:@selector(hscRecorderDidPauseRecord:)])
    {
        [delegate hscRecorderDidPauseRecord:self];
    }
}

- (IBAction)stopRecording
{
    NSLog(@"stopRecording");
    [audioRecorder stop];
    [self stopTimer];
    recordTimeCount = 0.0f;
    NSLog(@"stopped");
    
    if ([delegate respondsToSelector:@selector(hscRecorderDidStopRecord:)])
    {
        [delegate hscRecorderDidStopRecord:self];
    }
}

-(IBAction) playRecording
{
    NSLog(@"playRecording");
    // Init audio with playback capability
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/recordTest.caf", [[NSBundle mainBundle] resourcePath]]];
    NSError *error;
    
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    audioPlayer.numberOfLoops = 0;
    [audioPlayer play];
    NSLog(@"playing");
}

-(IBAction) stopPlaying
{
    NSLog(@"stopPlaying");
    [audioPlayer stop];
    NSLog(@"stopped");
}

//- (void)dealloc
//{
//    [audioPlayer release];
//    [audioRecorder release];
//    [super dealloc];
//}

@end
