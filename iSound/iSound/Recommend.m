//
//  Recommend.m
//  iSound
//
//  Created by Jumax.R on 13-11-4.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import "Recommend.h"
#import "SignIn.h"

@interface Recommend ()

@end

@implementation Recommend

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"热门关注";
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame = CGRectMake(0, 0, 28, 28);
    [doneButton addTarget:self
                   action:@selector(didFinish)
         forControlEvents:UIControlEventTouchUpInside];
    [doneButton setImage:[UIImage imageNamed:@"finishBtn"]
                forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = CUSTOMVIEW(doneButton);
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = nil;
    [[Request request] getRecommendPeople:1 delegate:self];
    
    [[UMSocialDataService defaultDataService] requestSnsFriends:UMShareToTencent
                                                     completion:^(UMSocialResponseEntity *response)
    {
        NSLog(@"SnsFriends is %@",response.data);
    }];

}

- (void)downloadDidFinish:(Request *)request withResult:(id)result {
    
    if ([[result valueForKey:@"code"] intValue] != 200)
    {
        return;
    }
    self.mainlist = [NSArray arrayWithArray:[[result valueForKey:@"data"] valueForKey:@"recommend_list"]];
    [(UITableView *)self.view reloadData];
}

- (void)didFinish {
    
    SignIn *controller = (SignIn *)[[self.navigationController viewControllers] objectAtIndex:0];
    [controller presentViewController:[controller pushTabBarController] animated:YES completion:^{
        [self.navigationController popToRootViewControllerAnimated:NO];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


