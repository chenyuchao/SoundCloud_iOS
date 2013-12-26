//
//  PlayerListContent.m
//  iSound
//
//  Created by 郭子健 on 13-11-13.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import "PlayerListContent.h"
#import "SoundCell.h"

@interface PlayerListContent ()

@end

@implementation PlayerListContent

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[Request request] audioPlayList:self.listId
                            fromPage:1
                         pageNumbers:10
                            delegate:self];
}

- (void)downloadDidFinish:(Request *)request withResult:(id)result {

    if ([[result valueForKey:@"code"] intValue] != 200)
    {
        return;
    }
    if ([[result valueForKey:@"data"] isKindOfClass:[NSArray class]])
    {
        if ([[result valueForKey:@"data"] count] == 0)
        {
            [Custom messageWithString:@"该播放列表没有数据"];
            return;
        }
        self.mainlist = [result valueForKey:@"data"];
        [(UITableView *)self.view reloadData];
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
    
    [self setHidesBottomBarWhenPushed:YES];
    SoundDetail *detail = [[SoundDetail alloc] init];
    detail.mainlist = self.mainlist;
    MoviePlayer *moviePlayer = [MoviePlayer standardMoviePlayer];
    moviePlayer.playlist     = self.mainlist;
    moviePlayer.playIdx      = indexPath.row;
    moviePlayer.isPlaying    = NO;
    [self.navigationController pushViewController:detail animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
}


@end
