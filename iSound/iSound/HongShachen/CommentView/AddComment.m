//
//  AddComment.m
//  iSound
//
//  Created by MaoHeng Zhang on 13-11-15.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import "AddComment.h"

@interface AddComment ()

@end

@implementation AddComment
@synthesize voiceId;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"评论";
    
//    textView.layer
    textView.layer.borderColor = ARGB(220, 220, 220, 1.0).CGColor;
    textView.layer.borderWidth = 0.5f;
    UIButton *returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
    returnButton.frame = CGRectMake(0, 0, 28, 28);
    [returnButton addTarget:self
                     action:@selector(back)
           forControlEvents:UIControlEventTouchUpInside];
    [returnButton setImage:[UIImage imageNamed:@"return"]
                  forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = CUSTOMVIEW(returnButton);
    
    UIButton *addComment = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
    [addComment setImage:LoadImage(@"RecordSave", @"png") forState:UIControlStateNormal];
    [addComment addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = CUSTOMVIEW(addComment);
}

- (void)send
{
    if (textView.text.length < 1)
    {
        [MTool showAlertViewWithMessage:@"请输入评论内容"];
        return;
    }
    
    if (textView.text.length > 140)
    {
        [MTool showAlertViewWithMessage:@"评论内容不得超过140字"];
        return;
    }
    
    [[Request request:10] addCommentWithVoice_id:voiceId type:@"1" comment:textView.text delegate:self];
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)downloadDidFinish:(Request *)request withResult:(id)result
{
    if ([[result objectForKey:@"code"] intValue] != 200)
    {
        [MTool showAlertViewWithMessage:@"评论发表失败"];
        return;
    }
    
    [self back];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
