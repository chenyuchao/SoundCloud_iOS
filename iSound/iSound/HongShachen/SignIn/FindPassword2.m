//
//  FindPassword2.m
//  iSound
//
//  Created by Jumax.R on 13-12-11.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import "FindPassword2.h"

@interface FindPassword2 ()

@end

@implementation FindPassword2

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
    self.title = @"重置密码";
    
    UIButton *returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
    returnButton.frame = CGRectMake(0, 0, 28, 28);
    [returnButton addTarget:self
                     action:@selector(popViewController)
           forControlEvents:UIControlEventTouchUpInside];
    [returnButton setImage:[UIImage imageNamed:@"return"]
                  forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = CUSTOMVIEW(returnButton);
}


#pragma mark - xib

- (IBAction)send
{
    if (psdField.text.length < 1)
    {
        return;
    }
    
    [[Request request] resetPasswordWithUsernamed:self.user_name password:psdField.text withDelegate:self];
}

- (void)downloadDidFinish:(Request *)request withResult:(id)result
{
//    if (request.requestId == kResetPsd)
    {
        if ([[result objectForKey:@"code"] intValue] != kSuccessful)
        {
            [MTool showAlertViewWithMessage:[[result objectForKey:@"error"] objectForKey:@"msg"]];
            return;
        }
    }

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:[result objectForKey:@"msg"]
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
    [alertView show];
    
}

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
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
