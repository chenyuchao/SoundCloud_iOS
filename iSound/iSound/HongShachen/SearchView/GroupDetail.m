//
//  GroupDetail.m
//  iSound
//
//  Created by MaoHeng Zhang on 13-11-17.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import "GroupDetail.h"

@interface GroupDetail ()

@end

@implementation GroupDetail
@synthesize groupDict;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
    returnButton.frame = CGRectMake(0, 0, 28, 28);
    [returnButton addTarget:self
                     action:@selector(popViewController)
           forControlEvents:UIControlEventTouchUpInside];
    [returnButton setImage:[UIImage imageNamed:@"return"]
                  forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = CUSTOMVIEW(returnButton);
    
    [[Request request:kGroupDetail] groupDetailWithGroup_id:self.group_id Withdelegate:self];
}

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)downloadDidFinish:(Request *)request withResult:(id)result
{
    NSLog(@"%@",result);
    switch (request.requestId)
    {
        case kAppGroupTag:
        {
            if ([[result objectForKey:@"code"] intValue] != 200)
            {
                [MTool showAlertViewWithMessage:[[result objectForKey:@"error"] objectForKey:@"msg"]];
            }
            else
            {
                [MTool showAlertViewWithMessage:[result objectForKey:@"msg"]];
            }
        }
            break;
        case kDeleteGroup:
        {
            if ([[result valueForKey:@"code"] intValue] != 200)
            {
                return;
            }
            
            [self popViewController];
        }
            break;
            case kGroupDetail:
        {
            if ([[result valueForKey:@"code"] intValue] != 200)
            {
                return;
            }
            
            self.groupDict = [result valueForKey:@"data"];
            
            if ([[groupDict objectForKey:@"create_user_id"] isEqualToString:[[UserInfo standardUserInfo] user_id]])
            {
                //解散 id == create_user_id
                
                rqBtn.tag = 100;
                [rqBtn setImage:LoadImage(@"JSQ", @"png") forState:UIControlStateNormal];
            }
            else
            {
                //加入 id != create_user_id
                //退群
                NSInteger isNumber = [[self.groupDict objectForKey:@"is_member"] intValue];
                
                if (isNumber == 1)
                {
                    rqBtn.tag = 300;
                    [rqBtn setImage:LoadImage(@"exitGroup", @"png") forState:UIControlStateNormal];
                }
                else
                {
                    rqBtn.tag = 200;
                    [rqBtn setImage:LoadImage(@"SQRQ", @"png") forState:UIControlStateNormal];

                }
            }
            
            NSString *headURL = [groupDict objectForKey:@"group_logo"];
            titleLabel.text = [groupDict objectForKey:@"group_name"];
            peopleLabel.text = [NSString stringWithFormat:@"(当前人数: %d人   声音数量：%@个)",[[groupDict objectForKey:@"user_count"] intValue],
                                [groupDict objectForKey:@"voice_num"]];
            masterLabel.text = [NSString stringWithFormat:@"群主: %@", [groupDict objectForKey:@"create_nickname"]];
            textView.text = [groupDict objectForKey:@"group_profile"];
            
            [[Downloader downloader] loadingWithURL:headURL index:0 delegate:self cacheTo:Temp];
        }
            break;
            case kLogoutGroup:
        {
            if ([[result valueForKey:@"code"] intValue] != 200)
            {
                return;
            }
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"已退出该群组" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            alertView.tag = kXXXXXTag;
            [alertView show];
            
        }
            break;
        default:
            break;
    }
    
}

#pragma mark - xxx

- (IBAction)chakan
{
    if ([[self.groupDict objectForKey:@"is_member"] intValue] != 1 &&
        [[self.groupDict objectForKey:@"is_master"] intValue] != 1)
    {
        [Custom messageWithString:@"不是当前群组内成员无法查看该群组成员"];
        return;
    }
    
    GroupMenber *menber = [[GroupMenber alloc] init];
    menber.userid = self.userid;
    menber.groupid = [groupDict objectForKey:@"group_id"];
    [self.navigationController pushViewController:menber animated:YES];
}

- (IBAction)deleteGroup
{
    if (!groupDict)
    {
        return;
    }
    
    if (rqBtn.tag == 100)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"你确定要删除该群组吗？"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:@"取消", nil];
        alert.tag = 4134;
        [alert show];
    }
    else if (rqBtn.tag == 200)
    {
        [[Request request:kAppGroupTag] applyGroupWithUserid:[[UserInfo standardUserInfo] user_id]
                                                     groupid:[groupDict objectForKey:@"group_id"]
                                                    delegate:self];
    }
    else if (rqBtn.tag == 300)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"你确定要删除该群组吗？"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:@"取消", nil];
        alert.tag = 5678;
        [alert show];
        
//        groupLogoutGroupId:
    }
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 4134)
    {
        if (buttonIndex == 0)
        {
            [[Request request:kDeleteGroup] deleteGroupWithUserid:[groupDict objectForKey:@"create_user_id"]
                                                          groupid:[groupDict objectForKey:@"group_id"]
                                                         delegate:self];
        }
    }
    else if (alertView.tag == 5678)
    {
        [[Request request:kLogoutGroup] groupLogoutGroupId:[groupDict objectForKey:@"group_id"]
                                                  delegate:self];
    }
    else if (alertView.tag == kXXXXXTag)
    {
        [self popViewController];
    }
}

#pragma mark - DownloaderDelegate

- (void)downloaderLoadingFromLocalDidFinish:(Downloader *)downloader
{
    
    headView.image = [MTool cutImageFormImage:downloader.image];
}

- (void)downloaderDidFinish:(Downloader *)downloader object:(UIImage *)object
{
    headView.image = [MTool cutImageFormImage:downloader.image];
}

- (void)downloaderNoSuchFileInThisUrl:(NSString *)url
{
    headView.image = nil;
}

- (void)downloaderDidFailWithError:(NSError *)error
{
    headView.image = nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
