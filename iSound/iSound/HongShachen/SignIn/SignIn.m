//
//  SignIn.m
//  iSound
//
//  Created by MaoHeng Zhang on 13-10-24.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import "SignIn.h"
#import "SoundRecord.h"
#import "FirstSign.h"
#import "Recommend.h"

@interface SignIn ()

@end

@implementation SignIn

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reRecord:)
                                                 name:@"ReSetSoundRecord"
                                               object:nil];
    
    self.title = @"登  录";

    UserInfo *userinfo = [UserInfo standardUserInfo];
    emailField.text = userinfo.userAccount;
    if (userinfo.user_id && userinfo.is_first == NO)
    {
        [self presentViewController:[self pushTabBarController] animated:NO completion:NULL];
    }
    
    loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    loadingView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    loadingView.hidden = YES;
    loadingView.alpha  = 0.8;
    loadingView.backgroundColor = [UIColor blackColor];
    loadingView.layer.cornerRadius = 10.0f;
    loadingView.clipsToBounds = YES;
    
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activityView startAnimating];
    activityView.center = CGPointMake(loadingView.frame.size.width/2, loadingView.frame.size.height/2);
    [loadingView addSubview:activityView];

    
    [self.view addSubview:loadingView];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    UserInfo *userinfo = [UserInfo standardUserInfo];
    emailField.text = userinfo.userAccount;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
     psdField.text = @"";
}

- (void)reRecord:(NSNotification *)info
{
    SoundRecord *record = [[SoundRecord alloc] init];
    UINavigationController *nav = [Custom defaultNavigationController:record];
    nav.navigationBarHidden = YES;
    [lastController presentModalViewController:nav animated:NO];
}

#pragma mark - xib

- (IBAction)zhaohuimima
{
    if (emailField.text.length < 1)
    {
        [MTool showAlertViewWithMessage:@"请输入你的账号"];
        return;
    }
    
    [emailField resignFirstResponder];
    [psdField   resignFirstResponder];
    loadingView.hidden = NO;
    self.view.userInteractionEnabled = NO;
    
    [[Request request:kFindPasswordTag] findPasswordWithUserName:emailField.text withDelegate:self];
}



- (IBAction)signIn
{
    if (emailField.text.length < 1)
    {
        [MTool showAlertViewWithMessage:@"请输入账号"];
        return;
    }
    
    if (psdField.text.length < 1)
    {
        [MTool showAlertViewWithMessage:@"请输入密码"];
        return;
    }
    
    [emailField resignFirstResponder];
    [psdField   resignFirstResponder];
    loadingView.hidden = NO;
    self.view.userInteractionEnabled = NO;
    [[Request request] userlogin:emailField.text password:psdField.text delegate:self];
}

- (IBAction)signInWithSinaWeiBo {

    [UMSocialConfig setSupportSinaSSO:YES];
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response)
                                  {
                                      NSLog(@"response is %@",response);
//                                      [Custom messageWithString:[NSString stringWithFormat:@"%@", response]];
                                      if ([[response valueForKey:@"responseCode"] integerValue] == 200)
                                      {
                                          UserInfo *userinfo = [UserInfo standardUserInfo];
                                          NSDictionary *object = [[response valueForKey:@"data"] valueForKey:@"sina"];
                                          userinfo.nickname = [object valueForKey:@"username"];
                                          [[Request request] otherLogin:[object valueForKey:@"usid"]
                                                               platform:@"1"
                                                               delegate:self];
                                      }
                                  });
}

- (IBAction)signInWithTencentWeiBo {

    [UMSocialConfig setSupportSinaSSO:YES];
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToTencent];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response)
                                  {
                                      NSLog(@"response is %@",response);
//                                      [Custom messageWithString:[NSString stringWithFormat:@"%@", response]];
                                      if ([[response valueForKey:@"responseCode"] integerValue] == 200)
                                      {
                                          UserInfo *userinfo = [UserInfo standardUserInfo];
                                          NSDictionary *object = [[response valueForKey:@"data"] valueForKey:@"tencent"];
                                          userinfo.nickname = [object valueForKey:@"username"];
                                          userinfo.head_image = [object valueForKey:@"icon"];
                                          [[Request request] otherLogin:[object valueForKey:@"openid"]
                                                               platform:@"2"
                                                               delegate:self];
                                      }
                                  });
}

