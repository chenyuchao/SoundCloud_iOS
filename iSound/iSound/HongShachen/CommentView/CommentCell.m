//
//  CommentCell.m
//  iSound
//
//  Created by MaoHeng Zhang on 13-11-15.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import "CommentCell.h"

@implementation CommentCell
@synthesize headView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)downImageWithURL:(NSString *)url
{
    headView.image = [MTool cutImageFormImage:[[Downloader downloader] loadingWithURL:url
                                                                                index:0
                                                                             delegate:self
                                                                              cacheTo:Temp]];
}

#pragma mark - DownloaderDelegate

- (void)downloaderLoadingFromLocalDidFinish:(Downloader *)downloader
{
    
    headView.image = [MTool cutImageFormImage:downloader.image];
}

- (void)downloaderDidFinish:(Downloader *)downloader object:(UIImage *)object
{
    headView.image = [MTool cutImageFormImage:downloader.image];
}

- (void)downloaderNoSuchFileInThisUrl:(NSString *)url
{
    headView.image = nil;
}

- (void)downloaderDidFailWithError:(NSError *)error
{
    headView.image = nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
