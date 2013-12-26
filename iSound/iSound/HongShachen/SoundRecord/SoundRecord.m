//
//  SoundRecord.m
//  iSound
//
//  Created by MaoHeng Zhang on 13-10-4.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import "SoundRecord.h"

@interface SoundRecord ()

@end

@implementation SoundRecord
@synthesize m4aArrayPath;

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    
    if ([viewController isKindOfClass:([self class])])
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    else
        [self.navigationController setNavigationBarHidden:NO animated:NO];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.delegate = self;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RECORDNOTIFICATION" object:nil];
    
    m4aArray = [[NSMutableArray alloc] initWithContentsOfFile:M4ARECORDPATH];
    
    if (!m4aArray)
    {
        m4aArray = [[NSMutableArray alloc] init];
    }
    
    leftView.delegate = self;
    leftView.userInteractionEnabled = YES;
    leftView.tag = kLeftViewTag;
    
    rightView.delegate = self;
    rightView.userInteractionEnabled = YES;
    rightView.tag = kRightViewTag;
    
    timeLabel.text = @"0:00";
    
    recordTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                   target:self
                                                 selector:@selector(recordTimerUpdate)
                                                 userInfo:self
                                                  repeats:YES];
    
    [recordTimer setFireDate:[NSDate distantFuture]];
    
    
    recordView = [[RecordDraw alloc] initWithFrame:CGRectMake(0,
                                                              timeLabel.frame.origin.y + timeLabel.frame.size.height + 10, 320, 80)];
    recordView.delegate = self;
    [self.view addSubview:recordView];
    [self.view sendSubviewToBack:recordView];
    [self.view sendSubviewToBack:bgView];
    
    initleftBGViewRect  = leftBGView.frame;
    initleftViewRect    = leftView.frame;
    initrightBGViewRect = rightBGView.frame;
    initrightViewRect   = rightView.frame;
    
    leftView.hidden  = YES;
    rightView.hidden = YES;
    timeLabel.hidden = YES;
    
    saveLabel.alpha   = 0.0f;
    saveBtn.alpha     = 0.0f;
    
    [self showWithAlpha:0.0f duration:0.3];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [audioPlayer stop];
}

- (void)playUpdate
{
    CGFloat currentTime = audioPlayer.currentTime;
    if (currentTime >= toTime)
    {
        [audioPlayer stop];
        isReplay = YES;
        currentTime = toTime;
    }
    
    CGFloat width = (rightView.frame.origin.x + rightView.frame.size.width - leftView.frame.origin.x)/(toTime - fromTime);
    
    CGRect frame   = playView.frame;
    frame.origin.x = leftView.frame.origin.x;
    frame.size.width = width * ((currentTime - fromTime));
    
    if (leftView.frame.origin.x == playView.frame.origin.x)
    {
        [UIView animateWithDuration:0.3 animations:^
         {
             playView.frame = frame;
         }];
    }
    else
    {
        playView.frame = frame;
    }
    
//    [self timeChangeWithSeconds:(currentTime - fromTime)];
    [self timeChangeWithSeconds:MIN(playTimeCount, toTime - fromTime)];
    
    playTimeCount ++;
    
    if (currentTime >= toTime)
    {
        [self stop];
    }
    
    
}

- (void)recordTimerUpdate
{
    if (audioPlayer.isPlaying)
    {
        [self playUpdate];
    }
    else
    {
        timerCount ++;
        
        timeLabel.text = [NSString stringWithFormat:@"%i:%i%i",timerCount/60,(timerCount/10)%6,timerCount%10];
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self stop];
}

- (void)showWithAlpha:(CGFloat)alpha duration:(CGFloat)duration
{
    [UIView animateWithDuration:duration animations:^
    {
        chongluLabel.alpha = alpha;
        chongluBtn.alpha   = alpha;
        shitingLabel.alpha = alpha;
        playBtn.alpha      = alpha;
        leftView.alpha     = alpha;
        rightView.alpha    = alpha;
    }];
}

- (void)stop
{
    playBtn.selected = NO;
    playView.hidden  = YES;
    playTimeCount    = 0;
    CGRect frame     = playView.frame;
    frame.size.width = 0;
    playView.frame   = frame;
    
    [recordTimer setFireDate:[NSDate distantFuture]];
}

#pragma mark - xib

