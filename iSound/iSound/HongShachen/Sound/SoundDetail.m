//
//  SoundDetail.m
//  iSound
//
//  Created by Jumax.R on 13-11-5.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import "SoundDetail.h"
#import "AppDelegate.h"
#import "UserCenter.h"

static SoundDetail *soundDetail = nil;

@interface SoundDetail ()

@end

@implementation SoundDetail
@synthesize dataDict;
@synthesize group_id;

+ (id)standardSoundDetail
{
    if (!soundDetail)
    {
        soundDetail = [[SoundDetail alloc] init];
    }
    return soundDetail;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"正在播放";
    
    UIButton *returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
    returnButton.frame = CGRectMake(0, 0, 28, 28);
    [returnButton addTarget:self
                     action:@selector(popViewController)
           forControlEvents:UIControlEventTouchUpInside];
    [returnButton setImage:[UIImage imageNamed:@"return"]
                  forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = CUSTOMVIEW(returnButton);
    
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    infoButton.frame = CGRectMake(0, 0, 28, 28);
    [infoButton addTarget:self
                   action:@selector(displayInfo:)
         forControlEvents:UIControlEventTouchUpInside];
    [infoButton setImage:[UIImage imageNamed:@"playInfo"]
                forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = CUSTOMVIEW(infoButton);
    
    propressView.userInteractionEnabled = YES;
    propressView.pDelegate = self;
    
    moviePlayer  = [MoviePlayer standardMoviePlayer];
    moviePlayer.delegate = self;
    
    if (!moviePlayer.isPlaying)
    {
        [moviePlayer stopAudio];
        [self playAudioAtIndex:moviePlayer.playIdx];
    }
    
    lastPlaytime = moviePlayer.currentPlaybackTime;
    
    CGFloat y = burlBackground.frame.origin.y + burlBackground.frame.size.height;
    
    mainScrollView.frame = CGRectMake(0, y, 320, playBGView.frame.origin.y - y);
    
    detailView.alpha = 0.0f;
    
    NSDictionary *object = [self.mainlist objectAtIndex:moviePlayer.playIdx];
    
    NSString *voiceUserId = [NSString stringWithFormat:@"%d",[[object objectForKey:@"user_id"] intValue]];
    if ([voiceUserId isEqualToString:[[UserInfo standardUserInfo] user_id]])
    {
        guanzhuBtn.hidden = YES;
    }
    else
    {
        guanzhuBtn.hidden = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSDictionary *object = [self.mainlist objectAtIndex:moviePlayer.playIdx];
    
    int type = self.isGroup ? 2 : 1;

    UserInfo *info = [UserInfo standardUserInfo];
    [[Request request:kVoiceInfoTag] getVoiceInfo:info.user_id
                                          voiceId:[object valueForKey:@"voice_id"]
                                             type:type
                                         delegate:self];
}

- (void)touchUpInsideAtImageView:(JRImageView *)touchView {

    if ([self.audioInfo valueForKey:@"user_id"] == nil)
    {
        [Custom messageWithString:@"抱歉，该用户信息暂时无法查看"];
        return;
    }
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UserCenter *center = [storyboard instantiateViewControllerWithIdentifier:@"UserCenter"];
    center.userid = [self.audioInfo valueForKey:@"user_id"];
    center.displayReturn = YES;
    [self.navigationController pushViewController:center animated:YES];
}

#pragma mark - RequestDelegate

- (void)downloadDidFinish:(Request *)request withResult:(id)result
{
    NSLog(@"result = %@",result);
    
    if (request.requestId == kGuanzhuCancle)
    {
        if ([[result valueForKey:@"code"] intValue] != 200)
        {
            [MTool showAlertViewWithMessage:[[result objectForKey:@"error"] valueForKey:@"msg"]];
            guanzhuBtn.selected = YES;
        }
        
        return;
    }
    
    if (request.requestId == kGuanzhuTag)
    {
        if ([[result objectForKey:@"code"] intValue] != 200)
        {
            [MTool showAlertViewWithMessage:[[result objectForKey:@"error"] valueForKey:@"msg"]];
            guanzhuBtn.selected = NO;
        }
        else
        {
            [Custom messageWithString:@"关注成功"];
            guanzhuBtn.selected = YES;
        }
        return;
    }
    
    if(request.requestId == kLikeAudioTag)
    {
        if ([[result objectForKey:@"code"] intValue] != 200)
        {
            
        }
        else
        {
            label3.text = [NSString stringWithFormat:@"%d",[label3.text intValue] + 1];
        }
        return;
    }
    
    if (request.requestId == kAddPlaylist)
    {
        if ([[result objectForKey:@"code"] intValue] != 200)
        {
//            favBtn.selected = NO;
//            [favBtn setImage:LoadImage(@"playNoLike", @"png") forState:UIControlStateNormal];
            [MTool showAlertViewWithMessage:[[result objectForKey:@"error"] valueForKey:@"msg"]];
        }
        else
        {
            [Custom messageWithString:@"加入播放列表成功"];
        }
        
        return;
    }
    
    if (request.requestId == kUNLikeAudioTag)
    {
        if ([[result objectForKey:@"code"] intValue] != 200)
        {
            favBtn.selected = YES;
            [favBtn setImage:LoadImage(@"playLike", @"png") forState:UIControlStateNormal];
            [MTool showAlertViewWithMessage:[result objectForKey:@"msg"]];
        }
        else
        {
            label3.text = [NSString stringWithFormat:@"%d",[label3.text intValue] - 1];
        }
        return;
    }
    
    if (request.requestId == kVoiceTranspond)//转发
    {
        if ([[result objectForKey:@"code"] intValue] == 200)
        {
            zfBtn.tag = 200;
            [zfBtn setImage:LoadImage(@"ZFImage", @"png") forState:UIControlStateNormal];
            label2.text = [NSString stringWithFormat:@"%d",[label2.text intValue] + 1];
            
            [MTool showAlertViewWithMessage:[result objectForKey:@"msg"]];
        }
        else
        {
            [MTool showAlertViewWithMessage:[[result objectForKey:@"error"] objectForKey:@"msg"]];
        }
        
        
        return;
    }
    
    if ([[result valueForKey:@"code"] intValue] != 200)
    {
        return;
    }
    
    NSDictionary *object = [result valueForKey:@"data"];
    
    self.audioInfo = object;
    
    guanzhuBtn.hidden = NO;
    
    switch ([[object objectForKey:@"follow_state"] intValue])
    {
        case 0:
            guanzhuBtn.selected = NO;
            break;
        case 1:
            guanzhuBtn.selected = YES;
            break;
        case 2:
            guanzhuBtn.hidden = YES;
            break;
        default:
            break;
    }
    
    if ([[object valueForKey:@"is_group"] intValue] == 1)
    {
        zfBtn.enabled = NO;
    }
    else
    {
        zfBtn.enabled = YES;
    }
    
    favBtn.selected = [[object objectForKey:@"like_state"] intValue] == 1 ? YES : NO;
    
    if (favBtn.selected)
    {
        [favBtn setImage:LoadImage(@"playLike", @"png") forState:UIControlStateNormal];
    }
    else
    {
        [favBtn setImage:LoadImage(@"playNoLike", @"png") forState:UIControlStateNormal];
    }
    
    BOOL isZF = [[object objectForKey:@"zf_state"] intValue] == 1 ? YES : NO;
    
    if (isZF)
    {
        zfBtn.tag = 200;
        [zfBtn setImage:LoadImage(@"ZFImage", @"png") forState:UIControlStateNormal];
    }
    else
    {
        zfBtn.tag = 100;
        [zfBtn setImage:LoadImage(@"playTransformSend", @"png") forState:UIControlStateNormal];
        
    }
    
    nameLabel.text = [object objectForKey:@"nickname"];
    bodyLabel.text = [object objectForKey:@"voice_name"];
    
    NSDate *voiceDate = [NSDate dateWithTimeIntervalSince1970:[[object objectForKey:@"create_time"] doubleValue]];
    
    if (!dateFormatter)
    {
        dateFormatter =[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    }
    
    dateLabel.text = [dateFormatter stringFromDate:voiceDate];
    
    label0.text = [NSString stringWithFormat:@"%@",[object objectForKey:@"play_count"]];
    label1.text = [NSString stringWithFormat:@"%@",[object objectForKey:@"comment_count"]];
    label2.text = [NSString stringWithFormat:@"%@",[object objectForKey:@"forward_count"]];
    label3.text = [NSString stringWithFormat:@"%@",[object objectForKey:@"like_count"]];
    [self autoLayout];

    ylikeLabel.text = [NSString stringWithFormat:@"%@ 人已喜欢",label3.text];
    yzhuanfaLabel.text = [NSString stringWithFormat:@"%@ 人已转发",label2.text];
    
    headerView.image = [[Downloader downloader] loadingWithURL:[object valueForKey:@"avatar"]
                                                         index:100
                                                      delegate:self
                                                       cacheTo:Document];
    
    [[mainScrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSArray *imagelist = [object valueForKey:@"img_list"];
    if (imagelist.count > 0)
    {
        int i = 0;
        for (; i < imagelist.count; i++)
        {
            NSDictionary *element = [imagelist objectAtIndex:i];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * 320,
                                                                                   0,
                                                                                   320,
                                                                                   mainScrollView.frame.size.height)];
            imageView.tag = 200 + i;
            imageView.userInteractionEnabled = YES;
            
            imageView.image = [[Downloader downloader] loadingWithURL:[element valueForKey:@"picture_path"]
                                                                index:200 + i
                                                             delegate:self
                                                              cacheTo:Document];
            
            UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(showImageWithRecognizer:)];
            tapRecognizer.numberOfTapsRequired = 1;
            [imageView addGestureRecognizer:tapRecognizer];
            
            [mainScrollView addSubview:imageView];
        }
        [mainScrollView setContentSize:CGSizeMake(i * 320, 0)];
    }
    else
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                               0,
                                                                               320,
                                                                               mainScrollView.frame.size.height)];
        imageView.userInteractionEnabled = YES;
        imageView.tag = 200;
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(showImageWithRecognizer:)];
        tapRecognizer.numberOfTapsRequired = 1;
        [imageView addGestureRecognizer:tapRecognizer];
        imageView.image = headerView.image;
        
        [mainScrollView addSubview:imageView];
    }
}

