//
//  MoviePlayer.m
//  iSound
//
//  Created by MaoHeng Zhang on 13-11-10.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import "MoviePlayer.h"

static MoviePlayer *moviewPlayer = nil;



@implementation MoviePlayer
@synthesize playlist;
@synthesize delegate;
@synthesize isPlaying;

+ (id)standardMoviePlayer
{
    if (!moviewPlayer)
    {
        moviewPlayer = [[MoviePlayer alloc] init];
    }
    
    return moviewPlayer;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        playTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/60.0f
                                                     target:self
                                                   selector:@selector(audioPlaying)
                                                   userInfo:nil
                                                    repeats:YES];
        
        [playTimer setFireDate:[NSDate distantFuture]];
        
        isPlaying = NO;
        self.playIdx = -1;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(recordNotification:)
                                                     name:@"RECORDNOTIFICATION"
                                                   object:nil];
    }
    
    return self;
}

- (void)recordNotification:(NSNotification *)info
{
    [self pauseAudio];
}

- (void)audioPlaying
{
    if (self.duration > 0 && self.currentPlaybackTime >= self.duration)
    {
        [playTimer setFireDate:[NSDate distantFuture]];
        
        isPlaying = NO;
        if ([delegate respondsToSelector:@selector(movePlayerDidFinished:)])
        {
            [delegate movePlayerDidFinished:self];
        }
        return;
    }
    
//    isPlaying = YES;

    if ([delegate respondsToSelector:@selector(movePlayerPlaying:)])
    {
        [delegate movePlayerPlaying:self];
    }
}


#pragma mark - private

- (void)playAudioAiIndex:(int)playIndex
{
    
    if (playIndex < 0 || playIndex > [playlist count] - 1)
    {
        return;
    }
    
    NSDictionary *dict = [playlist objectAtIndex:playIndex];
    NSString *url = [dict objectForKey:@"voice_path"];
    
    if ([url isEqualToString:@""])
    {
        return;
    }
    
    [self setContentURL:[NSURL URLWithString:url]];
    self.initialPlaybackTime = 0;
    [self playAudio];
}

- (void)playAudioWithURL:(NSString *)url
{
    [self setContentURL:[NSURL URLWithString:url]];
    self.initialPlaybackTime = 0;
    [self playAudio];
}

#pragma mark - pubilc

- (void)playAudio
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    isPlaying = YES;
    
    [self play];

    [playTimer setFireDate:[NSDate distantPast]];
    
    if ([delegate respondsToSelector:@selector(movePlayerStart:)])
    {
        [delegate movePlayerStart:self];
    }
}

- (void)pauseAudio
{
    [self pause];
    
    isPlaying = NO;
    
    [playTimer setFireDate:[NSDate distantFuture]];
    
    if ([delegate respondsToSelector:@selector(movePlayerPause:)])
    {
        [delegate movePlayerPause:self];
    }
}

- (void)stopAudio
{
    [self stop];
    
    isPlaying = NO;
    
    [playTimer setFireDate:[NSDate distantFuture]];
    
    if ([delegate respondsToSelector:@selector(movePlayerStop:)])
    {
        [delegate movePlayerStop:self];
    }
}

@end
