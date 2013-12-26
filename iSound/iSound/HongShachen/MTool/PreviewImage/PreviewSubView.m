//
//  PreviewSubView.m
//  LearnTink
//
//  Created by Jason_Li on 13-5-10.
//  Copyright (c) 2013年 admin. All rights reserved.
//

#import "PreviewSubView.h"

#define MAXSCALE 4

@implementation PreviewSubView
@synthesize image;

//- (void)dealloc
//{
//    [image       release];
//    [contentView release];
//    
//    [super dealloc];
//}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.delegate = self;
        
        contentView   = [[UIImageView alloc] initWithFrame:CGRectZero];
        
        [self addSubview:contentView];
    }
    
    return self;
}



#pragma mark - delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return contentView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?(scrollView.bounds.size.width - scrollView.contentSize.width)/2 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?(scrollView.bounds.size.height - scrollView.contentSize.height)/2 : 0.0;
    
    contentView.center = CGPointMake(scrollView.contentSize.width/2 + offsetX,scrollView.contentSize.height/2 + offsetY);
    
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationBeginsFromCurrentState:YES];
//    contentView.center = CGPointMake(scrollView.contentSize.width/2, scrollView.frame.size.height/2);
//    [UIView commitAnimations];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"%f",scrollView.contentOffset.x);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"vvvv = %d",decelerate);
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    NSLog(@"mmmm");
}
#pragma mark - override

- (void)setImage:(UIImage *)newValue
{
    if (image != newValue)
    {
//        [image release];
        image = [newValue copy];
        
        CGFloat scale      = ZoomScaleThatFits(self.frame.size, image.size);
        contentView.frame  = CGRectMake(0, 0, image.size.width * scale, image.size.height * scale);
        contentView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        contentView.image  = image;
        
        self.minimumZoomScale = scale + 1 - scale;
        self.maximumZoomScale = scale * MAXSCALE + 1 - scale;
    }
}

#pragma mark - other

static inline CGFloat ZoomScaleThatFits(CGSize target, CGSize source)
{
	CGFloat w_scale = (target.width  / source.width);
	CGFloat h_scale = (target.height / source.height);
    
	return ((w_scale < h_scale) ? w_scale : h_scale);
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