#pragma mark - down image

- (void)downloaderDidFinish:(Downloader *)downloader object:(UIImage *)object {
    
    if (downloader.idx == 100)
    {
        headerView.image = [MTool cutImageFormImage:object];
    }
    else
    {
        UIImageView *imageView = (UIImageView *)[mainScrollView viewWithTag:downloader.idx];
        imageView.image = object;
        
    }
}

- (void)downloaderDidFailWithError:(NSError *)error {
    
    NSLog(@"%@", error);
}

- (void)upate
{
    [self updatePropress];
}


#pragma mark - private

- (void)showImageWithRecognizer:(UITapGestureRecognizer *)tapRecognizer
{
    NSInteger showIndex =  mainScrollView.contentOffset.x/mainScrollView.frame.size.width;
    
    NSMutableArray *tmpArray = [NSMutableArray array];
    
    for (UIImageView *subView in mainScrollView.subviews)
    {
        UIImage *image = subView.image;
        
        if (image)
        {
            [tmpArray addObject:image];
        }
    }
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    PreViewController *preViewController = [[PreViewController alloc] init];
    preViewController.hiddenDeleteBtn = YES;
    preViewController.shotImage  = [appDelegate.window screenshot];
    preViewController.showIndex  = showIndex;
    preViewController.imageArray = tmpArray;
    
    [self presentViewController:preViewController animated:NO completion:nil];
    //    Prev
}

