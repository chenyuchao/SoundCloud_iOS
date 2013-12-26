//  Created by Jumax.R on 11-12-3.
//  Copyright 2011 __MyCompanyName__. All rights reserved.


#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>
#import <CommonCrypto/CommonDigest.h>

/*
 
 添加:
 QuartzCore.framework
 CoreLocation.framework
 Security.framework
 
 */

@interface Custom : NSObject {

}
+ (void)messageWithString:(NSString *)aString;
+ (void)setBorder:(UIView *)sender;
+ (void)setShadow:(UIView *)sender;
+ (NSString *)getDocumentDir;
+ (NSString *)getTempDir;
+ (NSString *)getCacheDir;
+ (NSString *)iPhone5WithString:(NSString *)name;
+ (NSDate *)getSystemTime;
+ (NSString *)MD5:(NSString *)str;
+ (UIImage *)scaleToSize:(UIImage *)image targetSize:(CGSize)size;
+ (UIFont *)systemFont:(CGFloat)size;
+ (UINavigationController *)defaultNavigationController:(UIViewController *)rootViewController;

@end

@interface Location : NSObject {
    
}

+ (void)setCoors:(CLLocationCoordinate2D)coors;
+ (CLLocationCoordinate2D)coors;

@end

@interface UIViewController (CustomTitleView)

@end

// 加载图片
#define LoadImage(PATH,TYPE) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:PATH ofType:TYPE]]
// 创建TabBar集合
#define CREATE_TABARITEM(TITLE,PATH,TAG) [[[UITabBarItem alloc] initWithTitle:TITLE image:PATH tag:TAG] autorelease]
// 创建导航视图控制器
#define Create_Navigation(CONTROLLER) [[UINavigationController alloc] initWithRootViewController:CONTROLLER]
// 设置ARBG
#define ARGB(R,G,B,A) [UIColor colorWithRed:R / 255.0 green:G / 255.0 blue:B / 255.0 alpha:A]
// 清空颜色
#define CLEARCOLOR [UIColor clearColor]
// 设置图像为填充色
#define ImageColor(PATH,TYPE) [UIColor colorWithPatternImage:LoadImage(PATH,TYPE)]
// 设置字体大小
#define FONT_WITH_SIZE(SIZE) [UIFont systemFontOfSize:SIZE]
// 创建导航条自定义按钮
#define CUSTOMVIEW(VIEW) [[UIBarButtonItem alloc] initWithCustomView:VIEW]
// 角度旋转
#define DegressToRadian(x) (M_PI * (x) / 180.0)
// AppDelegate
#define ApplicationDelegate	(AppDelegate *)[[UIApplication sharedApplication] delegate]
// MainBundleKey
#define ObjectForBundleKey(Key) [[NSBundle mainBundle] objectForInfoDictionaryKey:Key]
// 屏幕宽度
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
// 屏幕高度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
// 判断是否为iPhone5
#define iPhone5 ScreenHeight > 480
// 加载文件来自Bundle
#define FileForBundle(PATH, TYPE) [[NSBundle mainBundle] pathForResource:PATH ofType:TYPE]
// 项目主体颜色
#define MainColor ARGB(250, 128, 54, 1.0)