- (IBAction)playBtn:(UIButton *)button
{
    button.selected = !button.selected;
    
    if (audioPlayer.isPlaying)
    {
        playView.hidden = YES;
        [audioPlayer pause];

        [recordTimer setFireDate:[NSDate distantFuture]];
    }
    
    if (button.selected)
    {
        NSError *error;

        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        NSString *filePath = kRecordPath;
        if (isClip)
        {
            filePath = recordView.recordFilePath;
        }
        
//        if (isReplay)
        {
            audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:filePath] error:&error];
            audioPlayer.delegate = self;
            audioPlayer.currentTime = fromTime;
        }
        [audioPlayer play];
        NSLog(@"%@",audioPlayer);
        if (audioPlayer && audioPlayer.isPlaying)
        {
            playView.hidden = NO;
            
            [recordTimer setFireDate:[NSDate distantPast]];
        }
    }
}

- (IBAction)cancelClip
{
    [UIView animateWithDuration:0.3 animations:^{

        recordBtn.enabled = YES;
        leftBGView.frame  = initleftBGViewRect;
        leftView.frame    = initleftViewRect;
        rightBGView.frame = initrightBGViewRect;
        rightView.frame   = initrightViewRect;
        
        cancelClip.center = CGPointMake(-37, cancelClip.center.y);
        sureClip.center   = CGPointMake(357, cancelClip.center.y);
        
        saveLabel.alpha   = 1.0f;
        saveBtn.alpha     = 1.0f;
    }];
}

- (IBAction)audioSave
{
    if (toTime - fromTime < 5)
    {
        [MTool showAlertViewWithMessage:@"录音时长最少为5秒"];
        return;
    }
    [self audioClipIsAndSaveLocation:NO];
}

- (IBAction)audioClipIsAndSaveLocation:(BOOL)isSave
{
    [recordView stopRecording];
    
    [recordView clipAudioFromIndex:leftView.frame.origin.x
                           toIndex:MIN(319, rightView.frame.origin.x + rightView.frame.size.width)];
    recordView.recordTimeCount = toTime - fromTime;
    timerCount = recordView.recordTimeCount;
    
    [self cancelClip];
    
    leftView.alpha    = 0.0f;
    rightView.alpha   = 0.0f;
    
    recordBtn.enabled = NO;
    isClip   = YES;
    isReplay = YES;
    
    NSString *filenamed = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
    self.kM4APath = kRecordM4A(filenamed);
    
    NSMutableDictionary *dateDict = [NSMutableDictionary dictionary];
    NSString *dateString = [NSString stringWithFormat:@"%@",[Custom getSystemTime]];
    [dateDict setObject:[dateString substringToIndex:19] forKey:@"voice_name"];
    [dateDict setObject:self.kM4APath forKey:@"path"];
    [dateDict setObject:@"2" forKey:@"type"];
    [dateDict setObject:@"0" forKey:@"comment_count"];
    [dateDict setObject:@"0" forKey:@"play_count"];
    [dateDict setObject:@"0" forKey:@"forward_count"];
    [dateDict setObject:@"0" forKey:@"like_count"];
    [dateDict setObject:[[UserInfo standardUserInfo] head_image] forKey:@"image_path"];
    
    if (isSave)
    {
        [m4aArray insertObject:dateDict atIndex:0];
        [m4aArray writeToFile:M4ARECORDPATH atomically:YES];
    }
    
    [recordView exportAsset:[AVAsset assetWithURL:[NSURL fileURLWithPath:kRecordPath]]
                fromSeconds:[NSString stringWithFormat:@"%ld",(long)fromTime]
                  toSeconds:[NSString stringWithFormat:@"%ld",(long)toTime]
                 toFilePath:self.kM4APath];
//    [recordView clipAudioFromSeconds:fromTime toSeconds:toTime];
    
    
//    [recordView exportAsset:[AVAsset assetWithURL:[NSURL fileURLWithPath:kRecordPath]]
//                fromSeconds:[NSString stringWithFormat:@"%d",fromTime]
//                  toSeconds:[NSString stringWithFormat:@"%d",toTime]
//                 toFilePath:nil];
}

- (IBAction)saveRecord
{
    if (toTime - fromTime < 5)
    {
        [MTool showAlertViewWithMessage:@"录音时长最少为5秒"];
        return;
    }
    
    [recordView pauseRecording];
//    [self audioClipIsAndSaveLocation:NO];
    
    SoundSaved *soundSaved = [[SoundSaved alloc] init];
    soundSaved.delegate = self;
    soundSaved.recordPath  = kRecordPath;
    
    [self.navigationController pushViewController:soundSaved animated:YES];
}

