//
//  Sound.m
//  iSound
//
//  Created by Jumax.R on 13-9-27.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import "Sound.h"
#import "SoundDetail.h"
#import "UserGroup.h"

@interface Sound ()

@end

@implementation Sound
@synthesize soundAudioType;
@synthesize mainlist;
@synthesize keyWorld;
@synthesize guanzhuButton;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, 177, 29)];
        
    if (soundAudioType == SOUNDTYPE_NOR)
    {
        CGRect frame[] = {  CGRectMake(0, 0, 60, 29),
                            CGRectMake(59, 0, 60, 29),
                            CGRectMake(118, 0, 60, 29)
        };
        
        for (NSInteger i = 0; i < 3; i ++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = frame[i];
            button.tag = i;
            NSString *nor = [NSString stringWithFormat:@"SoundBtn%d_0",i];
            [button setImage:LoadImage(nor, @"png") forState:UIControlStateNormal];
            NSString *sel = [NSString stringWithFormat:@"SoundBtn%d_1",i];
            [button setImage:LoadImage(sel, @"png") forState:UIControlStateSelected | UIControlStateHighlighted];
            [button setImage:LoadImage(sel, @"png") forState:UIControlStateSelected];
            
            if (i == 0)
            {
                self.guanzhuButton = button;
                button.selected = YES;
            }
            [button addTarget:self action:@selector(topButtonPressed:) forControlEvents:UIControlEventTouchDown];
            [selectView addSubview:button];
        }
        self.navigationItem.titleView = selectView;
        [self reloadTableView:nil];
        
        // 下拉刷新
        __block UIViewController *controller = self;
        [soundTableView addPullToRefreshWithActionHandler:^{
            [controller performSelector:@selector(reloadTableView:) withObject:nil];
        }];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(refreshUserCenter)
                                                     name:@"MessageNotification"
                                                   object:nil];
    }
    else
    {
        self.mainlist = [[NSMutableArray alloc] init];
        
        UIButton *returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
        returnButton.frame = CGRectMake(0, 0, 28, 28);
        [returnButton addTarget:self
                         action:@selector(popViewController)
               forControlEvents:UIControlEventTouchUpInside];
        [returnButton setImage:[UIImage imageNamed:@"return"]
                      forState:UIControlStateNormal];
        self.navigationItem.leftBarButtonItem = CUSTOMVIEW(returnButton);
        
        self.title = @"热门音频排行榜";
        
        if (soundAudioType == SOUNDTYPE_KEYWORLD)
        {
            self.title = @"音频搜索";
        }
        
        likeMoreIndex = 0;
        [self loadMoreLike];
        
        // 下拉刷新
        __block UIViewController *controller = self;
        [soundTableView addPullToRefreshWithActionHandler:^{
            [controller performSelector:@selector(loadMoreLike) withObject:nil];
        }];
    }
    soundScrollView.delegate = self;
        
    rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 28, 28);
    [rightButton addTarget:self
                   action:@selector(playing)
         forControlEvents:UIControlEventTouchUpInside];
    [rightButton setImage:[UIImage imageNamed:@"RightTopButton"]
                forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = CUSTOMVIEW(rightButton);
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadTableView:)
                                                 name:@"ReloadTableViewOfHome"
                                               object:nil];
}

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)refreshUserCenter {

    UIViewController *viewController = [[self.tabBarController viewControllers] objectAtIndex:1];
    viewController.tabBarItem.badgeValue = @"···";
}

- (void)loadKeyWorld
{
    
}

- (void)backToGroupList {

    soundTableView.hidden = YES;
    soundScrollView.hidden = NO;
    self.navigationItem.leftBarButtonItem = nil;
}

