//
//  UserCenter.m
//  iSound
//
//  Created by Jumax.R on 13-9-27.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import "UserCenter.h"
#import "SoundCell.h"
#import "Activity.h"
#import "UserGroup.h"
#import "Favroites.h"
#import "UserDescription.h"
#import "FansList.h"
#import "PlayerList.h"
#import "SoundList.h"
#import "SoundSaved.h"

@interface UserCenter ()

@end

@implementation UserCenter

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    
    if ([viewController isKindOfClass:([UserCenter class])])
    {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    else
    {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fabuFromCenter:)
                                                 name:@"FABUAUDIO"
                                               object:nil];

    self.navigationController.tabBarItem.badgeValue = nil;
    
    lastIndex = -1000;
    
    [(UITableView *)self.view setTableHeaderView:headerTableView];
    [headView.layer setCornerRadius:5];
    [headView.layer setMasksToBounds:YES];
    [headView.layer setBorderColor:[UIColor whiteColor].CGColor];
	[headView.layer setCornerRadius:30];
	[headView.layer setBorderWidth:2];
    
    backGround = [[UIView alloc] initWithFrame:CGRectMake(0, -20, 320, 30)];
    backGround.backgroundColor = ARGB(250, 18, 55, 1.0);
    [headerTableView insertSubview:backGround atIndex:0];
    
    userinfo = [UserInfo standardUserInfo];
    if (![self.userid isEqualToString:userinfo.user_id] && self.userid)
    {
        [self centerComeFromOtherUser];
    }
    else
    {
        gzButton.hidden = YES;
        self.userid = userinfo.user_id;
    }
    returnButton.hidden = !self.displayReturn;
}

- (void)fabuFromCenter:(NSNotification *)info
{
    [self.m4aAudioArray removeObjectAtIndex:[[info object] intValue]];
    [self.m4aAudioArray writeToFile:M4ARECORDPATH atomically:YES];
    [((UITableView *)self.view) reloadData];
}

- (void)refresh {

    if (![self.userid isEqualToString:userinfo.user_id] && self.userid)
        [[Request request] getOtherUserCenterData:userinfo.user_id
                                       otherUname:self.userid
                                             page:1
                                         per_page:100
                                         delegate:self];
    else
        [[Request request] getUserCenterData:userinfo.user_id
                                        page:1
                                    per_page:100
                                    delegate:self];
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self refresh];
}

- (void)downloadDidFail:(Request *)request WithError:(NSError *)error {

    [[(UITableView *)self.view pullToRefreshView] performSelector:@selector(stopAnimating)
                                                       withObject:nil
                                                       afterDelay:1];
}

