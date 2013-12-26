//
//  SoundCell.h
//  iSound
//
//  Created by MaoHeng Zhang on 13-9-28.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface SoundCell : UITableViewCell<DownloaderDelegate>
{
    IBOutlet UIImageView *headView;
    IBOutlet UIImageView *zfView;
    IBOutlet UILabel *soundTitleLabel;
    IBOutlet UILabel *timeLabel;
    IBOutlet UILabel *label0;
    IBOutlet UILabel *label1;
    IBOutlet UILabel *label2;
    IBOutlet UILabel *label3;
    IBOutlet UILabel *zPeople;
    IBOutlet UILabel *nicknameLabel;
    
    CGFloat y;
    
    NSDateFormatter *dateFormatter;
}

@property (nonatomic, copy) NSString *headURL;

- (void)setDataDict:(NSMutableDictionary *)newValue;

@end

@interface SoundCell (UpdateSoundType) {
    
}

- (void)setSoundType:(NSInteger)soundType;

@end