- (void)loadMoreLike
{
//    likeMoreIndex ++;
    
    if (soundAudioType == SOUNDTYPE_LIKE)
    {
        [[Request request:kSoundListTag] audioLikePage:@"1"
                                              per_page:@"200"
                                          Withdelegate:self];
    }
    else if (soundAudioType == SOUNDTYPE_KEYWORLD)
    {
        [[Request request:kWorldTag] searchAudioWithKeyworld:keyWorld
                                                       pages:@"1"
                                                     numbers:@"200"
                                                    delegate:self];
    }
    
}

- (void)topButtonPressed:(UIButton *)button
{
    for (UIButton *btn  in selectView.subviews)
    {
        btn.selected = NO;
    }
    
    button.selected = YES;

    soundType = button.tag;
    
    if (soundAudioType == SOUNDTYPE_NOR)
    {
        self.navigationItem.leftBarButtonItem = nil;
    }
    
    
    switch (button.tag)
    {
        case 0:
            soundTableView.hidden = NO;
            soundScrollView.hidden = YES;
            [self reloadTableView:nil];
            break;
        case 1:
            [[soundScrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
            soundTableView.hidden = YES;
            soundScrollView.hidden = NO;
            [self reloadTableView:nil];
            break;
        case 2:
            [[soundScrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
            soundTableView.hidden = YES;
            soundScrollView.hidden = NO;
            [self reloadTableView:nil];
            break;
        default:
            break;
    }
    
    if (button.tag > 0)
    {
        _refreshHeaderView = nil;
        _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -soundScrollView.bounds.size.height, soundScrollView.frame.size.width, soundScrollView.bounds.size.height)];
        _refreshHeaderView.tag = 99998;
        _refreshHeaderView.delegate = self;
        [soundScrollView addSubview:_refreshHeaderView];
        [soundScrollView bringSubviewToFront:_refreshHeaderView];
        [_refreshHeaderView refreshLastUpdatedDate];
    }

}

- (void)reloadTableView:(NSNotification *)info
{
    UserInfo *userinfo = [UserInfo standardUserInfo];
    if (soundAudioType != SOUNDTYPE_NOR)
    {
        return;
    }
    switch (soundType)//首页三个按钮状态
    {
        case 0:
        {
            [[Request request:kSoundListTag] getSoundList:userinfo.user_id
                                                    pages:1
                                                 delegate:self];
        }
            break;
        case 1:
        {
            if (self.navigationItem.leftBarButtonItem == nil)
            {
                [[Request request:kGroupListTag] getGroupList:userinfo.user_id
                                                        pages:1
                                                       number:100
                                                     delegate:self];
            }
            else
            {
                [[Request request:kGroupAudioListTag] getGroupAudioList:self.groupId
                                                                  pages:1
                                                                numbers:100
                                                               delegate:self];
            }
        }
            
            break;
        case 2:
        {
            [[Request request:kFindVoiceTag] findVoiceWithPages:@"1"
                                                        numbers:@"100"
                                                       delegate:self];
        }
            break;
        default:
            break;
    }
    
}

- (void)downloadWillStart:(Request *)request
{
    if (request.requestId == kFindVoiceTag)
    {
        _reloading = YES;
    }
}

- (void)downloadDidFail:(Request *)request WithError:(NSError *)error {
    
    if (request.requestId == kFindVoiceTag)
    {
        _reloading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:soundScrollView];
    }
    
    [[soundTableView pullToRefreshView] performSelector:@selector(stopAnimating)
                                             withObject:nil
                                             afterDelay:1];
}

- (void)downloadDidFinish:(Request *)request withResult:(id)result {
    
    if (request.requestId == kFindVoiceTag || request.requestId == kGroupListTag)
    {
        _reloading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:soundScrollView];
    }

    [[soundTableView pullToRefreshView] performSelector:@selector(stopAnimating)
                                             withObject:nil
                                             afterDelay:1];
    
    if ([[result valueForKey:@"code"] intValue] != 200)
    {
        return;
    }
    
    if ([[result valueForKey:@"data"] count] > 0)
    {
        if (soundAudioType == SOUNDTYPE_NOR)
        {
            self.mainlist = [NSMutableArray arrayWithArray:[result valueForKey:@"data"]];
            
            if (request.requestId == kGroupAudioListTag)
            {
                soundTableView.hidden = NO;
                soundScrollView.hidden = YES;
                
                UIButton *returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
                returnButton.frame = CGRectMake(0, 0, 28, 28);
                [returnButton addTarget:self
                                 action:@selector(backToGroupList)
                       forControlEvents:UIControlEventTouchUpInside];
                [returnButton setImage:[UIImage imageNamed:@"return"]
                              forState:UIControlStateNormal];
                self.navigationItem.leftBarButtonItem = CUSTOMVIEW(returnButton);
            }
            else
            {
                if (soundType == 1)
                {
                    self.grouplist = [NSMutableArray arrayWithArray:[result valueForKey:@"data"]];
                    [self reloadContent:@"group_name" imagePath:@"group_logo"];
                    return;
                }
                else if (soundType == 2)
                {
                    
                    [self reloadContent:@"city" imagePath:@"image_path"];
                    return;
                }
            }
        }
        else if (soundAudioType == SOUNDTYPE_LIKE)
        {
//            NSLog(@"%@",request.url);
            
            NSArray *array = [[result valueForKey:@"data"] objectForKey:@"like_list"];
            if ([array isKindOfClass:[NSArray class]])
            {
                [self.mainlist insertObjects:array atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [array count])]];
            }
            else
            {
                soundTableView.tableFooterView = nil;
            }
        }
        else if (soundAudioType == SOUNDTYPE_KEYWORLD)
        {
            NSArray *array = [result valueForKey:@"data"];
            
            if ([array isKindOfClass:[NSArray class]])
            {
                [self.mainlist insertObjects:array atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [array count])]];
            }
        }
    }
    else if ([[result valueForKey:@"data"] count] == 0)
    {
        self.mainlist = nil;
        
        if (request.requestId == kGroupAudioListTag)
        {
            [Custom messageWithString:@"这里还木有数据哦~"];
            return;
        }
        else if (request.requestId == kWorldTag)
        {
            [Custom messageWithString:@"搜索结果为空"];
            return;
        }
    }
    [soundTableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    MoviePlayer *moviePlayer = [MoviePlayer standardMoviePlayer];
    rightButton.hidden  = !moviePlayer.isPlaying;
    
    [self topButtonPressed:guanzhuButton];
}