- (void)downloadDidFinish:(Request *)request withResult:(id)result {
    
    [[(UITableView *)self.view pullToRefreshView] performSelector:@selector(stopAnimating)
                                                       withObject:nil
                                                       afterDelay:1];
    if ([[result valueForKey:@"code"] intValue] != 200)
    {
        [Custom messageWithString:[[result valueForKey:@"msg"] valueForKey:@"msg"]];
        return;
    }
    
    if (request.requestId == 100)
    {
        [self refresh];
        return;
    }
    if (request.requestId == 200)
    {
        gzButton.tag = -gzButton.tag;
        if (gzButton.tag == -1)
            [gzButton setImage:[UIImage imageNamed:@"YGZ"]
                      forState:UIControlStateNormal];
        else
            [gzButton setImage:[UIImage imageNamed:@"JGZ"]
                      forState:UIControlStateNormal];
        return;
    }
    if ([[[result valueForKey:@"data"] valueForKey:@"voice_list"] isKindOfClass:[NSArray class]])
    {
        self.m4aAudioArray = [NSMutableArray arrayWithContentsOfFile:M4ARECORDPATH];
        self.mainlist = [NSArray arrayWithArray:[[result valueForKey:@"data"] valueForKey:@"voice_list"]];
        [(UITableView *)self.view reloadData];
    }
    
    NSDictionary *object = [[result valueForKey:@"data"] valueForKey:@"personal_information"];
    
    follow.text   = [object valueForKey:@"follow_num"];
    fans.text     = [object valueForKey:@"fans_num"];
    sound.text    = [object valueForKey:@"sound_num"];
    name.text     = [object valueForKey:@"nickname"];
    userSign.text = [object valueForKey:@"profile"];
    
    if ([userinfo.user_id isEqualToString:self.userid])
    {
        userinfo.nickname  = [object valueForKey:@"nickname"];
        userinfo.sign      = [object valueForKey:@"profile"];
        userinfo.follow    = [object valueForKey:@"follow_num"];
        userinfo.fans      = [object valueForKey:@"fans_num"];
        userinfo.sound     = [object valueForKey:@"sound_num"];
        userinfo.head_image= [object valueForKey:@"head_img"];
    }
    else
    {
        if ([[object valueForKey:@"follow_state"] intValue] == 0)
        {
            [gzButton setTag:1];
            [gzButton setImage:[UIImage imageNamed:@"JGZ"]
                      forState:UIControlStateNormal];
        }
        else
        {
            [gzButton setTag:-1];
            [gzButton setImage:[UIImage imageNamed:@"YGZ"]
                      forState:UIControlStateNormal];
        }
    }
    NSInteger followCount = [[object valueForKey:@"follow_num"] intValue];
    NSInteger fansCount   = [[object valueForKey:@"fans_num"]   intValue];
    NSInteger soundCount  = [[object valueForKey:@"sound_num"]  intValue];
    
    if (followCount > 100000)
    {
        follow.text = [NSString stringWithFormat:@"%i万",followCount / 10000];
    }
    if (fansCount > 100000)
    {
        fans.text = [NSString stringWithFormat:@"%i万",fansCount / 10000];
    }
    if (soundCount > 100000)
    {
        sound.text = [NSString stringWithFormat:@"%i万",soundCount / 10000];
    }
    self.userhead  = [object valueForKey:@"head_img"];
    headView.image = [[Downloader downloader] loadingWithURL:self.userhead
                                                       index:0
                                                    delegate:self
                                                     cacheTo:Document];
}
//
- (IBAction)addFollow:(UIButton *)sender {
    
    if (sender.tag == 1)
    {
        [[Request request:200] addFollow:userinfo.user_id
                                targetId:self.userid
                                delegate:self];
    }
    else
    {
        [[Request request:200] cancelFollow:userinfo.user_id
                                   targetId:self.userid
                                   delegate:self];
    }
}

- (void)centerComeFromOtherUser {
    
    iMessage.hidden = YES;
    
    iPlayList.frame = CGRectMake(0, 0, 106.5, 35);
    iLike.frame = CGRectMake(106.5, 0, 106.5, 35);
    iGroup.frame = CGRectMake(213, 0, 106.5, 35);
}

- (IBAction)pushViewController:(UIButton *)sender {
    
    if (sender.tag == 0)
    {
        PlayerList *list = [[PlayerList alloc] init];
        list.comfromCenter = YES;
        list.userid = self.userid;
        [list setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:list animated:YES];
        return;
    }
    if (sender.tag == 1)
    {
        Activity *activity = [[Activity alloc] init];
        [activity setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:activity animated:YES];
        return;
    }
    if (sender.tag == 2)
    {
        Favroites *favorites = [[Favroites alloc] init];
        favorites.userid = self.userid;
        [favorites setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:favorites animated:YES];
        return;
    }
    if (sender.tag == 3)
    {
        UserGroup *group = [[UserGroup alloc] init];
        group.comfromCenter = YES;
        group.userid = self.userid;
        [group setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:group animated:YES];
        return;
    }
    if (sender.tag == 4)
    {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
}

- (void)downloaderDidFinish:(Downloader *)downloader object:(UIImage *)object {
    
    headView.image = object;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.y < 0)
    {
        CGRect frame = backGround.frame;
        frame.origin = CGPointMake(0, scrollView.contentOffset.y);
        frame.size   = CGSizeMake(320, fabs(scrollView.contentOffset.y) + 30);
        backGround.frame = frame;
    }
}

- (void)touchUpInsideAtImageView:(JRImageView *)touchView {
    
     UserDescription *description = [[UserDescription alloc] init];
     description.userhead = self.userhead;
     description.userid = self.userid;
    [description setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:description animated:YES];
}

