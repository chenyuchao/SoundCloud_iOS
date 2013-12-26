//  Created by Jumax.R on 11-12-3.
//  Copyright 2011 __MyCompanyName__. All rights reserved.


#import "Custom.h"


@implementation Custom


+ (void)messageWithString:(NSString *)aString {

	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" 
                                                        message:aString
                                                       delegate:nil 
                                              cancelButtonTitle:nil 
                                              otherButtonTitles:@"确定", nil];
	[alertView show];
}

+ (void)setBorder:(UIView *)sender {
	
	[sender.layer setBorderColor:ARGB(216, 216, 216, 1.0f).CGColor];
	[sender.layer setMasksToBounds:YES];
	[sender.layer setCornerRadius:25];
	[sender.layer setBorderWidth:1.5];
}

+ (void)setShadow:(UIView *)sender {

	sender.layer.shadowOffset = CGSizeMake(0, 10);
	sender.layer.shadowOpacity = 1.1f;
	sender.layer.shadowColor = [UIColor blackColor].CGColor;
}

+ (NSString *)getDocumentDir {

	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0];
}

+ (NSString *)getTempDir {
    
    return NSTemporaryDirectory();
}

+ (NSString *)getCacheDir {
    
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

+ (NSString *)iPhone5WithString:(NSString *)name {

    return iPhone5 ? [name stringByAppendingString:@"-568h@2x"] : name;
}

+ (NSDate *)getSystemTime {
	
	NSTimeZone *zone = [NSTimeZone defaultTimeZone];
	NSTimeInterval t = [zone secondsFromGMTForDate:[NSDate date]];
    NSDate *system   = [[NSDate date] dateByAddingTimeInterval:t];
	return system;
}

+ (NSString *)MD5:(NSString *)str {
	
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result );
    return [NSString stringWithFormat:
			@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			result[0], result[1], result[2], result[3], 
			result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11],
			result[12], result[13], result[14], result[15]
			];
}

+ (UIImage *)scaleToSize:(UIImage *)image targetSize:(CGSize)size {

    UIGraphicsBeginImageContext(size);
    CGRect bounds;
    bounds.origin = CGPointZero;
    bounds.size   = size;
    [image drawInRect:bounds];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
     
    return resultImage;
}

+ (UIFont *)systemFont:(CGFloat)size {
    
    int systemFont = 1;
    if (systemFont == 1)
    {
        return [UIFont fontWithName:@"Avenir Next" size:size];
    }
    return [UIFont systemFontOfSize:size];
}

+ (UINavigationController *)defaultNavigationController:(UIViewController *)rootViewController {

    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:rootViewController];;
    
    CGFloat version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version < 7.0 && version > 4.0)
    {
        [navigation.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbg"]
                                       forBarMetrics:UIBarMetricsDefault];
    }
    else
    {
        navigation.navigationBar.barTintColor = MainColor;
        navigation.navigationBar.barStyle = UIBarStyleDefault;
        navigation.navigationBar.translucent = NO;
    }
    return navigation;
}

@end


@implementation Location

static CLLocationCoordinate2D currentCoors;

+ (void)setCoors:(CLLocationCoordinate2D)coors {
    
	currentCoors = coors;
}

+ (CLLocationCoordinate2D)coors {
    
	return currentCoors;
}

@end

@implementation UIViewController (CustomTitleView)

- (void)setTitle:(NSString *)title {

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 25)];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:16.0f];
    label.backgroundColor = CLEARCOLOR;
    self.navigationItem.titleView = label;
}

@end