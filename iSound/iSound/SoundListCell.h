//
//  SoundListCell.h
//  iSound
//
//  Created by Jumax.R on 13-11-11.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SoundListCellOfLeft : UITableViewCell <DownloaderDelegate> {

    IBOutlet UIImageView *headView;
    IBOutlet UIImageView *cityView;
    IBOutlet UILabel *timeA;
    IBOutlet UILabel *timeB;
    IBOutlet UILabel *number;
}

- (void)setResult:(NSDictionary *)result;

@end


@interface SoundListCellOfRight : UITableViewCell <DownloaderDelegate> {

    IBOutlet UIImageView *headView;
    IBOutlet UIImageView *cityView;
    IBOutlet UILabel *timeA;
    IBOutlet UILabel *timeB;
    IBOutlet UILabel *number;
}

- (void)setResult:(NSDictionary *)result;

@end