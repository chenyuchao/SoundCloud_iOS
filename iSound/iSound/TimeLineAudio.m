//
//  TimeLineAudio.m
//  iSound
//
//  Created by Jumax.R on 13-11-23.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import "TimeLineAudio.h"
#import "SoundCell.h"

@interface TimeLineAudio ()

@end

@implementation TimeLineAudio

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"声音列表";
    [[Request request] getTimeLineAudioList:self.userid
                                       year:[self.audioInfo valueForKey:@"release_year"]
                                      month:[self.audioInfo valueForKey:@"release_month"]
                                       city:[self.audioInfo valueForKey:@"city"]
                                      pages:1
                                    numbers:10
                                   delegate:self];
}

- (void)downloadDidFinish:(Request *)request withResult:(id)result {
    
    NSLog(@"%@", result);
    if ([[result valueForKey:@"code"] intValue] != 200)
    {
        return;
    }
    if ([[[result valueForKey:@"data"] valueForKey:@"voice_like_list"] isKindOfClass:[NSArray class]])
    {
        self.mainlist = [[result valueForKey:@"data"] valueForKey:@"voice_like_list"];
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
    
    SoundDetail *detail = [[SoundDetail alloc] init];
    detail.mainlist = self.mainlist;
    MoviePlayer *moviePlayer = [MoviePlayer standardMoviePlayer];
    moviePlayer.playlist     = self.mainlist;
    moviePlayer.playIdx      = indexPath.row;
    moviePlayer.isPlaying    = NO;
    [self.navigationController pushViewController:detail animated:YES];
}

@end
