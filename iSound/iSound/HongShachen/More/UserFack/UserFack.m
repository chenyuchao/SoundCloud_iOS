//
//  UserFack.m
//  iSound
//
//  Created by MaoHeng Zhang on 13-11-16.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import "UserFack.h"

@interface UserFack ()

@end

@implementation UserFack

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
    
    self.title = @"问题反馈";
    
    textView.layer.borderColor = ARGB(220, 220, 220, 1.0).CGColor;
    textView.layer.borderWidth = 0.5f;
 
    [textView becomeFirstResponder];
    
    UIButton *addComment = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
    [addComment setImage:LoadImage(@"RecordSave", @"png") forState:UIControlStateNormal];
    [addComment addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = CUSTOMVIEW(addComment);
}

- (void)send
{
    if (textView.text.length < 1)
    {
        return;
    }
    
    [[Request request:10] userFeedback:textView.text delegate:self];
}

- (void)downloadDidFinish:(Request *)request withResult:(id)result
{
    if ([[result objectForKey:@"code"] intValue] != 200)
    {
        [MTool showAlertViewWithMessage:@"请求提交失败"];
        return;
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"感谢您的宝贵意见"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles: nil];
    [alertView show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
