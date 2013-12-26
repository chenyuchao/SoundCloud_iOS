//
//  MTableView.m
//  RefreshDemo
//
//  Created by MaoHeng Zhang on 13-11-11.
//  Copyright (c) 2013年 MaoHeng Zhang. All rights reserved.
//

#import "MTableView.h"

@implementation MTableView
@synthesize mDelegate;


- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    
    if (self)
    {
//        self.delegate   = self;
//        self.dataSource = self;
        
        CGRect bounds = self.bounds;
        bounds.size.height += 1;
        
        self.contentSize = bounds.size;
        
        _slimeView = [[SRRefreshView alloc] init];
        _slimeView.delegate = self;
//        _slimeView.upInset = -10;
        
        [self addSubview:_slimeView];
    }
    
    return self;
}

- (void)awakeFromNib {

//    self.delegate   = self;
//    self.dataSource = self;
    
    CGRect bounds = self.bounds;
    bounds.size.height += 1;
    
    self.contentSize = bounds.size;
    _slimeView = [[SRRefreshView alloc] init];
    _slimeView.delegate = self;
    [self addSubview:_slimeView];
}

- (void)endRefresh
{
    [_slimeView performSelector:@selector(endRefresh)
                     withObject:nil
                     afterDelay:0.1
                        inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    cell.textLabel.text = @"dc";
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_slimeView scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_slimeView scrollViewDidEndDraging];
}

#pragma mark - SRRefreshDelegate

- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    if ([mDelegate respondsToSelector:@selector(tableViewRefreshStrat:)])
    {
        [mDelegate tableViewRefreshStrat:self];
    }
}

@end
