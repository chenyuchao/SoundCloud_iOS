//
//  MoviePlayer.h
//  iSound
//
//  Created by MaoHeng Zhang on 13-11-10.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class MoviePlayer;

@protocol MoviePlayerDelegate <NSObject>

@optional
- (void)movePlayerStart:(MoviePlayer *)player;
- (void)movePlayerPlaying:(MoviePlayer *)player;
- (void)movePlayerPause:(MoviePlayer *)player;
- (void)movePlayerStop:(MoviePlayer *)player;
- (void)movePlayerDidFinished:(MoviePlayer *)player;

@end

@interface MoviePlayer : MPMoviePlayerController
{
    NSTimer *playTimer;
}

@property (nonatomic, retain) id <MoviePlayerDelegate> delegate;
@property (nonatomic, retain) id touchTarget;
@property (nonatomic) int playIdx;
@property (nonatomic, copy) NSArray *playlist;
@property (nonatomic) BOOL isPlaying;

+ (id)standardMoviePlayer;

- (void)playAudioAiIndex:(int)playIndex;
- (void)playAudioWithURL:(NSString *)url;

- (void)playAudio;
- (void)pauseAudio;
- (void)stopAudio;

@end
