//
//  ADLabelView.m
//  iSound
//
//  Created by MaoHeng Zhang on 13-11-5.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import "ADLabelView.h"

@interface ADLabelView ()

@end

@implementation ADLabelView
@synthesize aDelegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = nil;
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 29, 29)];
    [backBtn setImage:LoadImage(@"SoundSavedBack", @"png") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = CUSTOMVIEW(backBtn);
}

- (void)back
{
    NSString *tags  = @"";
    NSString *names = @"";
    for (NSDictionary *objet in self.selectedTag)
    {
        tags  = [tags stringByAppendingFormat:@"%@,",[objet valueForKey:@"id"]];
        names = [names stringByAppendingFormat:@"%@,",[objet valueForKey:@"name"]];
    }
    
    if (tags.length > 0)
    {
        tags  = [tags substringToIndex:tags.length - 1];
        names = [names substringToIndex:names.length - 1];
    }
    
    if ([aDelegate respondsToSelector:@selector(backWithTags:names:)])
    {
        [aDelegate backWithTags:tags names:names];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
