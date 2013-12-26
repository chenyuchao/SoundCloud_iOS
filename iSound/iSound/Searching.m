//
//  Searching.m
//  iSound
//
//  Created by Jumax.R on 13-9-28.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import "Searching.h"

#define kUPHeight 26

#define kDownHeight 88

@interface Searching ()

@end

@implementation Searching

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"搜  索";
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 39)];
    titleView.backgroundColor = [UIColor colorWithPatternImage:LoadImage(@"SearchBG", @"png")];
    
    search = [[UITextField alloc] initWithFrame:CGRectMake(75, 0, 195, 23)];
    search.delegate = self;
    search.center = CGPointMake(search.center.x, titleView.frame.size.height/2);
    search.backgroundColor = CLEARCOLOR;
    
    UIButton *searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(270, 0, 19, 18)];
    [searchBtn setImage:LoadImage(@"SearchBtn", @"png") forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    searchBtn.center = CGPointMake(searchBtn.center.x, titleView.frame.size.height/2);
    [titleView addSubview:searchBtn];
    
    
    
    [titleView addSubview:search];
    
    [mainTableView addSubview:titleView];
    
    indexView = [[UIView alloc] initWithFrame:CGRectMake(22, 4, 48, kUPHeight)];
    indexView.backgroundColor = ARGB(238.0f, 238.0f, 238.0f, 1.0f);
    indexView.clipsToBounds   = YES;
    
    
    titleArray = [[NSArray alloc] initWithObjects:@"声音",@"用户",@"群组", nil];
    
    for (NSInteger i = 0; i < 3; i ++)
    {
        UIButton *butotn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0 + 30*i , 48, 32)];
        butotn.tag = 100 + i;
        butotn.backgroundColor = [UIColor whiteColor];
        butotn.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        [butotn setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
        [butotn setTitleColor:ARGB(250.0f, 128.0f, 54.0f, 1.0f) forState:UIControlStateNormal];
        [butotn addTarget:self action:@selector(tableBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0)
        {
            butotn.selected = YES;
        }
        
        [indexView addSubview:butotn];
    }
    [mainTableView addSubview:indexView];
    [mainTableView setContentSize:CGSizeMake(0, ScreenHeight - 64 - 49 + 1)];
    
    UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(40, 15, 8, 4)];
    [arrow setImage:[UIImage imageNamed:@"arrow.png"]];
    [indexView addSubview:arrow];
}

- (void)searchButtonPressed
{
    [self textFieldShouldReturn:search];
}

- (void)tableBtnPressed:(UIButton *)button
{
    CGRect frame = indexView.frame;
    frame.size.height = frame.size.height == kUPHeight ? kDownHeight : kUPHeight;
    indexView.frame = frame;
    
    NSInteger i = (button.frame.origin.y - 2)/30;
    
    selectedType = i;
    
    UIButton *firstBtn  = (UIButton *)[indexView viewWithTag:100];
    
    NSString *fromtitle = [button.titleLabel.text copy];
    NSString *totitle   = [firstBtn.titleLabel.text copy];
    [firstBtn setTitle:fromtitle forState:UIControlStateNormal];
    [button setTitle:totitle forState:UIControlStateNormal];
    
}

- (IBAction)pushController:(UIButton *)sender {

    switch (sender.tag)
    {
        case 0:
        {
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择搜索来源.."
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                 destructiveButtonTitle:nil
                                                      otherButtonTitles:@"按声音标签",@"按用户标签",@"按群组标签", nil];
            [sheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
            [sheet showInView:self.tabBarController.view];
        }
            break;
            case 1:
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            Sound *likeAudio = [storyboard instantiateViewControllerWithIdentifier:@"Sound"];
            likeAudio.soundAudioType = SOUNDTYPE_LIKE;
            [likeAudio setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:likeAudio animated:YES];
        }
            break;
        case 2:
        {
            RenqiWang *userLike = [[RenqiWang alloc] init];
            [userLike setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:userLike animated:YES];
        }
            break;
        case 3:
        {
            GroupRanking *group = [[GroupRanking alloc] init];
            group.hideAddGroup  = YES;
            [group setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:group animated:YES];
        }
            break;
        default:
        {
            Center_ViewController *controller = [[Center_ViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 2) return;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y > 20.f)
    {
        CGRect frame = indexView.frame;
        frame.size.height = kUPHeight;
        indexView.frame = frame;
        
        [search resignFirstResponder];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{

    [textField resignFirstResponder];
    
    if (textField.text.length < 1)
    {
        return YES;
    }
    
    if (indexView.frame.size.height == kUPHeight)
    {
//        [Request request:kUPHeightTag] 
    }
    else if (indexView.frame.size.height == kDownHeight)
    {
        
    }
    
    UIButton *firstBtn  = (UIButton *)[indexView viewWithTag:100];
    if ([firstBtn.titleLabel.text isEqualToString:@"声音"])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        Sound *likeAudio = [storyboard instantiateViewControllerWithIdentifier:@"Sound"];
        likeAudio.soundAudioType = SOUNDTYPE_KEYWORLD;
        likeAudio.keyWorld = textField.text;
        [likeAudio setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:likeAudio animated:YES];
    }
    else if ([firstBtn.titleLabel.text isEqualToString:@"用户"])
    {
        RenqiWang *userLike = [[RenqiWang alloc] init];
        userLike.isRanking = YES;
        userLike.keyworld = textField.text;
        [userLike setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:userLike animated:YES];
    }
    else if ([firstBtn.titleLabel.text isEqualToString:@"群组"])
    {
        GroupRanking *group = [[GroupRanking alloc] init];
        group.keyworld = textField.text;
        group.hideAddGroup  = YES;
        [group setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:group animated:YES];
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end