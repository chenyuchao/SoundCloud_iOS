//
//  GroupRanking.m
//  iSound
//
//  Created by MaoHeng Zhang on 13-11-17.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import "GroupRanking.h"

@interface GroupRanking ()

@end

@implementation GroupRanking
@synthesize keyworld;


- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.title = @"群组";
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (keyworld)
    {
        [[Request request] groupWithKeyworld:keyworld Page:@"1" per_page:@"30000" Withdelegate:self];
    }
    else
    {
        [[Request request] groupLikePage:@"1" per_page:@"300" Withdelegate:self];
    }
}

- (void)downloadDidFinish:(Request *)request withResult:(id)result
{
    if ([[result valueForKey:@"code"] intValue] != 200)
    {
        return;
    }
    
    if (keyworld)
    {
        NSArray *array = [result objectForKey:@"data"];
        
        if ([array isKindOfClass:[NSArray class]])
        {
            self.mainlist = array;
            [self reloadContent:@"group_name" imagePath:@"group_logo"];
        }
        else
        {
            [Custom messageWithString:@"暂时没有相关数据"];
        }
    }
    else
    {
        NSArray *array = [[result valueForKey:@"data"] objectForKey:@"group_list"];
        
        if ([array isKindOfClass:[NSArray class]])
        {
            self.mainlist = array;
            [self reloadContent:@"group_name" imagePath:@"group_logo"];
        }
        else
        {
            [Custom messageWithString:@"没有任何数据"];
        }
    }
    
    
}

- (void)touchUpInsideAtTouchView:(JRTouchView *)touchView
{
    NSDictionary *dict = [self.mainlist objectAtIndex:touchView.tag];
    GroupDetail *groupdetail = [[GroupDetail alloc] init];
    groupdetail.group_id = [NSString stringWithFormat:@"%d",[[dict objectForKey:@"group_id"] intValue]];
    groupdetail.userid = [[UserInfo standardUserInfo] user_id];
    groupdetail.title = [dict objectForKey:@"group_name"];
    [self.navigationController pushViewController:groupdetail animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
