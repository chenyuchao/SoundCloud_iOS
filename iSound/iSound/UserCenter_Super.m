//
//  UserCenter_Super.m
//  iSound
//
//  Created by Jumax.R on 13-11-2.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import "UserCenter_Super.h"

@implementation Center_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
    returnButton.frame = CGRectMake(0, 0, 28, 28);
    [returnButton addTarget:self
                     action:@selector(popViewController)
           forControlEvents:UIControlEventTouchUpInside];
    [returnButton setImage:[UIImage imageNamed:@"return"]
                  forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = CUSTOMVIEW(returnButton);
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)popViewController
{

//    if () {
//        <#statements#>
//    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end


@implementation Center_TableView

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
    returnButton.frame = CGRectMake(0, 0, 28, 28);
    [returnButton addTarget:self
                     action:@selector(popViewController)
           forControlEvents:UIControlEventTouchUpInside];
    [returnButton setImage:[UIImage imageNamed:@"return"]
                  forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = CUSTOMVIEW(returnButton);
    // 下拉刷新
//    [(UITableView *)self.view addPullToRefreshWithActionHandler:^{
////        [self performSelector:@selector(refresh) withObject:nil];
//    }];
    
    //    // 注册上拉刷新（获取旧数据）
    //    [_mainTableView addInfiniteScrollingWithActionHandler:^{
    //
    //        [UMeng upRefreshEvent];
    //
    //        loadingStyle    = LoadingStyleGetMoreData;
    //        NSDictionary *d = [_resultArray lastObject];
    //        [[Request hideRequest] getTipsListWithRefreshStyle:loadingStyle
    //                                                updateTime:[d valueForKey:@"CreateTime"]
    //                                                  delegate:self];
    //    }];
    //    [_mainTableView.pullToRefreshView triggerRefresh];
}

- (void)refresh {

}

- (void)popViewController {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