- (IBAction)resetSoundRecord
{
    [recordView stopRecording];
    [recordView resetData];
    [self dismissViewControllerAnimated:NO completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReSetSoundRecord" object:nil];
}

- (IBAction)close
{
    if ([recordLabel.text isEqualToString:@"录音"])
    {
        [self dismissViewControllerAnimated:YES completion:nil];
        
        return;
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"您的录音尚未保存，是否保存?"
                                                       delegate:self
                                              cancelButtonTitle:@"不保存"
                                              otherButtonTitles:@"保存", nil];
    alertView.tag = kAlertCloseTag;
    [alertView show];
}

- (IBAction)recordButton:(UIButton *)button
{
    recordBtn.selected = !recordBtn.selected;
    
    if (recordBtn.selected)
    {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        
        leftView.hidden  = YES;
        rightView.hidden = YES;
        
        leftBGView.frame  = initleftBGViewRect;
        leftView.frame    = initleftViewRect;
        rightBGView.frame = initrightBGViewRect;
        rightView.frame   = initrightViewRect;
        
        if ([recordLabel.text isEqualToString:@"录音"])
        {
            [recordView startRecording];
        }
        else
        {
            [recordView continueRecording];
        }

        timeLabel.hidden = NO;
        recordLabel.text = @"暂停录音";
        
        [self showWithAlpha:0.0f duration:0.3];
    }
    else
    {
        [recordView pauseRecording];
        
        leftView.hidden  = NO;
        rightView.hidden = NO;
        
        fromTime = (int)((timerCount/320.0f) * leftView.frame.origin.x);
        toTime   = (int)((timerCount/320.0f) * (rightView.frame.origin.x + rightView.frame.size.width));
        
        recordLabel.text = @"接着录";
        
        [self showWithAlpha:1.0f duration:0.3];
        
        saveLabel.alpha   = 1.0f;
        saveBtn.alpha     = 1.0f;
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == kAlertCloseTag && buttonIndex == 1)
    {
        [self audioClipIsAndSaveLocation:YES];
    }
    
    recordView.delegate = nil;
    [recordTimer invalidate];
    [audioPlayer stop];
    isReplay = YES;
    
    [recordView stopRecording];
    [recordView resetData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - SoundSavedDelegate

- (void)backToRecord
{
//    [self resetSoundRecord];
    recordBtn.enabled = YES;
}

#pragma mark - HSCMoveViewDelegate

- (void)moveViewTouchBagin:(HSCMoveView *)moveView
{
    recordBtn.enabled = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        cancelClip.center = CGPointMake(37, cancelClip.center.y);
        sureClip.center   = CGPointMake(283, cancelClip.center.y);
        saveLabel.alpha   = 0.0f;
        saveBtn.alpha     = 0.0f;
    }];
}

- (void)moveViewmoving:(HSCMoveView *)moveView
{
    if (moveView.tag == kLeftViewTag)
    {
        CGRect frame = leftBGView.frame;
        frame.size.width = leftView.frame.origin.x;
        leftBGView.frame = frame;
    }
    else if (moveView.tag == kRightViewTag)
    {
        CGRect frame = leftBGView.frame;
        frame.origin.x = rightView.frame.origin.x + rightView.frame.size.width;
        frame.size.width = 320 - frame.origin.x;
        rightBGView.frame = frame;
    }
    NSLog(@"timerCount = %d",timerCount);
    fromTime = (int)((timerCount/320.0f) * leftView.frame.origin.x);
    toTime   = (int)((timerCount/320.0f) * (rightView.frame.origin.x + rightView.frame.size.width));
    
    [self timeChangeWithSeconds:toTime - fromTime];
}

#pragma mark - RecordDrawDelegate

- (void)recordDrawDidRecording:(RecordDraw *)recordDrawView
{
    NSInteger timer = (int)recordDrawView.recordTimeCount;
    timerCount = timer;
    
    [self timeChangeWithSeconds:timerCount];
}

- (void)timeChangeWithSeconds:(NSInteger)seconds
{
    timeLabel.text = [NSString stringWithFormat:@"%i:%i%i",seconds/60,(seconds/10)%6,seconds%10];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
