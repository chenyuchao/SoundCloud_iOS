//
//  MTool.h
//  iSound
//
//  Created by MaoHeng Zhang on 13-9-29.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"
#import "HSCRequest.h"
#import "UIView+screenshot.h"


#define M4ARECORDPATH [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"M4A.plist"]

#define IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0f) ? NO : YES

#define kSuccessful 200

#define JJD_VERSION @"1.0"

@interface MTool : NSObject



+ (void)showAlertViewWithMessage:(NSString *)message;

+ (UIImage *)cutImageFormImage:(UIImage *)image;

+ (CGFloat)zoomScaleThatFitsTargetSize:(CGSize)target sourceSize:(CGSize)source;
@end