- (NSString *) formatTime: (int) num
{
    num = isnan(num) ? 0 : num;
    
    int secs = num % 60;
    int min = num / 60;
    
    if (num < 60) return [NSString stringWithFormat:@"0:%02d", num];
    
    return	[NSString stringWithFormat:@"%d:%02d", min, secs];
}

#pragma mark - xib

- (IBAction)comment
{
    [moviePlayer pauseAudio];
    NSDictionary *object = [self.mainlist objectAtIndex:moviePlayer.playIdx];
    
    CommentView *comment = [[CommentView alloc] init];
    comment.voiceId = [object objectForKey:@"voice_id"];
    comment.delegate = self;
    UINavigationController *navigation = [Custom defaultNavigationController:comment];
    [self presentViewController:navigation animated:YES completion:nil];
}

- (void)commentSendDidFinish {

    [moviePlayer playAudio];
}

- (IBAction)guanzhu
{
    NSDictionary *object = [self.mainlist objectAtIndex:moviePlayer.playIdx];
    
    if (guanzhuBtn.selected)
    {
        [[Request request:kGuanzhuCancle] cancelFollow:[[UserInfo standardUserInfo] user_id]
                                              targetId:[NSString stringWithFormat:@"%d",[[object objectForKey:@"user_id"] intValue]]
                                              delegate:self];
        guanzhuBtn.selected = NO;
    }
    else
    {
        [[Request request:kGuanzhuTag] addFollow:[[UserInfo standardUserInfo] user_id]
                                        targetId:[NSString stringWithFormat:@"%d",[[object objectForKey:@"user_id"] intValue]]
                                        delegate:self];
        guanzhuBtn.selected = YES;
    }
}

