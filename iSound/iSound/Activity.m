//
//  Acitivity.m
//  iSound
//
//  Created by Jumax.R on 13-9-28.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import "Activity.h"

@interface Activity ()

@end

@implementation Activity

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"消息中心";

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshTableView)
                                                 name:@"MessageNotification"
                                               object:nil];
    self.msgPath = [[Custom getDocumentDir] stringByAppendingPathComponent:@"message.plist"];
    self.mainlist = [NSArray arrayWithContentsOfFile:self.msgPath];
    
    UIViewController *viewController = [[self.tabBarController viewControllers] objectAtIndex:1];
    viewController.tabBarItem.badgeValue = nil;
}

- (void)refreshTableView {

    self.mainlist = [NSArray arrayWithContentsOfFile:self.msgPath];
    [(UITableView *)self.view reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.mainlist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"ActivityCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [Custom systemFont:14];
        
        UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
        [left  setFrame:CGRectMake(0, 0, 80, 40)];
        [left  setTag:1];
        [left  setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [left  addTarget:self
                  action:@selector(agress:)
        forControlEvents:UIControlEventTouchUpInside];
        [[left titleLabel] setFont:cell.textLabel.font];

        UIView *optionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
        [optionView addSubview:left];
        cell.accessoryView = optionView;
    }
    
    NSDictionary *object = [self.mainlist objectAtIndex:indexPath.row];
    int type = [[object valueForKey:@"centent_type"] intValue];
    cell.accessoryView.hidden = type >= 2 ? NO : YES;
    cell.accessoryView.tag = indexPath.row;
    [(UIButton *)cell.accessoryView setTitle:[object valueForKey:@"state"] forState:UIControlStateNormal];
    cell.textLabel.text = [[object valueForKey:@"aps"] valueForKey:@"alert"];
    
    if ([[object valueForKey:@"state"] isEqualToString:@"同意"])
    {
        cell.accessoryView.userInteractionEnabled = YES;
    }
    else
    {
        cell.accessoryView.userInteractionEnabled = NO;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)agress:(UIButton *)button {
    
    if ([[button titleForState:UIControlStateNormal] isEqualToString:@"已同意"])
        return;
    
    NSMutableDictionary *object = [self.mainlist objectAtIndex:button.superview.tag];
    int type = [[object valueForKey:@"centent_type"] intValue];

    if (type == 3)
    {
        [button setTitle:@"已同意" forState:UIControlStateNormal];
        [object setObject:@"已同意" forKey:@"state"];
        [[Request request] reviewComingGroup:[[UserInfo standardUserInfo] user_id]
                                     groupId:[[object valueForKey:@"desc"] valueForKey:@"group_id"]
                                     applyId:[object valueForKey:@"release_user_id"]
                                       agree:button.tag
                                    delegate:self];
    }
    else if (type == 2 && button.tag == 1)
    {
        [button setTitle:@"已同意" forState:UIControlStateNormal];
        [object setObject:@"已同意" forKey:@"state"];
        [[Request request] agreeToGroup:[[UserInfo standardUserInfo] user_id]
                                groupId:[[object valueForKey:@"desc"] valueForKey:@"group_id"]
                               delegate:self];
    }
}

- (void)downloadDidFinish:(Request *)request withResult:(id)result {

    NSLog(@"%@", result);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
