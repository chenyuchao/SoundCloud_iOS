//
//  CommentView.m
//  iSound
//
//  Created by MaoHeng Zhang on 13-11-13.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import "CommentView.h"

#define COMMENT_FONT [UIFont systemFontOfSize:14.0f]

@interface CommentView ()

@end

@implementation CommentView
@synthesize voiceId;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"评论列表";
    
    dataArray = [[NSMutableArray alloc] init];

    pageIndex = 0;
    
    UIButton *returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
    returnButton.frame = CGRectMake(0, 0, 28, 28);
    [returnButton addTarget:self
                     action:@selector(back)
           forControlEvents:UIControlEventTouchUpInside];
    [returnButton setImage:[UIImage imageNamed:@"return"]
                  forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = CUSTOMVIEW(returnButton);
    
    UIButton *addComment = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    [addComment setImage:LoadImage(@"CommentAdd", @"png") forState:UIControlStateNormal];
    [addComment addTarget:self action:@selector(addcomment) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = CUSTOMVIEW(addComment);
    
    [self moreBtnPressed:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    pageIndex = 0;
    
    [self moreBtnPressed:nil];
}

- (void)loadMoreData
{
    
}

- (void)addcomment
{
    AddComment *comment = [[AddComment alloc] init];
    comment.voiceId     = voiceId;
    UINavigationController *navigation = [Custom defaultNavigationController:comment];
    [self presentViewController:navigation animated:YES completion:nil];
}

- (void)downloadDidFinish:(Request *)request withResult:(id)result
{
    if ([[result objectForKey:@"code"] intValue] != 200)
    {
        return;
    }
    
    if (pageIndex == 1)
    {
        [dataArray removeAllObjects];
    }
    
    [dataArray addObjectsFromArray:[result objectForKey:@"data"]];
    
    NSArray *array = [result objectForKey:@"data"];
    
    if ([array count] == 0)
    {
        cTableView.tableFooterView = nil;
    }
    else
    {
        [cTableView reloadData];
        
        if (pageIndex == 1)
        {
            cTableView.contentOffset = CGPointMake(cTableView.contentOffset.x, 0);
        }
        
        if (cTableView.contentSize.height > cTableView.frame.size.height + 100)
        {
            UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
            [moreBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [moreBtn setTitle:@"点击加载更多" forState:UIControlStateNormal];
            [moreBtn addTarget:self action:@selector(moreBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
            cTableView.tableFooterView = moreBtn;
        }
        else
        {
            cTableView.tableFooterView = nil;
        }
    }
    
}

- (void)moreBtnPressed:(UIButton *)button
{
    [button setTitle:@"数据加载中..." forState:UIControlStateNormal];
    
    pageIndex ++;
    [[Request request:10] voiceCommentListWithVoiceId:voiceId
                                                pages:[NSString stringWithFormat:@"%d",pageIndex]
                                              numbers:@"30"
                                                 type:@"1"
                                             delegate:self];
}

- (void)back
{
    if ([self.delegate respondsToSelector:@selector(commentSendDidFinish)])
    {
        [self.delegate commentSendDidFinish];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - tableview

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentCell *cell = (CommentCell *)[tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:self options:nil] objectAtIndex:0];
        cell.commentLabel.font = COMMENT_FONT;
    }
    
    NSDictionary *dict = [dataArray objectAtIndex:indexPath.row];
    
    NSString *text = [dict objectForKey:@"comment"];
    
    CGRect frame = cell.commentLabel.frame;
    
    CGFloat height = [text sizeWithFont:COMMENT_FONT
                         constrainedToSize:CGSizeMake(228, MAXFLOAT)].height + 1;
    
    frame.size = CGSizeMake(frame.size.width, height);
    
    cell.commentLabel.frame = frame;
    cell.commentLabel.text  = text;
    cell.titleLabel.text = [dict objectForKey:@"nickname"];
    [cell downImageWithURL:[dict objectForKey:@"avatar"]];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"comment"];
    
    return [text sizeWithFont:COMMENT_FONT
            constrainedToSize:CGSizeMake(228, MAXFLOAT)].height + 50;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
