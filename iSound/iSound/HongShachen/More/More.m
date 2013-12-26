//
//  More.m
//  iSound
//
//  Created by Jumax.R on 13-9-28.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import "More.h"

@interface More ()

@end

@implementation More
@synthesize appURL;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    titleArray = [[NSArray alloc] initWithObjects:@"新浪微博绑定",
                                                  @"腾讯微博绑定",
                                                  @"问题反馈",
                                                  @"版本检测",
                                                  @"给个好评吧",
                                                  @"关于",@"注销登录", nil];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
    {
        self.view.backgroundColor = ARGB(239, 239, 244, 1.0);
        [(UITableView *)self.view setBackgroundView:nil];
    }
    self.title = @"更  多";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section)
    {
        case 0:
            return 2;
        case 1:
            return 4;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSInteger row     = indexPath.row;
    NSInteger section = indexPath.section;
    static NSString *identifier = @"MoreCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:identifier];
        cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [Custom systemFont:14];
    }
    NSInteger currentRow = [self atRow:row section:section];
    cell.textLabel.text = [titleArray objectAtIndex:currentRow];
    
    cell.textLabel.textColor = [UIColor blackColor];
    
    if (row == 0 && section == 0)
    {
        if ([UMSocialAccountManager isOauthWithPlatform:UMShareToSina])
        {
            cell.textLabel.text = @"解除新浪微博绑定";
            cell.textLabel.textColor = [UIColor redColor];
        }
    }
    if (row == 1 && section == 0)
    {
        if ([UMSocialAccountManager isOauthWithPlatform:UMShareToTencent])
        {
            cell.textLabel.text = @"解除腾讯微博绑定";
            cell.textLabel.textColor = [UIColor redColor];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NSInteger index = [self atRow:row section:section];
    
    switch (index) {
        case 6:
        {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                 message:@"是否退出登录"
                                                                delegate:self
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:@"取消", nil];
            alertView.tag = 12354;
            [alertView show];
        }
            break;
        case 0:
        {
            if ([UMSocialAccountManager isOauthWithPlatform:UMShareToSina])
            {
                [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToSina  completion:^(UMSocialResponseEntity *response){
                    [Custom messageWithString:@"成功解除新浪微博绑定"];
                    [(UITableView *)self.view reloadData];
                }];
            }
            else
            {
                [self bandWithSinaWeiBo];
            }
        }
            break;
        case 1:
        {
            if ([UMSocialAccountManager isOauthWithPlatform:UMShareToTencent])
            {
                [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToTencent completion:^(UMSocialResponseEntity *response){
                    [Custom messageWithString:@"成功解除腾讯微博绑定"];
                    [(UITableView *)self.view reloadData];
                }];
            }
            else
            {
                [self bandWithTencentWeiBo];
            }
        }
            break;
        case 2:
        {
            UserFack *comment = [[UserFack alloc] init];
            [self.navigationController pushViewController:comment animated:YES];
        }
            break;
        case 3:
        {
            [[Request request:kCheckVersionTag] checkVersionWithdelegate:self];
        }
            break;
        default:
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    if (section < 2)
        return 10;
    return 30;
}

- (NSInteger)atRow:(NSInteger)row section:(NSInteger)section {

    if (section == 0)
        return row;
    if (section == 1)
        return row + 2;
    
    return row + 6;
}

#pragma mark - RequestDelegate

- (void)downloadDidFinish:(Request *)request withResult:(id)result
{
    if (request.requestId == 10017)
    {
        if ([[result objectForKey:@"code"] intValue] != 200)
        {
            [MTool showAlertViewWithMessage:@"暂时无法注销当前账号，请稍后重试"];
            return;
        }
        if ([UMSocialAccountManager isOauthWithPlatform:UMShareToSina])
        {
            [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToSina  completion:^(UMSocialResponseEntity *response){
                [(UITableView *)self.view reloadData];
            }];
        }
        if ([UMSocialAccountManager isOauthWithPlatform:UMShareToTencent])
        {
            [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToTencent completion:^(UMSocialResponseEntity *response){
                [(UITableView *)self.view reloadData];
            }];
        }
        [APService setTags:nil
                     alias:[[UserInfo standardUserInfo] user_id]
          callbackSelector:@selector(tagsAliasCallback:tags:alias:)
                    object:self];
        [[UserInfo standardUserInfo] clearUserInfoData];
        [self.tabBarController dismissViewControllerAnimated:YES completion:NULL];
        return;
    }
    
    if ([[result objectForKey:@"code"] intValue] != 200)
    {
        [MTool showAlertViewWithMessage:@"暂时无法获取最新版本，请稍后重试"];
        return;
    }
    
    NSDictionary *infoDict = [[result objectForKey:@"data"] objectForKey:@"ver_info"];
    self.appURL = [infoDict objectForKey:@"update_url"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:[infoDict objectForKey:@"update_desc"]
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:@"取消", nil];
    alert.tag = 23443;
    [alert show];
}

- (void)bandWithSinaWeiBo {
    //友盟
    [UMSocialConfig setSupportSinaSSO:YES];
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response)
                                  {
                                      NSLog(@"response is %@",response);
                                      if ([[response valueForKey:@"responseCode"] integerValue] == 200)
                                      {
                                          [(UITableView *)self.view reloadData];
                                      }
                                  });
}

- (void)bandWithTencentWeiBo {
    
    [UMSocialConfig setSupportSinaSSO:YES];
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToTencent];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response)
                                  {
                                      NSLog(@"response is %@",response);
                                      if ([[response valueForKey:@"responseCode"] integerValue] == 200)
                                      {
                                          [(UITableView *)self.view reloadData];
                                      }
                                  });
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 12354 && buttonIndex == 0)
    {
        [[Request request:10017] logout:[[UserInfo standardUserInfo] user_id]
                               delegate:self];
        return;
    }
    
    if (alertView.tag == 23443 && buttonIndex == 0)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appURL]];
    }
}

- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    
    if (iResCode != 0)
    {
        [APService setTags:nil
                     alias:[[UserInfo standardUserInfo] user_id]
          callbackSelector:@selector(tagsAliasCallback:tags:alias:)
                    object:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
