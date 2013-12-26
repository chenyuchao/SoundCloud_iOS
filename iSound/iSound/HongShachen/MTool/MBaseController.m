//
//  MBaseController.m
//  iSound
//
//  Created by MaoHeng Zhang on 13-10-24.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import "MBaseController.h"

@interface MBaseController ()

@end

@implementation MBaseController

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
	// Do any additional setup after loading the view.
    
    self.title = @"登  录";
//    CGFloat height = 64;
//    
//    if (!IOS7)
//    {
//        height = 44;
//    }
//    
//    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, height)];
//    titleView.backgroundColor = ARGB(250.0f, 128.0f, 54.0f, 1.0f);
//    [self.view addSubview:titleView];
//    
//    CGFloat y = titleView.frame.size.height - 44;
//    
//    if (!IOS7)
//    {
//        y = 0;
//    }
//    
//    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, y, 320, 44)];
//    titleLabel.backgroundColor = CLEARCOLOR;
//    titleLabel.textColor = [UIColor whiteColor];
//    titleLabel.textAlignment = NSTextAlignmentCenter;
//    titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
//    [titleView addSubview:titleLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
