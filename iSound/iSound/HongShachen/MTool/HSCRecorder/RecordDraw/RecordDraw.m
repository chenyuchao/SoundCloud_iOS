//
//  RecordDraw.m
//  Bowen
//
//  Created by up72 on 13-9-15.
//  Copyright (c) 2013年 up72. All rights reserved.
//

#import "RecordDraw.h"

#define LINEWIDTH  1.0f
#define BaseHeight 10
#define MAXHeight  1.0f

//#define PowerMainColors [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:255.0f/255.0f green:140.0f/255.0f blue:26.0f/255.0f alpha:1.0] CGColor],(id)[[UIColor colorWithRed:217.0f/255.0f green:43.0f/255.0f blue:0.0f/255.0f alpha:1.0] CGColor],(id)[[UIColor colorWithRed:255.0f/255.0f green:140.0f/255.0f blue:26.0f/255.0f alpha:1.0] CGColor], nil]
#define PowerMainColors [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor],(id)[[UIColor whiteColor] CGColor],(id)[[UIColor whiteColor] CGColor], nil]

@implementation RecordDraw
@synthesize curPower;
@synthesize showMode;
@synthesize delegate;
@synthesize recordTimeCount;
@synthesize recordFilePath;

//- (void)dealloc
//{
//    [allPowerArray release];
//    [visibleArray release];
//    [super dealloc];
//}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        //[NSArray arrayWithObjects:(id)[ARGB(255, 68, 1, 1.0) CGColor],(id)[ARGB(255, 68, 1, 1.0) CGColor],(id)[ARGB(255, 68, 1, 1.0) CGColor], nil]
//        [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor],(id)[[UIColor whiteColor] CGColor],(id)[[UIColor whiteColor] CGColor], nil]
        //[NSArray arrayWithObjects:(id)[ARGB(250, 128, 54, 1.0) CGColor],(id)[ARGB(250, 128, 54, 1.0) CGColor],(id)[ARGB(250, 128, 54, 1.0) CGColor], nil]
        self.backgroundColor = CLEARCOLOR;

        recorder = [HSCRecorder standardHSCRecorder];
        recorder.delegate = self;
        NSLog(@"%@",kRecordPath);
        showMode = MaximizeMode;
        allPowerArray  = [[NSMutableArray alloc] init];
        visibleArray   = [[NSMutableArray alloc] init];
        animationIndex = 5;
        
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0f/60.0f
                                                 target:self
                                               selector:@selector(update)
                                               userInfo:self
                                                repeats:YES];
        
        [timer setFireDate:[NSDate distantFuture]];
    }
    return self;
}

- (void)resetData
{
    recorder.recordTimeCount = 0.0f;
}

#pragma mark main methods

- (void)startRecording
{
    [recorder startRecording];
}

- (void)pauseRecording
{
    [recorder pauseRecording];
}

- (void)continueRecording
{
    [recorder continueRecording];
}

- (void)stopRecording
{
    [recorder pauseRecording];
//    [recorder stopRecording];
    
//    [self exportAsset:[AVAsset assetWithURL:[NSURL fileURLWithPath:kRecordPath]]
//          fromSeconds:@"3.0"
//            toSeconds:@"6.0"
//           toFilePath:kRecordPath];
}

- (void)play
{
    
//    NSString * musicFilePath = [[NSBundle mainBundle] pathForResource:@"abc" ofType:@"mp3"];      //创建音乐文件路径
//    
//    NSURL * musicURL= [[NSURL alloc] initFileURLWithPath:musicFilePath];
//    
//    
//    
//    thePlayer  = [[AVAudioPlayer alloc] initWithContentsOfURL:musicURL error:nil];
//
//    [thePlayer setVolume:1];
//    [thePlayer play];
    
//    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"abc.mp3"];
//    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
//    {
//        NSLog(@"sssss");
//    }
//
//    path = [[NSBundle mainBundle] pathForResource:@"abc" ofType:@"mp3"];

}


#pragma mark - HSCRecorderDelegate

- (void)hscRecorderDidStartRecord:(HSCRecorder *)hscRecorder
{
    self.showMode = MaximizeMode;
}

- (void)hscRecorderDidRecording:(HSCRecorder *)hscRecorder power:(CGFloat)power peak:(CGFloat)peak
{
    self.curPower = power;
    self.recordTimeCount = hscRecorder.recordTimeCount;
    
    if ([delegate respondsToSelector:@selector(recordDrawDidRecording:)])
    {
        [delegate recordDrawDidRecording:self];
    }
}