- (IBAction)addToPalylist:(UIButton *)button
{
    PlayerList *pList = [[PlayerList alloc] init];
    pList.delegate = self;
    pList.comfromCenter = NO;
    pList.userid = [[UserInfo standardUserInfo] user_id];
    [self.navigationController pushViewController:pList animated:YES];
}

- (IBAction)shared
{
//    //友盟
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMengKey
                                      shareText:nil
                                     shareImage:((UIImageView *)[mainScrollView viewWithTag:200]).image
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,
                                                                          UMShareToTencent,nil]
                                       delegate:self];
}

- (IBAction)transpond//转发
{
    if (zfBtn.tag == 100)
    {
        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil
                                                            delegate:self
                                                   cancelButtonTitle:@"取消"
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:@"普通转发",@"转发到群组", nil];
        action.tag = 200;
        [action showInView:self.view];
    }
    else if (zfBtn.tag == 200)
    {
        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil
                                                            delegate:self
                                                   cancelButtonTitle:@"取消"
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:@"转发到群组", nil];
        action.tag = 100;
        [action showInView:self.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 200)
    {
        switch (buttonIndex)
        {
            case 0:
            {
                [[Request request:kVoiceTranspond] transpondAudio:[NSString stringWithFormat:@"%d",[[self.audioInfo objectForKey:@"voice_id"] intValue]]
                                                             type:@"1"
                                                         group_id:@""
                                                         delegate:self];
            }
                break;
                
            case 1:
            {
                
                UserGroup *userGroup = [[UserGroup alloc] init];
                userGroup.selectedGroupId = group_id;
                userGroup.userid = [[UserInfo standardUserInfo] user_id];
                userGroup.delegate = self;
                [self.navigationController pushViewController:userGroup animated:YES];
            }
                break;
            default:
                break;
        }
    }
    else if (actionSheet.tag == 100)
    {
        if (buttonIndex == 0)
        {
            UserGroup *userGroup = [[UserGroup alloc] init];
            userGroup.selectedGroupId = group_id;
            userGroup.userid = [[UserInfo standardUserInfo] user_id];
            userGroup.delegate = self;
            [self.navigationController pushViewController:userGroup animated:YES];
        }
    }
}

- (void)didSelectedGroup:(NSString *)title groupID:(NSString *)gid {

    self.group_id = gid;
    [[Request request:kVoiceTranspond] transpondAudio:[NSString stringWithFormat:@"%d",[[self.audioInfo objectForKey:@"voice_id"] intValue]]
                                                 type:@"2"
                                             group_id:group_id
                                             delegate:self];
}

- (IBAction)likeAudio
{
    NSDictionary *object = [self.mainlist objectAtIndex:moviePlayer.playIdx];
    
    if (favBtn.selected)
    {
        [[Request request:kUNLikeAudioTag] unFavoritesAudio:[NSString stringWithFormat:@"%d",[[object objectForKey:@"voice_id"] intValue]]
                                               delegate:self];
        
        favBtn.selected = NO;
        [favBtn setImage:LoadImage(@"playNoLike", @"png") forState:UIControlStateNormal];
    }
    else
    {
        [[Request request:kLikeAudioTag] favoritesAudio:[NSString stringWithFormat:@"%d",[[object objectForKey:@"voice_id"] intValue]]
                                               delegate:self];
        
        favBtn.selected = YES;
        [favBtn setImage:LoadImage(@"playLike", @"png") forState:UIControlStateNormal];
        
    }
}

- (IBAction)goForward
{
    moviePlayer.playIdx ++;
    
    [self playAudioAtIndex:moviePlayer.playIdx];
    //    self.playIdx ++;
}

- (IBAction)goBack
{
    moviePlayer.playIdx --;
    
    [self playAudioAtIndex:moviePlayer.playIdx];
}

