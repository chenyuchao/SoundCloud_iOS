//  Created by  Jumax.R on 12-8-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.


#import <Foundation/Foundation.h>

typedef enum {

    Document,
    Temp,
    None
    
}CachePath;

@class Downloader;

@protocol DownloaderDelegate <NSObject>

@optional
- (void)downloaderProgress:(CGFloat)progress;
- (void)downloaderNoSuchFileInThisUrl:(NSString *)url;
- (void)downloaderDidFailWithError:(NSError *)error;
- (void)downloaderDidStart:(Downloader *)downloader;
- (void)downloaderWillStart:(Downloader *)downloader;
- (void)downloaderLoadingFromLocalDidFinish:(Downloader *)downloader;
- (void)downloaderDidFinish:(Downloader *)downloader object:(UIImage *)object;

@end

@interface Downloader : NSObject {

    NSMutableData *receiveData;
    long long     dataLength;
}

@property (nonatomic, assign) int       idx;
@property (nonatomic, assign) CachePath cachePath;
@property (nonatomic, copy)   NSString  *url;
@property (nonatomic, retain) UIImage   *image;
@property (nonatomic, retain) id <DownloaderDelegate> delegate;

+ (id)downloader;
+ (BOOL)cleanCache;

/* 返回本地缓存图片。
   当本地无此图片的时候会开启线程进行下载后缓存到本地。
*/
- (UIImage *)loadingWithURL:(NSString *)_url
                      index:(int)idx
                   delegate:(id <DownloaderDelegate>)delegate
                    cacheTo:(CachePath)cachePath;

@end