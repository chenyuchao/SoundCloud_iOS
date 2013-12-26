//
//  AddUserToGroup.m
//  iSound
//
//  Created by Jumax.R on 13-11-16.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import "AddUserToGroup.h"

@implementation AddUserToGroup

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"从关注列表中邀请";
    [[Request request] getFollowList:[[UserInfo standardUserInfo] user_id]
                                page:1
                            per_page:10
                            delegate:self];
}

- (void)downloadDidFinish:(Request *)request withResult:(id)result {
    
    if ([[result valueForKey:@"code"] intValue] != 200)
    {
        return;
    }
    if ([[result valueForKey:@"data"] isKindOfClass:[NSArray class]] && request.requestId == 0)
    {
        for (NSMutableDictionary *object in [result valueForKey:@"data"])
        {
            [object setObject:@"1" forKey:@"follow"];
        }
        self.mainlist = [NSArray arrayWithArray:[result valueForKey:@"data"]];
        [(UITableView *)self.view reloadData];
    }
}

- (void)downloadDidFail:(Request *)request WithError:(NSError *)error {
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    
    static NSString *identifier = @"Cell";
    
    AddMemberCell *cell = (AddMemberCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[AddMemberCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:identifier];
    }
    
    NSMutableDictionary *object = [self.mainlist objectAtIndex:row];
    cell.result = object;
    cell.groupId = self.groupId;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