- (IBAction)play:(UIButton *)sender
{
    
    if (sender.selected == NO)
    {
        [moviePlayer playAudio];
    }
    else
    {
        [moviePlayer pauseAudio];
    }
    //    sender.selected = !sender.selected;
}

#pragma mark - PlayerListDelegate

- (void)didSelectedPlayerList:(NSString *)listId name:(NSString *)name
{
    NSDictionary *object = [self.mainlist objectAtIndex:moviePlayer.playIdx];
    
    [[Request request:kAddPlaylist] addPlayList:[NSString stringWithFormat:@"%d",[[object objectForKey:@"voice_id"] intValue]]
                                     playlistId:listId
                                       delegate:self];
}

#pragma mark - UMSocialUIDelegate
//友盟
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        //        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
        //        NSLog(@"%@",[response.data allKeys]);
//        [MTool showAlertViewWithMessage:@"分享成功"];
    }
}

#pragma mark - MoviePlayerDelegate

- (void)movePlayerStart:(MoviePlayer *)player
{
    
}

- (void)movePlayerPlaying:(MoviePlayer *)player
{
    //    if (moviePlayer.duration > 0 && moviePlayer.currentPlaybackTime >= moviePlayer.duration)
    //    {
    ////        [updateTimer setFireDate:[NSDate distantFuture]];
    //        playBtn.selected = NO;
    //        return;
    //    }
    
    CGRect frame = propressView.frame;
    if (moviePlayer.duration != 0)
    {
        frame.origin.x = MAXLEFT + (MAXRIGHT - MAXLEFT) * (moviePlayer.currentPlaybackTime/moviePlayer.duration) ;
    }
    else
    {
        frame.origin.x = MAXLEFT;
    }
    
    if (isnan(frame.origin.x))
    {
        frame.origin.x = MAXLEFT;
    }
    
    propressView.frame = frame;
    
    if (moviePlayer.duration > 0)
    {
        NSString *cur = [self formatTime:moviePlayer.currentPlaybackTime];
        NSString *dur = [self formatTime:moviePlayer.duration];
        timeLabel.text = [NSString stringWithFormat:@"%@/%@",cur,dur];
        playBtn.selected = YES;
    }
    else
    {
        timeLabel.text = @"0:00/0:00";
        playBtn.selected = NO;
    }
}

- (void)movePlayerPause:(MoviePlayer *)player
{
    playBtn.selected = NO;
}

- (void)movePlayerStop:(MoviePlayer *)player
{
    playBtn.selected = NO;
}

- (void)movePlayerDidFinished:(MoviePlayer *)player
{
    playBtn.selected = NO;
    [self goForward];
}

#pragma mark - AudioPropressDelegate

- (void)propressViewTouchBagin:(AudioPropress *)moveView
{
    //    [updateTimer setFireDate:[NSDate distantFuture]];
    [moviePlayer pauseAudio];
}

- (void)propressViewmoving:(AudioPropress *)moveView
{
    CGFloat value = ((moveView.frame.origin.x - MAXLEFT)/(MAXRIGHT - MAXLEFT));
    moviePlayer.currentPlaybackTime = value * moviePlayer.duration;
}

- (void)propressViewTouchEnd:(AudioPropress *)moveView
{
    if(moviePlayer.playbackState != MPMoviePlaybackStatePlaying)
    {
        //        [updateTimer setFireDate:[NSDate distantPast]];
        [moviePlayer playAudio];
        //        playBtn.selected = YES;
    }
}
#pragma mark -

- (void)playWithURL:(NSString *)url
{
    self.playing = YES;
    
    timeLabel.text = @"0:00/0:00";
    
    [moviePlayer playAudioWithURL:url];
}

- (void)updatePropress
{
}