- (UITabBarController *)pushTabBarController {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.tabBarController = [storyboard instantiateViewControllerWithIdentifier:@"RootTabBarController"];
    self.tabBarController.delegate = self;
    
    CGFloat version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version < 7.0 && version > 4.0)
    {
        for (UINavigationController *controller in self.tabBarController.viewControllers)
        {
            [controller.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbg"]
                                           forBarMetrics:UIBarMetricsDefault];
        }
        UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(0, -12, 320, 61)];
        background.image = [UIImage imageNamed:@"tabbarbg"];
        [self.tabBarController.tabBar insertSubview:background atIndex:1];
        [self.tabBarController.tabBar setTintColor:[UIColor whiteColor]];
        [self.tabBarController.tabBar setSelectedImageTintColor:ARGB(250, 140, 74, 1.0)];
    }
    else
    {        
        UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(0, -12, 320, 61)];
        background.image = [UIImage imageNamed:@"tabbarbg"];
        [self.tabBarController.tabBar insertSubview:background atIndex:0];
        [self.tabBarController.tabBar setTintColor:ARGB(250, 140, 74, 1.0)];
    }
    return self.tabBarController;
}

#pragma mark - RequestDelegate

- (void)downloadDidFinish:(Request *)request withResult:(id)result
{
    loadingView.hidden = YES;
    self.view.userInteractionEnabled = YES;
    
    if (request.requestId == kFindPasswordTag)
    {
        if ([[result objectForKey:@"code"] intValue] != kSuccessful)
        {
            [MTool showAlertViewWithMessage:[[result objectForKey:@"error"] objectForKey:@"msg"]];
            return;
        }
        
        FindPassword1 *findpassword1 = [[FindPassword1 alloc] init];
        findpassword1.user_name = emailField.text;
        [self.navigationController pushViewController:findpassword1 animated:YES];
        return;
    }
    
    if ([result isKindOfClass:[NSNull class]] ||
        !result ||
        [[result objectForKey:@"code"] intValue] != kSuccessful)
    {
        [MTool showAlertViewWithMessage:[[result objectForKey:@"error"] objectForKey:@"msg"]];
        return;
    }
    
    
    NSDictionary *infoDict = [[result objectForKey:@"data"] objectForKey:@"user_info"];
    
    UserInfo *userinfo = [UserInfo standardUserInfo];
    userinfo.userAccount = emailField.text;
    [userinfo userDataWithDict:infoDict];
    
    if ([[infoDict valueForKey:@"is_first"] boolValue] == YES)
    {
        FirstSign *sign = [[FirstSign alloc] init];
        [self.navigationController pushViewController:sign animated:NO];
    }
    else
    {
        [self presentViewController:[self pushTabBarController] animated:YES completion:NULL];
    }
}

- (void)downloadDidFail:(Request *)request WithError:(NSError *)error
{
    self.view.userInteractionEnabled = YES;
    loadingView.hidden = YES;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    index = tabBarController.selectedIndex;
    lastController = viewController;
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
    if (tabBarController.selectedIndex == 2)
    {
        tabBarController.selectedIndex = index;
        
        SoundRecord *record = [[SoundRecord alloc] init];
        UINavigationController *nav = [Custom defaultNavigationController:record];
        nav.navigationBarHidden = YES;
        [lastController presentModalViewController:nav animated:YES];
    }
}


- (IBAction)signUp
{
    SignUp *signup = [[SignUp alloc] init];
    [self.navigationController pushViewController:signup animated:YES];
}
- (IBAction)closeKeyboard
{
    [emailField resignFirstResponder];
    [psdField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
