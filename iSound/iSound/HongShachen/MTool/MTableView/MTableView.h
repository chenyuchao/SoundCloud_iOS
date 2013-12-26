//
//  MTableView.h
//  RefreshDemo
//
//  Created by MaoHeng Zhang on 13-11-11.
//  Copyright (c) 2013年 MaoHeng Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRRefreshView.h"

@class MTableView;

@protocol MTableViewDelegate <NSObject>

- (void)tableViewRefreshStrat:(MTableView *)mTbaleView;
- (void)tableViewRefreshDidFinished:(MTableView *)mTbaleView;

@end

@interface MTableView : UITableView <SRRefreshDelegate,UITableViewDelegate,UITableViewDataSource>
{

}

@property (nonatomic, assign) IBOutlet id <MTableViewDelegate> mDelegate;
@property (nonatomic, retain) SRRefreshView *slimeView;;

- (void)endRefresh;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

@end
