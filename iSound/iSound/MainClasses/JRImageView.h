//  Created by Thanatos on 11-5-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.

#import <Foundation/Foundation.h>

@class JRImageView;

@protocol JRImageViewDelegate <NSObject>

@optional

- (void)touchUpInsideAtImageView:(JRImageView *)touchView;

@end


@interface JRImageView : UIImageView {

}

@property (nonatomic, assign) IBOutlet id <JRImageViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame;

@end
