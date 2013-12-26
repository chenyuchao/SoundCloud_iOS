//
//  HSCMoveView.m
//  iSound
//
//  Created by MaoHeng Zhang on 13-10-30.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import "HSCMoveView.h"

@implementation HSCMoveView
@synthesize delegate;

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
    
    if ([delegate respondsToSelector:@selector(moveViewTouchBagin:)])
    {
        [delegate moveViewTouchBagin:self];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];

    CGPoint nowPoint = [touch locationInView:self];

    float offsetX = nowPoint.x - beginPoint.x;
    
    CGFloat x = 0;
    
    CGFloat width = self.frame.size.width/2;
    
    if (self.tag == kLeftViewTag)
    {
        x = MAX(self.center.x + offsetX, width);
        
        HSCMoveView *rightView = (HSCMoveView *)[[self superview] viewWithTag:kRightViewTag];
        
        x = MIN(x, rightView.frame.origin.x - width);
    }
    else if (self.tag == kRightViewTag)
    {
        HSCMoveView *leftView = (HSCMoveView *)[[self superview] viewWithTag:kLeftViewTag];
        
        x = MAX(self.center.x + offsetX, leftView.frame.origin.x + leftView.frame.size.width + width);
        x = MIN(x, 320 - width);
    }

    self.center = CGPointMake(x, self.center.y);
    
    if ([delegate respondsToSelector:@selector(moveViewmoving:)])
    {
        [delegate moveViewmoving:self];
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