- (void)hscRecorderDidPauseRecord:(HSCRecorder *)hscRecorder
{
    self.showMode = MinimizeMode;
}

- (void)hscRecorderDidStopRecord:(HSCRecorder *)hscRecorder
{
    self.showMode = MinimizeMode;
}

#pragma mark - lowPassResults

- (void)update
{
    animationIndex --;
    [self setNeedsDisplay];
//    if (animationIndex == 0)
//    {
//        animationIndex = 10;
//        [timer setFireDate:[NSDate distantFuture]];
//    }
}

- (void)setCurPower:(CGFloat)newValue
{
    curPower = newValue;
//    NSLog(@"curPower = %f",curPower);
//    curPower = -9;
    if (LINEWIDTH * [visibleArray count] > self.frame.size.width)
    {
        [visibleArray removeObjectAtIndex:0];
    }
//    NSLog(@"curPower = %f",curPower);
    [allPowerArray addObject:[NSString stringWithFormat:@"%f",curPower]];
    [visibleArray  addObject:[NSString stringWithFormat:@"%f",curPower]];
    
    [self setNeedsDisplay];
}

- (void)setRecordTimeCount:(CGFloat)newValue
{
    recordTimeCount = newValue;
    recorder.recordTimeCount = recordTimeCount;
}

- (void)setShowMode:(ShowMode)newValue
{
    showMode = newValue;
    
    switch (showMode)
    {
        case MinimizeMode:
        {
            [timer setFireDate:[NSDate distantPast]];
        }
            break;
        case MaximizeMode:
        {
            [self drawPower:visibleArray lineWidth:LINEWIDTH colorsArray:PowerMainColors offsetX:0 removeOld:YES];
        }
            break;
            case ClipMode:
        {
            
        }
            break;
        default:
            break;
    }
}

- (void)clipAudioFromIndex:(CGFloat)fromIndex toIndex:(CGFloat)toIndex
{
//    x/fromIndex=[allPowerArray count]/320;
    //fromIndex/x=
//    NSInteger startIndex =
    
    NSInteger x1 = (NSInteger)(([allPowerArray count]/320.0f)*fromIndex);
    NSInteger x2 = (NSInteger)(([allPowerArray count]/320.0f)*toIndex);
    
    NSInteger length = MIN(x2 - x1, [allPowerArray count] - x1 - 1);

    fromClipIndex = x1;
    clipLength    = length;
    NSLog(@"%f",fromIndex);
    NSLog(@"%f",toIndex);
    NSLog(@"%d",[allPowerArray count]);
    NSLog(@"%d",x1);
    NSLog(@"%d",x2);
    
    NSLog(@"%d",fromClipIndex);
    NSLog(@"%d",clipLength);
    
    self.showMode = ClipMode;
    
    [self setNeedsDisplay];
}

