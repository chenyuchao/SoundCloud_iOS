//
//  SoundList.m
//  iSound
//
//  Created by Jumax.R on 13-11-11.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import "SoundList.h"
#import "SoundListCell.h"
#import "TimeLineAudio.h"

@interface SoundList ()

@end

@implementation SoundList

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(159, 0, 2, 508)];
    lineView.backgroundColor = MainColor;
    [self.view addSubview:lineView];
    
    self.title = @"时光机";
    
    mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, ScreenHeight - 64) style:UITableViewStylePlain];
    mainTableView.separatorColor = CLEARCOLOR;
    mainTableView.backgroundColor = CLEARCOLOR;
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    [self.view addSubview:mainTableView];
    [[Request request] getTimeLineList:self.userid
                                  page:1
                              per_page:10
                              delegate:self];
}

- (void)downloadDidFinish:(Request *)request withResult:(id)result {

    if ([[result valueForKey:@"code"] intValue] != 200)
    {
        return;
    }
    if ([[[result valueForKey:@"data"] valueForKey:@"timeline_list"] isKindOfClass:[NSArray class]])
    {
        self.mainlist = [[result valueForKey:@"data"] valueForKey:@"timeline_list"];
        [mainTableView reloadData];
        
        if (mainTableView.contentSize.height - mainTableView.frame.size.height > 0)
        {
            [mainTableView setContentOffset:CGPointMake(0, mainTableView.contentSize.height - mainTableView.frame.size.height)];
            [UIView animateWithDuration:1.0f animations:^{
                [mainTableView setContentOffset:CGPointMake(0, 0)];
            }];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mainlist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2 == 0)
    {
        static NSString *identifier = @"SoundListCellOfLeft";
        SoundListCellOfLeft *cell = (SoundListCellOfLeft *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SoundListCell" owner:self
                                                options:nil] objectAtIndex:0];
        }
        [cell setResult:[self.mainlist objectAtIndex:indexPath.row]];
        return cell;
    }
    else
    {
        static NSString *identifier = @"SoundListCellOfRight";
        SoundListCellOfRight *cell = (SoundListCellOfRight *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SoundListCell" owner:self
                                                options:nil] objectAtIndex:1];
        }
        [cell setResult:[self.mainlist objectAtIndex:indexPath.row]];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 123;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TimeLineAudio *audio = [[TimeLineAudio alloc] init];
    audio.audioInfo = [self.mainlist objectAtIndex:indexPath.row];
    audio.userid = self.userid;
    [self.navigationController pushViewController:audio animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
