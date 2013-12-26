//  Created by Thanatos on 11-5-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.


#import "JRTouchView.h"


@implementation JRTouchView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {

	if (self = [super initWithFrame:frame])
	{
		[self setUserInteractionEnabled:YES];
	}
	return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

	if ([self.delegate respondsToSelector:@selector(touchDownAtTouchView:)])
	{
		[self.delegate touchDownAtTouchView:self];
	}
    
    longTouches = NO;
    times = 0.0f;
    timer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                             target:self
                                           selector:@selector(beginTimer)
                                           userInfo:nil
                                            repeats:YES];
    
//    self.backgroundColor = ARGB(250, 18, 55, 0.2);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

    if (longTouches) return;
    
    [timer invalidate];
    
	UITouch *touch = [touches anyObject];
	CGPoint points = [touch locationInView:self];
	
	BOOL inside = (points.x >= self.bounds.origin.x		&&
				   points.y >= self.bounds.origin.y		&&
				   points.x <= self.bounds.size.width	&&
				   points.y <= self.bounds.size.height	);

	if (inside  && [self.delegate respondsToSelector:@selector(touchUpInsideAtTouchView:)])
	{
		[self.delegate touchUpInsideAtTouchView:self];
	}
	
	if (!inside && [self.delegate respondsToSelector:@selector(touchUpOutsideAtTouchView:)])
	{
		[self.delegate touchUpOutsideAtTouchView:self];
	}
	
	if ([self.delegate respondsToSelector:@selector(touchEndedAtTouchView:)])
	{
		[self.delegate touchEndedAtTouchView:self];
	}
    
    
//    [self performSelector:@selector(clearColor)
//               withObject:nil
//               afterDelay:0.1];
}

//- (void)clearColor {
//
//    CATransition *transition  = [CATransition animation];
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//    transition.type     = kCATransitionFade;
//    transition.subtype  = kCATransitionFromBottom;
//    transition.duration = 0.5;
//    transition.delegate = self;
//    [self.layer addAnimation:transition forKey:nil];
//    
//    self.backgroundColor = [UIColor clearColor];
//}

- (void)beginTimer {

    times += 1.0f;
    
    if (times >= 2.0)
    {
        if ([self.delegate respondsToSelector:@selector(longTouchUpInsideAtTouchView:)])
        {
            [self.delegate longTouchUpInsideAtTouchView:self];
            longTouches = YES;
        }
        [timer invalidate];
    }
}

@end