#pragma mark - xib Method

- (IBAction)playing
{
    
    SoundDetail *detail = [[SoundDetail alloc] init];
    detail.mainlist = self.mainlist;
    MoviePlayer *moviePlayer = [MoviePlayer standardMoviePlayer];
    moviePlayer.playlist     = self.mainlist;
    
    moviePlayer.isPlaying = YES;
    [detail setHidesBottomBarWhenPushed:YES];
    moviePlayer.playIdx      = moviePlayer.playIdx;
    

//    moviePlayer.isPlaying = YES;
    [detail setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)loadPage
{
    [self reloadTableView:nil];
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self loadPage];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag != 10)
        return;
    
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.tag != 10) return;
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (scrollView.tag != 10) return;
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}


#pragma mark - tableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 84;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.mainlist count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *identifier = @"SoundCell";
    SoundCell *cell = (SoundCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SoundCell" owner:self options:Nil] objectAtIndex:0];
    }
    
    cell.dataDict = [self.mainlist objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {


    
    SoundDetail *detail = [[SoundDetail alloc] init];
    detail.mainlist = self.mainlist;
    MoviePlayer *moviePlayer = [MoviePlayer standardMoviePlayer];
    moviePlayer.playlist     = self.mainlist;
    detail.isGroup = soundType == 1 ? YES : NO;
    
    if (moviePlayer.touchTarget == indexPath)
    {
        if (!moviePlayer.isPlaying)
        {
            moviePlayer.isPlaying = NO;
        }
        else
        {
            moviePlayer.isPlaying = YES;
        }
    }
    else
    {
        moviePlayer.isPlaying = NO;
    }
    [detail setHidesBottomBarWhenPushed:YES];
     moviePlayer.playIdx      = indexPath.row;
    
    moviePlayer.touchTarget = indexPath;

    [self.navigationController pushViewController:detail animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    if (soundType == 1)
    {
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        textLabel.backgroundColor = ARGB(255, 255, 255, 0.8);
        textLabel.font = [Custom systemFont:13];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.text = self.groupTitle;
        return textLabel;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return soundType == 1 ? 40 : 0;
}

- (void)reloadContent:(NSString *)title imagePath:(NSString *)path {
    
    CGFloat lastY = 0;
    int idx = self.mainlist.count;
    
    for (int i = 0; i < idx; i++)
    {
        lastY  = i / 3 * 106 + 5;
        if (soundType == 1)
        {
            GroupElement *element = [[GroupElement alloc] initWithFrame:CGRectMake((i % 3) * 106 + 3.5, lastY, 100, 100)];
            element.tag = i;
            element.delegate = self;
            [soundScrollView addSubview:element];
            NSString *object = [self.mainlist objectAtIndex:i];
            element.titleLabel.text = [object valueForKey:title];
            [element setImage:[object valueForKey:@"group_logo"]];
        }
        else if (soundType == 2)
        {
            FindElement *element = [[FindElement alloc] initWithFrame:CGRectMake((i % 3) * 106 + 3.5, lastY, 100, 100)];
            element.tag = i;
            element.delegate = self;
            [soundScrollView addSubview:element];
            NSString *object = [self.mainlist objectAtIndex:i];
            element.titleLabel.text = [object valueForKey:title];
            [element setImage:[object valueForKey:@"image_path"]];
        }
        
    }
    soundScrollView.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        soundScrollView.alpha = 1;
    }];
    
    if (_refreshHeaderView == nil)
    {
        _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -soundScrollView.bounds.size.height, soundScrollView.frame.size.width, soundScrollView.bounds.size.height)];
        _refreshHeaderView.delegate = self;
        [soundScrollView addSubview:_refreshHeaderView];
        [soundScrollView bringSubviewToFront:_refreshHeaderView];
    }
    [_refreshHeaderView refreshLastUpdatedDate];
    
    CGFloat contentHeight = lastY + 111;
    if (contentHeight <= soundScrollView.frame.size.height)
    {
        contentHeight = soundScrollView.frame.size.height + 1;
    }
    [soundScrollView setContentSize:CGSizeMake(0, contentHeight)];
}

