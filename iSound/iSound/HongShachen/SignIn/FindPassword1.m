//
//  FindPassword1.m
//  iSound
//
//  Created by Jumax.R on 13-12-11.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import "FindPassword1.h"

@interface FindPassword1 ()

@end

@implementation FindPassword1

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
    
    self.title = @"校验验证码";
    
    UIButton *returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
    returnButton.frame = CGRectMake(0, 0, 28, 28);
    [returnButton addTarget:self
                     action:@selector(popViewController)
           forControlEvents:UIControlEventTouchUpInside];
    [returnButton setImage:[UIImage imageNamed:@"return"]
                  forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = CUSTOMVIEW(returnButton);
    
    
    [yzmField becomeFirstResponder];
}

#pragma mark - xib

- (IBAction)send
{
    if (yzmField.text.length < 1)
    {
        return;
    }
    
    [[Request request:1] findPasswordWithYanzhengma:yzmField.text username:self.user_name withDelegate:self];
}

- (void)downloadDidFinish:(Request *)request withResult:(id)result
{
    if ([[result objectForKey:@"code"] intValue] != kSuccessful)
    {
        [MTool showAlertViewWithMessage:[[result objectForKey:@"error"] objectForKey:@"msg"]];
        return;
    }
    
    FindPassword2 *find2 = [[FindPassword2 alloc] init];
    find2.user_name = self.user_name;
    [self.navigationController pushViewController:find2 animated:YES];
    
}

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
