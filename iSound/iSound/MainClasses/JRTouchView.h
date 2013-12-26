//  Created by Thanatos on 11-5-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.

#import <Foundation/Foundation.h>

@class JRTouchView;

@protocol JRTouchViewDelegate <NSObject>

@optional

- (void)touchDownAtTouchView:(JRTouchView *)touchView;
- (void)touchEndedAtTouchView:(JRTouchView *)touchView;
- (void)touchUpInsideAtTouchView:(JRTouchView *)touchView;
- (void)touchUpOutsideAtTouchView:(JRTouchView *)touchView;
- (void)longTouchUpInsideAtTouchView:(JRTouchView *)touchView;

@end


@interface JRTouchView : UIView {

    NSTimer *timer;
    CGFloat times;
    BOOL longTouches;
}

@property (nonatomic, retain) IBOutlet id <JRTouchViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame;

@end