//
//  UserGroup.m
//  iSound
//
//  Created by Jumax.R on 13-11-2.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import "UserGroup.h"
#import "GroupMenber.h"
#import "GroupRanking.h"

@interface UserGroup ()

@end

@implementation UserGroup

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"群  组";
    if (self.delegate)
    {
        self.title = @"选择群组";
    }
    lastElementTitle = @"创建新群组";
    [self reloadContent:@"group_name" imagePath:@"group_logo"];
    
    if ([self.delegate respondsToSelector:@selector(didSelectedGroups:groupIDs:)])
    {
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.frame = CGRectMake(0, 0, 28, 28);
        [rightButton addTarget:self
                        action:@selector(didFinish)
              forControlEvents:UIControlEventTouchUpInside];
        [rightButton setImage:[UIImage imageNamed:@"finishBtn"]
                     forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = CUSTOMVIEW(rightButton);
    }
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [[Request request] getGroupList:self.userid
                              pages:1
                             number:100
                           delegate:self];
}

- (void)didFinish {

    if ([self.delegate respondsToSelector:@selector(didSelectedGroups:groupIDs:)])
    {
        NSMutableString *names = [NSMutableString string];
        NSMutableString *ids   = [NSMutableString string];
        
        for (GroupElement *element in mainScrollView.subviews)
        {
            if ([element isKindOfClass:[GroupElement class]])
            {
                if (element.highlightedView.highlighted)
                {
                    NSDictionary *object = [self.mainlist objectAtIndex:element.tag];
                    [names appendFormat:@"%@,", [object valueForKey:@"group_name"]];
                    [ids   appendFormat:@"%@,", [object valueForKey:@"group_id"]];
                }
            }
        }
        if (names.length > 0 && ids.length > 0)
        {
            [self.delegate didSelectedGroups:[names substringToIndex:names.length - 1]
                                    groupIDs:[ids   substringToIndex:ids.length  - 1]];
        }
            
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)downloadDidFinish:(Request *)request withResult:(id)result
{
    if ([[result valueForKey:@"code"] intValue] != 200)
    {
        NSLog(@"%@", result);
        return;
    }
    if ([[result valueForKey:@"data"] isKindOfClass:[NSArray class]])
    {
        self.mainlist = [result valueForKey:@"data"];
    }
    [self reloadContent:@"group_name" imagePath:@"group_logo"];
    
    if (!self.ids) return;
    
    for (GroupElement *element in mainScrollView.subviews)
    {
        if ([element isKindOfClass:[GroupElement class]] && ![element.titleLabel.text isEqualToString:lastElementTitle])
        {
            NSDictionary *object = [self.mainlist objectAtIndex:element.tag];
            for (NSString *gid in self.ids)
            {
                if ([gid isEqualToString:[object valueForKey:@"group_id"]])
                {
                    element.highlightedView.highlighted = YES;
                    break;
                }
            }
        }
    }
}

- (void)touchUpInsideAtTouchView:(JRTouchView *)touchView {

    if ([self.delegate respondsToSelector:@selector(didSelectedGroup:groupID:)] &&
        self.mainlist.count != touchView.tag)
    {
        NSDictionary *object = [self.mainlist objectAtIndex:touchView.tag];
        [self.delegate didSelectedGroup:[object valueForKey:@"group_name"]
                                groupID:[object valueForKey:@"group_id"]];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if ([self.delegate respondsToSelector:@selector(didSelectedGroups:groupIDs:)] &&
        self.mainlist.count != touchView.tag)
    {
        [[(GroupElement *)touchView highlightedView] setHighlighted:![(GroupElement *)touchView highlightedView].highlighted];
    }
    else if (self.mainlist.count == touchView.tag)
    {
        CreateGroup *group = [[CreateGroup alloc] init];
        group.delegate = self;
        [self.navigationController pushViewController:group animated:YES];
    }
    else
    {
        NSDictionary *object = [self.mainlist objectAtIndex:touchView.tag];
        GroupDetail *groupdetail = [[GroupDetail alloc] init];
        groupdetail.userid = self.userid;
        groupdetail.title = [object valueForKey:@"group_name"];
        groupdetail.group_id = [object objectForKey:@"group_id"];
        [self.navigationController pushViewController:groupdetail animated:YES];
    }
}

- (void)addGroupDidFinish {

    [[Request request] getGroupList:self.userid
                              pages:1
                             number:10
                           delegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end