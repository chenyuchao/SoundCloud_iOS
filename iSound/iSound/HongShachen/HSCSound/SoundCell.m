//
//  SoundCell.m
//  iSound
//
//  Created by MaoHeng Zhang on 13-9-28.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import "SoundCell.h"

@implementation SoundCell

@synthesize headURL;
//@synthesize dataDict;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
    }
    return self;
}

- (void)awakeFromNib {

}

- (void)setDataDict:(NSMutableDictionary *)newValue
{
    self.headURL         = [newValue objectForKey:@"image_path"];
    nicknameLabel.text   = [newValue objectForKey:@"nickname"];
    soundTitleLabel.text = [newValue objectForKey:@"voice_name"];
    
    NSDate *voiceDate = [NSDate dateWithTimeIntervalSince1970:[[newValue objectForKey:@"create_time"] doubleValue]];
    
    if (!dateFormatter)
    {
        dateFormatter =[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    }

    timeLabel.text = [dateFormatter stringFromDate:voiceDate];
    
    label0.text = [NSString stringWithFormat:@"%@",[newValue objectForKey:@"play_count"]];
    label1.text = [NSString stringWithFormat:@"%@",[newValue objectForKey:@"comment_count"]];
    label2.text = [NSString stringWithFormat:@"%@",[newValue objectForKey:@"forward_count"]];
    label3.text = [NSString stringWithFormat:@"%@",[newValue objectForKey:@"like_count"]];

    y = 57;
    
    CGFloat width = [nicknameLabel.text sizeWithFont:nicknameLabel.font
                                   constrainedToSize:CGSizeMake(MAXFLOAT, 21)].width;
    CGRect frame  = nicknameLabel.frame;
    frame.size    = CGSizeMake(width + 1, frame.size.height);
    nicknameLabel.frame = frame;
    
//    NSLog(@"%@", NSStringFromCGRect(frame));

    if ([[newValue valueForKey:@"type"] intValue] == 1 && [newValue valueForKey:@"z_nickname"])
    {
        if (!zfView)
        {
            zfView = [[UIImageView alloc] initWithFrame:CGRectZero];
            zfView.image = [UIImage imageNamed:@"SoundCellBG2.png"];
            [self addSubview:zfView];
        }
        zfView.frame = CGRectMake(frame.origin.x + frame.size.width + 2, 20, 13, 8);
        zfView.hidden = NO;
        if (!zPeople)
        {
            zPeople = [[UILabel alloc] initWithFrame:CGRectZero];
            zPeople.font = [Custom systemFont:11];
            zPeople.textColor = [UIColor grayColor];
            [self addSubview:zPeople];
        }
        zPeople.frame  = CGRectMake(frame.origin.x + frame.size.width + 17, 14, 201, 21);
        zPeople.text   = [newValue valueForKey:@"z_nickname"];
        zPeople.hidden = NO;
    }
    else
    {
        zPeople.hidden = YES;
        zfView.hidden  = YES;
    }
    [self autoLayout];
}

- (void)setHeadURL:(NSString *)newValue
{
    headURL = newValue;
    headView.image = nil;
    UIImage *image = [[Downloader downloader] loadingWithURL:headURL index:0 delegate:self cacheTo:Temp];
    headView.image = [MTool cutImageFormImage:image];
}

- (void)autoLayout {

    UIImageView *icon = nil;
    CGFloat width = 0;
    CGRect frame = CGRectZero;
    // 名字
    frame = nicknameLabel.frame;
    frame.origin = CGPointMake(frame.origin.x, y - 44);
    nicknameLabel.frame = frame;
    // 标题
    frame = soundTitleLabel.frame;
    frame.origin = CGPointMake(frame.origin.x, y - 22);
    soundTitleLabel.frame = frame;
    // 播放次数的图片
    icon = (UIImageView *)[self viewWithTag:200];
    frame = icon.frame;
    frame.origin = CGPointMake(frame.origin.x, y);
    icon.frame = frame;
    // 播放次数文字
    width = [label0.text sizeWithFont:label0.font constrainedToSize:CGSizeMake(MAXFLOAT, 10)].width + 1;
    frame = label0.frame;
    frame.size = CGSizeMake(width, 10);
    frame.origin = CGPointMake(frame.origin.x, y - 1);
    label0.frame = frame;
    // 评论次数的图片
    icon = (UIImageView *)[self viewWithTag:201];
    frame = icon.frame;
    frame.origin = CGPointMake(label0.frame.origin.x + label0.frame.size.width + 10, y);
    icon.frame = frame;
    // 评论次数
    width = [label1.text sizeWithFont:label1.font constrainedToSize:CGSizeMake(MAXFLOAT, 10)].width + 1;
    frame = label1.frame;
    frame.size = CGSizeMake(width, 10);
    frame.origin = CGPointMake(icon.frame.origin.x + icon.frame.size.width + 5, y - 1);
    label1.frame = frame;
    // 转发次数的图片
    icon = (UIImageView *)[self viewWithTag:202];
    frame = icon.frame;
    frame.origin = CGPointMake(label1.frame.origin.x + label1.frame.size.width + 10, y);
    icon.frame = frame;
    // 转发次数
    width = [label2.text sizeWithFont:label2.font constrainedToSize:CGSizeMake(MAXFLOAT, 10)].width + 1;
    frame = label2.frame;
    frame.size = CGSizeMake(width, 10);
    frame.origin = CGPointMake(icon.frame.origin.x + icon.frame.size.width + 5, y - 1);
    label2.frame = frame;
    // 喜欢次数的图片
    icon = (UIImageView *)[self viewWithTag:203];
    frame = icon.frame;
    frame.origin = CGPointMake(label2.frame.origin.x + label2.frame.size.width + 10, y + 1);
    icon.frame = frame;
    // 喜欢次数
    width = [label3.text sizeWithFont:label3.font constrainedToSize:CGSizeMake(MAXFLOAT, 10)].width + 1;
    frame = label3.frame;
    frame.size = CGSizeMake(width, 10);
    frame.origin = CGPointMake(icon.frame.origin.x + icon.frame.size.width + 5, y - 1);
    label3.frame = frame;
}

#pragma mark - DownloaderDelegate

- (void)downloaderLoadingFromLocalDidFinish:(Downloader *)downloader
{
    
//    headView.image = [MTool cutImageFormImage:downloader.image];
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

@implementation SoundCell (UpdateSoundType)

- (void)setSoundType:(NSInteger)soundType {
    
    if (soundType == 0)
    {
        timeLabel.text = @"原创";
        timeLabel.textColor = MainColor;
    }
    else if (soundType == 2)
    {
        timeLabel.text = @"未发布";
        timeLabel.textColor = [UIColor grayColor];
    }
    else
    {
        timeLabel.text = @"转发";
        timeLabel.textColor = [UIColor grayColor];
    }
}

@end
