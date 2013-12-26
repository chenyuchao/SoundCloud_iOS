//
//  MTool.m
//  iSound
//
//  Created by MaoHeng Zhang on 13-9-29.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import "MTool.h"

@implementation MTool

+ (void)showAlertViewWithMessage:(NSString *)message
{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alertView show];
}

+ (UIImage *)cutImageFormImage:(UIImage *)image
{
    if (![image isKindOfClass:[UIImage class]])
    {
        return nil;
    }
    
    NSInteger width = MIN((int)image.size.width, (int)image.size.height);
    
    CGFloat x = 0;
    CGFloat y = 0;
    
    if (width == image.size.width)
    {
        y = (image.size.height - width)/2.0f;
    }
    else if (width == image.size.height)
    {
        x = (image.size.width - width)/2.0f;
    }
    
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef    = CGImageCreateWithImageInRect(sourceImageRef, CGRectMake(x, y, width, width));
    UIImage *resultImage      = [UIImage imageWithCGImage:newImageRef];
    CGImageRelease(newImageRef);
    return resultImage;
}

+ (CGFloat)zoomScaleThatFitsTargetSize:(CGSize)target sourceSize:(CGSize)source
{
    CGFloat w_scale = (target.width / source.width);
	CGFloat h_scale = (target.height / source.height);
    
	return ((w_scale < h_scale) ? w_scale : h_scale);
}

@end
