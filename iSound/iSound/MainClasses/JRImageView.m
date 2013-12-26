//  Created by Thanatos on 11-5-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.


#import "JRImageView.h"


@implementation JRImageView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {

	if (self = [super initWithFrame:frame])
	{
		[self setUserInteractionEnabled:YES];
	}
	return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
	UITouch *touch = [touches anyObject];
	CGPoint points = [touch locationInView:self];
	
	BOOL inside = (points.x >= self.bounds.origin.x		&&
				   points.y >= self.bounds.origin.y		&&
				   points.x <= self.bounds.size.width	&&
				   points.y <= self.bounds.size.height	);

	if (inside  && [self.delegate respondsToSelector:@selector(touchUpInsideAtImageView:)])
	{
		[self.delegate touchUpInsideAtImageView:self];
	}

}

@end
