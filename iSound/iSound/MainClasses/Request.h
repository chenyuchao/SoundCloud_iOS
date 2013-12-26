
#import <Foundation/Foundation.h>

#define PrivateKey @"kkL9C*116f"


@class Request;
@class JROrderlyDictionary;

@protocol RequestDelegate <NSObject>

@optional
- (void)downloadWillStart:(Request *)request;
//- (void)downloadDidStart:(Request *)request;
- (void)downloadProgress:(Request *)request withProgress:(CGFloat)progress;
- (void)downloadDidFinish:(Request *)request withResult:(id)result;
- (void)downloadDidFail:(Request *)request WithError:(NSError *)error;

@end

@interface Request : NSObject {

    NSMutableData *receiveData;
    NSInteger currentLength;
    NSInteger sumLength;
}

@property (nonatomic, weak) id <RequestDelegate> delegate;
@property (nonatomic, assign) int requestId;
@property (nonatomic, retain) NSURLConnection	*connection;

- (void)startConnection:(NSString *)url args:(JROrderlyDictionary *)info;

/*  请求实例
    当同一个类发生多次请求的时候可以使用request:方法，请求结束回调可取得id进行判断
*/

+ (Request *)request;
+ (Request *)request:(int)rid;

@end

// 外网地址
#define OutNetAddress   @"http://114.112.94.186/jinjidian/api/"