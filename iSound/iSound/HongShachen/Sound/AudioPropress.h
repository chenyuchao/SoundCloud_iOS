//
//  AudioPropress.h
//  iSound
//
//  Created by MaoHeng Zhang on 13-11-6.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MAXLEFT  -358
#define MAXRIGHT -49

@class AudioPropress;

@protocol AudioPropressDelegate <NSObject>

- (void)propressViewTouchBagin:(AudioPropress *)moveView;
- (void)propressViewmoving:(AudioPropress *)moveView;
- (void)propressViewTouchEnd:(AudioPropress *)moveView;
@end

@interface AudioPropress : UIImageView
{
    CGPoint beginPoint;
}

@property (nonatomic, assign) id <AudioPropressDelegate> pDelegate;

@end
