//
//  Favroites.m
//  iSound
//
//  Created by Jumax.R on 13-11-7.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import "Favroites.h"
#import "SoundCell.h"

@interface Favroites ()

@end

@implementation Favroites

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"喜欢";
    [[Request request] getLikeList:self.userid
                              page:1
                          per_page:10
                          delegate:self];
}

- (void)downloadDidFinish:(Request *)request withResult:(id)result {

    if ([[result valueForKey:@"code"] intValue] != 200)
    {
        return;
    }
    if ([[[result valueForKey:@"data"] valueForKey:@"like_list"] isKindOfClass:[NSArray class]])
    {
        self.mainlist = [[result valueForKey:@"data"] valueForKey:@"like_list"];
        [(UITableView *)self.view reloadData];
    }
    else
    {
        [Custom messageWithString:@"列表暂时没有数据"];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.mainlist count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"SoundCell";
    SoundCell *cell = (SoundCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SoundCell" owner:self
                                            options:nil] objectAtIndex:0];
    }
    NSDictionary *object = [self.mainlist objectAtIndex:indexPath.row];
    cell.dataDict = [NSMutableDictionary dictionaryWithDictionary:object];
    cell.soundType = [[object valueForKey:@"type"] intValue];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 84;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SoundDetail *detail = [[SoundDetail alloc] init];
    detail.mainlist = self.mainlist;
    MoviePlayer *moviePlayer = [MoviePlayer standardMoviePlayer];
    moviePlayer.playlist     = self.mainlist;
    moviePlayer.playIdx      = indexPath.row;
    moviePlayer.isPlaying    = NO;
    [self.navigationController pushViewController:detail animated:YES];
}

@end
