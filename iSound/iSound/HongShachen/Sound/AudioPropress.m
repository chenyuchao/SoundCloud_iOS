//
//  AudioPropress.m
//  iSound
//
//  Created by MaoHeng Zhang on 13-11-6.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import "AudioPropress.h"

@implementation AudioPropress
@synthesize pDelegate;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.userInteractionEnabled = YES;
    }
    
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    beginPoint = [touch locationInView:self];
    
    if ([pDelegate respondsToSelector:@selector(propressViewTouchBagin:)])
    {
        [pDelegate propressViewTouchBagin:self];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    CGPoint nowPoint = [touch locationInView:self];
    
    float offsetX = nowPoint.x - beginPoint.x;
    
    CGFloat x = 0;
    
//    if (self.tag == kLeftViewTag)
//    {
        x = MAX(self.center.x + offsetX, -173);
        x = MIN(x, 136);
//        HSCMoveView *rightView = (HSCMoveView *)[[self superview] viewWithTag:kRightViewTag];
//        
    
//    }
//    else if (self.tag == kRightViewTag)
//    {
//        HSCMoveView *leftView = (HSCMoveView *)[[self superview] viewWithTag:kLeftViewTag];
//        
//        x = MAX(self.center.x + offsetX, leftView.frame.origin.x + leftView.frame.size.width + width);
//        x = MIN(x, 320 - width);
//    }
    
    self.center = CGPointMake(x, self.center.y);
    
    if ([pDelegate respondsToSelector:@selector(propressViewmoving:)])
    {
        [pDelegate propressViewmoving:self];
    }
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([pDelegate respondsToSelector:@selector(propressViewTouchEnd:)])
    {
        [pDelegate propressViewTouchEnd:self];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
