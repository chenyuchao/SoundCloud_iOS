//
//  RenqiWang.m
//  iSound
//
//  Created by MaoHeng Zhang on 13-11-17.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import "RenqiWang.h"
#import "UserCenter.h"

@interface RenqiWang ()

@end

@implementation RenqiWang
@synthesize isRanking;
@synthesize keyworld;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"查找用户";
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    if (isRanking)
    {
        [[Request request] searchUserWithKeyworld:keyworld pages:@"1" numbers:@"300" delegate:self];
    }
    else
    {
        self.title = @"人气排行榜";
        [[Request request] userLikePage:@"1" per_page:@"300" Withdelegate:self];
    }
}

- (void)downloadDidFinish:(Request *)request withResult:(id)result
{
    if ([[result valueForKey:@"code"] intValue] != 200)
    {
        return;
    }
    
    NSArray *array = [[result valueForKey:@"data"] objectForKey:@"user_list"];
    
    if ([array isKindOfClass:[NSArray class]])
    {
        self.mainlist = array;
        [((UITableView *)self.view) reloadData];
    }
    else
    {
        [Custom messageWithString:@"暂时没有相关数据"];
    }
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