- (void)touchUpInsideAtTouchView:(JRTouchView *)touchView {
    
    if (touchView.tag == 0)
    {
        FansList *fansilist  = [[FansList alloc] init];
        fansilist.isFanslist = NO;
        fansilist.userid = self.userid;
        [fansilist setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:fansilist animated:YES];
        return;
    }
    if (touchView.tag == 1)
    {
        FansList *fansilist = [[FansList alloc] init];
        fansilist.isFanslist = YES;
        fansilist.userid = self.userid;
        [fansilist setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:fansilist animated:YES];
        return;
    }
    if (touchView.tag == 2)
    {
        SoundList *list = [[SoundList alloc] init];
        list.userid = self.userid;
        [list setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:list animated:YES];
        return;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 84;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.mainlist count] + [self.m4aAudioArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    
    static NSString *identifier = @"SoundCell";
    
    SoundCell *cell = (SoundCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SoundCell" owner:self
                                            options:nil] objectAtIndex:0];
    }
    NSDictionary *object;
    if (row < [self.m4aAudioArray count] && [self.m4aAudioArray count] > 0)
    {
        object = [self.m4aAudioArray objectAtIndex:row];
    }
    else
    {
        object = [self.mainlist objectAtIndex:row - [self.m4aAudioArray count]];
    }
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:object];
    if ([self.userid isEqualToString:userinfo.user_id] && self.userid)
    {
        [dictionary setObject:[userinfo nickname] forKey:@"nickname"];
    }
    cell.dataDict  = dictionary;
    cell.soundType = [[object valueForKey:@"type"] intValue];
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [self.m4aAudioArray count] && [self.m4aAudioArray count] > 0)
    {
        [tableView setEditing:NO animated:YES];
        return UITableViewCellEditingStyleNone;
    }
    [tableView setEditing:YES animated:YES];
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [self.m4aAudioArray count] && [self.m4aAudioArray count] > 0)
    {
        return NO;
    }
    return [self.userid isEqualToString:userinfo.user_id];
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"安全警告"
                                                        message:@"此操作不可逆，确定要删除吗？"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
    alertView.tag = indexPath.row;
    [alertView show];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row < [self.m4aAudioArray count] && [self.m4aAudioArray count] > 0)
    {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请选择操作..."
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:@"发布",@"删除", nil];
        sheet.tag = indexPath.row;
        [sheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
        [sheet showInView:self.tabBarController.view];
        return;
    }
    
    if (lastIndex != -100)
    {
        lastIndex = indexPath.row;
    }
    SoundDetail *detail = [[SoundDetail alloc] init];
    detail.mainlist = self.mainlist;
    MoviePlayer *moviePlayer = [MoviePlayer standardMoviePlayer];
    moviePlayer.playlist     = self.mainlist;
    detail.isGroup = NO;
    
    if (lastIndex == moviePlayer.playIdx)
        moviePlayer.isPlaying = !moviePlayer.isPlaying ? NO : YES;
    else
        moviePlayer.isPlaying = NO;
    
    [detail setHidesBottomBarWhenPushed:YES];
    moviePlayer.playIdx = indexPath.row;
    if (lastIndex == -100)
    {
        lastIndex = indexPath.row;
    }
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0)
    {
        SoundSaved *saved = [[SoundSaved alloc] init];
        saved.willFabuIndex = actionSheet.tag;
        saved.recordPath = [[self.m4aAudioArray objectAtIndex:actionSheet.tag] objectForKey:@"path"];
        saved.comeFromUserCenter = YES;
        UINavigationController *nav = [Custom defaultNavigationController:saved];
        [self presentModalViewController:nav animated:YES];
    }
    else if (buttonIndex == 1)
    {
        int row = actionSheet.tag;

        [[NSFileManager defaultManager] removeItemAtPath:[[self.m4aAudioArray objectAtIndex:row] objectForKey:@"path"] error:nil];
        [self.m4aAudioArray removeObjectAtIndex:row];
        [self.m4aAudioArray writeToFile:M4ARECORDPATH atomically:YES];
        [(UITableView *)self.view reloadData];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (alertView.tag < [self.m4aAudioArray count] && [self.m4aAudioArray count] > 0)
    {
        return;
    }
    if (buttonIndex == 1)
    {
        NSDictionary *object = [self.mainlist objectAtIndex:alertView.tag];
        [[Request request:100] deleteUsesrAudio:[object valueForKey:@"user_id"]
                                         audoId:[object valueForKey:@"voice_id"]
                                       delegate:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end