- (void)touchUpInsideAtTouchView:(JRTouchView *)touchView {

    if (soundType == 1)
    {
        NSDictionary *object = [self.grouplist objectAtIndex:touchView.tag];
        self.groupTitle = [object valueForKey:@"group_name"];
        self.groupId    = [object valueForKey:@"group_id"];
        [[Request request:kGroupAudioListTag] getGroupAudioList:[object valueForKey:@"group_id"]
                                                          pages:1
                                                        numbers:100
                                                       delegate:self];
    }
    else
    {
        SoundDetail *detail = [[SoundDetail alloc] init];
        detail.mainlist = self.mainlist;
        MoviePlayer *moviePlayer = [MoviePlayer standardMoviePlayer];
        moviePlayer.playlist     = self.mainlist;
        
        if (moviePlayer.touchTarget == touchView)
        {
            if (!moviePlayer.isPlaying)
            {
                moviePlayer.isPlaying = NO;
            }
            else
            {
                moviePlayer.isPlaying = YES;
            }
        }
        else
        {
            moviePlayer.isPlaying = NO;
        }
        [detail setHidesBottomBarWhenPushed:YES];
        moviePlayer.playIdx      = touchView.tag;
        
        moviePlayer.touchTarget = touchView;

        [self.navigationController pushViewController:detail animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
