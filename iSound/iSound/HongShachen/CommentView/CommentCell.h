//
//  CommentCell.h
//  iSound
//
//  Created by MaoHeng Zhang on 13-11-15.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentCell : UITableViewCell<DownloaderDelegate>


@property (nonatomic, assign) IBOutlet UILabel *commentLabel;
@property (nonatomic, assign) IBOutlet UIImageView *headView;
@property (nonatomic, assign) IBOutlet UILabel *titleLabel;
- (void)downImageWithURL:(NSString *)url;

@end
