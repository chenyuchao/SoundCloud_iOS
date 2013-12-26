//
//  HSCMoveView.h
//  iSound
//
//  Created by MaoHeng Zhang on 13-10-30.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kLeftViewTag 3542
#define kRightViewTag 5323

@class HSCMoveView;

@protocol HSCMoveViewDelegate <NSObject>

- (void)moveViewTouchBagin:(HSCMoveView *)moveView;
- (void)moveViewmoving:(HSCMoveView *)moveView;

@end

@interface HSCMoveView : UIImageView
{
    
    CGPoint beginPoint;
}

@property (nonatomic, assign) id <HSCMoveViewDelegate> delegate;

@end
