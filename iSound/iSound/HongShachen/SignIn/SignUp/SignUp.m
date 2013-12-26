//
//  SignUp.m
//  iSound
//
//  Created by MaoHeng Zhang on 13-10-24.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import "SignUp.h"
#import "FirstSign.h"

@interface SignUp ()

@end

@implementation SignUp

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    // Do any additional setup after loading the view from its nib.
    self.title = @"注  册";
}

- (IBAction)closeKeyboard
{
    [emailField resignFirstResponder];
    [psdField resignFirstResponder];
}

- (IBAction)signup
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
    
    [[Request request:kSignupTag] userRegister:emailField.text password:psdField.text delegate:self];
}

- (IBAction)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - RequestDelegate

- (void)downloadDidFinish:(Request *)request withResult:(id)result
{
    if ([result isKindOfClass:[NSNull class]] ||
        !result ||
        [[result objectForKey:@"code"] intValue] != kSuccessful)
    {
        [MTool showAlertViewWithMessage:[[result objectForKey:@"error"] objectForKey:@"msg"]];
        return;
    }
    
    if (request.requestId == kSignupTag && [[result objectForKey:@"code"] intValue] == kSuccessful)
    {
        [[Request request:kSigninTag] userlogin:emailField.text password:psdField.text delegate:self];
        
        return;
    }
    
    if (request.requestId == kSigninTag && [[result objectForKey:@"code"] intValue] == kSuccessful)
    {
        psdField.text = @"";
        
        NSMutableDictionary *infoDict = [[result objectForKey:@"data"] objectForKey:@"user_info"];
        UserInfo *userinfo = [UserInfo standardUserInfo];
        userinfo.userAccount = emailField.text;
        [userinfo userDataWithDict:infoDict];
        FirstSign *sign = [[FirstSign alloc] init];
        [self.navigationController pushViewController:sign animated:YES];
    }
}

- (void)downloadDidFail:(Request *)request WithError:(NSError *)error
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