- (void)drawPower:(NSMutableArray *)powerArray
        lineWidth:(CGFloat)lineWidth
      colorsArray:(NSArray *)colorsArray
          offsetX:(CGFloat)offsetX
        removeOld:(BOOL)removeOld
{
    self.backgroundColor = [UIColor clearColor];
    
    if (removeOld)
    {
        [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    }
    
    UIBezierPath *aPath = [UIBezierPath bezierPath];
    
    for (NSInteger i = 0; i < [powerArray count]; i ++)
    {
        CGFloat offsetY = [[powerArray objectAtIndex:i] floatValue]*MAXHeight + BaseHeight;
        CGPoint point = CGPointMake(lineWidth*i + offsetX, self.frame.size.height/2 + offsetY);
        
        if(i == 0)
        {
            [aPath moveToPoint:point];
        }
        else
        {
            [aPath addLineToPoint:point];
        }
    }
    
    for (NSInteger i = [powerArray count] - 1; i >= 0; i --)
    {
        CGFloat offsetY = [[powerArray objectAtIndex:i] floatValue]*MAXHeight + BaseHeight;
        CGPoint point = CGPointMake(lineWidth*i + offsetX, self.frame.size.height/2 - offsetY);
        
        [aPath addLineToPoint:point];
    }
    
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    
    pathLayer.frame = self.bounds;
    
    pathLayer.path = aPath.CGPath;
    
    pathLayer.fillColor = [[UIColor redColor] CGColor];
    
    //    pathLayer.fillColor = nil;
    
    pathLayer.lineWidth = 1;
    
    pathLayer.lineJoin = kCALineJoinRound;
    
    [self.layer addSublayer:pathLayer];
    
    CAGradientLayer *lineLayer = [CAGradientLayer layer];
    
    lineLayer.colors = colorsArray;
    
    lineLayer.frame = self.bounds;
    
    [lineLayer setMask:pathLayer];
    
    [self.layer addSublayer:lineLayer];
    
    self.backgroundColor = [UIColor clearColor];
}

- (void)lineWithWith:(CGFloat)lineWidth fromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint
{
    [[UIColor brownColor] set];
    //获得当前图形上下文
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    //设置连接类型
    CGContextSetLineJoin(currentContext, kCGLineJoinRound);
    //设置线条宽度
    CGContextSetLineWidth(currentContext,lineWidth);
    //设置开始点位置
    CGContextMoveToPoint(currentContext,fromPoint.x, fromPoint.y);
    //设置终点
    CGContextAddLineToPoint(currentContext,toPoint.x, toPoint.y);
    //设置另一个终点
    //    CGContextAddLineToPoint(currentContext,paramTopPoint.x + 140, paramTopPoint.y + 100);
    //画线
    CGContextStrokePath(currentContext);
    [[UIColor brownColor] set];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    UIColor *color = [UIColor lightGrayColor];
//    
//    [self drawPower:allPowerArray
//          lineWidth:self.frame.size.width/[allPowerArray count]
//        colorsArray:[NSArray arrayWithObjects:(id)[color CGColor],(id)[color CGColor],(id)[color CGColor], nil]
//            offsetX:0
//          removeOld:YES];
//    
//    UITouch *touch = [[touches allObjects] objectAtIndex:0];
//    CGPoint point = [touch locationInView:self];
//    
//    [self drawPowerToPoint:point];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
//    UITouch *touch = [[touches allObjects] objectAtIndex:0];
//    CGPoint point = [touch locationInView:self];
//    
//    [self drawPowerToPoint:point];
}

- (void)drawPowerToPoint:(CGPoint)toPoint
{
    CGFloat lineWidth = self.frame.size.width/[allPowerArray count];
    NSInteger idx = [allPowerArray count]/(self.frame.size.width/toPoint.x);
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSInteger i = 0; i < idx; i ++)
    {
        [array addObject:[allPowerArray objectAtIndex:i]];
    }
    
    if ([self.layer.sublayers count] > 1)
    {
        CAGradientLayer *lineLayer = [self.layer.sublayers lastObject];
        [lineLayer removeFromSuperlayer];
    }
    [self drawPower:array lineWidth:lineWidth colorsArray:PowerMainColors offsetX:0 removeOld:NO];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    switch (showMode)
    {
        case MinimizeMode:
        {
            NSMutableArray *array = [NSMutableArray array];
            
            for (NSInteger i = [allPowerArray count] - 1; i > [allPowerArray count]*(animationIndex/10.0f); i --)
            {
//                NSLog(@"i = %d",i);
                if (i < 0)
                {
                    break;
                }
                [array insertObject:[allPowerArray objectAtIndex:i] atIndex:0];
            }
            
            [self drawPower:array
                  lineWidth:self.frame.size.width/[array count]
                colorsArray:PowerMainColors
                    offsetX:0
                  removeOld:YES];
            NSLog(@"animationIndex = %d",animationIndex);
            if (animationIndex <= 0)
            {
                [timer setFireDate:[NSDate distantFuture]];
            }
        }
            break;
        case MaximizeMode:
        {
            animationIndex = 10;
            [self drawPower:visibleArray lineWidth:LINEWIDTH colorsArray:PowerMainColors offsetX:0 removeOld:YES];
        }
            break;
            case ClipMode:
        {
            NSArray *subArray = [allPowerArray subarrayWithRange:NSMakeRange(fromClipIndex, clipLength)];
            
            if([subArray count] > 5)
            {
                [self drawPower:(NSMutableArray *)subArray
                      lineWidth:self.frame.size.width/[subArray count]
                    colorsArray:PowerMainColors
                        offsetX:0
                      removeOld:YES];
            }
        }
            break;
        default:
            break;
    }
}

/*
 剪切开始工作
 大概流程
 1、获得视频总时长，处理时间，数组格式返回音频数据
 2、创建导出会话
 3、设计导出时间范围，淡出时间范围
 4、设计新音频配置数据，文件路径，类型等
 5、开始剪切
 */
