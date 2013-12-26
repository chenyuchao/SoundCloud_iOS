//
//  CommentView.h
//  iSound
//
//  Created by MaoHeng Zhang on 13-11-13.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddComment.h"
#import "CommentCell.h"

#define kCommentTag 985

@protocol CommentViewDelegate <NSObject>

- (void)commentSendDidFinish;

@end

@interface CommentView : UIViewController<RequestDelegate,UITableViewDelegate,UITableViewDataSource>
{
    int pageIndex;
    
    NSMutableArray *dataArray;
    IBOutlet UITableView *cTableView;
}
@property (nonatomic, copy) NSString *voiceId;
@property (nonatomic, assign) id <CommentViewDelegate> delegate;

@end