- (void)popViewController {
    moviePlayer.delegate = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)autoLayout
{
    UIImageView *icon = nil;
    CGFloat width = 0;
    CGRect frame = CGRectZero;
    // 播放次数文字，图片不需要改
    width = [label0.text sizeWithFont:label0.font constrainedToSize:CGSizeMake(MAXFLOAT, 10)].width;
    frame = label0.frame;
    frame.size = CGSizeMake(width, 10);
    label0.frame = frame;
    // 评论次数的图片
    icon = (UIImageView *)[burlBackground viewWithTag:201];
    frame = icon.frame;
    frame.origin = CGPointMake(label0.frame.origin.x + label0.frame.size.width + 10, frame.origin.y);
    icon.frame = frame;
    // 评论次数
    width = [label1.text sizeWithFont:label1.font constrainedToSize:CGSizeMake(MAXFLOAT, 10)].width;
    frame = label1.frame;
    frame.size = CGSizeMake(width, 10);
    frame.origin = CGPointMake(icon.frame.origin.x + icon.frame.size.width + 5, frame.origin.y);
    label1.frame = frame;
    // 转发次数的图片
    icon = (UIImageView *)[burlBackground viewWithTag:202];
    frame = icon.frame;
    frame.origin = CGPointMake(label1.frame.origin.x + label1.frame.size.width + 10, frame.origin.y);
    icon.frame = frame;
    // 转发次数
    width = [label2.text sizeWithFont:label2.font constrainedToSize:CGSizeMake(MAXFLOAT, 10)].width;
    frame = label2.frame;
    frame.size = CGSizeMake(width, 10);
    frame.origin = CGPointMake(icon.frame.origin.x + icon.frame.size.width + 5, frame.origin.y);
    label2.frame = frame;
    // 喜欢次数的图片
    icon = (UIImageView *)[burlBackground viewWithTag:203];
    frame = icon.frame;
    frame.origin = CGPointMake(label2.frame.origin.x + label2.frame.size.width + 10, frame.origin.y);
    icon.frame = frame;
    // 喜欢次数
    width = [label3.text sizeWithFont:label3.font constrainedToSize:CGSizeMake(MAXFLOAT, 10)].width;
    frame = label3.frame;
    frame.size = CGSizeMake(width, 10);
    frame.origin = CGPointMake(icon.frame.origin.x + icon.frame.size.width + 5, frame.origin.y);
    label3.frame = frame;
}

- (void)displayInfo:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    CGRect sFrame = detailView.frame;
    CGFloat alpha = 1.0f;
    if (sender.selected == YES)
    {
        sFrame.origin.y = burlBackground.frame.origin.y + burlBackground.frame.size.height;
        alpha = 1.0;
    }
    else
    {
        sFrame.origin.y = burlBackground.frame.origin.y + burlBackground.frame.size.height - detailView.frame.size.height;
        alpha = 0.0;
    }
    [UIView animateWithDuration:0.5f animations:^
    {
        detailView.alpha = alpha;
        detailView.frame = sFrame;
    }];
}

- (IBAction)gotoLikelist
{
    NSDictionary *object = [self.mainlist objectAtIndex:moviePlayer.playIdx];
    
    Likelist *likelist = [[Likelist alloc] init];
    likelist.isLikelist = YES;
    likelist.voice_id   = [object valueForKey:@"voice_id"];
    likelist.user_id    = [object valueForKey:@"user_id"];
    
    [self.navigationController pushViewController:likelist animated:YES];
}

- (IBAction)gotozhuanfa
{
    NSDictionary *object = [self.mainlist objectAtIndex:moviePlayer.playIdx];
    
    Likelist *likelist = [[Likelist alloc] init];
    likelist.isLikelist = NO;
    likelist.voice_id   = [object valueForKey:@"voice_id"];
    likelist.user_id    = [object valueForKey:@"user_id"];
    [self.navigationController pushViewController:likelist animated:YES];
}

- (void)playAudioAtIndex:(int)index
{
    if (moviePlayer.playIdx > [self.mainlist count] - 1)
    {
        moviePlayer.playIdx = [self.mainlist count] - 1;
        return;
    }
    
    if (moviePlayer.playIdx < 0)
    {
        moviePlayer.playIdx = 0;
        return;
    }
    
    if (moviePlayer.playIdx == 0)
    {
        gobackBtn.enabled = NO;
    }
    else
    {
        gobackBtn.enabled = YES;
    }
    
    if (moviePlayer.playIdx == ([self.mainlist count] - 1))
    {
        goforwardBtn.enabled = NO;
    }
    else
    {
        goforwardBtn.enabled = YES;
    }
    
    [moviePlayer playAudioAiIndex:index];
    
    NSDictionary *object = [self.mainlist objectAtIndex:index];
    
    UserInfo *info = [UserInfo standardUserInfo];
    [[Request request:kVoiceInfoTag] getVoiceInfo:info.user_id
                                          voiceId:[object valueForKey:@"voice_id"]
                                             type:self.isGroup ? 2 : 1
                                         delegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