- (BOOL)exportAsset:(AVAsset *)avAsset
        fromSeconds:(NSString *)fromSeconds
          toSeconds:(NSString *)toSeconds
         toFilePath:(NSString *)filePath
{

//    filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"recordTestss.m4a"];
    self.recordFilePath = filePath;
    // we need the audio asset to be at least 50 seconds long for this snippet
    CMTime assetTime = [avAsset duration];//获取视频总时长,单位秒
    Float64 duration = CMTimeGetSeconds(assetTime); //返回float64格式 获得音频总时长
    NSLog(@"%lld",assetTime.value);
    NSLog(@"%d",assetTime.timescale);
    
    if (duration < 2.0)
    {
        return NO; //小于20秒跳出
    }
    
    // get the first audio track
    NSArray *tracks = [avAsset tracksWithMediaType:AVMediaTypeAudio]; //返回该音频文件数据的数组
    if ([tracks count] == 0) return NO; //如果没有数据，跳出
    
    AVAssetTrack *track = [tracks objectAtIndex:0];//获取第一个对象
    
//    fromSeconds * avAsset.duration.timescale;
//    avAsset.duration
    // create the export session
    // no need for a retain here, the session will be retained by the
    // completion handler since it is referenced there
    //创建导出会话
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:filePath])
    {
        [fileManager removeItemAtPath:filePath error:nil];
    }

    AVAssetExportSession *exportSession = [AVAssetExportSession
                                           exportSessionWithAsset:avAsset
                                           presetName:AVAssetExportPresetAppleM4A];
    if (nil == exportSession) return NO;//创建失败，则跳出
    
//    avAsset.duration
    // create trim time range - 20 seconds starting from 30 seconds into the asset
    CMTime startTime = CMTimeMake([fromSeconds longLongValue]* assetTime.timescale, assetTime.timescale);//CMTimeMake(第几帧， 帧率) 30
    CMTime stopTime  = CMTimeMake([toSeconds  longLongValue] * assetTime.timescale, assetTime.timescale);//CMTimeMake(第几帧， 帧率)50
    CMTimeRange exportTimeRange = CMTimeRangeFromTimeToTime(startTime, stopTime);//导出时间范围

    // create fade in time range - 10 seconds starting at the beginning of trimmed asset
//    CMTime startFadeInTime = startTime;//30
//    CMTime endFadeInTime = CMTimeMake(40, 1);//40
    
    // setup audio mix
    AVMutableAudioMix *exportAudioMix = [AVMutableAudioMix audioMix];//实例新的可变音频混音
    AVMutableAudioMixInputParameters *exportAudioMixInputParameters =
    [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:track]; //给track 返回一个可变的输入参数对象
    
//    [exportAudioMixInputParameters setVolumeRampFromStartVolume:0.0 toEndVolume:1.0
//                                                      timeRange:fadeInTimeRange]; //设置指定时间范围内导出
    exportAudioMix.inputParameters = [NSArray
                                      arrayWithObject:exportAudioMixInputParameters]; //返回导出数据转化为数组
    
    // configure export session  output with all our parameters 新的配置信息
    exportSession.outputURL = [NSURL fileURLWithPath:filePath]; // output path 新文件路径
    exportSession.outputFileType = AVFileTypeAppleM4A; // output file type 新文件类型
    exportSession.timeRange = exportTimeRange; // trim time range //剪切时间
    exportSession.audioMix = exportAudioMix; // fade in audio mix //新的混音音频
    
    // perform the export  开始真正工作
    [exportSession exportAsynchronouslyWithCompletionHandler:^{ //block
        
        if (AVAssetExportSessionStatusCompleted == exportSession.status)
        { //如果信号提示已经完成
            NSLog(@"AVAssetExportSessionStatusCompleted"); //格式化输出成功提示
        }
        else if (AVAssetExportSessionStatusFailed == exportSession.status)
        {  //如果信号提示已经完成
            
            // a failure may happen because of an event out of your control
            // for example, an interruption like a phone call comming in
            // make sure and handle this case appropriately
            NSLog(@"AVAssetExportSessionStatusFailed"); //格式化输出失败提示
        }
        else
        {
            NSLog(@"Export Session Status: %i", exportSession.status);  //格式化输出信号状态
        }
    }];
    
    return YES;
}


@end
