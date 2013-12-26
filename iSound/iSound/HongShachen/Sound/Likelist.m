//
//  Likelist.m
//  iSound
//
//  Created by Jumax.R on 13-12-24.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import "Likelist.h"
#import "UserCenter.h"

@implementation Likelist
@synthesize voice_id;
@synthesize user_id;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.isLikelist ? @"喜欢列表" : @"转发列表";
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    if (!voice_id)
    {
        return;
    }
    
    if (_isLikelist)
        [[Request request] likeuserlikevoice_id:voice_id page:@"1" per_page:@"300" user_id:user_id withDelegate:self];
    else
        [[Request request] voiceTranspondUserListvoice_id:voice_id pages:@"1" numbers:@"300" user_id:user_id withDelegate:self];
}

- (void)downloadDidFinish:(Request *)request withResult:(id)result {
    
    if ([[result valueForKey:@"code"] intValue] != 200)
    {
        return;
    }
    if (_isLikelist)
    {
        if ([[[result valueForKey:@"data"] valueForKey:@"like_user_list"] isKindOfClass:[NSArray class]])
        {
            self.mainlist = [NSArray arrayWithArray:[[result valueForKey:@"data"] valueForKey:@"like_user_list"]];
            [(UITableView *)self.view reloadData];
            return;
        }
    }
    else
    {
        if ([[result valueForKey:@"data"] isKindOfClass:[NSArray class]])
        {
            self.mainlist = [NSArray arrayWithArray:[result valueForKey:@"data"]];
            [(UITableView *)self.view reloadData];
            return;
        }
    }
    [Custom messageWithString:@"暂时没有数据"];
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


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
