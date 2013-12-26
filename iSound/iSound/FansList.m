//
//  FansList.m
//  iSound
//
//  Created by Jumax.R on 13-11-10.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import "FansList.h"
#import "UserCenter.h"

@interface FansList ()

@end

@implementation FansList

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.isFanslist ? @"我的粉丝" : @"我的关注";
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    if (_isFanslist)
        [[Request request] getFansList:self.userid
                                  page:1
                              per_page:100
                              delegate:self];
    else
        [[Request request] getFollowList:self.userid
                                    page:1
                                per_page:100
                                delegate:self];
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
    else
    {
        [Custom messageWithString:@"暂时没有数据"];
    }
}

- (void)downloadDidFail:(Request *)request WithError:(NSError *)error {

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    
    static NSString *identifier = @"Cell";
    
    FansCell *cell = (FansCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[FansCell alloc] initWithStyle:UITableViewCellStyleDefault
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
