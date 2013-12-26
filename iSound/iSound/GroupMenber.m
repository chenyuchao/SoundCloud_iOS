//
//  GroupMenber.m
//  iSound
//
//  Created by Jumax.R on 13-11-16.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import "GroupMenber.h"
#import "UserCenter.h"
#import "AddUserToGroup.h"

@interface GroupMenber ()

@end

@implementation GroupMenber

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"群组成员";
    if([self.userid isEqualToString:[[UserInfo standardUserInfo] user_id]])
    {
        UIButton *yqButton = [UIButton buttonWithType:UIButtonTypeCustom];
        yqButton.frame = CGRectMake(0, 0, 41, 25);
        [yqButton addTarget:self
                     action:@selector(pleaseToAdd)
           forControlEvents:UIControlEventTouchUpInside];
        [yqButton setImage:[UIImage imageNamed:@"yqGroup"]
                      forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = CUSTOMVIEW(yqButton);
    }
    
    [[Request request] getGroupMember:self.userid
                              groupId:self.groupid
                             delegate:self];
}

- (void)pleaseToAdd {

    AddUserToGroup *group = [[AddUserToGroup alloc] init];
    group.groupId = self.groupid;
    [self.navigationController pushViewController:group animated:YES];
}

- (void)downloadDidFinish:(Request *)request withResult:(id)result {
    
    if ([[result valueForKey:@"code"] intValue] != 200)
    {
        return;
    }
    if ([[result valueForKey:@"data"] isKindOfClass:[NSArray class]])
    {
        self.mainlist = [NSArray arrayWithArray:[result valueForKey:@"data"]];
        [(UITableView *)self.view reloadData];
    }
}

- (void)downloadDidFail:(Request *)request WithError:(NSError *)error {
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    static NSString *identifier = @"Cell";
    GMCell *cell = (GMCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[GMCell alloc] initWithStyle:UITableViewCellStyleDefault
                             reuseIdentifier:identifier];
    }
    NSMutableDictionary *object = [self.mainlist objectAtIndex:row];
    cell.result = object;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *object = [self.mainlist objectAtIndex:indexPath.row];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UserCenter *center = [storyboard instantiateViewControllerWithIdentifier:@"UserCenter"];
    center.userid = [object valueForKey:@"user_id"];
    center.displayReturn = YES;
    [self.navigationController pushViewController:center animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


